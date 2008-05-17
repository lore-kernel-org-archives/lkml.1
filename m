Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYEQHir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYEQHir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 03:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYEQHij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 03:38:39 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:42476 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751941AbYEQHii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 03:38:38 -0400
To: linux-kernel@vger.kernel.org
cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: REGRESSION: 2.6.26-rc2-git4: X server failed start on X61s laptop
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1JxGth-0001te-S4@closure.thunk.org>
Date: Sat, 17 May 2008 03:32:05 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The X server failed to come up using the Intel driver, and forced a
fallback to the 800x600 VESA server.  This was on my Lenovo X61s laptop
with an Intel chipset, running Ubuntu Gutsy.  When it failed, there were
a large number of these errors in the /var/log/messages:

mtrr: type mismatch for e0760000,10000 old: write-back new: write-combining
mtrr: type mismatch for e0740000,20000 old: write-back new: write-combining
mtrr: type mismatch for e0700000,40000 old: write-back new: write-combining
mtrr: type mismatch for e0600000,100000 old: write-back new: write-combining
mtrr: type mismatch for e0400000,200000 old: write-back new: write-combining
mtrr: type mismatch for e0000000,400000 old: write-back new: write-combining
      ...

On kernels where this error did not occur during the bisect, there would
still be one of these messages:

mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining

... but the X server would correctly start.

The git bisect identified this commit as the guilty one:

1c12c4cf9411eb130b245fa8d0fbbaf989477c7b is first bad commit
commit 1c12c4cf9411eb130b245fa8d0fbbaf989477c7b
Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Wed May 14 16:05:51 2008 -0700

    mprotect: prevent alteration of the PAT bits
    
    There is a defect in mprotect, which lets the user change the page cache
    type bits by-passing the kernel reserve_memtype and free_memtype
    wrappers.  Fix the problem by not letting mprotect change the PAT bits.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Hugh Dickins <hugh@veritas.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 db42a4a31f711306205648690e97cbead50183ac 3f835886fcb56fc6e732ee6f985304c4c04b93d9 M      include
:040000 040000 b3c046a2f1cdfa6a3ec4b46f89cbee6f2ab5018d 07a87010634f455313e1e7f7e3f7d3a94b9bfed3 M      mm

And the bisect log follows here:

git-bisect start
# bad: [079d04dfa5198e3d43c6db2dcfa400f7fbbd516f] ext4: fiemap implementation Here is ext4_fiemap() itself.  This still needs a bit of testing & work, but is correct for most file layouts.... I still hit occasional problems with interesting mappings such as sparse/preallocated/etc.
git-bisect bad 079d04dfa5198e3d43c6db2dcfa400f7fbbd516f
# good: [e7f379d5cabb2790ecce5d623382fa6085e7686d] alim15x3: remove WDC_ALI15X3 config option
git-bisect good e7f379d5cabb2790ecce5d623382fa6085e7686d
# good: [9dcbf35afb7359466efdf7fb81ee32f3ae2d56a3] V4L/DVB (7887): cx18: fix Compro H900 analog support.
git-bisect good 9dcbf35afb7359466efdf7fb81ee32f3ae2d56a3
# bad: [8f40f672e6bb071812f61bfbd30efc3fc1263ad1] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs
git-bisect bad 8f40f672e6bb071812f61bfbd30efc3fc1263ad1
# good: [90898709dfca860d9550c85f0924007f4c0467ea] atmel_lcdfb: fix initialization of a pre-allocated framebuffer
git-bisect good 90898709dfca860d9550c85f0924007f4c0467ea
# bad: [9ffee4cbc51907755809d98613d9e7133612803a] tty_check_change(): avoid taking tasklist_lock while holding tty->ctrl_lock
git-bisect bad 9ffee4cbc51907755809d98613d9e7133612803a
# good: [122a881c776b7c155bf3f379928cc27aab435288] video/logo: add support for Blackfin/Linux logo for framebuffer console
git-bisect good 122a881c776b7c155bf3f379928cc27aab435288
# bad: [1c12c4cf9411eb130b245fa8d0fbbaf989477c7b] mprotect: prevent alteration of the PAT bits
git-bisect bad 1c12c4cf9411eb130b245fa8d0fbbaf989477c7b
# good: [fd8a4221ad76df700ff34875c9fbc42302aa4ba3] memory_hotplug: check for walk_memory_resource() failure in online_pages()
git-bisect good fd8a4221ad76df700ff34875c9fbc42302aa4ba3
# good: [44c81433e8b05dbc85985d939046f10f95901184] per_cpu: fix DEFINE_PER_CPU_SHARED_ALIGNED for modules
git-bisect good 44c81433e8b05dbc85985d939046f10f95901184
