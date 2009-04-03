Return-Path: <linux-kernel-owner+w=401wt.eu-S934202AbZDCPng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202AbZDCPng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbZDCPn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:43:26 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:22754 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbZDCPnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:43:25 -0400
Subject: Re: Linux 2.6.29
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain>
References: <1238758370.32764.5.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 11:40:08 -0400
Message-Id: <1238773208.7396.17.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49D62DF4.0098:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 08:07 -0700, Linus Torvalds wrote:
> 
> On Fri, 3 Apr 2009, Chris Mason wrote:
> 
> > On Thu, 2009-04-02 at 20:34 -0700, Linus Torvalds wrote:
> > > 
> > > Well, one rather simple explanation is that if you hadn't been doing lots 
> > > of writes, then the background garbage collection on the Intel SSD gets 
> > > ahead of the game, and gives you lots of bursty nice write bandwidth due 
> > > to having a nicely compacted and pre-erased blocks.
> > > 
> > > Then, after lots of writing, all the pre-erased blocks are gone, and you 
> > > are down to a steady state where it needs to GC and erase blocks to make 
> > > room for new writes.
> > > 
> > > So that part doesn't suprise me per se. The Intel SSD's definitely 
> > > flucutate a bit timing-wise (but I love how they never degenerate to the 
> > > "ooh, that _really_ sucks" case that the other SSD's and the rotational 
> > > media I've seen does when you do random writes).
> > > 
> > 
> > 23MB/s seems a bit low though, I'd try with O_DIRECT.  ext3 doesn't do
> > writepages, and the ssd may be very sensitive to smaller writes (what
> > brand?)
> 
> I didn't realize that Jeff had a non-Intel SSD. 
> 
> THAT sure explains the huge drop-off. I do see Intel SSD's fluctuating 
> too, but the Intel ones tend to be _fairly_ stable.

Even the intel ones have cliffs for long running random io workloads
(where the bottom of the cliff is still very fast), but something like
this should be stable.

> 
> > > The fact that it also happens for the regular disk does imply that it's 
> > > not the _only_ thing going on, though.
> > 
> > Jeff if you blktrace it I can make up a seekwatcher graph.  My bet is
> > that pdflush is stuck writing the indirect blocks, and doing a ton of
> > seeks.
> > 
> > You could change the overwrite program to also do sync_file_range on the
> > block device ;)
> 
> Actually, that won't help. 'sync_file_range()' works only on the virtually 
> indexed page cache, and I think ext3 uses "struct buffer_head *" for all 
> it's metadata updates (due to how JBD works). So sync_file_range() will do 
> nothing at all to the metadata, regardless of what mapping you execute it 
> on.

The buffer heads do end up on the block device inode's pages, and ext3
is letting pdflush do some of the writeback.  Its hard to say if the
sync_file_range is going to help, the IO on the metadata may be random
enough for that ssd that it won't really matter who writes it or when.

Spinning disks might suck, but at least they all suck in the same
way...tuning for all these different ssds isn't going to be fun at all.

-chris


