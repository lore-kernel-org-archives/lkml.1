Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYHQPvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYHQPvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 11:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYHQPve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 11:51:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:8838 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbYHQPve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 11:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m8STCW5QG4LPE+8WBatJCI8b92ktvtQoNF6ve2dU/ny2/V/h+eQ1AYiGemvP8x5z4W
         aDdoJVRIYsC+kabtADa2FceeCI/zfMkOEgHDMW/wXOrARit+R+b7zpBazRooqYWX00Fo
         CkFMuL90BojOGLKg93ug0ZzoUKwQ6+o+TzvE8=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: silence section mismatch warning - get_local_pda
Date: Sun, 17 Aug 2008 17:50:51 +0200
Message-Id: <1218988252-17932-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218988252-17932-1-git-send-email-marcin.slusarz@gmail.com>
References: <1218988252-17932-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take out part of get_local_pda referencing __init function (free_bootmem)
to new (static) function marked as __ref. It's safe to do because free_bootmem
is called before __init sections are dropped.

WARNING: vmlinux.o(.cpuinit.text+0x3cd7): Section mismatch in reference from the function get_local_pda() to the function .init.text:free_bootmem()
The function __cpuinit get_local_pda() references
a function __init free_bootmem().
If free_bootmem is only used by get_local_pda then
annotate free_bootmem with a matching annotation.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/smpboot.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 91055d7..47dbf98 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -756,6 +756,14 @@ static void __cpuinit do_fork_idle(struct work_struct *work)
 }
 
 #ifdef CONFIG_X86_64
+
+/* __ref because it's safe to call free_bootmem when after_bootmem == 0. */
+static void __ref free_bootmem_pda(struct x8664_pda *oldpda)
+{
+	if (!after_bootmem)
+		free_bootmem((unsigned long)oldpda, sizeof(*oldpda));
+}
+
 /*
  * Allocate node local memory for the AP pda.
  *
@@ -784,8 +792,7 @@ int __cpuinit get_local_pda(int cpu)
 
 	if (oldpda) {
 		memcpy(newpda, oldpda, size);
-		if (!after_bootmem)
-			free_bootmem((unsigned long)oldpda, size);
+		free_bootmem_pda(oldpda);
 	}
 
 	newpda->in_bootmem = 0;
-- 
1.5.4.5

