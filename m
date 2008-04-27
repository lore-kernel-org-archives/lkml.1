Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYD0KO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYD0KO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 06:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYD0KOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 06:14:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:17146 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbYD0KOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 06:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mlJ7K8enxjB7XGfk37W1xPehCOwpIHS3EYS9+VM/pvdQoIMaWqjYmUS+3UdRgtNeRKFGUSouxD90o5z/KO3jRUz7GabOGW0abjN/+d1UM4ZAcppyQOWQKQrkjLxfvB1SWPfQ/FdGkDaoWM4l97b4sFxMfA2ihOVmCjN3M66hq18=
Subject: Re: [PATCH 2/2] audit: fix sparse shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209289196.14173.54.camel@brick>
References: <1209289196.14173.54.camel@brick>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 03:14:25 -0700
Message-Id: <1209291265.14173.57.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msglen as the identifier.
kernel/audit.c:724:10: warning: symbol 'len' shadows an earlier one
kernel/audit.c:575:8: originally declared here

Eliminate the temporary var f and test entry->rule.inode_f directly at
the end of the functions.
kernel/auditfilter.c:429:22: warning: symbol 'f' shadows an earlier one
kernel/auditfilter.c:420:21: originally declared here
kernel/auditfilter.c:542:22: warning: symbol 'f' shadows an earlier one
kernel/auditfilter.c:529:21: originally declared here

i always used as a counter for a for loop and initialized to zero before
use.  Eliminate the inner i variables.
kernel/auditsc.c:1295:8: warning: symbol 'i' shadows an earlier one
kernel/auditsc.c:1152:6: originally declared here
kernel/auditsc.c:1320:7: warning: symbol 'i' shadows an earlier one
kernel/auditsc.c:1152:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Sorry, sent out the wrong mbox, this is the correct 2/2. (differs only
in kernel/auditfilter.c...for obvious reasons.

 kernel/audit.c       |   10 +++++-----
 kernel/auditfilter.c |   12 ++++--------
 kernel/auditsc.c     |    2 --
 3 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index a7b1608..679dabe 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -721,21 +721,21 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	case AUDIT_MAKE_EQUIV: {
 		void *bufp = data;
 		u32 sizes[2];
-		size_t len = nlmsg_len(nlh);
+		size_t msglen = nlmsg_len(nlh);
 		char *old, *new;
 
 		err = -EINVAL;
-		if (len < 2 * sizeof(u32))
+		if (msglen < 2 * sizeof(u32))
 			break;
 		memcpy(sizes, bufp, 2 * sizeof(u32));
 		bufp += 2 * sizeof(u32);
-		len -= 2 * sizeof(u32);
-		old = audit_unpack_string(&bufp, &len, sizes[0]);
+		msglen -= 2 * sizeof(u32);
+		old = audit_unpack_string(&bufp, &msglen, sizes[0]);
 		if (IS_ERR(old)) {
 			err = PTR_ERR(old);
 			break;
 		}
-		new = audit_unpack_string(&bufp, &len, sizes[1]);
+		new = audit_unpack_string(&bufp, &msglen, sizes[1]);
 		if (IS_ERR(new)) {
 			err = PTR_ERR(new);
 			kfree(old);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 2988919..44d1dbe 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -417,7 +417,6 @@ exit_err:
 static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 {
 	struct audit_entry *entry;
-	struct audit_field *f;
 	int err = 0;
 	int i;
 
@@ -499,9 +498,8 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 		}
 	}
 
-	f = entry->rule.inode_f;
-	if (f) {
-		switch(f->op) {
+	if (entry->rule.inode_f) {
+		switch(entry->rule.inode_f->op) {
 		case AUDIT_NOT_EQUAL:
 			entry->rule.inode_f = NULL;
 		case AUDIT_EQUAL:
@@ -526,7 +524,6 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 {
 	int err = 0;
 	struct audit_entry *entry;
-	struct audit_field *f;
 	void *bufp;
 	size_t remain = datasz - sizeof(struct audit_rule_data);
 	int i;
@@ -654,9 +651,8 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		}
 	}
 
-	f = entry->rule.inode_f;
-	if (f) {
-		switch(f->op) {
+	if (entry->rule.inode_f) {
+		switch(entry->rule.inode_f->op) {
 		case AUDIT_NOT_EQUAL:
 			entry->rule.inode_f = NULL;
 		case AUDIT_EQUAL:
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 478ea60..60737b7 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1293,7 +1293,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			break; }
 
 		case AUDIT_SOCKETCALL: {
-			int i;
 			struct audit_aux_data_socketcall *axs = (void *)aux;
 			audit_log_format(ab, "nargs=%d", axs->nargs);
 			for (i=0; i<axs->nargs; i++)
@@ -1318,7 +1317,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 
 	for (aux = context->aux_pids; aux; aux = aux->next) {
 		struct audit_aux_data_pids *axs = (void *)aux;
-		int i;
 
 		for (i = 0; i < axs->pid_count; i++)
 			if (audit_log_pid_context(context, axs->target_pid[i],
-- 
1.5.5.1.270.g89765



