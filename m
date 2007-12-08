Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbXLHReh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbXLHReh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 12:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXLHRea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 12:34:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:9170 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXLHRe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 12:34:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Na3c606LvIgeHyM5UmHJ8KPKXE1TZbeqDoE19+ZdmtZRpY5RIgfWnuRnc2h4dxHLxiMYUD0E8CBuvGLPbYjsuePfVPwuj99UT11EkaLDRQG6pxAhh1waDMP8Hx5eiGA9+ssSR14lERZYtgEYCxMzSIlTEOTY52Dhe0RRJa5aeJc=
Message-ID: <475AD59F.3010509@gmail.com>
Date: Sat, 08 Dec 2007 18:34:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47595A0A.5000502@gmail.com> <20071207151150.GB24254@elte.hu> <20071207175134.GA18916@elte.hu> <475A5188.6070809@gmail.com> <20071208083939.GD30997@elte.hu> <475A629C.7010408@gmail.com> <20071208152447.GA30270@elte.hu>
In-Reply-To: <20071208152447.GA30270@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2007 04:24 PM, Ingo Molnar wrote:
> i'm wondering why it had no effect now - the new code is in essence a 
> NOP over what we had. Could you send me your current (modified) 
> kernel/softlockup.c code?

Only these changes:
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index e50b44a..7011549 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -25,7 +25,7 @@ static DEFINE_PER_CPU(unsigned long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);

 static int did_panic;
-int softlockup_thresh = 60;
+int softlockup_thresh = 10;

 static int
 softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
@@ -101,7 +101,11 @@ void softlockup_tick(void)

        now = get_timestamp(this_cpu);

-       /* Warn about unreasonable delays: */
+       /* Wake up the high-prio watchdog task every second: */
+       if (now > (touch_timestamp + 1))
+               wake_up_process(per_cpu(watchdog_task, this_cpu));
+
+       /* Warn about unreasonable 10+ seconds delays: */
        if (now <= (touch_timestamp + softlockup_thresh))
                return;

@@ -213,8 +217,9 @@ static int watchdog(void *__bind_cpu)
         * debug-printout triggers in softlockup_tick().
         */
        while (!kthread_should_stop()) {
+               set_current_state(TASK_INTERRUPTIBLE);
                touch_softlockup_watchdog();
-               msleep_interruptible(10000);
+               schedule();

                /*
                 * Only do the hung-tasks check on one CPU:


Whole file:
http://www.fi.muni.cz/~xslaby/sklad/softlockup.c
