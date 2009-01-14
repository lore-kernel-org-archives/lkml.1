Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbZANITT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbZANITT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbZANITD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:19:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089AbZANITB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:19:01 -0500
Date: Wed, 14 Jan 2009 00:17:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Manfred Spraul" <manfred@colorfullife.com>, krh@redhat.com,
       stefanr@s5r6.in-berlin.de, dcm@acm.org, Nadia.Derbey@bull.net,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       paulmck@us.ibm.com, stable@kernel.org
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
Message-Id: <20090114001745.9575ab02.akpm@linux-foundation.org>
In-Reply-To: <84144f020901132319g50dc9e50o283b0d263f287eea@mail.gmail.com>
References: <1231571060.3538.18.camel@localhost.localdomain>
	<49686465.70501@s5r6.in-berlin.de>
	<20090110011557.9d94e111.akpm@linux-foundation.org>
	<496872E0.9030007@s5r6.in-berlin.de>
	<1231773620.6365.21.camel@gaara.bos.redhat.com>
	<496B9FC7.3090108@colorfullife.com>
	<1231792712.6365.31.camel@gaara.bos.redhat.com>
	<496BAD1C.5060201@colorfullife.com>
	<20090113144802.39dc4c23.akpm@linux-foundation.org>
	<84144f020901132319g50dc9e50o283b0d263f287eea@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 09:19:01 +0200 "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On Wed, Jan 14, 2009 at 12:48 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >> If the idr code passes uninitialized objects to kmem_cache_free(), then
> >> the next kmem_cache_alloc will return a bad object.
> >>
> >
> > None of this got us much closer to fixing the bug ;)
> >
> > What do we think of just removing the constructor and using
> > kmem_cache_zalloc()?
> 
> Why do I get the feeling that we have merged a similar patch before?

Dunno - maybe we had the same bug in other places.

> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Here 'tis:

From: Andrew Morton <akpm@linux-foundation.org>

David points out that the idr_remove_all() function returns unused slabs
to the kmem cache, but needs to zero them first or else they will be
uninitialized upon next use.  This causes crashes which have been observed
in the firewire subsystem.

He fixed this by zeroing the object before freeing it in idr_remove_all().

But we agree that simply removing the constructor and zeroing the object
at allocation time is simpler than relying upon slab constructor machinery
and might even be faster.

This problem was introduced by

commit cf481c20c476ad2c0febdace9ce23f5a4db19582
Author:     Nadia Derbey <Nadia.Derbey@bull.net>
AuthorDate: Fri Jul 25 01:48:02 2008 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Fri Jul 25 10:53:42 2008 -0700

    idr: make idr_remove rcu-safe

which was first released in 2.6.27.

There are no known codesites which trigger this bug in 2.6.27 or 2.6.28. 
The post-2.6.28 firewire changes are the only known triggerer.

There might of course be not-yet-discovered triggerers in 2.6.27 and
2.6.28, and there might be out-of-tree triggerers which are added to those
kernel versions.  I'll let the -stable guys decide whether they want to
backport this fix.

Reported-by: David Moore <dcm@acm.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Paul E. McKenney <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Kristian Hgsberg <krh@redhat.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/idr.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN lib/idr.c~lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache lib/idr.c
--- a/lib/idr.c~lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache
+++ a/lib/idr.c
@@ -121,7 +121,7 @@ int idr_pre_get(struct idr *idp, gfp_t g
 {
 	while (idp->id_free_cnt < IDR_FREE_MAX) {
 		struct idr_layer *new;
-		new = kmem_cache_alloc(idr_layer_cache, gfp_mask);
+		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
 		if (new == NULL)
 			return (0);
 		move_to_free_list(idp, new);
@@ -623,16 +623,10 @@ void *idr_replace(struct idr *idp, void 
 }
 EXPORT_SYMBOL(idr_replace);
 
-static void idr_cache_ctor(void *idr_layer)
-{
-	memset(idr_layer, 0, sizeof(struct idr_layer));
-}
-
 void __init idr_init_cache(void)
 {
 	idr_layer_cache = kmem_cache_create("idr_layer_cache",
-				sizeof(struct idr_layer), 0, SLAB_PANIC,
-				idr_cache_ctor);
+				sizeof(struct idr_layer), 0, SLAB_PANIC, NULL);
 }
 
 /**
_

