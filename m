Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbXBEOVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbXBEOVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932834AbXBEOVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:21:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932830AbXBEOVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:21:49 -0500
Subject: [DLM] fix master recovery [25/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:29:52 +0000
Message-Id: <1170685793.11001.321.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5581bdbb3858c4df26b88f2afa641b23833cbed1 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Mon, 15 Jan 2007 10:28:22 -0600
Subject: [PATCH] [DLM] fix master recovery

If master recovery happens on an rsb in one recovery sequence, then that
sequence is aborted before lock recovery happens, then in the next
sequence, we rely on the previous master recovery (which may now be
invalid due to another node ignoring a lookup result) and go on do to the
lock recovery where we get stuck due to an invalid master value.

 recovery cycle begins: master of rsb X has left
 nodes A and B send node C an rcom lookup for X to find the new master
 C gets lookup from B first, sets B as new master, and sends reply back to B
 C gets lookup from A next, and sends reply back to A saying B is master
 A gets lookup reply from C and sets B as the new master in the rsb
 recovery cycle on A, B and C is aborted to start a new recovery
 B gets lookup reply from C and ignores it since there's a new recovery
 recovery cycle begins: some other node has joined
 B doesn't think it's the master of X so it doesn't rebuild it in the directory
 C looks up the master of X, no one is master, so it becomes new master
 B looks up the master of X, finds it's C
 A believes that B is the master of X, so it sends its lock to B
 B sends an error back to A
 A resends
 this repeats forever, the incorrect master value on A is never corrected

The fix is to do master recovery on an rsb that still has the NEW_MASTER
flag set from an earlier recovery sequence, and therefore didn't complete
lock recovery.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index a7fa4cb..c2cc769 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -397,7 +397,9 @@ int dlm_recover_masters(struct dlm_ls *ls)
 
 		if (dlm_no_directory(ls))
 			count += recover_master_static(r);
-		else if (!is_master(r) && dlm_is_removed(ls, r->res_nodeid)) {
+		else if (!is_master(r) &&
+			 (dlm_is_removed(ls, r->res_nodeid) ||
+			  rsb_flag(r, RSB_NEW_MASTER))) {
 			recover_master(r);
 			count++;
 		}
-- 
1.4.4.2



