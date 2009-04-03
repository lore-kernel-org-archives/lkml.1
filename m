Return-Path: <linux-kernel-owner+w=401wt.eu-S1764916AbZDCLg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764916AbZDCLg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762807AbZDCLgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:36:19 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:34900 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762012AbZDCLgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:36:18 -0400
Subject: Re: Linux 2.6.29
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0904022030271.4130@localhost.localdomain>
References: <20090325183011.GN32307@mit.edu>
	 <20090325220530.GR32307@mit.edu>
	 <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	 <20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	 <20090326174704.cd36bf7b.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
	 <20090326182519.d576d703.akpm@linux-foundation.org>
	 <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel>
	 <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com>
	 <20090402094247.9d7ac19f.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain>
	 <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain>
	 <49D53787.9060503@garzik.org>
	 <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain>
	 <49D56DF6.5020300@garzik.org>
	 <alpine.LFD.2.00.0904021910380.4130@localhost.localdomain>
	 <49D57CF2.5020206@garzik.org>
	 <alpine.LFD.2.00.0904022030271.4130@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 07:32:50 -0400
Message-Id: <1238758370.32764.5.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49D5F3E6.011A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 20:34 -0700, Linus Torvalds wrote:
> 
> On Thu, 2 Apr 2009, Jeff Garzik wrote:
> > 
> > I was really surprised the performance was so high at first, then fell off so
> > dramatically, on the SSD here.
> 
> Well, one rather simple explanation is that if you hadn't been doing lots 
> of writes, then the background garbage collection on the Intel SSD gets 
> ahead of the game, and gives you lots of bursty nice write bandwidth due 
> to having a nicely compacted and pre-erased blocks.
> 
> Then, after lots of writing, all the pre-erased blocks are gone, and you 
> are down to a steady state where it needs to GC and erase blocks to make 
> room for new writes.
> 
> So that part doesn't suprise me per se. The Intel SSD's definitely 
> flucutate a bit timing-wise (but I love how they never degenerate to the 
> "ooh, that _really_ sucks" case that the other SSD's and the rotational 
> media I've seen does when you do random writes).
> 

23MB/s seems a bit low though, I'd try with O_DIRECT.  ext3 doesn't do
writepages, and the ssd may be very sensitive to smaller writes (what
brand?)

> The fact that it also happens for the regular disk does imply that it's 
> not the _only_ thing going on, though.
> 

Jeff if you blktrace it I can make up a seekwatcher graph.  My bet is
that pdflush is stuck writing the indirect blocks, and doing a ton of
seeks.

You could change the overwrite program to also do sync_file_range on the
block device ;)

-chris


