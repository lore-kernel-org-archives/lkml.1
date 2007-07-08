Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbXGHPcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbXGHPcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 11:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbXGHPcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 11:32:16 -0400
Received: from smtp-out-41.synserver.de ([217.119.50.41]:1151 "HELO
	smtp-out-41.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754040AbXGHPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 11:32:15 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-RemoteDnsName: port-212-202-34-50.dynamic.qsc.de
Date: Sun, 8 Jul 2007 17:28:08 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, drepper@redhat.com,
       torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer
	dereference - git-bisect result
Message-ID: <20070708152808.GA5902@gentoox2.trippelsdorf.de>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de> <20070708012016.455ce8d5.akpm@linux-foundation.org> <20070708100911.GA4196@gentoox2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070708100911.GA4196@gentoox2.trippelsdorf.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 12:09:11PM +0200, Markus Trippelsdorf wrote:
> On Sun, Jul 08, 2007 at 01:20:16AM -0700, Andrew Morton wrote:
> > On Sun, 8 Jul 2007 07:14:52 +0200 Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> > 
> > ...
> > > touch src/.depend # to prevent unecessary warnings
> > > make: *** [dep] Killed
> > 
> > ug.  nd.dentry.d_inode (as set up by do_utimes()) is garbage.  I don't know
> > what could have caused that.
> > 
> > 
> > > Running "touch  /var/tmp/paludis/sys-libs/gpm-1.20.1-r6/work/gpm-1.20.1/src/.depend" 
> > > triggers this oops.
> > 
> > What type of filesystem is at /var/tmp?
> > 
> > Is it repeatable after a reboot?
> > 
> 
> The filesystem at /var/tmp was xfs. And yes it was repeatable after a
> reboot...
> 
> So I ran xfs_check on that partition and it reported errors. Then I ran
> xfs_repair and after that rebooted, but the problem was still there.
> Finally I switched the partition back to ext3, because it got too scary.
> But the oops is now repeatable even on this new ext3 partition.

I tested this further and it turned out that the Linus tree is also
affected. So I ran git-bisect, after I found out that version
2.6.21.6 was not affected by this bug.

This is the result:

gentoox2 linux # git bisect bad
1c710c896eb461895d3c399e15bb5f20b39c9073 is first bad commit
commit 1c710c896eb461895d3c399e15bb5f20b39c9073
Author: Ulrich Drepper <drepper@redhat.com>
Date:   Tue May 8 00:33:25 2007 -0700

    utimensat implementation

    Implement utimensat(2) which is an extension to futimesat(2) in that it

    a) supports nano-second resolution for the timestamps
    b) allows to selectively ignore the atime/mtime value
    c) allows to selectively use the current time for either atime or mtime
    d) supports changing the atime/mtime of a symlink itself along the lines
       of the BSD lutimes(3) functions

    For this change the internally used do_utimes() functions was changed to
    accept a timespec time value and an additional flags parameter.

    Additionally the sys_utime function was changed to match compat_sys_utime
    which already use do_utimes instead of duplicating the work.

    Also, the completely missing futimensat() functionality is added.  We have
    such a function in glibc but we have to resort to using /proc/self/fd/* which
    not everybody likes (chroot etc).

    Test application (the syscall number will need per-arch editing):
...

    [akpm@linux-foundation.org: add missing i386 syscall table entry]
    Signed-off-by: Ulrich Drepper <drepper@redhat.com>
    Cc: Alexey Dobriyan <adobriyan@openvz.org>
    Cc: Michael Kerrisk <mtk-manpages@gmx.net>
    Cc: <linux-arch@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

HTH,
-- 
Markus
