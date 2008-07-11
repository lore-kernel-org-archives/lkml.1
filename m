Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbYGKHoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbYGKHoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 03:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbYGKHoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 03:44:09 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:44329 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754378AbYGKHoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 03:44:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAASqdkh5LFxA/2dsb2JhbACwAw
X-IronPort-AV: E=Sophos;i="4.30,343,1212330600"; 
   d="scan'208";a="146629875"
Date: Fri, 11 Jul 2008 17:43:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: [XFS REGRESSION, PATCH] Fix reference counting race on log buffers
Message-ID: <20080711074355.GT29319@disturbed>
Mail-Followup-To: torvalds@linux-foundation.org, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When we release the iclog, we do an atomic_dec_and_lock to determine
if we are the last reference and need to trigger update of log
headers and writeout. However, in xlog_state_get_iclog_space() we
also need to check if we have the last reference count there.  If we
do, we release the log buffer, otherwise we decrement the reference
count.

The issue is that the compare and decrement in
xlog_state_get_iclog_space() is not atomic, so both places can see a
reference count of 2 and neither will release the iclog. That leads
to a filesystem hang.

Close the race by replacing the atomic_read() and atomic_dec() pair with
atomic_add_unless() to ensure that they are executed atomically.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Tim Shimmin <tes@sgi.com>
Tested-by: Eric Sandeen <sandeen@sandeen.net>
---
 fs/xfs/xfs_log.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 760d543..0816c5d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2425,13 +2425,20 @@ restart:
 	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
 		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
 
-		/* If I'm the only one writing to this iclog, sync it to disk */
-		if (atomic_read(&iclog->ic_refcnt) == 1) {
+		/*
+		 * If I'm the only one writing to this iclog, sync it to disk.
+		 * We need to do an atomic compare and decrement here to avoid
+		 * racing with concurrent atomic_dec_and_lock() calls in
+		 * xlog_state_release_iclog() when there is more than one
+		 * reference to the iclog.
+		 */
+		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
+			/* we are the only one */
 			spin_unlock(&log->l_icloglock);
-			if ((error = xlog_state_release_iclog(log, iclog)))
+			error = xlog_state_release_iclog(log, iclog);
+			if (error)
 				return error;
 		} else {
-			atomic_dec(&iclog->ic_refcnt);
 			spin_unlock(&log->l_icloglock);
 		}
 		goto restart;
