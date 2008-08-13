Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYHMAEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYHMAEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYHMAEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:04:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49229 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbYHMAEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:04:36 -0400
Date: Wed, 13 Aug 2008 01:04:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080813000433.GZ28946@ZenIV.linux.org.uk>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org> <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 02:04:25PM -0700, Linus Torvalds wrote:

> But the actual _change_ I talked about would be to try to avoid using 
> "buf.error" entirely, and just make all the (many, I know) filesystem 
> readdir() functions return the callback value instead of 0. Which would 
> mean that most of the users would be able to drop their "buf.error" use 
> entirely, along with the ugly
> 
> 	if (error >= 0)
> 		error = buf.error;
> 
> that I have in this patch.

Careful; e.g. coda returns the number of entries read, _not_ 0.  So it'd
take more than just "return what the callback had given us".
 
FWIW, I'm more concerned about the other callers of vfs_readdir();
getdents(2) will get tested on pretty much any fs, so if that breaks
we'll know it (OK, short of ->readdir() doing something spectaculary
stupid when given unusual arguments).

_IF_ we are changing things in ->readdir() (and your "pass return value of
filldir to caller of ->readdir()" certainly qualifies), we'd better make
sure that old instances break visibly and immediately; preferably - at
compile time.

As for whether we want to bother...  I've looked through about half of the
->readdir instances.  We _do_ want to touch them, with cattle prod if nothing
else.  And that's just a cursory look...

9p:	touching belief that f_pos can't be changed under us.
adfs:	ditto.
affs:	user-triggerable affs_warning() (just lseek to 0x10001 and you've
	got it), plus fun race: default_lseek() sets ->f_pos before clearing
	->f_version and we have no exclusion whatsoever (and then there is an
	SMP ordering race).  Besides, it returns the number of entries read.
autofs4:broken lseek (uses dcache_readdir() without the matching ->llseek)
befs:	pulls out early (after one call of filldir, no matter
	what), advances ->f_pos no matter what filldir returns.
bfs:	fs-wide exclusion between ->readdir(), -EBADF(!) on invalid offset,
	believes that ->f_pos can't change under it.
cifs:	f_pos races
coda:	returns fsck knows what (number of entries, mostly)
cramfs:	blind assumption that on-disk data would be valid; entry crossing a
	block boundary => fucked.
ecryptfs: badly broken
efs:	f_pos races (BKL doesn't help if you block), ignores the return value
	filldir completely, fucked on corrupted data (it's a bit too late
	to check that we have bogus offset of name in block after we'd already
	accessed the contents).  Alignment issues, while we are at it (or
	EFS_SLOTAT() is buggy).
ext3:	take a look at comments around filldir call.  Yes, they are _that_
	ancient, and so's the logics around revalidate.  ext2 is sane, but
	that hadn't propagated.  Refuses to go through more than one block,
	BTW.  Revalidation loop is buggered if we have corrupt data, while
	we are at it.
ext4:	ditto
freevxfs: AFAICS simply bogus (grep for nblocks there).
hfs:	at least missing checks for hfs_bnode_read() failure.  And I'm not
	at all sure that hfs_mac2asc() use is safe there.  BTW, open_dir_list
	handling appears to be odd - how the hell does decrementing ->f_pos
	help anything?  And hfs_dir_release() removes from list without any
	locks, so that's almost certainly racy as well.
hfsplus: ditto
