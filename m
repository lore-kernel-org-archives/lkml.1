Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYKNEI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYKNEI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 23:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYKNEIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 23:08:19 -0500
Received: from smtpout.eastlink.ca ([24.222.0.30]:62128 "EHLO
	smtpout.eastlink.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYKNEIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 23:08:18 -0500
Date: Fri, 14 Nov 2008 00:08:16 -0400
From: Peter Cordes <peter@cordes.ca>
Subject: Re: [PATCH 2.6.28?] don't unlink an active swapfile
In-reply-to: <Pine.LNX.4.64.0811140234300.5027@blonde.site>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       Christoph Hellwig <hch@infradead.org>, Bodo Eggert <7eggert@gmx.de>,
       David Newall <davidn@davidnewall.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Message-id: <20081114040816.GS31127@cordes.ca>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEADOIHElMCxYt/2dsb2JhbACBbc8Bgng
X-IronPort-AV: E=Sophos;i="4.33,600,1220238000";   d="scan'208";a="368362628"
References: <bnJFK-3bu-7@gated-at.bofh.it> <bnR0A-4kq-1@gated-at.bofh.it>
 <E1KqkZK-0001HO-WF@be1.7eggert.dyndns.org>
 <Pine.LNX.4.64.0810171250410.22374@blonde.site>
 <20081018003117.GC26067@cordes.ca> <20081018051800.GO24654@1wt.eu>
 <Pine.LNX.4.64.0810182058120.7154@blonde.site>
 <20081018204948.GA22140@infradead.org> <20081018205647.GA29946@1wt.eu>
 <Pine.LNX.4.64.0811140234300.5027@blonde.site>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 02:37:22AM +0000, Hugh Dickins wrote:
> Peter Cordes is sorry that he rm'ed his swapfiles while they were in use,
> he then had no pathname to swapoff.  It's a curious little oversight, but
> not one worth a lot of hackery.

 Yeah, not a lot, but I'd say it's worth some.  On the system where I
'rm -rf'ed part of a filesystem before cp -a, mkfs, cp -a, I was left
unable to umount.  Plus, when I rebooted, Ubuntu's init scripts failed
to even sync the disks during shutdown.  A recently-written file on
the same XFS filesystem as the swap file ended up empty because of the
unclean shutdown. :(  I don't know if remount ro would have been
possible on a FS with an active swap file, but Ubuntu should have at
least tried to sync when umount failed.


>  Kudos to Willy Tarreau for turning this
> around from a discussion of synthetic pathnames to how to prevent unlink.

 Yeah, this is great; as a sysadmin, this produces exactly the right
behaviour, IMHO.  It doesn't have any chance of leaving files marked
immutable on disk after an unclean reboot, which was a fatal flaw in
the idea of setting the i bit on swap files, either in swapon(8) or in
the kernel.  That would introduce complexity for admins who would
otherwise never have to think about this.  The new behaviour this adds
should make sense to most admins;  They'll see
rm: swapfile: permission denied
or something, and should quickly realize that there must be something
special about active swap files.  So it's discoverable (i.e.
non-mysterious) behaviour.

 This prevents running with a deleted swapfile, but I can't think of a
case when that's useful, let alone worth the trouble of writing a new one every
reboot.  (e.g. xfs's resvsp ioctl creates extents flagged as unwritten
which can't be swapped on, so a swapfile would have to be actually
written on most filesystems.)

 And it doesn't add any size to the kernel binary, unlike my idea of
having a /proc/something/fd link that one could swapoff, having
sys_swapoff() fall back to parsing its argument as an integer index
into a list of swap areas, or other ugly ideas...  :P

 Thanks everyone for coming up with such a clever solution to the
pitfall I found.

> Mimic immutable: prohibit unlinking an active swapfile in may_delete()
> (and don't worry my little head over the tiny race window).
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Perhaps this is too late for 2.6.28: your decision.
> 
>  fs/namei.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 2.6.28-rc4/fs/namei.c	2008-10-24 09:28:19.000000000 +0100
> +++ linux/fs/namei.c	2008-11-12 11:52:44.000000000 +0000
> @@ -1378,7 +1378,7 @@ static int may_delete(struct inode *dir,
>  	if (IS_APPEND(dir))
>  		return -EPERM;
>  	if (check_sticky(dir, victim->d_inode)||IS_APPEND(victim->d_inode)||
> -	    IS_IMMUTABLE(victim->d_inode))
> +	    IS_IMMUTABLE(victim->d_inode) || IS_SWAPFILE(victim->d_inode))
>  		return -EPERM;
>  	if (isdir) {
>  		if (!S_ISDIR(victim->d_inode->i_mode))

-- 
#define X(x,y) x##y
Peter Cordes ;  e-mail: X(peter@cor , des.ca)

"The gods confound the man who first found out how to distinguish the hours!
 Confound him, too, who in this place set up a sundial, to cut and hack
 my day so wretchedly into small pieces!" -- Plautus, 200 BC
