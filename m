Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbZLPFcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbZLPFcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbZLPFcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:32:47 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:1297 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036AbZLPFcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:32:46 -0500
X-Trace: 308008701/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgQBAJ7/J0tPRRyw/2dsb2JhbAAI1TeEKwQ
X-IronPort-AV: E=Sophos;i="4.47,404,1257120000"; 
   d="scan'208";a="308008701"
Date: Wed, 16 Dec 2009 05:32:26 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Steven King <sfking@fdwdc.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [current HEAD] commit 5ad6468801d28c4d4ac9f48ec19297817c915f6a
 breaks the build on m68knommu
In-Reply-To: <200912151501.05552.sfking@fdwdc.com>
Message-ID: <Pine.LNX.4.64.0912160529440.5529@sister.anvils>
References: <200912151501.05552.sfking@fdwdc.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2009, Steven King wrote:

> and I suspect on any nommu:
> 
> In file included from kernel/fork.c:52:
> include/linux/ksm.h:129: warning: 'enum ttu_flags' declared inside parameter 
> list
> include/linux/ksm.h:129: warning: its scope is only this definition or 
> declaration, which is probably not what you want
> include/linux/ksm.h:129: error: parameter 2 ('flags') has incomplete type
> make[1]: *** [kernel/fork.o] Error 1
> make[1]: *** Waiting for unfinished jobs....

Aargh, sorry about that: I've not built this on nommu, does it fix it?


[PATCH] fix CONFIG_KSM broke nommu build

Commit 5ad6468801d28c4d4ac9f48ec19297817c915f6a "ksm: let shared pages
be swappable" breaks the build on m68knommu and I suspect on any nommu:

In file included from kernel/fork.c:52:
include/linux/ksm.h:129: warning: 'enum ttu_flags' declared inside parameter 
list
include/linux/ksm.h:129: warning: its scope is only this definition or 
declaration, which is probably not what you want
include/linux/ksm.h:129: error: parameter 2 ('flags') has incomplete type
make[1]: *** [kernel/fork.o] Error 1
make[1]: *** Waiting for unfinished jobs....

Let's fix that with CONFIG_MMU around most of the !CONFIG_KSM declarations.

Reported-by: Steven King <sfking@fdwdc.com>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 include/linux/ksm.h |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- 2.6.32-git/include/linux/ksm.h.0	2009-12-16 04:59:25.000000000 +0000
+++ linux/include/linux/ksm.h	2009-12-16 05:14:40.000000000 +0000
@@ -94,12 +94,6 @@ void ksm_migrate_page(struct page *newpa
 
 #else  /* !CONFIG_KSM */
 
-static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
-		unsigned long end, int advice, unsigned long *vm_flags)
-{
-	return 0;
-}
-
 static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	return 0;
@@ -114,6 +108,13 @@ static inline int PageKsm(struct page *p
 	return 0;
 }
 
+#ifdef CONFIG_MMU
+static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, int advice, unsigned long *vm_flags)
+{
+	return 0;
+}
+
 static inline struct page *ksm_might_need_to_copy(struct page *page,
 			struct vm_area_struct *vma, unsigned long address)
 {
@@ -140,6 +141,7 @@ static inline int rmap_walk_ksm(struct p
 static inline void ksm_migrate_page(struct page *newpage, struct page *oldpage)
 {
 }
+#endif /* CONFIG_MMU */
 #endif /* !CONFIG_KSM */
 
 #endif /* __LINUX_KSM_H */
