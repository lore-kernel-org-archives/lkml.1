Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbYEOBWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbYEOBWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYEOBWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:22:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:54743 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYEOBWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:22:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qOZJMMI54R7Rca6n9DxzPwz4T7zAFwJJ/KGAllTjJJOrvuluyq6+UJY1s9tUepIweE49cTq6CXPz5dd+fSKJyrVOEcCNF1k0lnzkLrcjthi0coI1KP4cYKbvmvY/7E6NOcZp0ZhZ4ZutSY3HiCkLSr/R72ChGqpCBcd3uFPeQu4=
Subject: [PATCH 1/2] mtd: mtdchar.c silence sparse warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 May 2008 18:22:10 -0700
Message-Id: <1210814530.6191.52.camel@brick>
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
 drivers/mtd/mtdchar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 5d3ac51..3522d4a 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -524,7 +524,7 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 		if (ops.oobretlen > 0xFFFFFFFFU)
 			ret = -EOVERFLOW;
 		retlen = ops.oobretlen;
-		if (copy_to_user(&((struct mtd_oob_buf *)argp)->length,
+		if (copy_to_user(argp + offsetof(struct mtd_oob_buf, length),
 				 &retlen, sizeof(buf.length)))
 			ret = -EFAULT;
 
-- 
1.5.5.1.482.g0f174


