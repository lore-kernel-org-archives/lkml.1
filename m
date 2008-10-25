Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbYJYW5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbYJYW5X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYJYW5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 18:57:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbYJYW5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 18:57:01 -0400
Date: Sat, 25 Oct 2008 15:56:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       walt <w41ter@gmail.com>
Subject: Re: [PULL] module, param and stop_machine patches
In-Reply-To: <alpine.LFD.2.00.0810251529240.3327@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0810251554030.3327@nehalem.linux-foundation.org>
References: <200810221005.59874.rusty@rustcorp.com.au> <alpine.LFD.2.00.0810251416130.3327@nehalem.linux-foundation.org> <200810260924.09479.rusty@rustcorp.com.au> <alpine.LFD.2.00.0810251529240.3327@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 25 Oct 2008, Linus Torvalds wrote:
> 
> Is there any reason why the real patch isn't just to make 
> 'stop_machine_init' a 'core_initcall()' instead of 'early_initcall()'?

IOW, something like this (untested)

		Linus

---
 init/main.c           |    3 +--
 kernel/stop_machine.c |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/init/main.c b/init/main.c
index 130d1a0..7e117a2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -768,6 +768,7 @@ static void __init do_initcalls(void)
 static void __init do_basic_setup(void)
 {
 	rcu_init_sched(); /* needed by module_init stage. */
+	init_workqueues();
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
@@ -851,8 +852,6 @@ static int __init kernel_init(void * unused)
 
 	cad_pid = task_pid(current);
 
-	init_workqueues();
-
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 8aff79d..9bc4c00 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -160,4 +160,4 @@ static int __init stop_machine_init(void)
 	stop_machine_work = alloc_percpu(struct work_struct);
 	return 0;
 }
-early_initcall(stop_machine_init);
+core_initcall(stop_machine_init);
