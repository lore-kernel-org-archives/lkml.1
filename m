Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbYLLF0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbYLLF0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbYLLFZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:25:10 -0500
Received: from kroah.org ([198.145.64.141]:37012 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752235AbYLLFZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:25:07 -0500
Date: Thu, 11 Dec 2008 21:24:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, Eugene Teo <eteo@redhat.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, Jake Edge <jake@lwn.net>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Dave Chinner <david@fromorbit.com>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Lachlan McIlroy <lachlan@sgi.com>
Subject: [patch 85/83] XFS: Fix hang after disallowed rename across
	directory quota domains
Message-ID: <20081212052401.GC9024@kroah.com>
References: <20081211191014.GA5759@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <david@fromorbit.com>

commit 576a488a27f267af203f3ea69c700a1612335e9f upstream.

When project quota is active and is being used for directory tree
quota control, we disallow rename outside the current directory
tree. This requires a check to be made after all the inodes
involved in the rename are locked. We fail to unlock the inodes
correctly if we disallow the rename when the target is outside the
current directory tree. This results in a hang on the next access
to the inodes involved in failed rename.

Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Tested-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_rename.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -212,7 +212,7 @@ xfs_rename(
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
 		     (target_dp->i_d.di_projid != src_ip->i_d.di_projid))) {
 		error = XFS_ERROR(EXDEV);
-		xfs_rename_unlock4(inodes, XFS_ILOCK_SHARED);
+		xfs_rename_unlock4(inodes, XFS_ILOCK_EXCL);
 		xfs_trans_cancel(tp, cancel_flags);
 		goto std_return;
 	}
