Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXL2MfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXL2MfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 07:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbXL2MfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 07:35:12 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:19012 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbXL2MfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 07:35:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=x0EPf20/ghiWnouTPWni3hGPAf/ywvJTcZr4N1Hfut3M62u1joMnUJPLcoYfQihwAXRD+Uq8VSN9+IKjEiYz1+VNDm6JqiUVWf095xQnl7O5aIORUi4bgiZfvQq4FtxseFwlIWUtsaPpE+F7VN5xC0Bi94o1h53ow/YWM6aMSVI=
Message-ID: <28c262360712290435w54b29c18ndd63b91369b27512@mail.gmail.com>
Date: Sat, 29 Dec 2007 21:35:07 +0900
From: "minchan kim" <minchan.kim@gmail.com>
To: akpm@linux-foundation.org
Subject: [PATCH] remove calculation for reclaiming anonymose page if system have no swap device
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If system have no swap device, scan_control's may_swap field have to
be set to zero.
This patch will remove redundant calc_reclaim_mapped call which called
in shrink_active_list by sc->may_swap.

This patch is made from 2.6.24-rc6-mm1.

Signed-off-by: minchan kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 45cee1c..7284d79 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1427,7 +1427,11 @@ unsigned long try_to_free_pages(struct zone
**zones, int order, gfp_t gfp_mask)
        .gfp_mask = gfp_mask,
        .may_writepage = !laptop_mode,
        .swap_cluster_max = SWAP_CLUSTER_MAX,
+#ifdef CONFIG_SWAP
        .may_swap = 1,
+#else
+       .may_swap = 0,
+#endif
        .swappiness = vm_swappiness,
        .order = order,
        .mem_cgroup = NULL,
@@ -1445,7 +1449,11 @@ unsigned long
try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
    struct scan_control sc = {
        .gfp_mask = gfp_mask,
        .may_writepage = !laptop_mode,
+#ifdef CONFIG_SWAP
        .may_swap = 1,
+#else
+       .may_swap = 0,
+#endif
        .swap_cluster_max = SWAP_CLUSTER_MAX,
        .swappiness = vm_swappiness,
        .order = 0,
@@ -1493,7 +1501,11 @@ static unsigned long balance_pgdat(pg_data_t
*pgdat, int order)
    struct reclaim_state *reclaim_state = current->reclaim_state;
    struct scan_control sc = {
        .gfp_mask = GFP_KERNEL,
+#ifdef CONFIG_SWAP
        .may_swap = 1,
+#else
+       .may_swap = 0,
+#endif
        .swap_cluster_max = SWAP_CLUSTER_MAX,
        .swappiness = vm_swappiness,
        .order = order,
@@ -2003,7 +2015,11 @@ static int __zone_reclaim(struct zone *zone,
gfp_t gfp_mask, unsigned int order)
    unsigned long nr_reclaimed = 0;
    struct scan_control sc = {
        .may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
+#ifdef CONFIG_SWAP
        .may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
+#else
+       .may_swap = 0,
+#endif
        .swap_cluster_max = max_t(unsigned long, nr_pages,
                    SWAP_CLUSTER_MAX),
        .gfp_mask = gfp_mask,
-- 
1.5.2.5




-- 
Kinds regards,
minchan kim
