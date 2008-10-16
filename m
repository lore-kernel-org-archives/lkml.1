Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYJPA3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYJPA3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 20:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbYJPA3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 20:29:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51266 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754185AbYJPA3e (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 20:29:34 -0400
Date: Thu, 16 Oct 2008 11:29:26 +1100
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: [PATCH] XFS fix remount rw with unrecognized options
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081016002926.D912558FA22B@chook.melbourne.sgi.com>
From: tes@sgi.com (Tim Shimmin)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending as I mangled sending the mail from home last time. Sorry.

Please include the following patch for 2.6.27.1 stable release as
suggested by Christoph Hellwig and Eric Sandeen.
It fixes a regression in the recent remount recoding
where remounting say from ro to rw allows the xfs flags to
be out of sync with the vfs flags, resulting
in failures for some programs such as touch (which end up calling xfs_setattr).
The fix is a very minor and clear.

Thanks,
Tim.

Date: Sun, 12 Oct 2008 14:30:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: xfs@oss.sgi.com
Subject: [PATCH] fix remount rw with unrecognized options

When we skip unrecognized options in xfs_fs_remount we should just break
out of the switch and not return because otherwise we may skip clearing
the xfs-internal read-only flag.  This will only show up on some
operations like touch because most read-only checks are done by the VFS
which thinks this filesystem is r/w.  Eventually we should replace the
XFS read-only flag with a helper that always checks the VFS flag to make
sure they can never get out of sync.

Bug reported and fix verified by Marcel Beister on #xfs.
Bug fix verified by updated xfstests/189.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Timothy Shimmin <tes@sgi.com>

Index: mainline/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- mainline.orig/fs/xfs/linux-2.6/xfs_super.c	2008-10-15 17:59:26.542652847 +1100
+++ mainline/fs/xfs/linux-2.6/xfs_super.c	2008-10-15 17:59:45.376217172 +1100
@@ -1323,7 +1323,7 @@ xfs_fs_remount(
 	"XFS: mount option \"%s\" not supported for remount\n", p);
 			return -EINVAL;
 #else
-			return 0;
+			break;
 #endif
 		}
 	}
