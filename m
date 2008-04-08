Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYDHL0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYDHL0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYDHLTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:49 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:7184 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbYDHLTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:48 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 9/29] sysvipc: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:16 +0400
Message-Id: <1207653576-12640-9-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create_data() to make sure that ->proc_fops and ->data be setup
before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 ipc/util.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 4c465cb..3339177 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -165,13 +165,12 @@ void __init ipc_init_proc_interface(const char *path, const char *header,
 	iface->ids	= ids;
 	iface->show	= show;
 
-	pde = create_proc_entry(path,
-				S_IRUGO,        /* world readable */
-				NULL            /* parent dir */);
-	if (pde) {
-		pde->data = iface;
-		pde->proc_fops = &sysvipc_proc_fops;
-	} else {
+	pde = proc_create_data(path,
+			       S_IRUGO,        /* world readable */
+			       NULL,           /* parent dir */
+			       &sysvipc_proc_fops,
+			       iface);
+	if (!pde) {
 		kfree(iface);
 	}
 }
-- 
1.5.3.rc5

