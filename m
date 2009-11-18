Return-Path: <linux-kernel-owner+w=401wt.eu-S1751914AbZKRHXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbZKRHXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 02:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZKRHXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 02:23:00 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:42317 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbZKRHW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 02:22:59 -0500
From: Li Yang <leoli@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@suse.de, Li Yang <leoli@freescale.com>
Subject: [RFC] char/mem: Honor O_SYNC over intelligent setting of uncached access
Date: Wed, 18 Nov 2009 16:05:48 +0800
Message-Id: <1258531548-5015-1-git-send-email-leoli@freescale.com>
X-Mailer: git-send-email 1.6.3.1.6.g4bf1f
X-OriginalArrivalTime: 18 Nov 2009 07:23:03.0094 (UTC) FILETIME=[F7033D60:01CA681F]
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code will automatially set the page non-cacheable if the mmap'ped
address is not in kernel managed low memory.

We already have O_SYNC flag to pass the cacheability settings.   Therefore we should
honor the case that O_SYNC is delibrately not used.  For example, it is useful to the
case that not all system memory is managed by Linux, and want to be mmaped cacheable.

Not sure if there is anything out there depending on the previous behavior.

Signed-off-by: Li Yang <leoli@freescale.com>
---
 drivers/char/mem.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a074fce..34a9b24 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -56,12 +56,10 @@ static inline int uncached_access(struct file *file, unsigned long addr)
 	}
 #else
 	/*
-	 * Accessing memory above the top the kernel knows about or through a file pointer
-	 * that was marked O_SYNC will be done non-cached.
+	 * Accessing memory through a file pointer that was marked O_SYNC will be done
+	 * non-cached.
 	 */
-	if (file->f_flags & O_SYNC)
-		return 1;
-	return addr >= __pa(high_memory);
+	return (file->f_flags & O_SYNC) ? 1 : 0;
 #endif
 }
 
-- 
1.6.3.1.6.g4bf1f

