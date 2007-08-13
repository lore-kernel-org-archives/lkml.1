Return-Path: <linux-kernel-owner+w=401wt.eu-S944140AbXHMVBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944140AbXHMVBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945155AbXHMU6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:58:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41793 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031841AbXHMU6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:58:49 -0400
Date: Mon, 13 Aug 2007 13:58:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: lethal@linux-sh.org, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] slab: revert "slab: fix alien cache handling"
In-Reply-To: <20070813175824.GB12874@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0708131349100.27728@schroedinger.engr.sgi.com>
References: <20070813175824.GB12874@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Siddha, Suresh B wrote:

> Can we revert git commit 3cdc0ed0cea50ea08dd146c1bbc82b1bcc2e1b80 ?

Only if you find another way to fix the bug that is addressed there.

> This is introducing a performance regression and nullifies the previous
> commit.

The implementation of noalien was breaking slab NUMA locality so 
that BUG() statements were triggered. This fixed it.

> Looking at the 3cdc0ed0cea50ea08dd146c1bbc82b1bcc2e1b80 changelog, I can't find
> enough info of why cache_free_alien() must be called regardless if we use alien
> caches or not.

cache_free_alien has to be called for any remote object because the per 
cpu queue does only contain node local objects. The noalian option was 
putting remote objects on the per cpu queue!

If you contaminate the per cpu queue with foreign objects then NUMA 
locality no longer works. Objects from other nodes are considered to be on 
the local node etc. So first of all requests for memory from one node will 
be served with memory from another,.

Plus the locks for slab lists are per node. So when we final drain the 
objects from the per cpu queue to the slab the local listlock may be taken 
to free an object to a remote node. If another free is in progress on the 
remote node then this will lead to corruption of slab meta data.

