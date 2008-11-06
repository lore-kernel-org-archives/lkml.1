Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbYKFTCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbYKFTCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYKFTCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:02:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40584 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYKFTCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:02:09 -0500
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com, npiggin@suse.de
Subject: [PATCH] restart search at beggining of vmalloc address
Date: Thu,  6 Nov 2008 18:58:26 -0200
Message-Id: <1226005106-4974-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current vmalloc restart search for a free area in case we
can't find one. The reason is there are areas which are lazily
freed, and could be possibly freed now. However, current implementation
start searching the tree from the last failing address, which is
pretty much by definition at the end of address space. So, we fail.

The proposal of this patch is to restart the search from the beginning
of the requested vstart address. This fixes the regression in running
KVM virtual machines for me, described in
http://lkml.org/lkml/2008/10/28/349, caused by commit
db64fe02258f1507e13fe5212a989922323685ce.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Nick Piggin <npiggin@suse.de>
---
 mm/vmalloc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7db493d..6fe2003 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -378,6 +378,7 @@ found:
 		if (!purged) {
 			purge_vmap_area_lazy();
 			purged = 1;
+			addr = ALIGN(vstart, align);
 			goto retry;
 		}
 		if (printk_ratelimit())
-- 
1.5.6.5

