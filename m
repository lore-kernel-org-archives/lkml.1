Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbXIPSp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbXIPSp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXIPSpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:45:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56607 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbXIPSpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:45:13 -0400
Date: Sun, 16 Sep 2007 11:44:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?iso-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: Andrea Arcangeli <andrea@suse.de>,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <20070916182136.GC2393@lazybastard.org>
Message-ID: <alpine.LFD.0.999.0709161128350.16478@woody.linux-foundation.org>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
 <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org>
 <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random>
 <87tzpvy9cb.fsf@informatik.uni-tuebingen.de> <20070915223032.GA6708@v2.random>
 <20070916174657.GA2393@lazybastard.org> <alpine.LFD.0.999.0709161112410.16478@woody.linux-foundation.org>
 <20070916182136.GC2393@lazybastard.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Sep 2007, Jörn Engel wrote:
> 
> My approach is to have one for mount points and ramfs/tmpfs/sysfs/etc.
> which are pinned for their entire lifetime and another for regular
> files/inodes.  One could take a three-way approach and have
> always-pinned, often-pinned and rarely-pinned.
> 
> We won't get never-pinned that way.

That sounds pretty good. The problem, of course, is that most of the time, 
the actual dentry allocation itself is done before you really know which 
case the dentry will be in, and the natural place for actually giving the 
dentry lifetime hint is *not* at "d_alloc()", but when we "instantiate" 
it with d_add() or d_instantiate().

But it turns out that most of the filesystems we care about already use a 
special case of "d_add()" that *already* replaces the dentry with another 
one in some cases: "d_splice_alias()".

So I bet that if we just taught "d_splice_alias()" to look at the inode, 
and based on the inode just re-allocate the dentry to some other slab 
cache, we'd already handle a lot of the cases!

And yes, you'd end up with the reallocation overhead quite often, but at 
least it would now happen only when filling in a dentry, not in the 
(*much* more critical) cached lookup path.

			Linus
