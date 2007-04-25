Return-Path: <linux-kernel-owner+w=401wt.eu-S2992654AbXDYKyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992654AbXDYKyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992689AbXDYKwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:52:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992678AbXDYKvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:51:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/16] AFS: Handle multiple mounts of an AFS superblock
	correctly [try #3]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, dhowells@redhat.com
Date: Wed, 25 Apr 2007 11:51:29 +0100
Message-ID: <20070425105129.10872.1324.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070425105036.10872.48596.stgit@warthog.cambridge.redhat.com>
References: <20070425105036.10872.48596.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle multiple mounts of an AFS superblock correctly, checking to see whether
the superblock is already initialised after calling sget() rather than just
unconditionally stamping all over it.

Also delete the "silent" parameter to afs_fill_super() as it's not used and
can, in any case, be obtained from sb->s_flags.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 fs/afs/super.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/afs/super.c b/fs/afs/super.c
index efc4fe6..77e6875 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -212,7 +212,7 @@ static int afs_test_super(struct super_block *sb, void *data)
 /*
  * fill in the superblock
  */
-static int afs_fill_super(struct super_block *sb, void *data, int silent)
+static int afs_fill_super(struct super_block *sb, void *data)
 {
 	struct afs_mount_params *params = data;
 	struct afs_super_info *as = NULL;
@@ -319,17 +319,23 @@ static int afs_get_sb(struct file_system_type *fs_type,
 		goto error;
 	}
 
-	sb->s_flags = flags;
-
-	ret = afs_fill_super(sb, &params, flags & MS_SILENT ? 1 : 0);
-	if (ret < 0) {
-		up_write(&sb->s_umount);
-		deactivate_super(sb);
-		goto error;
+	if (!sb->s_root) {
+		/* initial superblock/root creation */
+		_debug("create");
+		sb->s_flags = flags;
+		ret = afs_fill_super(sb, &params);
+		if (ret < 0) {
+			up_write(&sb->s_umount);
+			deactivate_super(sb);
+			goto error;
+		}
+		sb->s_flags |= MS_ACTIVE;
+	} else {
+		_debug("reuse");
+		ASSERTCMP(sb->s_flags, &, MS_ACTIVE);
 	}
-	sb->s_flags |= MS_ACTIVE;
-	simple_set_mnt(mnt, sb);
 
+	simple_set_mnt(mnt, sb);
 	afs_put_volume(params.volume);
 	afs_put_cell(params.default_cell);
 	_leave(" = 0 [%p]", sb);

