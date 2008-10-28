Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbYJ1U66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbYJ1U66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYJ1U6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:58:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47650 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbYJ1U6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:58:48 -0400
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com, aliguori@codemonkey.ws,
       npiggin@suse.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: [PATCH] regression: vmalloc easily fail.
Date: Tue, 28 Oct 2008 20:55:13 -0200
Message-Id: <1225234513-3996-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit db64fe02258f1507e13fe5212a989922323685ce broke
KVM (the symptom) for me. The cause is that vmalloc
allocations fail, despite of the fact that /proc/meminfo
shows plenty of vmalloc space available.

After some investigation, it seems to me that the current
way to compute the next addr in the rb-tree transversal
leaves a spare page between each allocation. After a few
allocations, regardless of their size, we run out of vmalloc
space.

Signed-off-by: Glauber Costa <glommer@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
---
 mm/vmalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0365369..a33b0d1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -363,7 +363,7 @@ retry:
 		}
 
 		while (addr + size >= first->va_start && addr + size <= vend) {
-			addr = ALIGN(first->va_end + PAGE_SIZE, align);
+			addr = ALIGN(first->va_end, align);
 
 			n = rb_next(&first->rb_node);
 			if (n)
-- 
1.5.6.5

