Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbZFKP3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbZFKP3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbZFKP3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:29:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55889 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbZFKP3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:29:19 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] dlm: fix use count with multiple joins
Date: Thu, 11 Jun 2009 10:20:47 -0500
Message-Id: <1244733649-26003-3-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a lockspace was joined multiple times, the global dlm
use count was incremented when it should not have been.  This
caused the global dlm threads to not be stopped when all
lockspaces were eventually be removed.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lockspace.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 82528d9..d489fcc 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -419,16 +419,14 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 			break;
 		}
 		ls->ls_create_count++;
-		module_put(THIS_MODULE);
-		error = 1; /* not an error, return 0 */
+		*lockspace = ls;
+		error = 1;
 		break;
 	}
 	spin_unlock(&lslist_lock);
 
-	if (error < 0)
-		goto out;
 	if (error)
-		goto ret_zero;
+		goto out;
 
 	error = -ENOMEM;
 
@@ -583,7 +581,6 @@ static int new_lockspace(const char *name, int namelen, void **lockspace,
 	dlm_create_debug_file(ls);
 
 	log_debug(ls, "join complete");
- ret_zero:
 	*lockspace = ls;
 	return 0;
 
@@ -628,7 +625,9 @@ int dlm_new_lockspace(const char *name, int namelen, void **lockspace,
 	error = new_lockspace(name, namelen, lockspace, flags, lvblen);
 	if (!error)
 		ls_count++;
-	else if (!ls_count)
+	if (error > 0)
+		error = 0;
+	if (!ls_count)
 		threads_stop();
  out:
 	mutex_unlock(&ls_lock);
-- 
1.5.5.6

