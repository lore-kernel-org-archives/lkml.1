Return-Path: <linux-kernel-owner+w=401wt.eu-S932254AbZKSBXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbZKSBXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 20:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932137AbZKSBXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 20:23:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34446 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbZKSBXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 20:23:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]  [for mmotm-1113] mm: Simplify try_to_unmap_one()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20091118151803.35f55ca3.akpm@linux-foundation.org>
References: <20091117173759.3DF6.A69D9226@jp.fujitsu.com> <20091118151803.35f55ca3.akpm@linux-foundation.org>
Message-Id: <20091119100525.3E2B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 19 Nov 2009 10:23:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 17 Nov 2009 17:39:27 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > +out_mlock:
> > +	pte_unmap_unlock(pte, ptl);
> > +
> > +	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
> > +		if (vma->vm_flags & VM_LOCKED) {
> > +			mlock_vma_page(page);
> > +			ret = SWAP_MLOCK;
> >  		}
> > +		up_read(&vma->vm_mm->mmap_sem);
> 
> It's somewhat unobvious why we're using a trylock here.  Ranking versus
> lock_page(), perhaps?
> 
> In general I think a trylock should have an associated comment which explains
> 
> a) why it is being used at this site and
> 
> b) what happens when the trylock fails - why this isn't a
>    bug, how the kernel recovers from the inconsistency, what its
>    overall effect is, etc.
> 
> <wonders why we need to take mmap_sem here at all>

This mmap_sem is needed certainenaly. Following comment is sufficient?


---
 mm/rmap.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 70dec01..b1c9342 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -860,6 +860,14 @@ out:
 out_mlock:
 	pte_unmap_unlock(pte, ptl);
 
+
+	/*
+	 * We need mmap_sem locking, Otherwise VM_LOCKED check makes
+	 * unstable result and race. Plus, We can't wait here because
+	 * we now hold anon_vma->lock or mapping->i_mmap_lock.
+	 * If trylock failed, The page remain evictable lru and
+	 * retry to more unevictable lru by later vmscan.
+	 */
 	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
 		if (vma->vm_flags & VM_LOCKED) {
 			mlock_vma_page(page);
-- 
1.6.2.5



