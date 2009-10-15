Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbZJOA7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbZJOA7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 20:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZJOA73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 20:59:29 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:2620 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbZJOA73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 20:59:29 -0400
X-Trace: 274118630/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.53.219/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.53.219
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYAAL0Q1kpPRTXb/2dsb2JhbAAI2jmELgQ
X-IronPort-AV: E=Sophos;i="4.44,562,1249254000"; 
   d="scan'208";a="274118630"
Date: Thu, 15 Oct 2009 01:58:51 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 9/9] swap_info: reorder its fields
In-Reply-To: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
Message-ID: <Pine.LNX.4.64.0910150157310.3291@sister.anvils>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder (and comment) the fields of swap_info_struct, to make better
use of its cachelines: it's good for swap_duplicate() in particular
if unsigned int max and swap_map are near the start.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 include/linux/swap.h |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- si8/include/linux/swap.h	2009-10-14 21:27:07.000000000 +0100
+++ si9/include/linux/swap.h	2009-10-14 21:27:14.000000000 +0100
@@ -167,21 +167,21 @@ struct swap_info_struct {
 	signed short	prio;		/* swap priority of this type */
 	signed char	type;		/* strange name for an index */
 	signed char	next;		/* next type on the swap list */
-	struct file *swap_file;
-	struct block_device *bdev;
-	struct swap_extent first_swap_extent;
-	struct swap_extent *curr_swap_extent;
-	unsigned char *swap_map;
-	unsigned int lowest_bit;
-	unsigned int highest_bit;
+	unsigned int	max;		/* extent of the swap_map */
+	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
+	unsigned int lowest_bit;	/* index of first free in swap_map */
+	unsigned int highest_bit;	/* index of last free in swap_map */
+	unsigned int pages;		/* total of usable pages of swap */
+	unsigned int inuse_pages;	/* number of those currently in use */
+	unsigned int cluster_next;	/* likely index for next allocation */
+	unsigned int cluster_nr;	/* countdown to next cluster search */
 	unsigned int lowest_alloc;	/* while preparing discard cluster */
 	unsigned int highest_alloc;	/* while preparing discard cluster */
-	unsigned int cluster_next;
-	unsigned int cluster_nr;
-	unsigned int pages;
-	unsigned int max;
-	unsigned int inuse_pages;
-	unsigned int old_block_size;
+	struct swap_extent *curr_swap_extent;
+	struct swap_extent first_swap_extent;
+	struct block_device *bdev;	/* swap device or bdev of swap file */
+	struct file *swap_file;		/* seldom referenced */
+	unsigned int old_block_size;	/* seldom referenced */
 };
 
 struct swap_list_t {
