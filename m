Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbZKIPKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbZKIPKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZKIPKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:10:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZKIPKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:10:46 -0500
From: =?utf-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       =?utf-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH] audit: Match SELinux context in "user" records
Date: Mon,  9 Nov 2009 16:10:46 +0100
Message-Id: <1257779446-1395-1-git-send-email-mitr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miloslav Trmac <mitr@redhat.com>

Add support for matching by security label (e.g. SELinux context) of
the sender of an user-space audit record.

The audit filter code already allows user space to configure such
filters, but they were ignored during evaluation.  This patch implements
evaluation of these filters.

For example, after application of this patch, PAM authentication logs
caused by cron can be disabled using
	auditctl -a user,never -F subj_type=crond_t

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
---
 kernel/auditfilter.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index a706040..50307c1 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1259,6 +1259,18 @@ static int audit_filter_user_rules(struct netlink_skb_parms *cb,
 		case AUDIT_LOGINUID:
 			result = audit_comparator(cb->loginuid, f->op, f->val);
 			break;
+		case AUDIT_SUBJ_USER:
+		case AUDIT_SUBJ_ROLE:
+		case AUDIT_SUBJ_TYPE:
+		case AUDIT_SUBJ_SEN:
+		case AUDIT_SUBJ_CLR:
+			if (f->lsm_rule)
+				result = security_audit_rule_match(cb->sid,
+								   f->type,
+								   f->op,
+								   f->lsm_rule,
+								   NULL);
+			break;
 		}
 
 		if (!result)
-- 
1.6.2.5

