Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbYCUGYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbYCUGYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 02:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbYCUGTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 02:19:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49207 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753557AbYCUGS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 02:18:56 -0400
Message-Id: <20080321061727.491610308@sgi.com>
References: <20080321061703.921169367@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Mar 2008 23:17:17 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [14/14] vcompound: Avoid vmalloc for ehash_locks
Content-Disposition: inline; filename=tcpinit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid the use of vmalloc for the ehash locks.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/net/inet_hashtables.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.25-rc5-mm1/include/net/inet_hashtables.h
===================================================================
--- linux-2.6.25-rc5-mm1.orig/include/net/inet_hashtables.h	2008-03-20 22:21:02.680501729 -0700
+++ linux-2.6.25-rc5-mm1/include/net/inet_hashtables.h	2008-03-20 22:22:15.416565317 -0700
@@ -164,7 +164,8 @@ static inline int inet_ehash_locks_alloc
 	if (sizeof(rwlock_t) != 0) {
 #ifdef CONFIG_NUMA
 		if (size * sizeof(rwlock_t) > PAGE_SIZE)
-			hashinfo->ehash_locks = vmalloc(size * sizeof(rwlock_t));
+			hashinfo->ehash_locks = __alloc_vcompound(GFP_KERNEL,
+				get_order(size * sizeof(rwlock_t)));
 		else
 #endif
 		hashinfo->ehash_locks =	kmalloc(size * sizeof(rwlock_t),
@@ -185,7 +186,7 @@ static inline void inet_ehash_locks_free
 		unsigned int size = (hashinfo->ehash_locks_mask + 1) *
 							sizeof(rwlock_t);
 		if (size > PAGE_SIZE)
-			vfree(hashinfo->ehash_locks);
+			__free_vcompound(hashinfo->ehash_locks);
 		else
 #endif
 		kfree(hashinfo->ehash_locks);

-- 
