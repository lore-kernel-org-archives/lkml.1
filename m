Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbXGIQXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbXGIQXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbXGIQXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbXGIQXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:04 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] flush the glock completely in inode_go_sync
Date: Mon,  9 Jul 2007 17:02:07 +0100
Message-Id: <1183996989263-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839969822277-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

Fix for bz #231910
When filemap_fdatawrite() is called on the inode mapping in data=ordered mode,
it will add the glock to the log. In inode_go_sync(), if you do the
gfs2_log_flush() before this, after the filemap_fdatawrite() call, the glock
and its associated data buffers will be on the log again. This means you can
demote a lock from exclusive, without having it flushed from the log. The
attached patch simply moves the gfs2_log_flush up to after the
filemap_fdatawrite() call.

Originally, I tried moving the gfs2_log_flush to after gfs2_meta_sync(), but
that caused me to trip the following assert.

GFS2: fsid=cypher-36:test.0: fatal: assertion "!buffer_busy(bh)" failed
GFS2: fsid=cypher-36:test.0:   function = gfs2_ail_empty_gl, file = fs/gfs2/glops.c, line = 61

It appears that gfs2_log_flush() puts some of the glocks buffers in the busy
state and the filemap_fdatawrite() call is necessary to flush them. This makes
me worry slightly that a related problem could happen because of moving the
gfs2_log_flush() after the initial filemap_fdatawrite(), but I assume that
gfs2_ail_empty_gl() would catch that case as well.

Signed-off-by: Benjamin E. Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 7b82657..777ca46 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -156,9 +156,9 @@ static void inode_go_sync(struct gfs2_glock *gl)
 		ip = NULL;
 
 	if (test_bit(GLF_DIRTY, &gl->gl_flags)) {
-		gfs2_log_flush(gl->gl_sbd, gl);
 		if (ip)
 			filemap_fdatawrite(ip->i_inode.i_mapping);
+		gfs2_log_flush(gl->gl_sbd, gl);
 		gfs2_meta_sync(gl);
 		if (ip) {
 			struct address_space *mapping = ip->i_inode.i_mapping;
-- 
1.5.1.2

