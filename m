Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbXDKOnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbXDKOnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbXDKOnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:43:51 -0400
Received: from THUNK.ORG ([69.25.196.29]:41543 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbXDKOnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:43:50 -0400
Date: Wed, 11 Apr 2007 10:42:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: Neil Brown <neilb@suse.de>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070411144252.GB17778@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <17947.65165.569482.976343@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17947.65165.569482.976343@notabene.brown>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 07:15:57AM +1000, Neil Brown wrote:
> > Neil, is this correct?
> 
> It's just NFS.  nfsd does open/getdents/close on every readdir
> request.

That's... unfortunate.

Ext3 w/htree enable creates an in-memory red-black tree of a portion
of the directory; this is typically one filesystem block worth of
entries, but if there is a hash collision which spells across a
directory block, we will fill the red-block tree until we have read in
all of the directory entries that collide on a particular hash value
into the red-black tree.

We then maintain an internal pointer which provides us with exactly
which directory entries we have and haven't returned via
getdents/readdir via a pointer referenced off the file pointer.  So
long as the user never changes filp->f_pos, we can meet the POSIX
guarantees about returning each file (that hasn't been deleted or
added since the last opendir or rewinddir) once and exactly once.  If
the user calls telldir/seekdir, we can no longer make this guarantee
since the telldir cookie can't encapsulate the location inside our AVL
tree.  (We would need at least 96 bits in order to make that
guarantee; 64 bits of hash, plus a 32-bit count value in the hash
collision chain.)  The relevant code which does this is in
ext3_dx_readdir:

#define hash2pos(major, minor)	(major >> 1)
#define pos2maj_hash(pos)	((pos << 1) & 0xffffffff)
#define pos2min_hash(pos)	(0)

	/* Some one has messed with f_pos; reset the world */
	if (info->last_pos != filp->f_pos) {
		free_rb_tree_fname(&info->root);
		info->curr_node = NULL;
		info->extra_fname = NULL;
		info->curr_hash = pos2maj_hash(filp->f_pos);
		info->curr_minor_hash = pos2min_hash(filp->f_pos);
	}

(Note, we're only using a 31-bit telldir cookie because of NFSv2
compatibility.  If we could know we're using NFSv3/v4, by via checking
O_LARGEFILE, we could easily supply a 63-bit telldir cookie.  As I
recall there were some signed/unsigned issues which is why we had to
limit ourselves to a 31-bit/63-bit value).


So the problem with nfsd doing an open/getdents/close on every readdir
request is two-fold.  First of all, it means that you are incurring
extra overhead by forcing ext3 to allocate, create, and free the
red-black tree on every single NFS readdir request.  Secondly, it
increases the chances of problems with the hash collision logic.

Yes, right now we're probably courting danger if we try to operate on
a directory with hash collisions because it means that multiple
dirents returned by the NFS server to the NFS client will have the
same NFS readdir cookie (currently supplied by filp->f_pos/llseek).
But if most NFS clients typically use the cookie associated with the
last dirent returned by the readdir RPC, we might be getting away with
potential hash collisions --- and if nfsd were to cache open directory
fd's for some short period of time, we might get away with it even
more, since if the NFS client does a linear readthrough of the
dirents, we might end up winning even though the results might be a
little cheasy.  

It is true that if the NFS client tries to use a telldir cookie
associated with some directory entry not at the end of the returned
block of dirents, and the directory entry is part of a set of
filenames that result in a hash collision, we could end up losing.
But I'm guessing this happens very rarely in practice.

One of the things I did when I was debugging this code way back when
was that I had a debugging hash type which always returned the value
42.  This allowed me to be sure that all of the edge conditions
involving hash collisions could be well tested, and modulo
telldir/seekdir simply not working, I was able to verify that the
filesystem worked correctly, albeit not very efficiently.  I didn't
test to see what would happen with exporting such a filesystem via
NFS.  It might be interesting to try that and then see how many NFS
clients were able to deal with such a filesystem export.  

Given that we haven't gotten any complaints of clients stuck in an
infinite readdir loop, I have to conclude that either NFS clients are
a lot more robust/predictable than we are giving them credit for, or
people aren't exporting via NFS directories big enough that hash
collisions given a 31-bit cookie value haven't happened yet, which
seems to be rather unbelievable.

Regards,

						- Ted
