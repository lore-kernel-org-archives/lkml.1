Return-Path: <linux-kernel-owner+w=401wt.eu-S935098AbZLKXiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935098AbZLKXiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933644AbZLKXhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:37:01 -0500
Received: from kroah.org ([198.145.64.141]:50440 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404AbZLKX2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:55 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/58] tty: istallion: Kill off the BKL ioctl
Date: Fri, 11 Dec 2009 15:27:55 -0800
Message-Id: <1260574122-10676-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Fairly trivial as the BKL push down into the methods has already been done.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/istallion.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 402838f..babfd44 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -621,7 +621,7 @@ static int	stli_brdinit(struct stlibrd *brdp);
 static int	stli_startbrd(struct stlibrd *brdp);
 static ssize_t	stli_memread(struct file *fp, char __user *buf, size_t count, loff_t *offp);
 static ssize_t	stli_memwrite(struct file *fp, const char __user *buf, size_t count, loff_t *offp);
-static int	stli_memioctl(struct inode *ip, struct file *fp, unsigned int cmd, unsigned long arg);
+static long	stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg);
 static void	stli_brdpoll(struct stlibrd *brdp, cdkhdr_t __iomem *hdrp);
 static void	stli_poll(unsigned long arg);
 static int	stli_hostcmd(struct stlibrd *brdp, struct stliport *portp);
@@ -704,7 +704,7 @@ static const struct file_operations	stli_fsiomem = {
 	.owner		= THIS_MODULE,
 	.read		= stli_memread,
 	.write		= stli_memwrite,
-	.ioctl		= stli_memioctl,
+	.unlocked_ioctl	= stli_memioctl,
 };
 
 /*****************************************************************************/
@@ -4311,7 +4311,7 @@ static int stli_getbrdstruct(struct stlibrd __user *arg)
  *	reset it, and start/stop it.
  */
 
-static int stli_memioctl(struct inode *ip, struct file *fp, unsigned int cmd, unsigned long arg)
+static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	struct stlibrd *brdp;
 	int brdnr, rc, done;
@@ -4356,7 +4356,7 @@ static int stli_memioctl(struct inode *ip, struct file *fp, unsigned int cmd, un
  *	Now handle the board specific ioctls. These all depend on the
  *	minor number of the device they were called from.
  */
-	brdnr = iminor(ip);
+	brdnr = iminor(fp->f_dentry->d_inode);
 	if (brdnr >= STL_MAXBRDS)
 		return -ENODEV;
 	brdp = stli_brds[brdnr];
-- 
1.6.5.5

