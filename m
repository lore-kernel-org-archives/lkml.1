Return-Path: <linux-kernel-owner+w=401wt.eu-S1759270AbZBMQGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270AbZBMQGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbZBMQGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:06:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756983AbZBMQGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:06:41 -0500
Date: Fri, 13 Feb 2009 08:05:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: paulmck@linux.vnet.ibm.com, Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
 (repost)
In-Reply-To: <200902140050.44550.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.2.00.0902130758010.3099@localhost.localdomain>
References: <20090212023308.GA21157@linux.vnet.ibm.com> <alpine.LFD.2.00.0902121247040.3099@localhost.localdomain> <20090212215959.GN6759@linux.vnet.ibm.com> <200902140050.44550.nickpiggin@yahoo.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 14 Feb 2009, Nick Piggin wrote:
> 
> Interesting. I don't know if you would say it is not cache coherent.
> Does anything in cache coherency definition require timeliness? Only
> causality I think.

Nick, afaik, BF _really_ isn't cache coherent.

It's not about timeliness. It's literally non-coherent.

Blackfin L1 caches are
 (a) write-through
 (b) per-cpu
 (c) non-coherent
so the way that BF implements "cache coherency" is by literally

 - use a magic test-and-set instruction that works on L2 memory (shared)
 - keep track of which core has done that test-and-set last
 - *flush* the L1 when it was the other core.

Note that because it's a write-through cache, _writes_ are basically 
"coherent". But since the cache isn't actually _updated_ ont he other CPU, 
you can have two CPU's doing writes, and they'll both continue to see 
their own write, not necessarily the one that made it to memory. So I 
would not call that a "timeliness" issue, I would just say that the caches 
simply aren't coherent.

But because it's write-through, flushing the cache always makes things 
coherent again (well, on _that_ CPU), of course.

			Linus
