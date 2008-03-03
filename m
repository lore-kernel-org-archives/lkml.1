Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbYCCNXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbYCCNXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 08:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYCCNXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 08:23:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbYCCNXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 08:23:16 -0500
Date: Mon, 3 Mar 2008 14:22:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ed Tomlinson <edt@aei.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: Panic 2.6.24-3 NMI Watchdog detected LOCKUP on CPU 0
Message-ID: <20080303132251.GA32030@elte.hu>
References: <200803010911.04569.edt@aei.ca> <alpine.LFD.1.00.0803011527410.11084@apollo.tec.linutronix.de> <200803030817.03680.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803030817.03680.edt@aei.ca>
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


* Ed Tomlinson <edt@aei.ca> wrote:

> Thomas,
> 
> I have booted many times over the weekend.  I've yet to trigger the 
> watchdog.  Since I used to see problems in 1 in 3 or 4 boots, I think 
> you fixed the problem with patch below.

thanks for testing it.

Stable Team, please consider the post-2.6.24 commit below for -stable.

	Ingo

--------------------->
commit 3d97775a80a03013abe1fd681620925f884ad18a
Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Date:   Wed Jan 30 13:33:00 2008 +0100

    x86: move out tick_nohz_stop_sched_tick() call from the loop
    
    Move out tick_nohz_stop_sched_tick() call from the loop in cpu_idle
    same as 32-bit version.
    
    Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 78d8006..a0130eb 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -170,14 +170,13 @@ void cpu_idle(void)
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
