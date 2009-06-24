Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZFXLLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZFXLLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZFXLLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:11:06 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:40044 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZFXLLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:11:04 -0400
Date: Wed, 24 Jun 2009 13:11:04 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: lethal@linux-sh.org
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: register_timer_hook use in arch/sh/oprofile
Message-ID: <20090624131104.705c828d@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,
following Ingo's suggestion I'm working on a patch to use a per-cpu
hrtimer instead of the timer_hook for the oprofile ticks. Given that
oprofile is the only user of the timer_hook I want to remove it
completely. That way I came across the register_timer_hook call in
arch/sh/oprofile/op_model_sh7750.c. Did this ever work? The startup
of oprofile is done in two steps, on module load oprofile_init is
called, on profiling start oprofile_start is called.
Now for SH7750 this happens:

oprofile_init()
	...
	oprofile_arch_init(&oprofile_ops);
		...
		lmodel->init(); 
		/* init() is sh7750_ppc_init for CPU_SH7750/CPU_7750S */
			sh7750_ppc_reset();
			register_timer_hook(sh7750_timer_notify);
			...
		...
	oprofile_timer_init(&oprofile_ops);
		...
		ops->start = timer_start;
		...
	...

oprofile_start()
	...
	oprofile_ops.start();
	/* start() is timer_start set by oprofile_timer_init */
		register_timer_hook(timer_notify);
	...

As far as I can see the second register_timer_hook will fail
because sh7750_timer_notify is already registered. That will cause
oprofile_start to fail with -EBUSY, no?

My proposed solution for that particular problem would be to remove the
sh7750_timer_notify function together with the register/unregister
calls, see patch below. Then the sole caller of register_timer_hook
would be in drivers/oprofile/timer_int.c and after that has been
converted to hrtimer the whole timer_hook stuff could go away.

---
diff -urpN linux-2.6/arch/sh/oprofile/op_model_sh7750.c linux-2.6-patched/arch/sh/oprofile/op_model_sh7750.c
--- linux-2.6/arch/sh/oprofile/op_model_sh7750.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6-patched/arch/sh/oprofile/op_model_sh7750.c	2009-06-24 13:07:08.000000000 +0200
@@ -95,12 +95,6 @@ static struct sh7750_ppc_register_config
  * behavior.
  */
 
-static int sh7750_timer_notify(struct pt_regs *regs)
-{
-	oprofile_add_sample(regs, 0);
-	return 0;
-}
-
 static u64 sh7750_read_counter(int counter)
 {
 	return (u64)((u64)(__raw_readl(PMCTRH(counter)) & 0xffff) << 32) |
@@ -231,14 +225,11 @@ static inline void sh7750_ppc_reset(void
 static int sh7750_ppc_init(void)
 {
 	sh7750_ppc_reset();
-
-	return register_timer_hook(sh7750_timer_notify);
+	return 0;
 }
 
 static void sh7750_ppc_exit(void)
 {
-	unregister_timer_hook(sh7750_timer_notify);
-
 	sh7750_ppc_reset();
 }
 
---

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

