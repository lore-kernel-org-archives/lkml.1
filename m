Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYFAX2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYFAX2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbYFAX11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:27:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:2864 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbYFAX10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=lXpDI6I0mVklL0d5mciqIuf0Og1i2EYqMfqBWPFU3XY9S2lZAFFdrNRXyez3v+xzeuDqerziVkSI5XMwteDRmc+21YHIEdKmLjPN9fKYcMZ94wXK8Vx7tSEsjsvTkjsJEG5I4WpX2EudClU0wB06MGVOJTmgPLI2uFQ2Wo4WQtU=
Message-Id: <20080601231511.232641309@gmail.com>
References: <20080601231329.223608711@gmail.com>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 08:13:34 +0900
From: akinobu.mita@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <kkeil@suse.de>
Subject: [patch -v2 05/23] isdn: use simple_read_from_buffer
Content-Disposition: inline; filename=isdn-hysdn-use-simple-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hysdn/hysdn_procconf.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

Index: 2.6-git/drivers/isdn/hysdn/hysdn_procconf.c
===================================================================
--- 2.6-git.orig/drivers/isdn/hysdn/hysdn_procconf.c
+++ 2.6-git/drivers/isdn/hysdn/hysdn_procconf.c
@@ -207,30 +207,17 @@ hysdn_conf_write(struct file *file, cons
 /* read conf file -> output card info data */
 /*******************************************/
 static ssize_t
-hysdn_conf_read(struct file *file, char __user *buf, size_t count, loff_t * off)
+hysdn_conf_read(struct file *file, char __user *buf, size_t count, loff_t *off)
 {
 	char *cp;
-	int i;
 
-	if (file->f_mode & FMODE_READ) {
-		if (!(cp = file->private_data))
-			return (-EFAULT);	/* should never happen */
-		i = strlen(cp);	/* get total string length */
-		if (*off < i) {
-			/* still bytes to transfer */
-			cp += *off;	/* point to desired data offset */
-			i -= *off;	/* remaining length */
-			if (i > count)
-				i = count;	/* limit length to transfer */
-			if (copy_to_user(buf, cp, i))
-				return (-EFAULT);	/* copy error */
-			*off += i;	/* adjust offset */
-		} else
-			return (0);
-	} else
-		return (-EPERM);	/* no permission to read */
+	if (!(file->f_mode & FMODE_READ))
+		return -EPERM;	/* no permission to read */
 
-	return (i);
+	if (!(cp = file->private_data))
+		return -EFAULT;	/* should never happen */
+
+	return simple_read_from_buffer(buf, count, off, cp, strlen(cp));
 }				/* hysdn_conf_read */
 
 /******************/

-- 
