Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbYDKOYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbYDKOYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbYDKOYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:24:15 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33425 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbYDKOYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:24:14 -0400
Subject: Re: 2.6.25-rc8-mm2
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20080411221714.5f917a72.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	 <20080411185703.a5407940.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080411192346.6872472a.kamezawa.hiroyu@jp.fujitsu.com>
	 <1207910058.7212.1.camel@haji>
	 <20080411195738.16e9ef92.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080411201724.e820122b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080411221714.5f917a72.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 11 Apr 2008 17:24:11 +0300
Message-Id: <1207923851.7212.14.camel@haji>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 22:17 +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 11 Apr 2008 20:17:24 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > slab-2.6.git booted well :(
> > Hmm, It seems I have to dig somewhere different...
> > 
> Sorry, I tested *master* branch ;), under *testing* branch it reproduced.
> 
> bisected. (see below)
> 
> I'm sorry I can't use my box for next 2 days. I can test possible fix
> on Monday (in Japan). 
> 
> ==bisect result==
> 831d78b552aade2c383cf8d75b180dd35f81a4e3 is first bad commit
> commit 831d78b552aade2c383cf8d75b180dd35f81a4e3
> Author: Christoph Lameter <clameter@sgi.com>
> Date:   Tue Apr 8 22:26:30 2008 +0300
> 
>     SLUB: Add KICKABLE to avoid repeated kick() attempts
> 
>     Add a flag KICKABLE to be set on slabs with a defragmentation method
> 
>     Clear the flag if a kick action is not successful in reducing the
>     number of objects in a slab. This will avoid future attempts to
>     kick objects out.
> 
>     The KICKABLE flag is set again when all objects of the slab have been
>     allocated (Occurs during removal of a slab from the partial lists).
> 
>     Reviewed-by: Rik van Riel <riel@redhat.com>
>     Signed-off-by: Christoph Lameter <clameter@sgi.com>
>     Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

My bad, sorry. Fixed and pushed out.

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



