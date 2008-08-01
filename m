Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYHALST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYHALST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 07:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYHALSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 07:18:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63510 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbYHALSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 07:18:05 -0400
Message-ID: <4892F063.1080109@cn.fujitsu.com>
Date: Fri, 01 Aug 2008 19:15:47 +0800
From: zhangxiliang <zhangxiliang@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
       viro@zeniv.linux.org.uk, Linux Audit <linux-audit@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix the kernel panic of audit_filter_task when key field
 is set
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling audit_filter_task(), it calls audit_filter_rules() with audit_context is NULL.
If the key field is set, the result in audit_filter_rules() will be set to 1 and 
ctx->filterkey will be set to key.
But the ctx is NULL in this condition, so kernel will panic.

Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
---
 kernel/auditsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 4699950..012c94e 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -610,7 +610,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 		if (!result)
 			return 0;
 	}
-	if (rule->filterkey)
+	if (rule->filterkey && ctx)
 		ctx->filterkey = kstrdup(rule->filterkey, GFP_ATOMIC);
 	switch (rule->action) {
 	case AUDIT_NEVER:    *state = AUDIT_DISABLED;	    break;

