Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYHMBT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYHMBT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbYHMBTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:19:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38787 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbYHMBTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:19:12 -0400
Date: Wed, 13 Aug 2008 02:19:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080813011909.GA28946@ZenIV.linux.org.uk>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org> <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121708160.3462@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808121708160.3462@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 05:28:28PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 13 Aug 2008, Al Viro wrote:
> > 
> > As for whether we want to bother...  I've looked through about half of the
> > ->readdir instances.  We _do_ want to touch them, with cattle prod if nothing
> > else.
> 
> The really sad part is that readdir() really is also the thing that should 
> make us change locking. That i_mutex thing is fine and dandy for 
> everything else, but for readdir() we really would be much better off with 
> a rwsem - and only take it for reading.

*cringe*

I agree, but... there's another shitpile in the same area and there we are
_really_ buggered - take a look at what ncpfs/smbfs/cifs/<parts of> procfs
are pulling off with very odd attempts to dump stuff into dcache.

That means manual equivalent of lookup and you _do_ want some exclusion for
that.  If nothing else, you want to prevent multiple dentries for the same
subdirectory...

And rwsem for reading wouldn't help at all - readdir/readdir contention
might be annoying, but it's readdir/lookup that really hurts.

> Right now, readdir() is one of the most serialized parts of the whole 
> kernel. Sad. And while it's a per-directory lock, there are directories 
> that get much more reading than others, and this has been a small 
> scalability issue (for samba and apache) for years.

I know.  And things like exportfs use of vfs_readdir() are also rather
painful.
 
> The reason ext2 is ok is that you long long ago fixed it to use the page 
> cache. That got rid of a _lot_ of the crap, and made all the IO look like 
> regular files (including read-ahead etc). Ext2 _used_ to be the same crap 
> that ext3 is.

I remember ;-)  However, f_version/i_version mess at that place simply an
ancient crap - we *are* holding i_mutex and we are using generic_file_lseek().
IOW, it simply hadn't been reviewed since then - or reviewers had been
stunned into glazed-eyes mode by the entire thing.
 
> I so wish that ext3 could do the same thing, but no. I still think it 
> should be possible, but the whole journalling is designed for buffer 
> heads.

Don't.  Get.  Me.  Started.   Hell, at least by now somebody had cleaned
htree code into nearly readable form; maybe it might be doable...

> > freevxfs: AFAICS simply bogus (grep for nblocks there).
> > hfs:	at least missing checks for hfs_bnode_read() failure.  And I'm not
> > 	at all sure that hfs_mac2asc() use is safe there.  BTW, open_dir_list
> > 	handling appears to be odd - how the hell does decrementing ->f_pos
> > 	help anything?  And hfs_dir_release() removes from list without any
> > 	locks, so that's almost certainly racy as well.
> > hfsplus: ditto
> 
> I don't dispute at all that the readdir() thing is one of the weakest 
> points of the whole VFS layer. And part of it is that there is no good 
> caching helper for it at the VFS level, so we always end up having to do 
> everything at the low-level filesystem level, and that invariably ends up 
> being sh*t compared to the shared VFS routines.

What _can_ a common helper do, anyway, when we are busy parsing an arseload of
possibly corrupt data in whatever weird format fs insists upon?

As for the locking...  I toyed with one idea for a while: instead of passing
a callback and one of many completely different structs, how about a common
*beginning* of a struct, with callback stored in it along with several
common fields?  Namely,
	* count of filldir calls already made
	* pointer to file in question
	* "are we done" flag
And instead of calling filldir(buf, ...) ->readdir() would call one of several
helpers:
	* readdir_emit(buf, ...) - obvious
	* readdir_relax(buf) - called in a spot convenient for dropping
and retaking lock; returns whether we need to do revalidation.
	* readdir_eof(buf) - end of directory
	* maybe readdir_dot() and readdir_dotdot() - those are certainly
common enough

That's the obvious flagday stuff, but since we need to give serious beating
to most of the instances anyway...  Might as well consider something in
that direction.
