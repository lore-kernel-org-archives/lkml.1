Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588Ab0AEUJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0AEUJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536Ab0AEUI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:08:59 -0500
Received: from kroah.org ([198.145.64.141]:50051 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab0AEUGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:24 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:02 2010
Message-Id: <20100105200302.877059856@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Jan Rekorajski <baggins@sith.mimuw.edu.pl>, Alex Elder <aelder@sgi.com>,
       Simon Kirby <sim@hostway.ca>
Subject: [30/39] XFS bug in log recover with quota (bugzilla id 855)
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Rekorajski <baggins@sith.mimuw.edu.pl>

commit 8ec6dba2581754e375be66f7bedd708d856d8b30 upstream.

Hi,
I was hit by a bug in linux 2.6.31 when XFS is not able to recover the
log after a crash if fs was mounted with quotas. Gory details in XFS
bugzilla: http://oss.sgi.com/bugzilla/show_bug.cgi?id=855.

It looks like wrong struct is used in buffer length check, and the following
patch should fix the problem.

xfs_dqblk_t has a size of 104+32 bytes, while xfs_disk_dquot_t is 104 bytes
long, and this is exactly what I see in system logs - "XFS: dquot too small
(104) in xlog_recover_do_dquot_trans."

Signed-off-by: Jan Rekorajski <baggins@sith.mimuw.edu.pl>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Cc: Simon Kirby <sim@hostway.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_log_recover.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1980,7 +1980,7 @@ xlog_recover_do_reg_buffer(
 					"XFS: NULL dquot in %s.", __func__);
 				goto next;
 			}
-			if (item->ri_buf[i].i_len < sizeof(xfs_dqblk_t)) {
+			if (item->ri_buf[i].i_len < sizeof(xfs_disk_dquot_t)) {
 				cmn_err(CE_ALERT,
 					"XFS: dquot too small (%d) in %s.",
 					item->ri_buf[i].i_len, __func__);
@@ -2635,7 +2635,7 @@ xlog_recover_do_dquot_trans(
 			"XFS: NULL dquot in %s.", __func__);
 		return XFS_ERROR(EIO);
 	}
-	if (item->ri_buf[1].i_len < sizeof(xfs_dqblk_t)) {
+	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
 		cmn_err(CE_ALERT,
 			"XFS: dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);


