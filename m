Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbYEVWbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbYEVWbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760213AbYEVWa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:30:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38833 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760357AbYEVWa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:30:56 -0400
Date: Thu, 22 May 2008 23:18:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aacraid: BKL push down
Message-ID: <20080522231827.32e68a08@core>
In-Reply-To: <Pine.LNX.4.64.0805221454560.3694@shark.he.net>
References: <20080522223957.6c079b33@core>
	<Pine.LNX.4.64.0805221454560.3694@shark.he.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 14:55:20 -0700 (PDT)
"Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> On Thu, 22 May 2008, Alan Cox wrote:
> 
> > The aacraid definitely needs the BKL internally right now so push the
> > lock take down into the driver but go no further
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> 
> Wrong patch file ??

Correct one below

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 1f7c836..f0aaee7 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -692,12 +692,16 @@ static int aac_cfg_open(struct inode *inode, struct file *file)
  *	Bugs: Needs to handle hot plugging
  */
 
-static int aac_cfg_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long aac_cfg_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
+	long ret;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	return aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
+	lock_kernel();
+	ret = aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
+	unlock_kernel();
+	return ret;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1016,7 +1020,7 @@ ssize_t aac_get_serial_number(struct device *device, char *buf)
 
 static const struct file_operations aac_cfg_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= aac_cfg_ioctl,
+	.unlocked_ioctl	= aac_cfg_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl   = aac_compat_cfg_ioctl,
 #endif
