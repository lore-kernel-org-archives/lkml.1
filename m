Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752088AbYLRFIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbYLRFIR (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 00:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbYLRFH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 00:07:59 -0500
Received: from smtp-out.google.com ([216.239.45.13]:20459 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYLRFH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 00:07:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type;
	b=YaI7U4w+ludwTxxO2WFDBV0Rbh/tcPsBviugr6gBd3mJMhwRrgBG/UB+HcyeogTF+
	F2ypBzJyI6b5mM0DKhTWQ==
Date: Wed, 17 Dec 2008 21:07:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] slub: avoid leaking caches or refcounts on sysfs error
Message-ID: <alpine.DEB.2.00.0812172106470.8230@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a slab cache is mergeable and the sysfs alias cannot be added, the
target cache shall have its refcount decremented.  kmem_cache_create()
will return NULL, so if kmem_cache_destroy() is ever called on the target
cache, it will never be freed if the refcount has been leaked.

Likewise, if a slab cache is not mergeable and the sysfs link cannot be
added, the new cache shall be removed from the slab_caches list.
kmem_cache_create() will return NULL, so it will be impossible to call
kmem_cache_destroy() on it.

Both of these operations require slub_lock since refcount of all slab
caches and slab_caches are protected by the lock.

In the mergeable case, it would be better to restore objsize and offset
back to their original values, but this could race with another merge
since slub_lock was dropped.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3123,8 +3123,12 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 		up_write(&slub_lock);
 
-		if (sysfs_slab_alias(s, name))
+		if (sysfs_slab_alias(s, name)) {
+			down_write(&slub_lock);
+			s->refcount--;
+			up_write(&slub_lock);
 			goto err;
+		}
 		return s;
 	}
 
@@ -3134,8 +3138,12 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 				size, align, flags, ctor)) {
 			list_add(&s->list, &slab_caches);
 			up_write(&slub_lock);
-			if (sysfs_slab_add(s))
+			if (sysfs_slab_add(s)) {
+				down_write(&slub_lock);
+				list_del(&s->list);
+				up_write(&slub_lock);
 				goto err;
+			}
 			return s;
 		}
 		kfree(s);
