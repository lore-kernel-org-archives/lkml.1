Return-Path: <linux-kernel-owner+w=401wt.eu-S932232AbXFRPNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbXFRPNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932218AbXFRPMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:12:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209AbXFRPMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:12:36 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Josef Bacik <jwhiter@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/4] [DLM] keep dlm from panicing when traversing rsb list in debugfs
Date: Mon, 18 Jun 2007 15:54:30 +0100
Message-Id: <11821784842672-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1182178482182-git-send-email-swhiteho@redhat.com>
References: y
 <11821784703600-git-send-email-swhiteho@redhat.com>
 <1182178478593-git-send-email-swhiteho@redhat.com>
 <11821784801162-git-send-email-swhiteho@redhat.com>
 <1182178482182-git-send-email-swhiteho@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.1.2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Bacik <jwhiter@redhat.com>

This is a multi-part message in MIME format.
--------------1.5.1.2
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


This problem was originally reported against GFS6.1, but the same issue exists
in upstream DLM.  This patch keeps the rsb iterator assigning under the rsbtbl
list lock.  Each time we process an rsb we grab a reference to it to make sure
it is not freed out from underneath us, and then put it when we get the next rsb
in the list or move onto another list.

Signed-off-by: Josef Bacik <jwhiter@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/dlm/debug_fs.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)
--------------1.5.1.2
Content-Type: text/x-patch; name="b366510ec8e4fcf5a918a0c9fc1ba967d543838b.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="b366510ec8e4fcf5a918a0c9fc1ba967d543838b.diff"

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

--------------1.5.1.2--


