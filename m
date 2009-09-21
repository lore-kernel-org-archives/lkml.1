Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354AbZIUPD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354AbZIUPD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 11:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbZIUPD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 11:03:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60143 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZIUPD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 11:03:58 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu, agruen@suse.de, hch@lst.de,
       hugh.dickins@tiscali.co.uk, matthew@wil.cx
In-reply-to: <20090921140220.GD14381@ZenIV.linux.org.uk> (message from Al Viro
	on Mon, 21 Sep 2009 15:02:20 +0100)
Subject: Re: [PATCH 2/2] vfs: fix d_path() for unreachable paths
References: <E1MpiJo-0005fv-2y@pomaz-ex.szeredi.hu> <E1MpiMo-0005h9-DG@pomaz-ex.szeredi.hu> <20090921140220.GD14381@ZenIV.linux.org.uk>
Message-Id: <E1MpkQe-00060P-Q4@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Sep 2009 17:03:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009, Al Viro wrote:
> On Mon, Sep 21, 2009 at 02:51:42PM +0200, Miklos Szeredi wrote:
> > Hugh Dickins reported that an old version of gnome-vfs-daemon crashes
> > because it finds an entry in /proc/mounts where the mountpoint is
> > unreachable.  So revert /proc/mounts to the old behavior (or rather a
> > less crazy version of the old behavior).
> > 
> > Also revert the effect on /proc/${PID}/maps for memory maps set up
> > with shmem_file_setup() or hugetlb_file_setup().  These functions set
> > up unlinked files under a kernel-private vfsmount.  Since this
> > vfsmount is unreachable from userspace, these maps will be reported
> > with the "(unreachable)" prefix, which is undesirable, because it
> > changes the kernel ABI and might break applications for no good
> > reason.
> 
> Ho-hum...
> 	a) d_op you've got there look like a candidate for libfs, if
> we go for that at all
> 	b) I *really* don't like changing the behaviour of d_path() instead
> of doing new behaviour in a new function and deciding where to use it on
> case-by-case basis
> 	c) having just grepped for d_path()... oh, man
> * blackfin cplbinfo: utter crap; it's used to decide which procfs file
> is being opened - by dumping full pathname into a (on-stack) buffer
> and then parsing it.  Stupid *and* broken.
> * blackfin traps.c:decode_address(): for one thing, pathnames has been
> known to be longer than 256 bytes.  For another... locking in that loop
> over processes and VMAs of each looks very suspicios, while we are at it.
> * pohmelfs_construct_path_string(): just what will happen if we are called
> from process chrooted into that bugger?  d_path() is badly abused there.
> * ext4_file_open(): d_path() per se is probably OK, but initializing
> path.mnt/path.dentry isn't.  mount --move racing with that thing => loads
> of fun.
> * sysfs_open_file(): racy in an obvious way, but probably won't do anything
> worse than garbage in oopsen.
> 
> I'm very uncomfortable with the silent change of behaviour, especially since
> existing callers seem to be split between "part of user-visible ABI" and
> "generally bogus, waiting for a gnat to fart".  At the very least it needs
> a serious audit of callers.


Fair enough, I should have done a review of internal callers...  Will
do that now.

The big question is, however, if we accept the unknown risk of
changing the user-visible ABI from "broken, but path at least *looks*
normal" to "paths don't necessarily begin with a slash anymore".

Hmm?

Thanks,
Miklos

