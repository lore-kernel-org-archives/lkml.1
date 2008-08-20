Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYHTHri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYHTHri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 03:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYHTHr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 03:47:29 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:55276 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYHTHr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 03:47:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=d74RoLzo5vIeRn660Gr1FI2T4zhsJssgwsha8PBwTRSblYA8Ao4oT7GKhT/sl938kz
         7+8ku+9tu1SEdnQp5u18amchzOrIQUWUZGq8qE5/oHbaWDVbWfHMgwNa9iuY34SCHQpA
         PM75OADcS2ZHlnTONqIB5FgbW0pWHPZ8sEe+E=
Message-ID: <48ABCC0B.40607@gmail.com>
Date: Wed, 20 Aug 2008 00:47:23 -0700
From: Zev Weiss <zevweiss@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [MTD] mtdchar.c: Fix regression in MEMGETREGIONINFO ioctl()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zev Weiss <zevweiss@gmail.com>

The MEMGETREGIONINFO ioctl() in mtdchar.c was clobbering user memory by
overwriting more than intended, due to the size of struct
mtd_erase_region_info changing in commit
0ecbc81adfcb9f15f86b05ff576b342ce81bbef8.

Fix uses a member-by-member copy into a local struct region_info_user,
which is then copy_to_user()'d (and matches the size correctly by being
of the same type as the pointer passed in the ioctl() call).

Signed-off-by: Zev Weiss <zevweiss@gmail.com>
Tested-by: Zev Weiss <zevweiss@gmail.com>
---
I had been having some problems with userspace memory corruption, and traced
them to a MEMGETREGIONINFO ioctl() on an MTD device.  I applied this patch and
it seems to fix the problem, though I am not an expert and there may be a more
correct way to go about doing this.  I'm also new at submitting patches, so
hopefully I haven't screwed up the patch-submission etiquette too
horrifically.

  drivers/mtd/mtdchar.c |   11 +++++++++--
  1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 13cc67a..0acb135 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -411,14 +411,21 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
  	case MEMGETREGIONINFO:
  	{
  		struct region_info_user ur;
+		struct mtd_erase_region_info *kr;

  		if (copy_from_user(&ur, argp, sizeof(struct region_info_user)))
  			return -EFAULT;

  		if (ur.regionindex >= mtd->numeraseregions)
  			return -EINVAL;
-		if (copy_to_user(argp, &(mtd->eraseregions[ur.regionindex]),
-				sizeof(struct mtd_erase_region_info)))
+
+		kr = &(mtd->eraseregions[ur.regionindex]);
+
+		ur.offset = kr->offset;
+		ur.erasesize = kr->erasesize;
+		ur.numblocks = kr->numblocks;
+
+		if (copy_to_user(argp, &ur, sizeof(struct region_info_user)))
  			return -EFAULT;
  		break;
  	}
