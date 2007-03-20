Return-Path: <linux-kernel-owner+w=401wt.eu-S965533AbXCTRMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965533AbXCTRMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965537AbXCTRMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:12:34 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:41089 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965533AbXCTRMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:12:34 -0400
Date: Tue, 20 Mar 2007 18:12:35 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <christoph@lameter.com>,
       Andi Kleen <andi@firstfloor.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: [RFC] SLAB : NUMA cache_free_alien() very expensive because of
 virt_to_slab(objp); nodeid = slabp->nodeid;
Message-Id: <20070320181235.77d28864.dada1@cosmosbay.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I noticed on a small x86_64 NUMA setup (2 nodes) that cache_free_alien() is very expensive.
This is because of a cache miss on struct slab.
At the time an object is freed (call to kmem_cache_free() for example), the underlying 'struct slab' is not anymore cache-hot.

struct slab *slabp = virt_to_slab(objp);
nodeid = slabp->nodeid; // cache miss

So we currently need slab only to lookup nodeid, to be able to use the cachep cpu cache, or not.

Couldn't we use something less expensive, like pfn_to_nid() ?
On x86_64 pfn_to_nid usually shares one cache line for all objects (struct memnode)

Is it possible virt_to_slab(objp)->nodeid being different from pfn_to_nid(objp) ?

Eric
