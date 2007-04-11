Return-Path: <linux-kernel-owner+w=401wt.eu-S1161305AbXDKWck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161305AbXDKWck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161301AbXDKWck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:32:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161305AbXDKWcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:32:39 -0400
From: Neil Brown <neilb@suse.de>
To: Theodore Tso <tytso@mit.edu>
Date: Thu, 12 Apr 2007 08:32:05 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17949.25061.739035.688232@notabene.brown>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
In-Reply-To: message from Theodore Tso on Wednesday April 11
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
	<20070407203633.GA21555@thunk.org>
	<20070407233037.GA16508@infradead.org>
	<46193048.6000606@zytor.com>
	<20070408184129.GA20871@lazybastard.org>
	<17947.65165.569482.976343@notabene.brown>
	<20070411144252.GB17778@thunk.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday April 11, tytso@mit.edu wrote:
> On Wed, Apr 11, 2007 at 07:15:57AM +1000, Neil Brown wrote:
> > > Neil, is this correct?
> > 
> > It's just NFS.  nfsd does open/getdents/close on every readdir
> > request.
> 
> That's... unfortunate.

I like to think of it as "challenging" :-)

> 
> 
> So the problem with nfsd doing an open/getdents/close on every readdir
> request is two-fold.  First of all, it means that you are incurring
> extra overhead by forcing ext3 to allocate, create, and free the
> red-black tree on every single NFS readdir request.  Secondly, it
> increases the chances of problems with the hash collision logic.

I guess we need a two-fold solution then  :-)

For the first:
  You are storing an internal tree representation of part of the
  directory attached to the 'struct file'.
  Would it be possible to store this attached to the page via the
  ->private pointer?  What would avoid the allocate/create/free
  overhead on every request.

  You suggest caching the open files in nfsd.  While that is probably
  possible (I've thought of it a number of times) is would also be
  quite complex, e.g. requiring some sort of call-back to close all
  those files when the filesystem is unexported.  And it is very easy
  to get caching heuristics wrong.  Leveraging the page-cache which is
  a very mature cache seems to make a lot of sense.

  The cursor would still be in the 'struct file', but if the second
  second fold works, that should be much less critical.

For the second.
  You say that you " would need at least 96 bits in order to make that
  guarantee; 64 bits of hash, plus a 32-bit count value in the hash
  collision chain".  I think 96 is a bit greedy.  Surely 48 bits of 
  hash and 16 bits of collision-chain-position would plenty.  You would
  need 65537 entries before a collision was even possible, and
  billions before it was at all likely. (How big does a set of 48bit
  numbers have to get before the probability that "No subset of 65536
  numbers are all the same" drops below 0.95?)

  This would really require that the collision-chain-index was stable
  across create/delete.  Doing that while you have the tree in the
  page cache is probably easy enough.  Doing it across reboots is
  probably not possible without on-disk changes.

So while my two-fold solution is not perfect(*), I think it is
substantially better than what we have now, and is extremely unlike to
ever show an observable problem.
(*)And perfection can only be achieved we two independent indexes.


This requires 64bit cookies which NFSv2 cannot handle.  I think it is
OK to say "tough".  We should probably make sure that READDIRv2 *always*
fails on a directory which is indexed, and possibly on a filesystem
which allows index directories.  People can always disable indexing if
they want a v2 export.

NeilBrown
