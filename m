Return-Path: <linux-kernel-owner+w=401wt.eu-S1760518AbYAVK6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518AbYAVK6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYAVK57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:57:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44093 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbYAVK56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:57:58 -0500
Date: Tue, 22 Jan 2008 11:57:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Rescheduling interrupts
Message-ID: <20080122105741.GG21149@elte.hu>
References: <200801220119.42312.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801220119.42312.caglar@pardus.org.tr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> Top causes for wakeups:
>   59,9% (238,4)      <kernel IPI> : Rescheduling interrupts
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   14,7% ( 58,6)         amarokapp : schedule_timeout (process_timeout)

hm, would be nice to figure out what causes these IPIs. Could you stick 
something like this into arch/x86/kernel/smp_32.c's 
smp_send_reschedule() function [this is the function that generates the 
IPI]:

static void native_smp_send_reschedule(int cpu)
{
        WARN_ON(cpu_is_offline(cpu));
        send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
	if (panic_timeout > 0) {
		panic_timeout--;
		printk("IPI from task %s:%d on CPU#%d:\n", 
			current->comm, current->pid, cpu);
		dump_stack();
	}
}

NOTE: if you run an SMP kernel then first remove these two lines from 
kernel/printk.c:

        if (!oops_in_progress && waitqueue_active(&log_wait))
                wake_up_interruptible(&log_wait);

otherwise you'll get lockups. (the IPI is sent while holding the 
runqueue lock, so the printks will lock up)

then wait for the bad condition to occur on your system and generate a 
stream of ~10 backtraces, via:

	echo 10 > /proc/sys/kernel/panic

you should be getting 10 immediate backtraces - please send them to us. 
The backtraces should show the place that generates the wakeups. [turn 
on CONFIG_FRAME_POINTERS=y to get high quality backtraces.]
 
If you do _not_ get 10 immediate backtraces, then something in the 
system is generating such IPIs outside of the scheduler's control. That 
would suggest some other sort of borkage.

	Ingo
