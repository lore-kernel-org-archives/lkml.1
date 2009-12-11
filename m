Return-Path: <linux-kernel-owner+w=401wt.eu-S935094AbZLKXkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935094AbZLKXkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934199AbZLKXg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:36:57 -0500
Received: from kroah.org ([198.145.64.141]:50441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933644AbZLKX24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:56 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/58] tty: stallion: kill BKL ioctl
Date: Fri, 11 Dec 2009 15:27:56 -0800
Message-Id: <1260574122-10676-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/stallion.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index db6dcfa..b4ba5ed 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -407,7 +407,7 @@ static unsigned int	stl_baudrates[] = {
  *	Declare all those functions in this driver!
  */
 
-static int	stl_memioctl(struct inode *ip, struct file *fp, unsigned int cmd, unsigned long arg);
+static long	stl_memioctl(struct file *fp, unsigned int cmd, unsigned long arg);
 static int	stl_brdinit(struct stlbrd *brdp);
 static int	stl_getportstats(struct tty_struct *tty, struct stlport *portp, comstats_t __user *cp);
 static int	stl_clrportstats(struct stlport *portp, comstats_t __user *cp);
@@ -607,7 +607,7 @@ static unsigned int	sc26198_baudtable[] = {
  */
 static const struct file_operations	stl_fsiomem = {
 	.owner		= THIS_MODULE,
-	.ioctl		= stl_memioctl,
+	.unlocked_ioctl	= stl_memioctl,
 };
 
 static struct class *stallion_class;
@@ -2486,18 +2486,19 @@ static int stl_getbrdstruct(struct stlbrd __user *arg)
  *	collection.
  */
 
-static int stl_memioctl(struct inode *ip, struct file *fp, unsigned int cmd, unsigned long arg)
+static long stl_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	int	brdnr, rc;
 	void __user *argp = (void __user *)arg;
 
-	pr_debug("stl_memioctl(ip=%p,fp=%p,cmd=%x,arg=%lx)\n", ip, fp, cmd,arg);
+	pr_debug("stl_memioctl(fp=%p,cmd=%x,arg=%lx)\n", fp, cmd,arg);
 
-	brdnr = iminor(ip);
+	brdnr = iminor(fp->f_dentry->d_inode);
 	if (brdnr >= STL_MAXBRDS)
 		return -ENODEV;
 	rc = 0;
 
+	lock_kernel();
 	switch (cmd) {
 	case COM_GETPORTSTATS:
 		rc = stl_getportstats(NULL, NULL, argp);
@@ -2518,7 +2519,7 @@ static int stl_memioctl(struct inode *ip, struct file *fp, unsigned int cmd, uns
 		rc = -ENOIOCTLCMD;
 		break;
 	}
-
+	unlock_kernel();
 	return rc;
 }
 
-- 
1.6.5.5

