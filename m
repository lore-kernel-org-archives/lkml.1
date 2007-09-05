Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbXIER4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbXIER4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbXIER4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:56:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:33936 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXIER4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=fQepiauKm14zwWsOLGM5Rius3TL0OQLTElAPlmcIDS0naXDQ6LP4r7g0xi8Z73+MsW0rZTWQJ2hLgyxkf2v3fV5gZjCT+PKVbhikq5RRYZF5+xXiYOSAhq4Pnt8eb+BZnYFmqA+oxyGW+bB2p5CWbnu3tfpq1DZ6cqQHB4lSlJI=
Date: Wed, 5 Sep 2007 21:56:11 +0400
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org,
       T Taneli Vahakangas <vahakang@cs.helsinki.fi>
Subject: [PATCH] Fix select on /proc files without ->poll
Message-ID: <20070905175611.GA1826@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

T Taneli Vahakangas <vahakang@cs.helsinki.fi> reported that
commit 786d7e1612f0b0adb6046f19b906609e4fe8b1ba aka
"Fix rmmod/read/write races in /proc entries"
broke SBCL + SLIME combo.

Old code in do_select() used DEFAULT_POLLMASK, if couldn't find ->poll
handler. New code makes ->poll always there and returns 0 by default,
which is not correct. Return DEFAULT_POLLMASK instead.

Steps to reproduce:

	install emacs, SBCL, SLIME
	emacs
	M-x slime	in *inferior-lisp* buffer
	[watch it doing "Connecting to Swank on port X.."]

Please, apply before 2.6.23.

P.S.: why SBCL can't just read(2) /proc/cpuinfo is a mystery.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/inode.c      |    3 ++-
 fs/select.c          |    2 --
 include/linux/poll.h |    2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -11,6 +11,7 @@
 #include <linux/string.h>
 #include <linux/stat.h>
 #include <linux/completion.h>
+#include <linux/poll.h>
 #include <linux/file.h>
 #include <linux/limits.h>
 #include <linux/init.h>
@@ -232,7 +233,7 @@ static ssize_t proc_reg_write(struct file *file, const char __user *buf, size_t
 static unsigned int proc_reg_poll(struct file *file, struct poll_table_struct *pts)
 {
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
-	unsigned int rv = 0;
+	unsigned int rv = DEFAULT_POLLMASK;
 	unsigned int (*poll)(struct file *, struct poll_table_struct *);
 
 	spin_lock(&pde->pde_unload_lock);
--- a/fs/select.c
+++ b/fs/select.c
@@ -26,8 +26,6 @@
 
 #include <asm/uaccess.h>
 
-#define DEFAULT_POLLMASK (POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM)
-
 struct poll_table_page {
 	struct poll_table_page * next;
 	struct poll_table_entry * entry;
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -21,6 +21,8 @@
 #define WQUEUES_STACK_ALLOC	(MAX_STACK_ALLOC - FRONTEND_STACK_ALLOC)
 #define N_INLINE_POLL_ENTRIES	(WQUEUES_STACK_ALLOC / sizeof(struct poll_table_entry))
 
+#define DEFAULT_POLLMASK (POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM)
+
 struct poll_table_struct;
 
 /* 
