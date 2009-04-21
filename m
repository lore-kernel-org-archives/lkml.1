Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbZDUJOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbZDUJOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbZDUJOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:14:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59579 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbZDUJO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:14:29 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/2] GFS2: Clear dirty bit at end of inode glock sync
Date: Tue, 21 Apr 2009 09:09:28 +0100
Message-Id: <1240301369-12585-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1240301369-12585-1-git-send-email-swhiteho@redhat.com>
References: <1240301369-12585-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dirty bit can get set during the inode glock sync. Its too
complicated to change that at the moment, so this is the quick
fix - to clear the bit again at the end of the function.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index bf23a62..70f87f4 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -156,6 +156,12 @@ static void inode_go_sync(struct gfs2_glock *gl)
 	error = filemap_fdatawait(metamapping);
 	mapping_set_error(metamapping, error);
 	gfs2_ail_empty_gl(gl);
+	/*
+	 * Writeback of the data mapping may cause the dirty flag to be set
+	 * so we have to clear it again here.
+	 */
+	smp_mb__before_clear_bit();
+	clear_bit(GLF_DIRTY, &gl->gl_flags);
 }
 
 /**
-- 
1.6.0.6

