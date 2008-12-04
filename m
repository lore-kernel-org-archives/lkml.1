Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYLDJCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYLDJCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 04:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYLDJCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 04:02:22 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:54844 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbYLDJCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 04:02:20 -0500
X-Greylist: delayed 44616 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Dec 2008 04:02:19 EST
Date: Thu, 4 Dec 2008 10:02:15 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>,
       Lachlan McIlroy <lachlan@sgi.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, xfs@oss.sgi.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: XFS breakage on m68k (was: Re: linux-next: Tree for December 3)
In-Reply-To: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0812040956370.10635@anakin>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Stephen Rothwell wrote:
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

On m68k (32-bit only, no compat32), XFS fails to build in linux-next:

| fs/xfs/linux-2.6/xfs_ioctl32.h:50: error: syntax error before 'compat_time_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:52: error: syntax error before '}' token
| fs/xfs/linux-2.6/xfs_ioctl32.h:63: error: syntax error before 'compat_xfs_bstime_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:65: error: syntax error before 'bs_ctime'
| fs/xfs/linux-2.6/xfs_ioctl32.h:76: error: syntax error before '}' token
| fs/xfs/linux-2.6/xfs_ioctl32.h:79: error: syntax error before 'compat_uptr_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:81: error: syntax error before 'ubuffer'
| fs/xfs/linux-2.6/xfs_ioctl32.h:82: error: syntax error before 'ocount'
| fs/xfs/linux-2.6/xfs_ioctl32.h:94: error: syntax error before 'compat_uptr_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:96: error: syntax error before 'ihandle'
| fs/xfs/linux-2.6/xfs_ioctl32.h:98: error: syntax error before 'ohandle'
| fs/xfs/linux-2.6/xfs_ioctl32.h:99: error: syntax error before 'ohandlen'
| fs/xfs/linux-2.6/xfs_ioctl32.h:121: error: syntax error before 'compat_xfs_bstat_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:127: error: field 'hreq' has incomplete type
| fs/xfs/linux-2.6/xfs_ioctl32.h:131: error: syntax error before 'compat_uptr_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:142: error: syntax error before 'compat_uptr_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:146: error: syntax error before '}' token
| fs/xfs/linux-2.6/xfs_ioctl32.h:149: error: field 'hreq' has incomplete type
| fs/xfs/linux-2.6/xfs_ioctl32.h:152: error: syntax error before 'compat_uptr_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:159: error: field 'hreq' has incomplete type
| fs/xfs/linux-2.6/xfs_ioctl32.h:161: error: syntax error before 'compat_uptr_t'
| distcc[28223] ERROR: compile fs/xfs/linux-2.6/xfs_file.c on localhost failed

(http://kisskb.ellerman.id.au/kisskb/buildresult/58941/)

or (with a different compiler):

| In file included from fs/xfs/linux-2.6/xfs_file.c:39:
| fs/xfs/linux-2.6/xfs_ioctl32.h:50: error: expected specifier-qualifier-list before 'compat_time_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:79: error: expected specifier-qualifier-list before 'compat_uptr_t'
| fs/xfs/linux-2.6/xfs_ioctl32.h:94: error: expected specifier-qualifier-list before 'compat_uptr_t'
| make[2]: *** [fs/xfs/linux-2.6/xfs_file.o] Error 1

git bisect run says:

ffae263a640b736a7206a0d7bd14ab44eb58cd28 is first bad commit
commit ffae263a640b736a7206a0d7bd14ab44eb58cd28
Author: sandeen@sandeen.net <sandeen@sandeen.net>
Date:   Tue Nov 25 21:20:07 2008 -0600

    [XFS] Move compat ioctl structs & numbers into xfs_ioctl32.h

    This makes the c file less cluttered and a bit more
    readable.   Consistently name the ioctl number
    macros with "_32" and the compatibility stuctures
    with "_compat."  Rename the helpers which simply
    copy in the arg with "_copyin" for easy identification.

    Finally, for a few of the existing helpers, modify them
    so that they directly call the native ioctl helper
    after userspace argument fixup.

    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
