Return-Path: <linux-kernel-owner+w=401wt.eu-S932589AbYA2NoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbYA2NoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933329AbYA2Nnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:43:32 -0500
Received: from sacred.ru ([62.205.161.221]:35687 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933330AbYA2Nn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:43:29 -0500
Message-ID: <479F2D7D.70304@openvz.org>
Date: Tue, 29 Jan 2008 16:43:25 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 2/12] Use find_task_by_vpid in autid code
References: <479F2C5C.1050303@openvz.org>
In-Reply-To: <479F2C5C.1050303@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 29 Jan 2008 16:43:05 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pid to lookup a task by is passed inside audit code
via netlink message.

Thanks to Denis Lunev, netlink packets are now (since 2.6.24) 
_always_ processed in the context of the sending task. So this
is correct to lookup the task with find_task_by_vpid() here.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/audit.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index ae58d87..ebb9d60 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -378,7 +378,7 @@ static int audit_prepare_user_tty(pid_t pid, uid_t loginuid)
 	int err;
 
 	read_lock(&tasklist_lock);
-	tsk = find_task_by_pid(pid);
+	tsk = find_task_by_vpid(pid);
 	err = -ESRCH;
 	if (!tsk)
 		goto out;
@@ -764,7 +764,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		struct task_struct *tsk;
 
 		read_lock(&tasklist_lock);
-		tsk = find_task_by_pid(pid);
+		tsk = find_task_by_vpid(pid);
 		if (!tsk)
 			err = -ESRCH;
 		else {
@@ -787,7 +787,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (s->enabled != 0 && s->enabled != 1)
 			return -EINVAL;
 		read_lock(&tasklist_lock);
-		tsk = find_task_by_pid(pid);
+		tsk = find_task_by_vpid(pid);
 		if (!tsk)
 			err = -ESRCH;
 		else {
-- 
1.5.3.4

