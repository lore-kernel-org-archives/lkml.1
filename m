Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbZG1UwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbZG1UwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 16:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbZG1UwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 16:52:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbZG1UwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 16:52:23 -0400
Date: Tue, 28 Jul 2009 13:50:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Kyle Moffett <kyle@moffetthome.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Zachary Amsden <zamsden@redhat.com>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, tytso@mit.edu, miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
In-Reply-To: <87d47kh9kh.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.2.01.0907281333490.3186@localhost.localdomain>
References: <4A6D79F6.3050509@redhat.com> <1248699365.6987.1628.camel@twins> <20090727142536.465799aa@lxorguk.ukuu.org.uk> <4A6E529B.9030104@kernel.org> <4A6E764E.80805@redhat.com> <20090728112734.5a75752d@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280851360.3186@localhost.localdomain>
 <f73f7ab80907281136k2d7797bat2526d1798aba2f85@mail.gmail.com> <87d47kh9kh.fsf@basil.nowhere.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Jul 2009, Andi Kleen wrote:

> Kyle Moffett <kyle@moffetthome.net> writes:
> >
> >   (1) The ability to rearrange, resize, and restructure
> > partition-tables on the fly.  The existing "re-read partition tables"
> > infrastructure does not safely and reasonably handle changes to the
> > partition-table while partitions are mounted. 
> 
> It doesn't today (and I really hate it too), but is there a hard reason it
> couldn't be fixed to support that properly? 

If something has a partition open (and it doesn't really even have to be a 
mounted filesystem, altough that's obviously the most relevant case), how 
can you reasonably change the partition from underneath it? So I assume 
you mean that partitions were opened earlier (for a mount) would not be 
touched.

And these days, that _should_ just work. The "reread partition table" 
operation should just leave the old bdev's around (so a mounted filesystem 
simply won't _see_ the new partitions, but will continue to use the old 
one), and for all I know that might even work these days.

[ Here "these days" is admittedly only in comparison to the _original_ 
 Linux code, which used block numbers. Many years ago. ]

Filesystems long ago _used_ to index things by device number and block - 
and that meant that re-reading partition tables was _really_ dangerous, 
because the "device number" would just magically mean something else for a 
mounted filesystem. But we've indexed things by bdev for a longish time 
now, and most (all?) filesystems use "sb_bread()" instead of bread etc.

So I think re-reading the partition tables should be safe these days. It 
definitely didn't _use_ to be the case due to dev_t issues, but that's 
really ancient.

It may be that we just have the old check in place ("don't allow 
re-reading if something has mounted a partition"), and we could just get 
rid of it. I have not looked. 

But if you actually meant that re-reading the partition table should 
_change_ a "struct block_dev" that is in use, then I think that would be a 
bad idea. At the very least, it should involve a re-mount or something.

		Linus
