Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYFBPs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYFBPs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYFBPsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:48:47 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42058 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbYFBPsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:48:46 -0400
Date: Mon, 2 Jun 2008 11:35:44 -0400
Message-Id: <200806021535.m52FZiZD011931@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: hooanon05@yahoo.co.jp, Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support 
In-reply-to: Your message of "Mon, 02 Jun 2008 09:12:49 +0200."
             <200806020912.49721.arnd@arndb.de> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <200806020912.49721.arnd@arndb.de>, Arnd Bergmann writes:
> On Monday 02 June 2008, hooanon05@yahoo.co.jp wrote:
[...]
> Ok, I'm sorry for not having looked at it myself. I saw an older version
> and assumed it was not going to improve much. I'll have another look
> when I find the time. Unionfs was suffering from severe feature creep
> (multiple writable branches, runtime branch modification), and aufs
> seemed to add even more features instead of removing them.

Re: feature creep.  Unionfs had more features initially, but we removed
those that users didn't seem to want/use.  The bottom line, we've been
maintaining unionfs publicly for 5+ years now, so the set of features we
have is based exactly on what users want.  If anyone can give the users what
they want/need in a different, more elegant way, that's great; if not, users
just won't switch to another solution.

> Without reading either again, the top problems in unionfs at the time were:
> * data inconsistency problems when simultaneously accessing the underlying
>   fs and the union.

That's not an issue when using vm_ops->fault for data.

There is still an issue wrt dentries and topology changes, as Al mentioned
here before.  Al suggested to me (at OLS 08) that the superblock struct
might need the same writers-count as has been done for vfsmounts recently;
then you can prevent topology changes during union'ed operations
(esp. copyup).

> * duplication of dentry and inode data structures in the union wastes
>   memory and cpu cycles.

Yes, but I don't think it's much more than any other layered solution will
have (including ecryptfs and union mounts).  This is a general problem in
stackable file systems.  Union Mounts, being in the VFS, has the chance to
use less memory indeed, but at a possible cost of increased VFS complexity.

> * whiteouts are in the same namespace as regular files, so conflicts are
>   possible.

Agreed.  We have a different version of unionfs, called unionfs-odf, which
moves the whiteouts and all unioning-related meta-data to a separate, small
persistent partition.

But the better long-term solution is to get WH support in every native f/s.
These patches had been floating around for a while now, and they seem simple
enough that I don't see why it had taken so long to get basic WH support
into mainline (or at least -mm).  (Bharata, can you ask akpm to add just the
WH support into -mm perhaps?)

> * mounting a large number of aufs on top of each other eventually
>   overflows the kernel stack, e.g. in readdir.

Yes.  That's a general problem with stackable file systems.  Each layer you
add increases the depth of the stack.  There are all already known paths
(involving xfs/nfs/dm, etc.) which overrun the stack and the solution I've
heard was "don't do it."  That seems silly to me.  Instead, the kernel stack
should be growable dynamically, at the cost of performance.

However, the vast majority of unioning users use just one layer, so even for
us, blowing up the stack has been a rather rare user complaint.  And we've
been very mindful of stack usage (i.e., checking and optimizing based on
checkstack.pl).

> * allowing multiple writable branches (instead of just stacking
>   one rw copy on a number of ro file systems) is confusing to the user
>   and complicates the implementation a lot.

I agree that it does complicate the implementation, but again, this is
something that _some_ users really want: they want to merge multiple
"packages" together, and ensure that modifications to files/dirs of a given
package stay in their logical location.

I disagree with you that it's confusing to the user.  I've never had
complaints that people didn't how to change the branch configurations
dynamically.  Heck, people come up with creative ways of using dynamic
branch configurations in all sorts of funky environments that make even my
head spin :-) -- chroot, pivot_root, nfs exports, etc.

> With the exception of the last two, I assumed that these were all
> unfixable with a file system based approach (including the hypothetical
> union-tmpfs). If you have addressed them, how?
> 
> 	Arnd <><

Erez.
