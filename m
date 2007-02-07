Return-Path: <linux-kernel-owner+w=401wt.eu-S1422891AbXBGTy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422891AbXBGTy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422915AbXBGTy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:54:58 -0500
Received: from [198.99.130.12] ([198.99.130.12]:34291 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1422891AbXBGTy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:54:57 -0500
Message-Id: <200702071947.l17JlgoC006600@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 1/7] UML - IRQ handler tidying
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 07 Feb 2007 14:47:42 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tidying the irq code -
	make a variable static
	activate_fd can call kmalloc directly since it's now kernel code
	added a no-locking comment
	fixed a style violation

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/kernel/irq.c   |    7 +++----
 arch/um/os-Linux/irq.c |    6 +++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6.18-mm/arch/um/kernel/irq.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/kernel/irq.c	2007-01-09 17:08:58.000000000 -0500
+++ linux-2.6.18-mm/arch/um/kernel/irq.c	2007-01-10 15:30:35.000000000 -0500
@@ -79,7 +79,7 @@ skip:
 	return 0;
 }
 
-struct irq_fd *active_fds = NULL;
+static struct irq_fd *active_fds = NULL;
 static struct irq_fd **last_irq_ptr = &active_fds;
 
 extern void free_irqs(void);
@@ -124,8 +124,8 @@ int activate_fd(int irq, int fd, int typ
 	if (err < 0)
 		goto out;
 
-	new_fd = um_kmalloc(sizeof(*new_fd));
 	err = -ENOMEM;
+	new_fd = kmalloc(sizeof(struct irq_fd), GFP_KERNEL);
 	if (new_fd == NULL)
 		goto out;
 
@@ -176,9 +176,8 @@ int activate_fd(int irq, int fd, int typ
 		 */
 		spin_unlock_irqrestore(&irq_lock, flags);
 		kfree(tmp_pfd);
-		tmp_pfd = NULL;
 
-		tmp_pfd = um_kmalloc(n);
+		tmp_pfd = kmalloc(n, GFP_KERNEL);
 		if (tmp_pfd == NULL)
 			goto out_kfree;
 
Index: linux-2.6.18-mm/arch/um/os-Linux/irq.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/os-Linux/irq.c	2007-01-10 15:08:33.000000000 -0500
+++ linux-2.6.18-mm/arch/um/os-Linux/irq.c	2007-01-10 15:34:43.000000000 -0500
@@ -20,6 +20,10 @@
 #include "os.h"
 #include "um_malloc.h"
 
+/*
+ * Locked by irq_lock in arch/um/kernel/irq.c.  Changed by os_create_pollfd
+ * and os_free_irq_by_cb, which are called under irq_lock.
+ */
 static struct pollfd *pollfds = NULL;
 static int pollfds_num = 0;
 static int pollfds_size = 0;
@@ -58,7 +62,7 @@ int os_create_pollfd(int fd, int events,
 	if (pollfds_num == pollfds_size) {
 		if (size_tmpfds <= pollfds_size * sizeof(pollfds[0])) {
 			/* return min size needed for new pollfds area */
-			return((pollfds_size + 1) * sizeof(pollfds[0]));
+			return (pollfds_size + 1) * sizeof(pollfds[0]);
 		}
 
 		if (pollfds != NULL) {

