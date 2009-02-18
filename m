Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbZBRVj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbZBRVj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbZBRVfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:35:39 -0500
Received: from kroah.org ([198.145.64.141]:56176 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755189AbZBRVfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:38 -0500
Date: Wed, 18 Feb 2009 13:32:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Carsten Otte <cotte@de.ibm.com>,
       Nick Piggin <npiggin@suse.de>, Jared Hulbert <jaredeh@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 12/39] ext2/xip: refuse to change xip flag during remount
	with busy inodes
Message-ID: <20090218213236.GM19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ext2-xip-refuse-to-change-xip-flag-during-remount-with-busy-inodes.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Carsten Otte <cotte@de.ibm.com>

commit 0e4a9b59282914fe057ab17027f55123964bc2e2 upstream.

For a reason that I was unable to understand in three months of debugging,
mount ext2 -o remount stopped working properly when remounting from
regular operation to xip, or the other way around.  According to a git
bisect search, the problem was introduced with the VM_MIXEDMAP/PTE_SPECIAL
rework in the vm:

commit 70688e4dd1647f0ceb502bbd5964fa344c5eb411
Author: Nick Piggin <npiggin@suse.de>
Date:   Mon Apr 28 02:13:02 2008 -0700

    xip: support non-struct page backed memory

In the failing scenario, the filesystem is mounted read only via root=
kernel parameter on s390x.  During remount (in rc.sysinit), the inodes of
the bash binary and its libraries are busy and cannot be invalidated (the
bash which is running rc.sysinit resides on subject filesystem).
Afterwards, another bash process (running ifup-eth) recurses into a
subshell, runs dup_mm (via fork).  Some of the mappings in this bash
process were created from inodes that could not be invalidated during
remount.

Both parent and child process crash some time later due to inconsistencies
in their address spaces.  The issue seems to be timing sensitive, various
attempts to recreate it have failed.

This patch refuses to change the xip flag during remount in case some
inodes cannot be invalidated.  This patch keeps users from running into
that issue.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Jared Hulbert <jaredeh@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext2/super.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1177,9 +1177,12 @@ static int ext2_remount (struct super_bl
 	es = sbi->s_es;
 	if (((sbi->s_mount_opt & EXT2_MOUNT_XIP) !=
 	    (old_mount_opt & EXT2_MOUNT_XIP)) &&
-	    invalidate_inodes(sb))
-		ext2_warning(sb, __func__, "busy inodes while remounting "\
-			     "xip remain in cache (no functional problem)");
+	    invalidate_inodes(sb)) {
+		ext2_warning(sb, __func__, "refusing change of xip flag "
+			     "with busy inodes while remounting");
+		sbi->s_mount_opt &= ~EXT2_MOUNT_XIP;
+		sbi->s_mount_opt |= old_mount_opt & EXT2_MOUNT_XIP;
+	}
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		return 0;
 	if (*flags & MS_RDONLY) {

