Return-Path: <linux-kernel-owner+w=401wt.eu-S1161458AbXDLBrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161458AbXDLBrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 21:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161459AbXDLBrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 21:47:00 -0400
Received: from mail.suse.de ([195.135.220.2]:32844 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161458AbXDLBq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 21:46:59 -0400
From: Neil Brown <neilb@suse.de>
To: Theodore Tso <tytso@mit.edu>
Date: Thu, 12 Apr 2007 11:46:41 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17949.36737.701327.104172@notabene.brown>
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
	<17949.25061.739035.688232@notabene.brown>
	<20070411232224.GF17778@thunk.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday April 11, tytso@mit.edu wrote:
> 
> Actually, no, we can't keep the collision chain count stable across a
> create/delete even while the tree is cached.  At least, not without
> storing a huge amount of state associated with each page.  (It would
> be a lot more work than simply having nfsd keep a fd cache for
> directory streams ;-).

Well, there's the rub, isn't it :-)
You think it is easier to fix the problem in nfsd, and I think it is
easier to fix the problem in ext3.  Both positions are quite
understandable and quite genuine.
And I am quite sure that all the issues that have been raised can be
solved with a bit of effort providing the motivation is there.

I could argue that nfs came before ext3+dirindex, so ext3 should have
been designed to work properly with NFS.  You could argue that fixing
it in nfsd fixes it for all filesystems.  But I'm not sure either of
those arguments are likely to be at all convincing...

Maybe the best compromise is to both fix the 'problem' :-?

Let me explores some designs a bit more..

NFS:
   All we have to do is cache the open files.  This should be only a
   performance issue, not a correctness issue (once we get 64bit
   cookies from ext3).  So the important thing is to cache then for
   a reasonable period of time.

   We currently cache the read-ahead info from regular files (though
   I was hoping that would go away when the page-cache-based readahead
   became a reality).  We can reasonably replace this with caching
   the open files if we are going to do it for directories anyway.

   So the primary key is "struct inode * + loff_t".  This is suitable
   both for file-readahead and for ext3-directory-caching.  Might also
   be useful for filesystem that stores pre-allocation information in
   the struct-file.
   We keep these in an LRU list and a hash table.  We register a
   callback with register_shrinker (or whatever it is called today) so
   that VM pressure can shrink the cache, and also arrange a timer to
   remove entries older than -- say -- 5 seconds.

   I think that placing a fixed size on the cache based on number of
   active clients would be a mistake, as it is virtually impossible to
   know how many active clients there are, and the number can change
   very dynamically.

   When a filesystem is un-exported, (rare event) we walk the whole
   list and discard entries for that filesystem.

   Look into the possibility of a callback on unlink to drop the
   cached open when the link count hits zero.... I wonder if inotify
   or leases can help with that.

   To help with large NUMA machine, we probably don't want a single
   hash LRU chain, but rather a number of LRU chains.  That way the
   action of moving an entry to the end of the chain is less likely to
   conflict with another processor trying to do the same thing to a
   different entry.  This is the sort of consideration that is already
   handled in the page cache, and having to handle it in every other
   cache is troublesome.... because the next time a need like that
   arises, the page cache will get fixed but other little caches won't
   until someone like Greg Banks come along with a big hammer...

EXT3:
   Have a rbtree for storing directory entries. This is attached to a
   pages via the ->private page field.
   Normally each page of a directory has it's own rbtree, but when two
   pages contain entries with the same hash, the one rbtree is shared
   between the pages.
   Thus when you load a block you must also load other blocks under
   the same hash, but I think you do that already.

   When you split a block (because it has become too big) the rbtree
   attached to that block is dismantled and each entry is inserted
   into the appropriate new rbtree, one for each of the two blocks.
   The entries are unchanged - they just get placed in a different
   tree - so cursors in the struct file will still be valid.

   Each entry has a count of the number of cursors pointing to it, and
   when this is non-zero, a refcount on the page is held, thus making
   sure the page doesn't get freed and the btree lost.  The entry
   should possibly also contain a pointer to the page.. not sure if
   that is needed.

   Each entry in the rbtree contains (in minor_hash) a sequence number
   that is used when multiple entries hash to the same value.  We
   store a 'current-seq-number' in the root of the rbtree and when an
   attempt to insert an entry finds a collision, we increase
   current-seq-number, set the minor_hash to that, and retry the
   insert.
   This minor_hash is combined with some bits of the major hash to
   form the fpos/cookie.

   The releasepage address_space_operation will check that all pages
   which share the same major hash are treated as a unit, all released
   at the same time.  So it will fail if any of the pages in the
   group are in use.  If they can all be freed, it will free the
   rbtree for that group.


   This not only benefits nfsd, which opens and closes directories
   often, but also benefit any local application that happens to
   open/scan/close a directory very often.  It might still be a
   measurable benefit even if the nfsd fix is implemented.



Hmmm. I wonder.  Which is more likely?
  - That two 64bit hashes from some set are the same
  - or that 65536 48bit hashes from a set of equal size are the same.

Taken to the extreme, if we used all the available bits for a sequence
number, we would never get a collision with 2^64 entries, while if all
the bits were for hash, we have a good chance of a collision at 2^32
entries.  So using bits of the cookie for a sequence number reduces
the chance that two entries will need the same cookie, at the cost of
increasing the chance that multiple entries will hash to the same
value.

Probably 8 bits is plenty to spend on the sequence number leaving 56
bits for the hash, meaning 200 million entries before the birthday
paradox starts making hash chains at all likely, and still billions
before there is significant chance that the hash chains will even
overflow one block.

NeilBrown
