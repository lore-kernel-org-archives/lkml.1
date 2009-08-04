Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbZHDOyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbZHDOyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbZHDOyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:54:13 -0400
Received: from mail.windriver.com ([147.11.1.11]:38713 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595AbZHDOyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:54:12 -0400
Message-ID: <4A784B78.2020801@windriver.com>
Date: Tue, 04 Aug 2009 09:53:44 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Deng, Dongdong" <Dongdong.Deng@windriver.com>
Subject: Re: [PATCH] softlockup: fix problem with long kernel pauses fromkgdb
References: <4A6E0825.3020604@windriver.com> <1248725893.6987.2055.camel@twins> <4A6F139C.6070806@windriver.com> <20090804141623.GD7746@elte.hu>
In-Reply-To: <20090804141623.GD7746@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Aug 2009 14:53:45.0825 (UTC) FILETIME=[5DF30510:01CA1513]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jason Wessel <jason.wessel@windriver.com> wrote:
> 
>> -----
>> From: Jason Wessel <jason.wessel@windriver.com>
>> Subject: [PATCH] softlockup: add sched_clock_tick() to avoid kernel warning on kgdb resume
>>
>> When CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is set sched_clock() gets the
>> time from hardware, such as from TSC.  In this configuration kgdb will
>> report a softlock warning messages on resuming or detaching from a
>> debug session.
>>
> 
> Hm, this looks quite ugly. Peter, Thomas, can you think of a cleaner 
> solution?
> 

Below was a more specific test case I received from Dongdong Deng
which did not require kgdb.  The test case is not something to merge,
it is just a simple module to build to demonstrate the problem outside
of kgdb.

The patch I submitted might have been on the "ugly" side, but there
was not an obvious way to solve the problem without making changes in
kernel/sched*.  I opted for something that was entirely self contained
to the softlockup code.

Jason.

============= test case ================
/* Information about this test case.
 * -------------------------------------
 * 1: CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
 * 
 * 2: export clocksource_touch_watchdog for this test case to build.
 *
 * 
 * diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
 * index 7466cb8..c81f9a3 100644
 * --- a/kernel/time/clocksource.c
 * +++ b/kernel/time/clocksource.c
 * @@ -319,6 +319,7 @@ void clocksource_touch_watchdog(void)
 *  {
 * 	    clocksource_resume_watchdog();
 *  }
 * +EXPORT_SYMBOL(clocksource_touch_watchdog);
 * 
 * 3: build following module, insmod and observe the softlockup
 *    warning or watch your system reboot if you have reboot
 *    on softlockup set.
 * 
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/irqflags.h>
#include <linux/delay.h>
#include <linux/sched.h>
#include <linux/clocksource.h>



static int example_init(void)
{
	unsigned long flags;
	unsigned i;

	printk(KERN_NOTICE"softlockup test init\n");

	local_irq_save(flags);

	for (i = 0; i < 70; i++)
		mdelay(1000);

	touch_softlockup_watchdog();
	clocksource_touch_watchdog();

	local_irq_restore(flags);

	return 0;
}

static void example_exit(void)
{
	printk(KERN_NOTICE"softlockup test exit\n");
}

module_init(example_init);
module_exit(example_exit);
MODULE_LICENSE("GPL");

