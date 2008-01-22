Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbYAVMzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbYAVMzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 07:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYAVMzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 07:55:32 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:40779 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752390AbYAVMzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 07:55:32 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Rescheduling interrupts
Date: Tue, 22 Jan 2008 14:55:14 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <200801220119.42312.caglar@pardus.org.tr> <20080122105741.GG21149@elte.hu>
In-Reply-To: <20080122105741.GG21149@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801221455.16814.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

22 Oca 2008 Sal tarihinde, Ingo Molnar şunları yazmıştı: 
> * S.Çağlar Onur <caglar@pardus.org.tr> wrote:
> 
> > Top causes for wakeups:
> >   59,9% (238,4)      <kernel IPI> : Rescheduling interrupts
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >   14,7% ( 58,6)         amarokapp : schedule_timeout (process_timeout)
> 
> hm, would be nice to figure out what causes these IPIs. Could you stick 
> something like this into arch/x86/kernel/smp_32.c's 
> smp_send_reschedule() function [this is the function that generates the 
> IPI]:
> 
> static void native_smp_send_reschedule(int cpu)
> {
>         WARN_ON(cpu_is_offline(cpu));
>         send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
> 	if (panic_timeout > 0) {
> 		panic_timeout--;
> 		printk("IPI from task %s:%d on CPU#%d:\n", 
> 			current->comm, current->pid, cpu);
> 		dump_stack();
> 	}
> }
> 
> NOTE: if you run an SMP kernel then first remove these two lines from 
> kernel/printk.c:
> 
>         if (!oops_in_progress && waitqueue_active(&log_wait))
>                 wake_up_interruptible(&log_wait);
> 
> otherwise you'll get lockups. (the IPI is sent while holding the 
> runqueue lock, so the printks will lock up)
> 
> then wait for the bad condition to occur on your system and generate a 
> stream of ~10 backtraces, via:
> 
> 	echo 10 > /proc/sys/kernel/panic
> 
> you should be getting 10 immediate backtraces - please send them to us. 
> The backtraces should show the place that generates the wakeups. [turn 
> on CONFIG_FRAME_POINTERS=y to get high quality backtraces.]
>  
> If you do _not_ get 10 immediate backtraces, then something in the 
> system is generating such IPIs outside of the scheduler's control. That 
> would suggest some other sort of borkage.
> 
> 	Ingo

I grabbed the logs two times to make sure to catch needed info. 1st [1] one is generated while "Rescheduling interrupts" wakeups ~200 times and 2nd one generated for ~350 wakeups.

[1] http://cekirdek.pardus.org.tr/~caglar/dmesg.1st 
[2] http://cekirdek.pardus.org.tr/~caglar/dmesg.2nd

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
