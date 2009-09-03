Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbZICOTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbZICOTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZICOTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:19:53 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:41613 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbZICOTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:19:52 -0400
Message-ID: <4A9FD047.9000002@gmail.com>
Date: Thu, 03 Sep 2009 16:18:47 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, "stable@kernel.org" <stable@kernel.org>
Subject: [PATCH] slub: Fix kmem_cache_destroy() with SLAB_DESTROY_BY_RCU
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>	 <4A896324.3040104@trash.net>	 <c4e36d110909021445l5f44183es9e338437dfbbd195@mail.gmail.com>	 <4A9EEF07.5070800@gmail.com>	 <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com>	 <4A9F1620.2080105@gmail.com>	 <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com>	 <4A9F7283.1090306@gmail.com>	 <84144f020909030051u6cf6ae01he25c268f718ff3af@mail.gmail.com>	 <alpine.DEB.1.10.0909031246010.27903@V090114053VZO-1> <84144f020909030705x7909cf07w7ea0d3662a66c5cc@mail.gmail.com>
In-Reply-To: <84144f020909030705x7909cf07w7ea0d3662a66c5cc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 03 Sep 2009 16:18:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg a écrit :
> Hi Christoph,
> 
> On Thu, 3 Sep 2009, Pekka Enberg wrote:
>>> Oh, sure, the fix looks sane to me. It's just that I am a complete
>>> coward when it comes to merging RCU related patches so I always try to
>>> fish an Acked-by from Paul or Christoph ;).
> 
> On Thu, Sep 3, 2009 at 8:50 PM, Christoph
> Lameter<cl@linux-foundation.org> wrote:
>> I am fine with acking the poison piece.
> 
> Ok.
> 
> On Thu, Sep 3, 2009 at 8:50 PM, Christoph
> Lameter<cl@linux-foundation.org> wrote:
>> I did not ack the patch that added rcu to kmem_cache_destroy() and I
>> likely wont ack that piece either.
> 
> Right. I didn't remember that I merged that over your NAK but I don't
> share your view that kmem_cache_destroy() callers should do
> rcu_barrier() or whatever is necessary if we can do it from
> kmem_cache_destroy(). So I am happy to take both changes but I would
> appreciate them being split into two separate patches.
> 

Here is the second patch (RCU thing). Stable candidate

[PATCH] slub: Fix kmem_cache_destroy() with SLAB_DESTROY_BY_RCU

kmem_cache_destroy() should call rcu_barrier() *after* kmem_cache_close()
and *before* sysfs_slab_remove() or risk rcu_free_slab()
being called after kmem_cache is deleted (kfreed).

rmmod nf_conntrack can crash the machine because it has to
kmem_cache_destroy() a SLAB_DESTROY_BY_RCU enabled cache.

Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

diff --git a/mm/slub.c b/mm/slub.c
index b9f1491..b627675 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2594,8 +2594,6 @@ static inline int kmem_cache_close(struct kmem_cache *s)
  */
 void kmem_cache_destroy(struct kmem_cache *s)
 {
-	if (s->flags & SLAB_DESTROY_BY_RCU)
-		rcu_barrier();
 	down_write(&slub_lock);
 	s->refcount--;
 	if (!s->refcount) {
@@ -2606,6 +2604,8 @@ void kmem_cache_destroy(struct kmem_cache *s)
 				"still has objects.\n", s->name, __func__);
 			dump_stack();
 		}
+		if (s->flags & SLAB_DESTROY_BY_RCU)
+			rcu_barrier();
 		sysfs_slab_remove(s);
 	} else
 		up_write(&slub_lock);
