Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYDVR1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYDVR1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 13:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbYDVR1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 13:27:22 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36475 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566AbYDVR1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 13:27:21 -0400
Date: Tue, 22 Apr 2008 20:27:19 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
       gregkh@suse.de, clameter@sgi.com
Subject: Re: [sched-devel/latest] WARNING: at mm/slub.c:2443
In-Reply-To: <20080422134034.GF7311@elte.hu>
Message-ID: <Pine.LNX.4.64.0804222022530.17337@sbz-30.cs.Helsinki.FI>
References: <200804212310.41729.elendil@planet.nl> <20080422134034.GF7311@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008, Ingo Molnar wrote:
> * Frans Pop <elendil@planet.nl> wrote:
> 
> > I got the following warning while running sched-devel/latest.
> > 
> > I was not doing any tracing at that point (for the glibc compilation 
> > issue). I suspect it was while I was using a KDE application (amarok) 
> > as the desktop froze for a few seconds at one point.
> 
> i think this message is harmless to system stability.
> 
> Cc:-ing USB folks as the kmem_cache_destroy() comes from 
> drivers/usb/mon/mon_text.c.
> 
> Context: SLUB recently started warning about caches that get destroyed 
> with still outstanding allocations.
> 
> Pekka, it might make sense to turn this SLUB warning into something more 
> specific? It does seem to trigger in practice.

Oh absolutely. Something like this?

[PATCH] slub: improve kmem_cache_destroy() error message

As pointed out by Ingo, the SLUB warning of calling kmem_cache_destroy() 
with cache that still has objects triggers in practice. So turn this 
WARN_ON() into a nice SLUB specific error message to avoid people 
confusing it to a SLUB bug.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

diff --git a/mm/slub.c b/mm/slub.c
index 7f8aaa2..c372e88 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2426,8 +2426,11 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	if (!s->refcount) {
 		list_del(&s->list);
 		up_write(&slub_lock);
-		if (kmem_cache_close(s))
-			WARN_ON(1);
+		if (kmem_cache_close(s)) {
+			printk(KERN_ERR "SLUB %s: %s called for cache that "
+				"still has objects.\n", s->name, __func__);
+			dump_stack();
+		}
 		sysfs_slab_remove(s);
 	} else
 		up_write(&slub_lock);
