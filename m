Return-Path: <linux-kernel-owner+w=401wt.eu-S1761530AbYAQWq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761530AbYAQWq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759962AbYAQWhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:37:09 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:10997 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760144AbYAQWgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:53 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>
Subject: [PATCH 01/30] ocfs2_dlm: Call node eviction callbacks from heartbeat handler
Date: Thu, 17 Jan 2008 14:35:27 -0800
Message-Id: <1200609356-17788-2-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this, a dlm client can take advantage of the group protocol in the dlm
to get full notification whenever a node within the dlm domain leaves
unexpectedly.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlm/dlmrecovery.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
index 2fde7bf..b10f3e3 100644
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -2321,6 +2321,13 @@ void dlm_hb_node_down_cb(struct o2nm_node *node, int idx, void *data)
 	if (!dlm_grab(dlm))
 		return;
 
+	/*
+	 * This will notify any dlm users that a node in our domain
+	 * went away without notifying us first.
+	 */
+	if (test_bit(idx, dlm->domain_map))
+		dlm_fire_domain_eviction_callbacks(dlm, idx);
+
 	spin_lock(&dlm->spinlock);
 	__dlm_hb_node_down(dlm, idx);
 	spin_unlock(&dlm->spinlock);
-- 
1.5.3.6

