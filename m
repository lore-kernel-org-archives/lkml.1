Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbYAXRBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbYAXRBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbYAXQ6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202AbYAXQ6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:38 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Patrick Caulfeld <pcaulfie@redhat.com>
Subject: [PATCH 05/19] dlm: close othercons
Date: Thu, 24 Jan 2008 10:50:28 -0600
Message-Id: <1201193442-8260-6-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Caulfeld <pcaulfie@redhat.com>

This patch addresses a problem introduced with the last round of
lowcomms patches where the 'othercon' connections do not get freed when
the DLM shuts down.

This results in the error message
"slab error in kmem_cache_destroy(): cache `dlm_conn': Can't free all
objects"

and the DLM cannot be restarted without a system reboot.

See bz#428119

Signed-off-by: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Fabio M. Di Nitto <fabbione@ubuntu.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 5772844..7c1e5e5 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1437,6 +1437,8 @@ void dlm_lowcomms_stop(void)
 		con = __nodeid2con(i, 0);
 		if (con) {
 			close_connection(con, true);
+			if (con->othercon)
+				kmem_cache_free(con_cache, con->othercon);
 			kmem_cache_free(con_cache, con);
 		}
 	}
-- 
1.5.3.3

