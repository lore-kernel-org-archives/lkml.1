Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbZDCPLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbZDCPLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZDCPLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:11:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbZDCPLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:11:37 -0400
Date: Fri, 3 Apr 2009 08:07:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Mason <chris.mason@oracle.com>
cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <1238758370.32764.5.camel@think.oraclecorp.com>
Message-ID: <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain>
References: <1238758370.32764.5.camel@think.oraclecorp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Apr 2009, Chris Mason wrote:

> On Thu, 2009-04-02 at 20:34 -0700, Linus Torvalds wrote:
> > 
> > Well, one rather simple explanation is that if you hadn't been doing lots 
> > of writes, then the background garbage collection on the Intel SSD gets 
> > ahead of the game, and gives you lots of bursty nice write bandwidth due 
> > to having a nicely compacted and pre-erased blocks.
> > 
> > Then, after lots of writing, all the pre-erased blocks are gone, and you 
> > are down to a steady state where it needs to GC and erase blocks to make 
> > room for new writes.
> > 
> > So that part doesn't suprise me per se. The Intel SSD's definitely 
> > flucutate a bit timing-wise (but I love how they never degenerate to the 
> > "ooh, that _really_ sucks" case that the other SSD's and the rotational 
> > media I've seen does when you do random writes).
> > 
> 
> 23MB/s seems a bit low though, I'd try with O_DIRECT.  ext3 doesn't do
> writepages, and the ssd may be very sensitive to smaller writes (what
> brand?)

I didn't realize that Jeff had a non-Intel SSD. 

THAT sure explains the huge drop-off. I do see Intel SSD's fluctuating 
too, but the Intel ones tend to be _fairly_ stable.

> > The fact that it also happens for the regular disk does imply that it's 
> > not the _only_ thing going on, though.
> 
> Jeff if you blktrace it I can make up a seekwatcher graph.  My bet is
> that pdflush is stuck writing the indirect blocks, and doing a ton of
> seeks.
> 
> You could change the overwrite program to also do sync_file_range on the
> block device ;)

Actually, that won't help. 'sync_file_range()' works only on the virtually 
indexed page cache, and I think ext3 uses "struct buffer_head *" for all 
it's metadata updates (due to how JBD works). So sync_file_range() will do 
nothing at all to the metadata, regardless of what mapping you execute it 
on.

			Linus
