Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbYFDML1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbYFDML1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760500AbYFDMJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:09:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:50343 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760277AbYFDMJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=MCYE6+gx9KtJ1Zzxv5y4xd93wr6adUD8FYKWwWKzh3h5CCJW0FPW+L/n7CI7SQyTCy
         IwWVhJutw4jm3ujb/3ivHoSzQgJ8zrFzNHF8gH7ia0SDo697slEqriG5lSs9q9UeLzs7
         nFbdgLB6Qp51cLIx6/A4IXNMfY7IGi8AnqV28=
Message-Id: <20080604115721.851585803@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:37 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Karsten Keil <kkeil@suse.de>
Subject: [patch -v3 04/22] isdn: use simple_read_from_buffer
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
