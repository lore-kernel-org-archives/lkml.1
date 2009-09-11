Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZIKCc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZIKCc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 22:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZIKCc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 22:32:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:2578 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZIKCcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 22:32:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,367,1249282800"; 
   d="scan'208";a="186432881"
Message-Id: <20090911023200.767391440@intel.com>
References: <20090911022333.324128054@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 10:23:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Avi Kivity <avi@qumranet.com>, Wu Fengguang <fengguang.wu@intel.com>
cc: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] devmem: cleanup unxlate_dev_mem_ptr() calls
Content-Disposition: inline; filename=kmem-dev-mem-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No behavior change.

CC: Marcelo Tosatti <mtosatti@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Johannes Berg <johannes@sipsolutions.net>
CC: Avi Kivity <avi@qumranet.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2009-09-10 21:59:39.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-09-10 22:00:12.000000000 +0800
@@ -131,6 +131,7 @@ static ssize_t read_mem(struct file * fi
 			size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
+	unsigned long ret;
 	ssize_t read, sz;
 	char *ptr;
 
@@ -169,12 +170,10 @@ static ssize_t read_mem(struct file * fi
 		if (!ptr)
 			return -EFAULT;
 
-		if (copy_to_user(buf, ptr, sz)) {
-			unxlate_dev_mem_ptr(p, ptr);
-			return -EFAULT;
-		}
-
+		ret = copy_to_user(buf, ptr, sz);
 		unxlate_dev_mem_ptr(p, ptr);
+		if (ret)
+			return -EFAULT;
 
 		buf += sz;
 		p += sz;
@@ -232,16 +231,14 @@ static ssize_t write_mem(struct file * f
 		}
 
 		copied = copy_from_user(ptr, buf, sz);
+		unxlate_dev_mem_ptr(p, ptr);
 		if (copied) {
 			written += sz - copied;
-			unxlate_dev_mem_ptr(p, ptr);
 			if (written)
 				break;
 			return -EFAULT;
 		}
 
-		unxlate_dev_mem_ptr(p, ptr);
-
 		buf += sz;
 		p += sz;
 		count -= sz;

-- 

