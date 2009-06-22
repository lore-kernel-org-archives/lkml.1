Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbZFVLbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbZFVLbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZFVLbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:31:07 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42888 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbZFVLbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:31:05 -0400
Date: Mon, 22 Jun 2009 12:31:05 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Catalin Marinas <catalin.marinas@arm.com>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] profile: Suppress warning about large allocations when
	profile=1 is specified
Message-ID: <20090622113104.GD3981@csn.ul.ie>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org> <20090616223649.719ea378.akpm@linux-foundation.org> <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu> <20090617113534.GA21276@elte.hu> <20090617121913.GC28529@csn.ul.ie> <20090620100932.GA5863@fancy-poultry.org> <20090620195000.GC10878@csn.ul.ie> <20090620214835.GA6528@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090620214835.GA6528@fancy-poultry.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 11:48:35PM +0200, Heinz Diehl wrote:
> On 20.06.2009, Mel Gorman wrote: 
> 
> > I can't figure out from this trace where the problem is coming from. Can
> > you post your .config and the full dmesg please?
> 
> Yes, of course. It's attached.
> 

I have no idea why the stack trace is so badly managed but the problem appears
to be in DCCP so can you try the patch below please? It applies on top of the
profile=1 patch fix. If it works for you, I'll split out the patch properly
into three separate patches and repost.

Some questions though

1. Could DCCP use alloc_large_system_hash()?

2. Any idea why the stack trace for the warning was so useless?

==== CUT HERE ====
dccp: Suppress warning about large allocations from DCCP

The DCCP protocol tries to allocate some large hash tables during
initialisation using the largest size possible. The allocator warns if
the allocations are too large but the caller is able to handle
allocation failure. This patch disables the warnings in the case DCCP
requests too large an allocation.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 net/dccp/proto.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 314a1b5..fd21676 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1066,7 +1066,7 @@ static int __init dccp_init(void)
 		       (dccp_hashinfo.ehash_size - 1))
 			dccp_hashinfo.ehash_size--;
 		dccp_hashinfo.ehash = (struct inet_ehash_bucket *)
-			__get_free_pages(GFP_ATOMIC, ehash_order);
+			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, ehash_order);
 	} while (!dccp_hashinfo.ehash && --ehash_order > 0);
 
 	if (!dccp_hashinfo.ehash) {
@@ -1091,7 +1091,7 @@ static int __init dccp_init(void)
 		    bhash_order > 0)
 			continue;
 		dccp_hashinfo.bhash = (struct inet_bind_hashbucket *)
-			__get_free_pages(GFP_ATOMIC, bhash_order);
+			__get_free_pages(GFP_ATOMIC|__GFP_NOWARN, bhash_order);
 	} while (!dccp_hashinfo.bhash && --bhash_order >= 0);
 
 	if (!dccp_hashinfo.bhash) {
