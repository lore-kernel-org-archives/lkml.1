Return-Path: <linux-kernel-owner+w=401wt.eu-S936336AbZAPO06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936336AbZAPO06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936124AbZAPOYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:24:43 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:49559 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935933AbZAPOYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:24:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DI/r70TdK9c3jiVQtvq2qVD+a69P90QNOtccA9OPO4gpEXkRwqWZngkw5F7ZCXEChE
         FDXRGNOGGH48kyoxUPVpD7XJ7k8zFSvStEm5gNXZ2NJpe7gDPlP7u+Od3Star9QSuNvy
         mTmd6bFoq00XfxPiQNSftBbr9RPasQfzWlYBU=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 11/17] x86-64: Move isidle from PDA to per-cpu.
Date: Fri, 16 Jan 2009 09:16:30 -0500
Message-Id: <1232115396-26367-11-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-10-git-send-email-brgerst@gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
 <1232115396-26367-6-git-send-email-brgerst@gmail.com>
 <1232115396-26367-7-git-send-email-brgerst@gmail.com>
 <1232115396-26367-8-git-send-email-brgerst@gmail.com>
 <1232115396-26367-9-git-send-email-brgerst@gmail.com>
 <1232115396-26367-10-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/pda.h   |    1 -
 arch/x86/kernel/process_64.c |    5 +++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index b30ef6b..c31ca04 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -23,7 +23,6 @@ struct x8664_pda {
 					   offset 40!!! */
 #endif
 	short in_bootmem;		/* pda lives in bootmem */
-	short isidle;
 } ____cacheline_aligned_in_smp;
 
 DECLARE_PER_CPU(struct x8664_pda, __pda);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index d4a7391..3cf12f4 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -61,6 +61,7 @@ DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 
 DEFINE_PER_CPU(unsigned long, oldrsp);
+static DEFINE_PER_CPU(unsigned char, isidle);
 
 unsigned long kernel_thread_flags = CLONE_VM | CLONE_UNTRACED;
 
@@ -80,13 +81,13 @@ EXPORT_SYMBOL_GPL(idle_notifier_unregister);
 
 void enter_idle(void)
 {
-	write_pda(isidle, 1);
+	percpu_write(isidle, 1);
 	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
 }
 
 static void __exit_idle(void)
 {
-	if (test_and_clear_bit_pda(0, isidle) == 0)
+	if (x86_test_and_clear_bit_percpu(0, isidle) == 0)
 		return;
 	atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
 }
-- 
1.6.1.rc1

