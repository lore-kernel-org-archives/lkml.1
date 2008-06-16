Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYFPNWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYFPNWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYFPNWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:22:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:42031 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYFPNWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:22:43 -0400
To: torvalds@linux-foundation.org
Cc: jacmet@sunsite.dk, dhowells@redhat.com, k.shutemov@gmail.com,
       linux-kernel@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Date: Mon, 16 Jun 2008 12:11:54 +0100
In-Reply-To: <87abhl7eqo.fsf@macbook.be.48ers.dk>
Subject: [PATCH 1/4] Include <asm/a.out.h> in fs/exec.c only for Alpha.
Message-Id: <E1K8Eex-0002GT-LV@pmac.infradead.org>
X-Bad-Reply: In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only need it for the /sbin/loader hack for OSF/1 executables, and we
don't want to include it otherwise.

While we're at it, remove the redundant '&& CONFIG_ARCH_SUPPORTS_AOUT'
in the ifdef around that code. It's already dependent on __alpha__, and
CONFIG_ARCH_SUPPORTS_AOUT is hard-coded to 'y' there.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 fs/exec.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 9448f1b..da94a6f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -26,7 +26,6 @@
 #include <linux/file.h>
 #include <linux/fdtable.h>
 #include <linux/mman.h>
-#include <linux/a.out.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/smp_lock.h>
@@ -61,6 +60,11 @@
 #include <linux/kmod.h>
 #endif
 
+#ifdef __alpha__
+/* for /sbin/loader handling in search_binary_handler() */
+#include <linux/a.out.h>
+#endif
+
 int core_uses_pid;
 char core_pattern[CORENAME_MAX_SIZE] = "core";
 int suid_dumpable = 0;
@@ -1155,7 +1159,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 {
 	int try,retval;
 	struct linux_binfmt *fmt;
-#if defined(__alpha__) && defined(CONFIG_ARCH_SUPPORTS_AOUT)
+#ifdef __alpha__
 	/* handle /sbin/loader.. */
 	{
 	    struct exec * eh = (struct exec *) bprm->buf;
-- 
1.5.5.1

