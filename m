Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYGaCNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYGaCNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYGaCNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:13:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65036 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbYGaCNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:13:32 -0400
Message-ID: <48911F47.50606@cn.fujitsu.com>
Date: Thu, 31 Jul 2008 10:11:19 +0800
From: zhangxiliang <zhangxiliang@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: sgrubb@redhat.com, viro@zeniv.linux.org.uk, eparis@redhat.com,
       Linux Audit <linux-audit@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix the bug of using AUDIT_STATUS_RATE_LIMIT when set fail,
 no error output.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the "status_get->mask" is "AUDIT_STATUS_RATE_LIMIT || AUDIT_STATUS_BACKLOG_LIMIT".
If "audit_set_rate_limit" fails and "audit_set_backlog_limit" succeeds, the "err" value will be greater than or equal to 0. It will miss the failure of rate set. 

Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
---
 kernel/audit.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index e092f1c..38a4080 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -725,9 +725,11 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			audit_pid = new_pid;
 			audit_nlk_pid = NETLINK_CB(skb).pid;
 		}
-		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT)
+		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT) {
 			err = audit_set_rate_limit(status_get->rate_limit,
 						   loginuid, sessionid, sid);
+			if (err < 0) return err;
+		}
 		if (status_get->mask & AUDIT_STATUS_BACKLOG_LIMIT)
 			err = audit_set_backlog_limit(status_get->backlog_limit,
 						      loginuid, sessionid, sid);
-- 
1.5.4.2


-- 
Regards
Zhang Xiliang

