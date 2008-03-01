Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbYCAO3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbYCAO3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 09:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYCAO3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 09:29:14 -0500
Received: from www.tglx.de ([62.245.132.106]:40310 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYCAO3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 09:29:13 -0500
Date: Sat, 1 Mar 2008 15:29:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ed Tomlinson <edt@aei.ca>
cc: linux-kernel@vger.kernel.org
Subject: Re: Panic 2.6.24-3 NMI Watchdog detected LOCKUP on CPU 0
In-Reply-To: <200803010911.04569.edt@aei.ca>
Message-ID: <alpine.LFD.1.00.0803011527410.11084@apollo.tec.linutronix.de>
References: <200803010911.04569.edt@aei.ca>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Ed Tomlinson wrote:
> Hi,
> 
> I have been seeing these since I installed .24 kernels.  It does not seem to matter if I change the clocksource from tsc
> to apci_pm.  Its happened with all .24 kernels I have tried starting with stock 2.6.24 upto 2.6.24-gentoo-r2 + 2.6.24-3
> 
> Ideas?

Questions first. Is there a particular reason to use idle=poll ?

Idea: does the patch below help ?

Thanks,
	tglx

---

 arch/x86/kernel/process_64.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.24/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6.24.orig/arch/x86/kernel/process_64.c
+++ linux-2.6.24/arch/x86/kernel/process_64.c
@@ -212,14 +212,13 @@ void cpu_idle (void)
 	current_thread_info()->status |= TS_POLLING;
 	/* endless idle loop with no priority at all */
 	while (1) {
+		tick_nohz_stop_sched_tick();
 		while (!need_resched()) {
 			void (*idle)(void);
 
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
-			tick_nohz_stop_sched_tick();
-
 			rmb();
 			idle = pm_idle;
 			if (!idle)
