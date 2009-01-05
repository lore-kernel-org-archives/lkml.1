Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZAEKBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZAEKBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZAEKBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:01:24 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:26482 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbZAEKBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:01:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kc9EKULqtq4pl/7/HVROg87SDnJNJHLcv/BdAh6AEUvSjrOtvevYxgxhdjvkhDEcZa
         LT5z2xA2WqtYRBfPA7m8xDszJ5aOk25zlrd1NCCK4BX66hKiWB5inJMPaNJwTi2h7yVh
         rLvjQiwumUqaQdP1RNFgfe3i8BeRt54wyX9lM=
Date: Mon, 5 Jan 2009 13:01:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow
Message-ID: <20090105100120.GB7645@localhost>
References: <20090105094034.GA7645@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105094034.GA7645@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Mon, Jan 05, 2009 at 12:40:34PM +0300]
| __nr_to_section should check for array bound overflow.
| We should better get NULL dereference then silently
| pass some memory snippet out of bounds to a caller.
| 
| Also add a comment about mem_section structure.
| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| ---
| 
| Please review. Some __nr_to_section callers don't check
| for NULL returned so this patch could be a bit dangerous
| but should reveal the problems eventually.
|
...

Populating WARN_ON_ONCE by inline is not good. Fixed.

		- Cyrill -
---

[PATCH] mm: __nr_to_section - make it safe against overflow

__nr_to_section should check for array bound overflow.
We should better get NULL dereference then silently
pass some memory snippet out of bounds to a caller.

Also add a comment about mem_section structure.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 include/linux/mmzone.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6.git/include/linux/mmzone.h
===================================================================
--- linux-2.6.git.orig/include/linux/mmzone.h
+++ linux-2.6.git/include/linux/mmzone.h
@@ -935,6 +935,12 @@ static inline unsigned long early_pfn_to
 
 struct page;
 struct page_cgroup;
+
+/*
+ * NOTE: sizeof(struct mem_section) _must_ be power of 2
+ * otherwise SECTION_ROOT_MASK will be broken so be
+ * really cautious while modifying this structure
+ */
 struct mem_section {
 	/*
 	 * This is, logically, a pointer to an array of struct
@@ -980,9 +986,13 @@ extern struct mem_section mem_section[NR
 
 static inline struct mem_section *__nr_to_section(unsigned long nr)
 {
-	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
+	unsigned long idx = SECTION_NR_TO_ROOT(nr);
+
+	WARN_ON(idx >= NR_SECTION_ROOTS);
+	if (idx >= NR_SECTION_ROOTS || !mem_section[idx])
 		return NULL;
-	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
+
+	return &mem_section[idx][nr & SECTION_ROOT_MASK];
 }
 extern int __section_nr(struct mem_section* ms);
 extern unsigned long usemap_size(void);
