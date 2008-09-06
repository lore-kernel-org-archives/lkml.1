Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbYIFPJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbYIFPJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 11:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYIFPJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 11:09:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:22249 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbYIFPJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 11:09:29 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Introduce field 'taso' into struct linux_binprm
Date: Sat,  6 Sep 2008 18:09:54 +0300
Message-Id: <1220713795-5313-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.5.6.5.GIT
In-Reply-To: <20080902110648.GA5027@localhost.localdomain>
References: <20080902110648.GA5027@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is Alpha-specific. It adds field 'taso' into struct
linux_binprm to remember if the application is TASO. Previously,
field sh_bang was wsed for this purpose.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/alpha/include/asm/a.out.h |    2 +-
 fs/exec.c                      |    2 +-
 include/linux/binfmts.h        |    3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/include/asm/a.out.h b/arch/alpha/include/asm/a.out.h
index 02ce847..acdc681 100644
--- a/arch/alpha/include/asm/a.out.h
+++ b/arch/alpha/include/asm/a.out.h
@@ -95,7 +95,7 @@ struct exec
    Worse, we have to notice the start address before swapping to use
    /sbin/loader, which of course is _not_ a TASO application.  */
 #define SET_AOUT_PERSONALITY(BFPM, EX) \
-	set_personality (((BFPM->sh_bang || EX.ah.entry < 0x100000000L \
+	set_personality (((BFPM->taso || EX.ah.entry < 0x100000000L \
 			   ? ADDR_LIMIT_32BIT : 0) | PER_OSF4))
 
 #endif /* __KERNEL__ */
diff --git a/fs/exec.c b/fs/exec.c
index 32993be..a46de17 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1189,7 +1189,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			return retval;
 
 		/* Remember if the application is TASO.  */
-		bprm->sh_bang = eh->ah.entry < 0x100000000UL;
+		bprm->taso = eh->ah.entry < 0x100000000UL;
 
 		bprm->file = file;
 		bprm->loader = loader;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 826f623..54980a3 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -36,6 +36,9 @@ struct linux_binprm{
 	unsigned long p; /* current top of mem */
 	unsigned int sh_bang:1,
 		     misc_bang:1;
+#ifdef __alpha__
+	unsigned int taso:1;
+#endif
 	struct file * file;
 	int e_uid, e_gid;
 	kernel_cap_t cap_post_exec_permitted;
-- 
1.5.6.5.GIT

