Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYHMAeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYHMAeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbYHMA2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:28:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755160AbYHMA2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:28:32 -0400
Date: Tue, 12 Aug 2008 17:28:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <20080813000433.GZ28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0808121708160.3462@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org>
 <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, Al Viro wrote:
> 
> As for whether we want to bother...  I've looked through about half of the
> ->readdir instances.  We _do_ want to touch them, with cattle prod if nothing
> else.

The really sad part is that readdir() really is also the thing that should 
make us change locking. That i_mutex thing is fine and dandy for 
everything else, but for readdir() we really would be much better off with 
a rwsem - and only take it for reading.

Right now, readdir() is one of the most serialized parts of the whole 
kernel. Sad. And while it's a per-directory lock, there are directories 
that get much more reading than others, and this has been a small 
scalability issue (for samba and apache) for years.

> 9p:	touching belief that f_pos can't be changed under us.
> adfs:	ditto.

The thing is, generic_file_llseek() takes i_mutex, exactly because of 
issues like this. Of course, you have to ask for it (the _default_ llseek 
does not do it), and you're right that 9p does not.

Strangely enough, at least 9p _does_ use it for regular files. I'm not 
sure how come it decided to do that, but whatever.

> ext3:	take a look at comments around filldir call.  Yes, they are _that_
> 	ancient, and so's the logics around revalidate.  ext2 is sane, but
> 	that hadn't propagated.  Refuses to go through more than one block,
> 	BTW.  Revalidation loop is buggered if we have corrupt data, while
> 	we are at it.
> ext4:	ditto

The reason ext2 is ok is that you long long ago fixed it to use the page 
cache. That got rid of a _lot_ of the crap, and made all the IO look like 
regular files (including read-ahead etc). Ext2 _used_ to be the same crap 
that ext3 is.

I so wish that ext3 could do the same thing, but no. I still think it 
should be possible, but the whole journalling is designed for buffer 
heads.

> freevxfs: AFAICS simply bogus (grep for nblocks there).
> hfs:	at least missing checks for hfs_bnode_read() failure.  And I'm not
> 	at all sure that hfs_mac2asc() use is safe there.  BTW, open_dir_list
> 	handling appears to be odd - how the hell does decrementing ->f_pos
> 	help anything?  And hfs_dir_release() removes from list without any
> 	locks, so that's almost certainly racy as well.
> hfsplus: ditto

I don't dispute at all that the readdir() thing is one of the weakest 
points of the whole VFS layer. And part of it is that there is no good 
caching helper for it at the VFS level, so we always end up having to do 
everything at the low-level filesystem level, and that invariably ends up 
being sh*t compared to the shared VFS routines.

I'm convinced that the reason we do well on most other filesystem accesses 
is exactly the fact that a filesystem basically has to be crazy to try to 
do their own version, and in many cases cannot really do it at all (eg you 
can't really even avoid using the dcache or the page cache and actually 
get any valid semantics).

But readdir() is the _one_ operation where the low-level filesystem still 
basically does it all itself. Which is why we can't fix locking, and why 
even simple changes are hard because it's not just complex code, it's 
complex code in 50+ filesystems with almost zero shared code!

			Linus
