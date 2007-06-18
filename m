Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbXFRPMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbXFRPMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932121AbXFRPMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:12:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101AbXFRPM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:12:29 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/4] [GFS2] flush the glock completely in inode_go_sync
Date: Mon, 18 Jun 2007 15:54:27 +0100
Message-Id: <1182178478593-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11821784703600-git-send-email-swhiteho@redhat.com>
References: y
 <11821784703600-git-send-email-swhiteho@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.1.2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

This is a multi-part message in MIME format.
--------------1.5.1.2
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


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
---
 fs/gfs2/glops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
--------------1.5.1.2
Content-Type: text/x-patch; name="e92666ae590962682cf23fcae2c3bdcb6e5e2d27.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="e92666ae590962682cf23fcae2c3bdcb6e5e2d27.diff"

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

--------------1.5.1.2--


