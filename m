Return-Path: <linux-kernel-owner+w=401wt.eu-S1758371AbXHNKMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371AbXHNKMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbXHNKKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:10:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbXHNKKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:44 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Jesper Juhl <jesper.juhl@gmail.com>, David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] Fix memory leak in dlm_add_member() when dlm_node_weight() returns less than zero
Date: Tue, 14 Aug 2007 10:47:08 +0100
Message-Id: <11870848472401-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11870848365-git-send-email-swhiteho@redhat.com>
References: <11870848365-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

There's a memory leak in fs/dlm/member.c::dlm_add_member().

If "dlm_node_weight(ls->ls_name, nodeid)" returns < 0, then
we'll return without freeing the memory allocated to the (at
that point yet unused) 'memb'.
This patch frees the allocated memory in that case and thus
avoids the leak.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index 073599d..d099775 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -56,8 +56,10 @@ static int dlm_add_member(struct dlm_ls *ls, int nodeid)
 		return -ENOMEM;
 
 	w = dlm_node_weight(ls->ls_name, nodeid);
-	if (w < 0)
+	if (w < 0) {
+		kfree(memb);
 		return w;
+	}
 
 	memb->nodeid = nodeid;
 	memb->weight = w;
-- 
1.5.1.2

