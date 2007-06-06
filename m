Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbXFFPel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbXFFPel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbXFFPeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:34:31 -0400
Received: from [198.99.130.12] ([198.99.130.12]:56604 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759989AbXFFPea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:34:30 -0400
Date: Wed, 6 Jun 2007 11:25:57 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] UML - Get declaration of simple_strtoul
Message-ID: <20070606152557.GA7234@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/kernel.h wherever simple_strtoul is used.  This kills a
compile warning in stderr_console.c and potential ones in the other
files.

This also fixes a bunch of style violations in exitcode.c.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/line.c           |    1 +
 arch/um/drivers/stderr_console.c |    1 +
 arch/um/drivers/ubd_kern.c       |    1 +
 arch/um/kernel/exitcode.c        |   39 +++++++++++++++++----------------------
 4 files changed, 20 insertions(+), 22 deletions(-)

Index: linux-2.6.21-mm/arch/um/drivers/stderr_console.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/stderr_console.c	2007-05-28 11:06:27.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/stderr_console.c	2007-06-06 09:31:06.000000000 -0400
@@ -1,3 +1,4 @@
+#include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/console.h>
 
Index: linux-2.6.21-mm/arch/um/drivers/line.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/line.c	2007-06-06 09:28:13.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/line.c	2007-06-06 11:13:03.000000000 -0400
@@ -3,6 +3,7 @@
  * Licensed under the GPL
  */
 
+#include "linux/kernel.h"
 #include "linux/sched.h"
 #include "linux/slab.h"
 #include "linux/list.h"
Index: linux-2.6.21-mm/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/ubd_kern.c	2007-06-06 09:28:47.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/ubd_kern.c	2007-06-06 11:13:42.000000000 -0400
@@ -20,6 +20,7 @@
 #define MAJOR_NR UBD_MAJOR
 #define UBD_SHIFT 4
 
+#include "linux/kernel.h"
 #include "linux/module.h"
 #include "linux/blkdev.h"
 #include "linux/hdreg.h"
Index: linux-2.6.21-mm/arch/um/kernel/exitcode.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/exitcode.c	2007-05-28 11:06:28.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/exitcode.c	2007-06-06 11:23:09.000000000 -0400
@@ -1,8 +1,9 @@
-/* 
+/*
  * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
  * Licensed under the GPL
  */
 
+#include "linux/kernel.h"
 #include "linux/init.h"
 #include "linux/ctype.h"
 #include "linux/proc_fs.h"
@@ -24,11 +25,14 @@ static int read_proc_exitcode(char *page
 	val = uml_exitcode;
 	len = sprintf(page, "%d\n", val);
 	len -= off;
-	if(len <= off+count) *eof = 1;
+	if(len <= off+count)
+		*eof = 1;
 	*start = page + off;
-	if(len > count) len = count;
-	if(len < 0) len = 0;
-	return(len);
+	if(len > count)
+		len = count;
+	if(len < 0)
+		len = 0;
+	return len;
 }
 
 static int write_proc_exitcode(struct file *file, const char __user *buffer,
@@ -38,12 +42,14 @@ static int write_proc_exitcode(struct fi
 	int tmp;
 
 	if(copy_from_user(buf, buffer, count))
-		return(-EFAULT);
+		return -EFAULT;
+
 	tmp = simple_strtol(buf, &end, 0);
 	if((*end != '\0') && !isspace(*end))
-		return(-EINVAL);
+		return -EINVAL;
+
 	uml_exitcode = tmp;
-	return(count);
+	return count;
 }
 
 static int make_proc_exitcode(void)
@@ -54,24 +60,13 @@ static int make_proc_exitcode(void)
 	if(ent == NULL){
 		printk(KERN_WARNING "make_proc_exitcode : Failed to register "
 		       "/proc/exitcode\n");
-		return(0);
+		return 0;
 	}
 
 	ent->read_proc = read_proc_exitcode;
 	ent->write_proc = write_proc_exitcode;
-	
-	return(0);
+
+	return 0;
 }
 
 __initcall(make_proc_exitcode);
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
