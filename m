Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbYDLJVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbYDLJVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 05:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbYDLJVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 05:21:34 -0400
Received: from po-out-1718.google.com ([72.14.252.157]:34753 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbYDLJVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 05:21:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=GhP0UCrW8zNJFefPhfCJSH/SCxptwCy5g+XAwyxuPfO/gakW+4eTTI6tPNPrb5/9qgNU1p8KfwyeaUr7uP86K5xly4zpRf7nGjogkoy1ga4UgzX7ApIZtW63QYUvLgEVrxsbF0ltUf+Hrjd+65nTyL++RACDVghJQV8um7xy+mo=
Date: Sat, 12 Apr 2008 17:17:47 +0800 (CST)
Message-Id: <20080412.171747.26924099.xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] arch/um/os-Linux/sys-i386/task_size.c: improve a bit
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Improve this code a bit: check sigaction's return value and remove a useless
fflush().

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>

---

diff --git a/arch/um/os-Linux/sys-i386/task_size.c b/arch/um/os-Linux/sys-i386/task_size.c
index 48d211b..2b5bba5 100644
--- a/arch/um/os-Linux/sys-i386/task_size.c
+++ b/arch/um/os-Linux/sys-i386/task_size.c
@@ -88,7 +88,10 @@ unsigned long os_get_task_size(void)
 	sa.sa_handler = segfault;
 	sigemptyset(&sa.sa_mask);
 	sa.sa_flags = SA_NODEFER;
-	sigaction(SIGSEGV, &sa, &old);
+	if (sigaction(SIGSEGV, &sa, &old)) {
+		perror("os_get_task_size");
+		exit(1);
+	}
 
 	if (!page_ok(bottom)) {
 		fprintf(stderr, "Address 0x%x no good?\n",
@@ -110,11 +113,12 @@ unsigned long os_get_task_size(void)
 
 out:
 	/* Restore the old SIGSEGV handling */
-	sigaction(SIGSEGV, &old, NULL);
-
+	if (sigaction(SIGSEGV, &old, NULL)) {
+		perror("os_get_task_size");
+		exit(1);
+	}
 	top <<= UM_KERN_PAGE_SHIFT;
 	printf("0x%x\n", top);
-	fflush(stdout);
 
 	return top;
 }
