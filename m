Return-Path: <linux-kernel-owner+w=401wt.eu-S964829AbZKYN2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829AbZKYN2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964811AbZKYN2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:28:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbZKYN2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:12 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/30] GFS2: Use forget_all_cached_acls()
Date: Wed, 25 Nov 2009 14:22:30 +0000
Message-Id: <1259158975-28499-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-5-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-2-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-3-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-4-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-5-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invalidate all the cached ACLs when we drop the glock.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/glops.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 6985eef..78554ac 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -13,6 +13,7 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/bio.h>
+#include <linux/posix_acl.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -184,8 +185,10 @@ static void inode_go_inval(struct gfs2_glock *gl, int flags)
 	if (flags & DIO_METADATA) {
 		struct address_space *mapping = gl->gl_aspace->i_mapping;
 		truncate_inode_pages(mapping, 0);
-		if (ip)
+		if (ip) {
 			set_bit(GIF_INVALID, &ip->i_flags);
+			forget_all_cached_acls(&ip->i_inode);
+		}
 	}
 
 	if (ip == GFS2_I(gl->gl_sbd->sd_rindex))
-- 
1.6.2.5

