Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbXIQS6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbXIQS6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbXIQS6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:58:16 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:19084 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbXIQS6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:58:15 -0400
Date: Mon, 17 Sep 2007 19:57:00 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH mm] fix swapoff breakage; however...
Message-ID: <Pine.LNX.4.64.0709171947130.15413@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rc4-mm1's memory-controller-memory-accounting-v7.patch broke swapoff:
it extended unuse_pte_range's boolean "found" return code to allow an
error return too; but ended up returning found (1) as an error.
Replace that by success (0) before it gets to the upper level.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
More fundamentally, it looks like any container brought over its limit in
unuse_pte will abort swapoff: that doesn't doesn't seem "contained" to me.
Maybe unuse_pte should just let containers go over their limits without
error?  Or swap should be counted along with RSS?  Needs reconsideration.

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.23-rc4-mm1/mm/swapfile.c	2007-09-07 13:09:42.000000000 +0100
+++ linux/mm/swapfile.c	2007-09-17 15:14:47.000000000 +0100
@@ -642,7 +642,7 @@ static int unuse_mm(struct mm_struct *mm
 			break;
 	}
 	up_read(&mm->mmap_sem);
-	return ret;
+	return (ret < 0)? ret: 0;
 }
 
 /*
