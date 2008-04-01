Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbYDAQtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbYDAQtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 12:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYDAQtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 12:49:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:40323 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbYDAQtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 12:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=No5DpqAHM96bw4+71t+li4ezVAVhypAxidS1fuqAR3wtMBxF0qNoHLl/wDPDduMYhd/KQTh093Iv3lz607eMDKUjZwcxSHqbFf5XSeo7s1QRebhHVJ/NwjGICy2TBnQ0T8VJ0y8UX4aeW384ZMC+LIvno1yF5ET9R/1QOfnquf8=
Date: Tue, 1 Apr 2008 20:48:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com
Subject: [PATCH] bttv: Bt832 - fix possible NULL pointer deref
Message-ID: <20080401164823.GB7654@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does fix potential NULL pointer dereference

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/drivers/media/video/bt8xx/bt832.c
===================================================================
--- linux-2.6.git.orig/drivers/media/video/bt8xx/bt832.c	2008-01-21 19:35:13.000000000 +0300
+++ linux-2.6.git/drivers/media/video/bt8xx/bt832.c	2008-04-01 20:43:03.000000000 +0400
@@ -97,6 +97,11 @@ int bt832_init(struct i2c_client *i2c_cl
 	int rc;
 
 	buf=kmalloc(65,GFP_KERNEL);
+	if (!buf) {
+		v4l_err(&t->client,
+			"Unable to allocate memory. Detaching.\n");
+		return 0;
+	}
 	bt832_hexdump(i2c_client_s,buf);
 
 	if(buf[0x40] != 0x31) {
@@ -211,7 +216,12 @@ bt832_command(struct i2c_client *client,
 	switch (cmd) {
 		case BT832_HEXDUMP: {
 			unsigned char *buf;
-			buf=kmalloc(65,GFP_KERNEL);
+			buf=kmalloc(65, GFP_KERNEL);
+			if (!buf) {
+				v4l_err(&t->client,
+					"Unable to allocate memory\n");
+				break;
+			}
 			bt832_hexdump(&t->client,buf);
 			kfree(buf);
 		}
