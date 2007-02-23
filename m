Return-Path: <linux-kernel-owner+w=401wt.eu-S933136AbXBWQbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136AbXBWQbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 11:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933137AbXBWQbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 11:31:31 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:45961 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933136AbXBWQbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 11:31:31 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Date: Fri, 23 Feb 2007 17:31:17 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070223153743.GA26141@wotan.suse.de>
In-Reply-To: <20070223153743.GA26141@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702231731.17262.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 February 2007 16:37, Nick Piggin wrote:
> The dentry hash uses up 8MB for 1 million entries on my 4GB system is one
> of the biggest wasters of memory for me. Because I rarely have more than
> one or two hundred thousand dentries. And that's with several kernel trees
> worth of entries. Most desktop and probably even many types of servers will
> only use a fraction of that.
>
> So I introduce a new method for resizing hash tables with RCU, and apply
> that to the dentry hash.
>
> The primitive heuristic is that the hash size is doubled when the number of
> entries reaches 150% the hash size, and halved when the number is 50%.
> It should also be able to shrink under memory pressure, and scale up as
> large as we go.
>
> A pity it uses vmalloc memory for the moment.
>
> The implementation is not highly stress tested, but it is running now. It
> could do a bit more RCU stuff asynchronously rather than with
> synchronize_rcu, but who cares, for now.
>
> The hash is costing me about 256K now, which is a 32x reduction in memory.
>
> I don't know if it's worthwhile to do this, rather than move things to
> other data structures, but something just tempted me to have a go!  I'd be
> interested to hear comments, and how many holes people can spot in my
> design ;)
>
> Thanks,
> Nick

Hi Nick

Thats a really good idea !

The vmalloc() thing could be a problem, so :

Could you bring back the support of 'dhash_entries=262144' boot param, so that 
an admin could set the initial size of dhash table, (and not shrink it under 
this size even if the number of dentries is low)

In case dhash_entries is set in boot params, we could try to use 
alloc_large_system_hash() for the initial table, (eventually using Hugepages 
(not vmalloc)), if we add a free_large_system_hash() function to be able to 
free the initial table.

Or else, time is to add the possibility for vmalloc() to use hugepages 
itself...

