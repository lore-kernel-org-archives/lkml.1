Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYIAMTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYIAMTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 08:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYIAMT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 08:19:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:62906 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbYIAMT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 08:19:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cOWiF4WmAn7ZNbsINAf9R3oLLB+JkSgVyRxPH6eq+0iSXmhRSc6u7YE77mf2WUfSc2
         B0NAKCTT16qFnnbs6+TMH4JSH2tziY6aOJmxpNlKbjggXPHQzeDzB42dnauFothepdSI
         eJqtFwJkl8GlE3iE/ZnbCp2pC4aAUPUYPSIpU=
Message-ID: <48BBDDC9.9020003@gmail.com>
Date: Mon, 01 Sep 2008 05:19:21 -0700
From: Zev Weiss <zevweiss@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCH] [MTD] mtdchar.c: Fix regression in MEMGETREGIONINFO	ioctl()
References: <48ABCC0B.40607@gmail.com>	 <20080822153451.bb79bd1f.akpm@linux-foundation.org>	 <48AFC5ED.50005@gmail.com>	 <20080823222707.2fb972b5.akpm@linux-foundation.org>	 <48B13F88.3080306@gmail.com>  <48B4D884.5040204@gmail.com> <1220266884.2982.62.camel@pmac.infradead.org>
In-Reply-To: <1220266884.2982.62.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zev Weiss <zevweiss@gmail.com>
Date: Mon, 1 Sep 2008 05:02:12 -0700
Subject: [PATCH] [MTD] mtdchar.c: Fix regression in MEMGETREGIONINFO ioctl()

The MEMGETREGIONINFO ioctl() in mtdchar.c was clobbering user memory by
overwriting more than intended, due the size of struct mtd_erase_region_info
changing in commit 0ecbc81adfcb9f15f86b05ff576b342ce81bbef8.

Fix avoids this by copying struct members one by one with put_user(), as there
is no longer a convenient struct to use the size of as the length argument to
copy_to_user().

Signed-off-by: Zev Weiss <zevweiss@gmail.com>
---
  drivers/mtd/mtdchar.c |   16 ++++++++++------
  1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 13cc67a..424f318 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -410,16 +410,20 @@ static int mtd_ioctl(struct inode *inode, struct file *file,

  	case MEMGETREGIONINFO:
  	{
-		struct region_info_user ur;
+		u32 ur_idx;
+		struct mtd_erase_region_info *kr;
+		struct region_info_user *ur = (struct region_info_user *) argp;

-		if (copy_from_user(&ur, argp, sizeof(struct region_info_user)))
+		if (get_user(ur_idx,&(ur->regionindex)))
  			return -EFAULT;

-		if (ur.regionindex >= mtd->numeraseregions)
-			return -EINVAL;
-		if (copy_to_user(argp, &(mtd->eraseregions[ur.regionindex]),
-				sizeof(struct mtd_erase_region_info)))
+		kr = &(mtd->eraseregions[ur_idx]);
+
+		if (put_user(kr->offset, &(ur->offset))
+		    || put_user(kr->erasesize, &(ur->erasesize))
+		    || put_user(kr->numblocks, &(ur->numblocks)))
  			return -EFAULT;
+
  		break;
  	}

-- 
1.5.4.1

