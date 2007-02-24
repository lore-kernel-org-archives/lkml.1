Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbXBXFJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbXBXFJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 00:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933389AbXBXFJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 00:09:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933387AbXBXFJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 00:09:44 -0500
Date: Sat, 24 Feb 2007 06:09:37 +0100
From: Nick Piggin <npiggin@suse.de>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] dynamic resizing dentry hash using RCU
Message-ID: <20070224050937.GA16601@wotan.suse.de>
References: <20070223153743.GA26141@wotan.suse.de> <20070224042444.GU21484@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070224042444.GU21484@holomorphy.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 08:24:44PM -0800, William Lee Irwin III wrote:
> On Fri, Feb 23, 2007 at 04:37:43PM +0100, Nick Piggin wrote:
> > The dentry hash uses up 8MB for 1 million entries on my 4GB system is
> > one of the biggest wasters of memory for me. Because I rarely have
> > more than one or two hundred thousand dentries. And that's with
> > several kernel trees worth of entries. Most desktop and probably even
> > many types of servers will only use a fraction of that.
> > So I introduce a new method for resizing hash tables with RCU, and apply
> > that to the dentry hash.
> > The primitive heuristic is that the hash size is doubled when the number of
> > entries reaches 150% the hash size, and halved when the number is 50%.
> > It should also be able to shrink under memory pressure, and scale up as
> > large as we go.
> 
> You would be better served by a data structure different from a hashtable.

Possibly. Note that I wasn't intending to rewrite the dcache hash
specifically, but just demonstrate my lockless dynamic data structure
switch, and the dentry hash was the most obvious candidate.

But considering that it is lockless, and basically free in the fastpath
(ie. a single easily-predicted branch), then I'm better served by an
dynamically sized dynamic hash table than an inappropriately sized one.

Well, almost. The vmalloc issue is the downside, of course. But if I'm
on a NUMA that is doing vmalloc hashes anyway, then there is little
downside.

Out of curiosity, what better data structure do you have in mind for
the dentry hash?
