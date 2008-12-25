Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYLYSOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYLYSOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYLYSFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:05:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:60698 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbYLYSFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:05:40 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Sunil Mushran <sunil.mushran@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 27/35] ocfs2/dlm: Hold off sending lockres drop ref message while lockres is migrating
Date: Thu, 25 Dec 2008 10:04:42 -0800
Message-Id: <1230228290-22803-28-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
References: <1230228290-22803-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sunil Mushran <sunil.mushran@oracle.com>

During lockres purge, o2dlm sends a drop reference message to the lockres
master. This patch delays the message if the lockres is being migrated.

Fixes oss bugzilla#1012
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1012

Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/dlm/dlmthread.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index 4060bb3..d129520 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -181,7 +181,8 @@ static int dlm_purge_lockres(struct dlm_ctxt *dlm,
 
 		spin_lock(&res->spinlock);
 		/* This ensures that clear refmap is sent after the set */
-		__dlm_wait_on_lockres_flags(res, DLM_LOCK_RES_SETREF_INPROG);
+		__dlm_wait_on_lockres_flags(res, (DLM_LOCK_RES_SETREF_INPROG |
+						  DLM_LOCK_RES_MIGRATING));
 		spin_unlock(&res->spinlock);
 
 		/* clear our bit from the master's refmap, ignore errors */
-- 
1.5.6

