Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbYEOCk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbYEOCk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 22:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYEOCks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 22:40:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:39263 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbYEOCkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 22:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SwVlDguuAmhRC6aJwK9QloYFYXrxZUZ+J3/EzLGZlGWnmiIxolGY9H0ZiqQXSIptn8of1u/IVDy/lUdAdz/QWxbzeP/Leu1p5cnWssDviJ43Xcoei33ZEOzI2JfGOaKcWchirxqO7TdNOGtlKMP1TViXq+TfarO7WEA/n04tATU=
Subject: [PATCHv2 1/2] mtd: mtdchar.c silence sparse warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 May 2008 19:40:46 -0700
Message-Id: <1210819246.6191.60.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The copy_to_user was casting away the address space to get the offset
of the length member.  Use offsetof() instead and add it to the void __user *argp.

drivers/mtd/mtdchar.c:527:23: warning: cast removes address space of expression
drivers/mtd/mtdchar.c:527:23: warning: incorrect type in argument 1 (different address spaces)
drivers/mtd/mtdchar.c:527:23:    expected void [noderef] <asn:1>*to
drivers/mtd/mtdchar.c:527:23:    got unsigned int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/mtd/mtdchar.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 5d3ac51..9c2af46 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -481,6 +481,7 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 	{
 		struct mtd_oob_buf buf;
 		struct mtd_oob_ops ops;
+		struct mtd_oob_buf __user *user_buf = argp;
 	        uint32_t retlen;
 
 		if(!(file->f_mode & 2))
@@ -524,8 +525,7 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 		if (ops.oobretlen > 0xFFFFFFFFU)
 			ret = -EOVERFLOW;
 		retlen = ops.oobretlen;
-		if (copy_to_user(&((struct mtd_oob_buf *)argp)->length,
-				 &retlen, sizeof(buf.length)))
+		if (copy_to_user(&user_buf->length, &retlen, sizeof(buf.length)))
 			ret = -EFAULT;
 
 		kfree(ops.oobbuf);
-- 
1.5.5.1.482.g0f174


