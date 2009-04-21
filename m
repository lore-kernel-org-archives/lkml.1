Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZDUJPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZDUJPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZDUJOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:14:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59580 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbZDUJOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:14:30 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/2] GFS2: Fix page_mkwrite() return code
Date: Tue, 21 Apr 2009 09:09:29 +0100
Message-Id: <1240301369-12585-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1240301369-12585-2-git-send-email-swhiteho@redhat.com>
References: <1240301369-12585-1-git-send-email-swhiteho@redhat.com>
 <1240301369-12585-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows for the possibility of returning VM_FAULT_OOM as
well as VM_FAULT_SIGBUS. This ensures that the correct action
is taken.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 101caf3..5d82e91 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -413,7 +413,9 @@ out_unlock:
 	gfs2_glock_dq(&gh);
 out:
 	gfs2_holder_uninit(&gh);
-	if (ret)
+	if (ret == -ENOMEM)
+		ret = VM_FAULT_OOM;
+	else if (ret)
 		ret = VM_FAULT_SIGBUS;
 	return ret;
 }
-- 
1.6.0.6

