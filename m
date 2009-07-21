Return-Path: <linux-kernel-owner+w=401wt.eu-S1750849AbZGUXmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849AbZGUXmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 19:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbZGUXmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 19:42:08 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:33180 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZGUXmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 19:42:07 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: fix sb->s_maxbytes so that it casts properly to a signed value
Date: Tue, 21 Jul 2009 19:42:03 -0400
Message-Id: <1248219723-832-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This off-by-one bug causes sendfile() to not work properly. When a task
calls sendfile() on a file on a CIFS filesystem, the syscall returns -1
and sets errno to EOVERFLOW.

do_sendfile uses s_maxbytes to verify the returned offset of the file.
The problem there is that this value is cast to a signed value (loff_t).
When this is done on the s_maxbytes value that cifs uses, it becomes
negative and the comparisons against it fail.

Even though s_maxbytes is an unsigned value, it seems that it's not OK
to set it in such a way that it'll end up negative when it's cast to a
signed value. These casts happen in other codepaths besides sendfile
too, but the VFS is a little hard to follow in this area and I can't
be sure if there are other bugs that this will fix.

It's not clear to me why s_maxbytes isn't just declared as loff_t in the
first place, but either way we still need to fix these values to make
sendfile work properly. This is also an opportunity to replace the magic
bit-shift values here with the standard #defines for this.

This fixes the reproducer program I have that does a sendfile and
will probably also fix the situation where apache is serving from a
CIFS share.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3e9936d..82ad2a8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2446,10 +2446,10 @@ try_mount_again:
 		tcon->local_lease = volume_info->local_lease;
 	}
 	if (pSesInfo) {
-		if (pSesInfo->capabilities & CAP_LARGE_FILES) {
-			sb->s_maxbytes = (u64) 1 << 63;
-		} else
-			sb->s_maxbytes = (u64) 1 << 31;	/* 2 GB */
+		if (pSesInfo->capabilities & CAP_LARGE_FILES)
+			sb->s_maxbytes = MAX_LFS_FILESIZE;
+		else
+			sb->s_maxbytes = MAX_NON_LFS;
 	}
 
 	/* BB FIXME fix time_gran to be larger for LANMAN sessions */
-- 
1.6.0.6

