Return-Path: <linux-kernel-owner+w=401wt.eu-S1761929AbZLJWOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761929AbZLJWOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761856AbZLJWOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:14:03 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761704AbZLJWOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:14:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] compat_ioctl cleanup
Date: Thu, 10 Dec 2009 23:13:32 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912102313.33000.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18XH5O0Pn8OSxHrPeRpxtlavpBhDZ/5WVEp2vm
 lxJidxWZIowAJgMeipTb3NcnGlhcjwf6Kzvfg/xMLnIeBCKJO8
 eLMXf4AKTBhfRSCGtyRVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

If you like this stuff, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git compat-ioctl-merge

It's a major rework of the way we handle ioctl calls for 32 bit
emulation and gets rid of the BKL in there as well as saving
some 30kb of kernel memory.

It did however not go through linux-next because it had 
conflicts/dependencies on the net-next tree and others.

The first two patches, killing off the BKL, have spend some time
in -mm, and I'm including them here because the rest of the
stuff depends on it.

The others are just cleanup, and if you decide not to take that
now, I'll have it properly go through linux-next for the 2.6.34 cycle.
I've been working on parts of this for some time and the whole
point is not to change any behaviour, so I'm not in a hurry here.

I have more patches on top of this to move other parts of
compat_ioctl.c into drivers, but those need more review and testing,
so they will have to wait for the next merge window.

	Arnd
---
Arnd Bergmann (8):
  compat_ioctl: remove all VT ioctl handling
  compat_ioctl: Remove BKL
  compat_ioctl: inline all conversion handlers
  compat_ioctl: simplify calling of handlers
  compat_ioctl: simplify lookup table
  compat_ioctl: pass compat pointer directly to handlers
  lp: move compat_ioctl handling into lp.c
  usbdevfs: move compat_ioctl handling to devio.c

 drivers/char/lp.c            |  115 +++++--
 drivers/usb/core/devio.c     |  110 ++++++-
 fs/compat_ioctl.c            |  767 +++++++++++-------------------------------
 include/linux/usbdevice_fs.h |   26 ++
 4 files changed, 417 insertions(+), 601 deletions(-)

---

commit ac2c97eae25760490a5f71cd8d5c0135599a993c
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sat Nov 14 02:28:05 2009 +0100

    usbdevfs: move compat_ioctl handling to devio.c
    
    Half the compat_ioctl handling is in devio.c, the other
    half is in fs/compat_ioctl.c. This moves everything into
    one place for consistency.
    
    As a positive side-effect, push down the BKL into the
    ioctl methods.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
    Cc: Alan Stern <stern@rowland.harvard.edu>
    Cc: Oliver Neukum <oliver@neukum.org>
    Cc: Alon Bar-Lev <alon.barlev@gmail.com>
    Cc: David Vrabel <david.vrabel@csr.com>
    Cc: linux-usb@vger.kernel.org

commit ecfa62f567c96e8e06500e9049598894fc5700d0
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sat Nov 14 01:33:13 2009 +0100

    lp: move compat_ioctl handling into lp.c
    
    Handling for LPSETTIMEOUT can easily be done in lp_ioctl, which
    is the only user. As a positive side-effect, push the BKL
    into the ioctl methods.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

commit 5c6596b027ac34f46f9d06a78b4a5adcb77b8149
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sat Nov 14 23:16:18 2009 +0100

    compat_ioctl: pass compat pointer directly to handlers
    
    Instead of having each handler call compat_ptr, we can now
    convert the pointer once and pass that to each handler.
    This saves a little bit of both source and object code size.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 88b13b474f3984f296a3b77bc98410ea24beb039
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu Nov 5 19:52:55 2009 +0100

    compat_ioctl: simplify lookup table
    
    The compat_ioctl table now only contains entries for
    COMPATIBLE_IOCTL, so we only need to know if a number
    is listed in it or now.
    
    As an optimization, we hash the table entries with a
    reversible transformation to get a more uniform distribution
    over it, sort the table at startup and then guess the
    position in the table when an ioctl number gets called
    to do a linear search from there.
    
    With the current set of ioctl numbers and the chosen
    transformation function, we need an average of four
    steps to find if a number is in the set, all of the
    accesses within one or two cache lines.
    
    This at least as good as the previous hash table
    approach but saves 8.5 kb of kernel memory.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 54d8470665395237b5b321d63b4567bfe7da5c50
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu Nov 5 19:13:51 2009 +0100

    compat_ioctl: simplify calling of handlers
    
    The compat_ioctl array now contains only entries for ioctl numbers
    that do not require a separate handler. By special-casing the
    ULONG_IOCTL case in the do_ioctl_trans function, we can kill the
    final use of a function pointer in the array.
    
       text    data     bss     dec     hex filename
       7539   13352    2080   22971    59bb before/fs/compat_ioctl.o
       7910    8552    2080   18542    486e after/fs/compat_ioctl.o
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 822dd237fa994132b14716b3645c25675132314d
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu May 21 22:04:16 2009 +0000

    compat_ioctl: inline all conversion handlers
    
    This makes all ioctl conversion handlers called from
    a single switch statement, leaving only COMPATIBLE_IOCTL
    and ULONG_IOCTL statements in the table. This is somewhat
    more space efficient and also lets us simplify the
    handling of the lookup table significantly.
    
    before:
       text    data     bss     dec     hex filename
       7619   14024    2080   23723    5cab obj/fs/compat_ioctl.o
    after:
       7567   13352    2080   22999    59d7 obj/fs/compat_ioctl.o
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 5250df8da312c2ff04b30e0641f2d2fa179c5075
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri Oct 16 02:25:25 2009 +0200

    compat_ioctl: Remove BKL
    
    We have always called ioctl conversion handlers under the big kernel lock,
    although that is generally not necessary.  In particular it is not needed
    for conversion of data structures and for calling sys_ioctl or
    do_vfs_ioctl, which will get the BKL again if needed.
    
    Handlers doing more than those two have been moved out, so we can kill off
    the BKL from compat_sys_ioctl.  This may significantly improve latencies
    with 32 bit applications, and it avoids a common scenario where a thread
    acquires the BKL twice.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Cc: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 2ce869a90064bc3f2d6d9e9745da5c3ac0930a1c
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Fri Oct 16 02:25:25 2009 +0200

    compat_ioctl: remove all VT ioctl handling
    
    The VT driver now handles all of these ioctls directly, so we can remove
    the handlers from common code.
    
    These are the only handlers that require the BKL because they directly
    perform the ioctl action rather than just converting the data structures.
    Once they are gone, we can remove the BKL from the remaining ioctl
    conversion handlers.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
