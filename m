Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYI0C3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYI0C3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 22:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYI0C2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 22:28:17 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:54607 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbYI0C2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 22:28:09 -0400
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH 5/6] file capabilities: remove needless inline functions
Date: Fri, 26 Sep 2008 22:27:49 -0400
Message-Id: <06b2774a667bc535442305193417ff1a479ef1aa.1222451103.git.serue@us.ibm.com>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <c9c64bbdfd3f1c665f0d1b08b82f77622be701cc.1222451103.git.serue@us.ibm.com>
References: <1222482472-12847-1-git-send-email-serue@us.ibm.com>
 <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com>
 <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com>
 <178a4b5984b7559cb5cdb93b242484386ec3e3ab.1222451103.git.serue@us.ibm.com>
 <c9c64bbdfd3f1c665f0d1b08b82f77622be701cc.1222451103.git.serue@us.ibm.com>
In-Reply-To: <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com>
References: <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cap_limit_ptraced_target always returns 1, so nix it.

cap_block_setpcap can't return 1 any more, because
kernel/capabilities.c:sys_capset() will return -EPERM
if it is called on a task other than current, and will
never get to cap_capset_check.

This brings the vmlinux size with my config down another
16 bytes (making up for the 8 byte increase from the
last patch).

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/commoncap.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index d48fdd8..e5afb7c 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -93,15 +93,6 @@ int cap_capget (struct task_struct *target, kernel_cap_t *effective,
 	return 0;
 }
 
-static inline int cap_block_setpcap(struct task_struct *target)
-{
-	/*
-	 * No support for remote process capability manipulation with
-	 * filesystem capability support.
-	 */
-	return (target != current);
-}
-
 static inline int cap_inh_is_capped(void)
 {
 	/*
@@ -112,14 +103,9 @@ static inline int cap_inh_is_capped(void)
 	return (cap_capable(current, CAP_SETPCAP) != 0);
 }
 
-static inline int cap_limit_ptraced_target(void) { return 1; }
-
 int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
 		      kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
-	if (cap_block_setpcap(target)) {
-		return -EPERM;
-	}
 	if (cap_inh_is_capped()
 	    && !cap_issubset(*inheritable,
 			     cap_combine(target->cap_inheritable,
@@ -343,11 +329,9 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
 				bprm->e_uid = current->uid;
 				bprm->e_gid = current->gid;
 			}
-			if (cap_limit_ptraced_target()) {
-				bprm->cap_post_exec_permitted = cap_intersect(
-					bprm->cap_post_exec_permitted,
-					current->cap_permitted);
-			}
+			bprm->cap_post_exec_permitted = cap_intersect(
+				bprm->cap_post_exec_permitted,
+				current->cap_permitted);
 		}
 	}
 
-- 
1.5.1.1.GIT

