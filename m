Return-Path: <linux-kernel-owner+w=401wt.eu-S1762208AbZCaQIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762208AbZCaQIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761407AbZCaQHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:07:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756189AbZCaQHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:07:49 -0400
Date: Tue, 31 Mar 2009 08:54:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ric Wheeler <rwheeler@redhat.com>
cc: Jens Axboe <jens.axboe@oracle.com>,
       =?ISO-8859-15?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
In-Reply-To: <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903310846110.4093@localhost.localdomain>
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk>
 <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain>
 <49D17CA2.5060105@redhat.com> <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain> <49D1FB64.8000505@redhat.com> <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Mar 2009, Linus Torvalds wrote:
> 
> Ok? Until you can see the bigger picture, just don't bother.

And this is really what it boils down to. Abstraction. Bigger picture. And 
the fact that the filesystem should DAMN WELL NOT THINK IT KNOWS WHAT IS 
GOING ON!

This is also fundamentally why returning that particular error is 
pointless. If the driver returns EOPNOTSUPP, there is simply never _any_ 
possible reason for upper layers to ever be informed about it - because 
there is not _any_ possible situation where they can do anything about it. 

Even _thinking_ that they can do something about it is fundamentally 
flawed. It misses the entire point of having layering and abstraction and 
having a "block layer" there to do these kinds of things.

If you want to write your filesystem so that it interacts with the 
low-level device directly, go and write an MTD filesystem instead. Don't 
even _claim_ to care about generic filesystems like 'ext3' or something 
like that. 

But if you try to be a "real" filesystem (ie general-purpose, meant to 
work on any random block device), don't come and whine about it when the 
block device then doesn't really do anything but read or write, or when 
the driver literally doesn't even _know_ how to serialize something 
because it doesn't even make sense in its world-view.

Don't mix up block layer and low-level driver issues with filesystem 
issues. The filesystem should say "block layer: flush the pending writes". 
And the block layer should try its best, but if the low-level driver says 
"that operation doesn't make sense for me", the block layer should just 
say "ok, whatever".

And the filesystem shouldn't know, and it most definitely mustr not act 
any differently. Because that's behind the abstraction, and there's no 
sane way to bring it _out_ of the abstraction that isn't fundamentally 
flawed (like thinking that it's always a SATA-II drive).

		Linus
