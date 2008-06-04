Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbYFDMMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbYFDMMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760517AbYFDMKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:06 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:50343 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760616AbYFDMKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=xZ2IWGFkx1eEWiLUE7T3AMudbeilIMob5iF3L1RhvaWodkvWJ1oAdjLq1MpIajk/Ak
         47Ii4kv1+J/9IeUQC4PAPOoSY6krLlRQigA79hwz3Z0+BWw670SLsfGWA4Ce5RRs6wWT
         jlIfHPiffQ8QfCdjnGcKvh46pSsvGj80iIq4w=
Message-Id: <20080604115742.108954119@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:41 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Greg Kroah-Hartman <greg@kroah.com>
Subject: [patch -v3 08/22] usbmon: use simple_read_from_buffer
Content-Disposition: inline; filename=mon-use-simple-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
---
 drivers/usb/mon/mon_stat.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

Index: 2.6-git/drivers/usb/mon/mon_stat.c
===================================================================
--- 2.6-git.orig/drivers/usb/mon/mon_stat.c
+++ 2.6-git/drivers/usb/mon/mon_stat.c
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/usb.h>
+#include <linux/fs.h>
 #include <asm/uaccess.h>
 
 #include "usb_mon.h"
@@ -42,19 +43,8 @@ static ssize_t mon_stat_read(struct file
 				size_t nbytes, loff_t *ppos)
 {
 	struct snap *sp = file->private_data;
-	loff_t pos = *ppos;
-	int cnt;
 
-	if (pos < 0 || pos >= sp->slen)
-		return 0;
-	if (nbytes == 0)
-		return 0;
-	if ((cnt = sp->slen - pos) > nbytes)
-		cnt = nbytes;
-	if (copy_to_user(buf, sp->str + pos, cnt))
-		return -EFAULT;
-	*ppos = pos + cnt;
-	return cnt;
+	return simple_read_from_buffer(buf, nbytes, ppos, sp->str, sp->slen);
 }
 
 static int mon_stat_release(struct inode *inode, struct file *file)

-- 
