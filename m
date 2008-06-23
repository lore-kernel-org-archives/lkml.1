Return-Path: <linux-kernel-owner+w=401wt.eu-S1762218AbYFWS41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218AbYFWS41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbYFWS4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:56:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47160 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYFWS4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:56:18 -0400
Date: Mon, 23 Jun 2008 21:56:15 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Steven Rostedt <srostedt@redhat.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: linux-next: Tree for June 23
In-Reply-To: <19f34abd0806230402x502eca3cna927eb8742553570@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0806232155060.4033@sbz-30.cs.Helsinki.FI>
References: <20080623182549.b0552851.sfr@canb.auug.org.au> 
 <19f34abd0806230323o6373015fj93a85b929545a7a8@mail.gmail.com> 
 <19f34abd0806230326i592ba39eu837d290e21431d14@mail.gmail.com>
 <19f34abd0806230402x502eca3cna927eb8742553570@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008, Vegard Nossum wrote:
> Okay, I can confirm that this happens with today's tree too. I also
> get this (new) warning:
> 
> mm/slub.c: In function 'kmem_cache_defrag':
> mm/slub.c:3046: warning: 'reclaimed' may be used uninitialized in this function
> 
> Otherwise things seem to work good :-)

Christoph, while the warning itself seems harmless, I think we need to do 
something like the following; otherwise the return value for 
kmem_cache_defrag() will be incorrect on NUMA machines that have more than 
one N_NORMAL_MEMORY nodes.

		Pekka

diff --git a/mm/slub.c b/mm/slub.c
index deb8153..7707550 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3043,7 +3043,7 @@ int kmem_cache_defrag(int node)
 		return 0;
 
 	list_for_each_entry(s, &slab_caches, list) {
-		unsigned long reclaimed;
+		unsigned long reclaimed = 0;
 
 		/*
 		 * Defragmentable caches come first. If the slab cache is not
@@ -3056,7 +3056,7 @@ int kmem_cache_defrag(int node)
 			int nid;
 
 			for_each_node_state(nid, N_NORMAL_MEMORY)
-				reclaimed = __kmem_cache_shrink(s, nid,
+				reclaimed += __kmem_cache_shrink(s, nid,
 								MAX_PARTIAL);
 		} else
 			reclaimed = __kmem_cache_shrink(s, node, MAX_PARTIAL);
