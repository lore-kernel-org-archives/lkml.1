Return-Path: <linux-kernel-owner+w=401wt.eu-S1762173AbXJDJgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173AbXJDJgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759740AbXJDJSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759698AbXJDJSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:44 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Patrick Caulfield <pcaulfie@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 50/51] [DLM] don't overwrite castparam if it's NULL
Date: Thu,  4 Oct 2007 09:49:43 +0100
Message-Id: <1191487880270-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878792099-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
 <11914878383633-git-send-email-swhiteho@redhat.com>
 <11914878401428-git-send-email-swhiteho@redhat.com>
 <11914878422398-git-send-email-swhiteho@redhat.com>
 <1191487844772-git-send-email-swhiteho@redhat.com>
 <1191487846406-git-send-email-swhiteho@redhat.com>
 <11914878472056-git-send-email-swhiteho@redhat.com>
 <11914878492645-git-send-email-swhiteho@redhat.com>
 <11914878513555-git-send-email-swhiteho@redhat.com>
 <11914878521254-git-send-email-swhiteho@redhat.com>
 <119148785427-git-send-email-swhiteho@redhat.com>
 <11914878551328-git-send-email-swhiteho@redhat.com>
 <11914878571888-git-send-email-swhiteho@redhat.com>
 <11914878592314-git-send-email-swhiteho@redhat.com>
 <1191487861683-git-send-email-swhiteho@redhat.com>
 <11914878632211-git-send-email-swhiteho@redhat.com>
 <1191487864951-git-send-email-swhiteho@redhat.com>
 <11914878661743-git-send-email-swhiteho@redhat.com>
 <11914878683674-git-send-email-swhiteho@redhat.com>
 <1191487870444-git-send-email-swhiteho@redhat.com>
 <1191487872941-git-send-email-swhiteho@redhat.com>
 <119148787317-git-send-email-swhiteho@redhat.com>
 <11914878753861-git-send-email-swhiteho@redhat.com>
 <1191487877383-git-send-email-swhiteho@redhat.com>
 <11914878792099-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Caulfield <pcaulfie@redhat.com>

If the castaddr passed to the userland API is NULL then don't overwrite the
existing castparam. This allows a different thread to cancel a lock request and
the CANCEL AST gets delivered to the original thread.

bz#306391 (for RHEL4) refers.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 2082daf..031229f 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4429,7 +4429,8 @@ int dlm_user_unlock(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 
 	if (lvb_in && ua->lksb.sb_lvbptr)
 		memcpy(ua->lksb.sb_lvbptr, lvb_in, DLM_USER_LVB_LEN);
-	ua->castparam = ua_tmp->castparam;
+	if (ua_tmp->castparam)
+		ua->castparam = ua_tmp->castparam;
 	ua->user_lksb = ua_tmp->user_lksb;
 
 	error = set_unlock_args(flags, ua, &args);
@@ -4474,7 +4475,8 @@ int dlm_user_cancel(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 		goto out;
 
 	ua = (struct dlm_user_args *)lkb->lkb_astparam;
-	ua->castparam = ua_tmp->castparam;
+	if (ua_tmp->castparam)
+		ua->castparam = ua_tmp->castparam;
 	ua->user_lksb = ua_tmp->user_lksb;
 
 	error = set_unlock_args(flags, ua, &args);
-- 
1.5.1.2

