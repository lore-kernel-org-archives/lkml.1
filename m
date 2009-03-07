Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbZCGSM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbZCGSM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 13:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbZCGSMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 13:12:20 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:34598 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZCGSMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 13:12:19 -0500
Date: Sat, 7 Mar 2009 10:10:50 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: serue@us.ibm.com, hpa@zytor.com, sukadev@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5][v2] Simplify devpts code
Message-ID: <20090307181050.GB30072@us.ibm.com>
References: <20090307180816.GA30072@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090307180816.GA30072@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [v3][PATCH 1/5] Unroll essentials of do_remount_sb() into devpts

On remount, devpts fs only needs to parse the mount options. Users cannot
directly create/dirty files in /dev/pts so the MS_RDONLY flag and
shrinking the dcache does not really apply to devpts.

So effectively on remount, devpts only parses the mount options and updates
these options in its super block. As such, we could replace do_remount_sb()
call with a direct parse_mount_options().

Doing so enables subsequent patches to avoid parsing the mount options twice
and simplify the code.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 fs/devpts/inode.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index ad186b4..de15e73 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -442,6 +442,8 @@ static int get_init_pts_sb(struct file_system_type *fs_type, int flags,
 		void *data, struct vfsmount *mnt)
 {
 	struct super_block *s;
+	struct pts_mount_opts *opts;
+	struct pts_fs_info *fsi;
 	int error;
 
 	s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
@@ -458,7 +460,10 @@ static int get_init_pts_sb(struct file_system_type *fs_type, int flags,
 		}
 		s->s_flags |= MS_ACTIVE;
 	}
-	do_remount_sb(s, flags, data, 0);
+	fsi = DEVPTS_SB(s);
+	opts = &fsi->mount_opts;
+	parse_mount_options(data, PARSE_REMOUNT, opts);
+
 	simple_set_mnt(mnt, s);
 	return 0;
 }
-- 
1.5.2.5

