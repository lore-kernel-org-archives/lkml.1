Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYJROxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYJROxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 10:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYJROxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 10:53:31 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:25722 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYJROxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 10:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=t7TvxpCBB+ppxAJiMhbenw8Nimpub6QZIF51TS3znFW2pwAM15W3P40IAT7LXn/jex
         5N/lsDL2Mk5URL88X/+fug/QBxAiQno+TbUN67agffbGdTpRnRPbnuliIEr3XdBT+uch
         dF/5TCfusJ7IWIfWkfnpPFvnWP+853wRX9yZ4=
Date: Sat, 18 Oct 2008 16:53:37 +0200
From: dcg <diegocg@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix leak in drivers/staging/at76_usb.c
Message-ID: <20081018165337.284f6307@diego-desktop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix leak in at76_usb as reported in:
http://bugzilla.kernel.org/show_bug.cgi?id=11778


Reported-by: Daniel Marjamäki <danielm77@spray.se>
Signed-off-by: Diego Calleja <diegocg@gmail.com>

Index: 2.6/drivers/staging/at76_usb/at76_usb.c
===================================================================
--- 2.6.orig/drivers/staging/at76_usb/at76_usb.c	2008-10-18 16:19:38.000000000 +0200
+++ 2.6/drivers/staging/at76_usb/at76_usb.c	2008-10-18 16:20:21.000000000 +0200
@@ -2319,9 +2319,11 @@
 	if (!iwe)
 		return -ENOMEM;
 
-	if (priv->scan_state != SCAN_COMPLETED)
+	if (priv->scan_state != SCAN_COMPLETED) {
 		/* scan not yet finished */
+		kfree(iwe);
 		return -EAGAIN;
+	}
 
 	spin_lock_irqsave(&priv->bss_list_spinlock, flags);
 
