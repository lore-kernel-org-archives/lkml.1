Return-Path: <linux-kernel-owner+w=401wt.eu-S935472AbYBBXDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935472AbYBBXDo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934395AbYBBXCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:02:45 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35450 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765648AbYBBXCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:02:43 -0500
Message-Id: <20080202230226.241445883@szeredi.hu>
References: <20080202230111.346847183@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Sun, 03 Feb 2008 00:01:12 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 1/3] mm: bdi: fix read_ahead_kb_store()
Content-Disposition: inline; filename=mm-bdi-fix-read_ahead_kb_store.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This managed to completely evade testing :(

Fix return value to be count or -errno.  Also bring the function in
line with the other store functions on this object, which have more
strict input checking.

Also fix bdi_set_max_ratio() to actually return an error, instead of
always zero.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/mm/backing-dev.c
===================================================================
--- linux.orig/mm/backing-dev.c	2008-02-02 23:21:50.000000000 +0100
+++ linux/mm/backing-dev.c	2008-02-02 23:26:01.000000000 +0100
@@ -16,10 +16,15 @@ static ssize_t read_ahead_kb_store(struc
 {
 	struct backing_dev_info *bdi = dev_get_drvdata(dev);
 	char *end;
+	unsigned long read_ahead_kb;
+	ssize_t ret = -EINVAL;
 
-	bdi->ra_pages = simple_strtoul(buf, &end, 10) >> (PAGE_SHIFT - 10);
-
-	return end - buf;
+	read_ahead_kb = simple_strtoul(buf, &end, 10);
+	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
+		bdi->ra_pages = read_ahead_kb >> (PAGE_SHIFT - 10);
+		ret = count;
+	}
+	return ret;
 }
 
 #define K(pages) ((pages) << (PAGE_SHIFT - 10))
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2008-02-02 20:51:26.000000000 +0100
+++ linux/mm/page-writeback.c	2008-02-02 23:26:15.000000000 +0100
@@ -288,7 +288,7 @@ int bdi_set_max_ratio(struct backing_dev
 	}
 	spin_unlock_irqrestore(&bdi_lock, flags);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(bdi_set_max_ratio);
 

--
