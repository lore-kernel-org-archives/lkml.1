Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYLSETg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYLSETg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 23:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYLSETF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 23:19:05 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:41143 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYLSETE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 23:19:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rze7lgPrV73vNlzh7tsPvbAGgOxvuDgSEmr7wi+V36otvSjoptXRbpJCM1YujvlJM0
         8h+DIyYF+2gSsQOzGWa56d1iO29QIPUndYiNZ4S8mCh+vCPQ1Lw67bOydpQxGs0FPTNg
         2U2E3un4Yq4ckGK4KDc6mu+TLMJJhvcsAUrwo=
From: crquan@gmail.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] dm-target: use the module's refcount instead
Date: Fri, 19 Dec 2008 12:19:43 +0800
Message-Id: <1229660385-17153-2-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229660385-17153-1-git-send-email-crquan@gmail.com>
References: <1229660385-17153-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

The tt_internal's use field is superfluous, the module's refcount has done
the work properly.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 drivers/md/dm-target.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 835cf95..018df35 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -18,7 +18,6 @@ struct tt_internal {
 	struct target_type tt;
 
 	struct list_head list;
-	long use;
 };
 
 static LIST_HEAD(_targets);
@@ -44,12 +43,8 @@ static struct tt_internal *get_target_type(const char *name)
 	down_read(&_lock);
 
 	ti = __find_target_type(name);
-	if (ti) {
-		if ((ti->use == 0) && !try_module_get(ti->tt.module))
-			ti = NULL;
-		else
-			ti->use++;
-	}
+	if (ti && !try_module_get(ti->tt.module))
+		ti = NULL;
 
 	up_read(&_lock);
 	return ti;
@@ -77,10 +72,7 @@ void dm_put_target_type(struct target_type *t)
 	struct tt_internal *ti = (struct tt_internal *) t;
 
 	down_read(&_lock);
-	if (--ti->use == 0)
-		module_put(ti->tt.module);
-
-	BUG_ON(ti->use < 0);
+	module_put(ti->tt.module);
 	up_read(&_lock);
 
 	return;
@@ -140,7 +132,7 @@ int dm_unregister_target(struct target_type *t)
 		return -EINVAL;
 	}
 
-	if (ti->use) {
+	if (ti->tt.module && module_refcount(ti->tt.module)) {
 		up_write(&_lock);
 		return -ETXTBSY;
 	}
-- 
1.6.0.2.GIT

