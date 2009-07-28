Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbZG1VJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbZG1VJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbZG1VJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:09:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37819 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZG1VJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:09:27 -0400
Date: Tue, 28 Jul 2009 23:09:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Kyle Moffett <kyle@moffetthome.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Zachary Amsden <zamsden@redhat.com>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, hch@infradead.org, akpm@linux-foundation.org,
       Paul.Clements@steeleye.com, tytso@mit.edu, miklos <miklos@szeredi.hu>
Subject: Re: [PATCH] Allow userspace block device implementation
Message-ID: <20090728210918.GP15310@basil.fritz.box>
References: <4A6D79F6.3050509@redhat.com> <1248699365.6987.1628.camel@twins> <20090727142536.465799aa@lxorguk.ukuu.org.uk> <4A6E529B.9030104@kernel.org> <4A6E764E.80805@redhat.com> <20090728112734.5a75752d@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0907280851360.3186@localhost.localdomain> <f73f7ab80907281136k2d7797bat2526d1798aba2f85@mail.gmail.com> <87d47kh9kh.fsf@basil.nowhere.org> <alpine.LFD.2.01.0907281333490.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907281333490.3186@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 01:50:56PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 28 Jul 2009, Andi Kleen wrote:
> 
> > Kyle Moffett <kyle@moffetthome.net> writes:
> > >
> > >   (1) The ability to rearrange, resize, and restructure
> > > partition-tables on the fly.  The existing "re-read partition tables"
> > > infrastructure does not safely and reasonably handle changes to the
> > > partition-table while partitions are mounted. 
> > 
> > It doesn't today (and I really hate it too), but is there a hard reason it
> > couldn't be fixed to support that properly? 
> 
> If something has a partition open (and it doesn't really even have to be a 
> mounted filesystem, altough that's obviously the most relevant case), how 
> can you reasonably change the partition from underneath it?

Well LVM can do that, why not standard partitions?

e.g. extending should be totally fine. The file system can continue
using the old size until you run the online fs extender tool which
does then the right magic to sync the file system state. I believe
that is how it works on LVM.

Shrinking is more difficult, but giving root enough rope ... 
And we got offline shrinkers at least.

> So I assume 
> you mean that partitions were opened earlier (for a mount) would not be 
> touched.

Also right now you can't change any other partition.

I know part of the problem is that I like using fdisk 
(simply because I think the person who designed parted's user interface
was on something unholy) and apparently it works better
when you use the right ioctls to add/remove partitions
instead of wholesale reread like fdisk.
Perhaps the reread table ioctl can be just fixed.

> It may be that we just have the old check in place ("don't allow 
> re-reading if something has mounted a partition"), and we could just get 
> rid of it. I have not looked. 

Yes I'm sure there's lot of historical baggage here.

> 
> But if you actually meant that re-reading the partition table should 
> _change_ a "struct block_dev" that is in use, then I think that would be a 
> bad idea. At the very least, it should involve a re-mount or something.

LVM already does it afaik.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
