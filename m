Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbXGIQem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbXGIQem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758325AbXGIQYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758252AbXGIQYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:12 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Robert Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Can't mount GFS2 file system on AoE device
Date: Mon,  9 Jul 2007 17:02:40 +0100
Message-Id: <11839970573954-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1183997056121-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
 <11839970542719-git-send-email-swhiteho@redhat.com>
 <1183997056121-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Peterson <rpeterso@redhat.com>

This patch fixes bug 243131: Can't mount GFS2 file system on AoE device.
When using AoE devices with lock_nolock, there is no locking table, so
gfs2 (and gfs1) uses the superblock s_id.  This turns out to be the device
name in some cases.  In the case of AoE, the device contains a slash,
(e.g. "etherd/e1.1p2") which is an invalid character when we try to
register the table in sysfs.  This patch replaces the "/" with underscore.
Rather than add a new variable to the stack, I'm just reusing a (char *)
variable that's no longer used: table.

This code has been tested on the failing system using a RHEL5 patch.
The upstream code was tested by using gfs2_tool sb to interject a "/"
into the table name of a clustered gfs2 file system.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index b467272..dae1d71 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -145,6 +145,9 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
 	snprintf(sdp->sd_proto_name, GFS2_FSNAME_LEN, "%s", proto);
 	snprintf(sdp->sd_table_name, GFS2_FSNAME_LEN, "%s", table);
 
+	while ((table = strchr(sdp->sd_table_name, '/')))
+		*table = '_';
+
 out:
 	return error;
 }
-- 
1.5.1.2

