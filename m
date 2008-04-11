Return-Path: <linux-kernel-owner+w=401wt.eu-S1761011AbYDKVZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761011AbYDKVZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 17:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbYDKVZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 17:25:23 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58543 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbYDKVZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 17:25:23 -0400
Date: Sat, 12 Apr 2008 00:25:21 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: 2.6.25-rc8-mm2: boot hang after "ACPI: using IOAPIC for	interrupt
 routing"
In-Reply-To: <20080411210715.GA4851@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0804120024470.18799@sbz-30.cs.Helsinki.FI>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
 <20080411062928.GB4748@martell.zuzino.mipt.ru> <1207910128.7212.4.camel@haji>
 <20080411210715.GA4851@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Apr 2008, Alexey Dobriyan wrote:
> > Alexey, can you try passing the 'slub_nomerge' option to the kernel to
> > see if the hang goes away with that?
> 
> nomerge doesn't help as well as turning on combinations of SLUB debug options.

Does the following patch fix it?

			Pekka

>From 7c7e7e5e7ec07c0a47705b2d21c779c39ba02252 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Fri, 11 Apr 2008 17:17:43 +0300
Subject: [PATCH] slub: add missing slab_unlock() to __kmem_cache_shrink()

If page is not kickable, remember to slab_unlock() before continuing the loop.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4b694a7..f09f1fb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2926,8 +2926,10 @@ static unsigned long __kmem_cache_shrink(struct kmem_cache *s, int node,
 			continue;
 
 		if (page->inuse) {
-			if (!SlabKickable(page))
+			if (!SlabKickable(page)) {
+				slab_unlock(page);
 				continue;
+			}
 
 			if (page->inuse * 100 >=
 					s->defrag_ratio * page->objects) {
-- 
1.5.2.5



