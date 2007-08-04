Return-Path: <linux-kernel-owner+w=401wt.eu-S932713AbXHDVt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbXHDVt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 17:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764812AbXHDVtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 17:49:16 -0400
Received: from thunk.org ([69.25.196.29]:53909 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764788AbXHDVtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 17:49:14 -0400
Date: Sat, 4 Aug 2007 17:48:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070804214821.GC11150@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
	dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
	trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
	richard@rsk.demon.co.uk, david@lang.hm
References: <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804192615.GA25600@lazybastard.org> <alpine.LFD.0.999.0708041246530.5037@woody.linux-foundation.org> <1186258399.2777.8.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186258399.2777.8.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 01:13:19PM -0700, Arjan van de Ven wrote:
> there is another trick possible (more involved though, Al will have to
> jump in on that one I suspect): Have 2 types of "dirty inode" states;
> one is the current dirty state (meaning the full range of ext3
> transactions etc) and "lighter" state of "atime-dirty"; which will not
> do the background syncs or journal transactions (so if your machine
> crashes, you lose the atime update) but it does keep atime for most
> normal cases and keeps it standard compliant "except after a crash".

That would make us standards compliant (POSIX explicitly says that
what happens after a unclean shutdown is Unspecified) and it would
make things a heck of a lot faster.  However, there is a potential
problem which is that it will keep a large number of inodes pinned in
memory, which is its own problem.  So there would have to be some way
to force the atime updates to be merged when under memory pressure,
and and perhaps on some much longer background interval (i.e., every
hour or so).

							- Ted
