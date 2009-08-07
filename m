Return-Path: <linux-kernel-owner+w=401wt.eu-S933018AbZHGS7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbZHGS7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932871AbZHGS7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:59:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56763 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932957AbZHGS6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:58:38 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk, hannes@cmpxchg.org
Subject: [PATCH 1/4] vfs: make get_sb_pseudo set s_maxbytes to value that can be cast to signed
Date: Fri,  7 Aug 2009 14:57:38 -0400
Message-Id: <1249671461-9071-2-git-send-email-jlayton@redhat.com>
In-Reply-To: <1249671461-9071-1-git-send-email-jlayton@redhat.com>
References: <1249671461-9071-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a counterpart to the CIFS patch posted yesterday. I
believe either patch will fix the problem seen in do_sendfile since the
smaller s_maxbytes value for the two superblocks is used there.

get_sb_pseudo sets s_maxbytes to ~0ULL, which becomes negative when cast
to a signed value. Fix it to use MAX_LFS_FILESIZE which casts properly
to a positive signed value.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/libfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index ddfa899..dcec3d3 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -217,7 +217,7 @@ int get_sb_pseudo(struct file_system_type *fs_type, char *name,
 		return PTR_ERR(s);
 
 	s->s_flags = MS_NOUSER;
-	s->s_maxbytes = ~0ULL;
+	s->s_maxbytes = MAX_LFS_FILESIZE;
 	s->s_blocksize = PAGE_SIZE;
 	s->s_blocksize_bits = PAGE_SHIFT;
 	s->s_magic = magic;
-- 
1.6.0.6

