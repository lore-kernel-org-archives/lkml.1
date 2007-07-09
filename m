Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbXGIQ0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbXGIQ0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbXGIQXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757438AbXGIQX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:29 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Josef Bacik <jwhiter@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] keep dlm from panicing when traversing rsb list in debugfs
Date: Mon,  9 Jul 2007 17:02:16 +0100
Message-Id: <11839970101065-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1183997008395-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Bacik <jwhiter@redhat.com>

This problem was originally reported against GFS6.1, but the same issue exists
in upstream DLM.  This patch keeps the rsb iterator assigning under the rsbtbl
list lock.  Each time we process an rsb we grab a reference to it to make sure
it is not freed out from underneath us, and then put it when we get the next rsb
in the list or move onto another list.

Signed-off-by: Josef Bacik <jwhiter@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 61ba670..9e27a16 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -17,6 +17,7 @@
 #include <linux/debugfs.h>
 
 #include "dlm_internal.h"
+#include "lock.h"
 
 #define DLM_DEBUG_BUF_LEN 4096
 static char debug_buf[DLM_DEBUG_BUF_LEN];
@@ -166,6 +167,9 @@ static int rsb_iter_next(struct rsb_iter *ri)
 			read_lock(&ls->ls_rsbtbl[i].lock);
 			if (!list_empty(&ls->ls_rsbtbl[i].list)) {
 				ri->next = ls->ls_rsbtbl[i].list.next;
+				ri->rsb = list_entry(ri->next, struct dlm_rsb,
+							res_hashchain);
+				dlm_hold_rsb(ri->rsb);
 				read_unlock(&ls->ls_rsbtbl[i].lock);
 				break;
 			}
@@ -176,6 +180,7 @@ static int rsb_iter_next(struct rsb_iter *ri)
 		if (ri->entry >= ls->ls_rsbtbl_size)
 			return 1;
 	} else {
+		struct dlm_rsb *old = ri->rsb;
 		i = ri->entry;
 		read_lock(&ls->ls_rsbtbl[i].lock);
 		ri->next = ri->next->next;
@@ -184,11 +189,13 @@ static int rsb_iter_next(struct rsb_iter *ri)
 			ri->next = NULL;
 			ri->entry++;
 			read_unlock(&ls->ls_rsbtbl[i].lock);
+			dlm_put_rsb(old);
 			goto top;
                 }
+		ri->rsb = list_entry(ri->next, struct dlm_rsb, res_hashchain);
 		read_unlock(&ls->ls_rsbtbl[i].lock);
+		dlm_put_rsb(old);
 	}
-	ri->rsb = list_entry(ri->next, struct dlm_rsb, res_hashchain);
 
 	return 0;
 }
-- 
1.5.1.2

