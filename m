Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0AOSZo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997Ab0AOSZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:25:43 -0500
Received: from [206.15.93.42] ([206.15.93.42]:21737 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752192Ab0AOSZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:25:42 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH] mtdchar.c: fix different address space noise
Date: Fri, 15 Jan 2010 11:25:38 -0700
Cc: dwmw2@infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001151125.39100.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mtdchar.c: fix different address space noise

In mtd_ioctl MEMGETREGIONINFO the region_user_info pointer ur
is cast in __kernel space. This produces a number of sparse warnings
like:

warning: cast removes address space of expression
warning: incorrect type in initializer (different address spaces)
   expected unsigned int const [noderef] <asn:1>*register __p
   got unsigned int *<noident>

Since argp is already a void __user * just use it dirrectly without
the cast and make ur a __user *.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 5b081cb..0a85085 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -482,7 +482,7 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 	{
 		uint32_t ur_idx;
 		struct mtd_erase_region_info *kr;
-		struct region_info_user *ur = (struct region_info_user *) argp;
+		struct region_info_user __user *ur = argp;
 
 		if (get_user(ur_idx, &(ur->regionindex)))
 			return -EFAULT;
