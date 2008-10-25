Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbYJYVTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbYJYVTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 17:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYJYVTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:19:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbYJYVTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:19:09 -0400
Date: Sat, 25 Oct 2008 14:17:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PULL] module, param and stop_machine patches
In-Reply-To: <200810221005.59874.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0810251416130.3327@nehalem.linux-foundation.org>
References: <200810221005.59874.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Oct 2008, Rusty Russell wrote:
> 
> Heiko Carstens (4):
>       Call init_workqueues before pre smp initcalls.

This one actually causes a regression for me on one of my machines.

Don't ask me why, but it's very repeatable, and it goes away when that 
commit is reverted. See the appended commit that I have queued up (but not 
yet pushed out) in my tree for details..

		Linus
---
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Oct 2008 14:04:40 -0700
Subject: [PATCH] Revert "Call init_workqueues before pre smp initcalls."

This reverts commit a802dd0eb5fc97a50cf1abb1f788a8f6cc5db635, which
causes an odd bootup failure on one of my machines.  The boot hangs
after printing out

	Found volume group "VolGroup00" using metadata type lvm2

where the next message (that never prints out) should be

	2 logical volume(s) in Volume Group"VolGroup00" now active.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/init/main.c b/init/main.c
index 130d1a0..70e4eed 100644
--- a/init/main.c
+++ b/init/main.c
@@ -768,6 +768,8 @@ static void __init do_initcalls(void)
 static void __init do_basic_setup(void)
 {
 	rcu_init_sched(); /* needed by module_init stage. */
+	/* drivers will send hotplug events */
+	init_workqueues();
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
@@ -851,8 +853,6 @@ static int __init kernel_init(void * unused)
 
 	cad_pid = task_pid(current);
 
-	init_workqueues();
-
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
