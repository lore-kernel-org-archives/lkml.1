Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbYDCAfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbYDCAfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbYDCAeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:34:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:9328 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760130AbYDCAeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=T4EUzYTfgod2rNCCM/73LxZloMZVolVGF6rHJlWezSlY1dJa1gUSgL1NueJFf95uWOetIq5WGO9Z95wft4/KoA/A4Jup4r9xMY0RzxjVyI5J2TvZuqv7QqJf1UxyV/npyORxBahbt7izfkf72PK/vof/ctYzVheGB431K5uVZjE=
Subject: [PATCH 6/7] audit: fix sparse shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 17:33:37 -0700
Message-Id: <1207182817.5740.25.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msglen as the identifier.
kernel/audit.c:724:10: warning: symbol 'len' shadows an earlier one
kernel/audit.c:575:8: originally declared here

Don't use ino_f to check the inode field at the end of the functions.
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
 kernel/audit.c       |   10 +++++-----
 kernel/auditfilter.c |   18 +++++++++---------
 kernel/auditsc.c     |    2 --
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index b782b04..a4c36ed 100644
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
index 0c63577..587c893 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -417,7 +417,7 @@ exit_err:
 static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 {
 	struct audit_entry *entry;
-	struct audit_field *f;
+	struct audit_field *ino_f;
 	int err = 0;
 	int i;
 
@@ -499,9 +499,9 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 		}
 	}
 
-	f = entry->rule.inode_f;
-	if (f) {
-		switch(f->op) {
+	ino_f = entry->rule.inode_f;
+	if (ino_f) {
+		switch(ino_f->op) {
 		case AUDIT_NOT_EQUAL:
 			entry->rule.inode_f = NULL;
 		case AUDIT_EQUAL:
@@ -526,7 +526,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 {
 	int err = 0;
 	struct audit_entry *entry;
-	struct audit_field *f;
+	struct audit_field *ino_f;
 	void *bufp;
 	size_t remain = datasz - sizeof(struct audit_rule_data);
 	int i;
@@ -539,7 +539,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 	bufp = data->buf;
 	entry->rule.vers_ops = 2;
 	for (i = 0; i < data->field_count; i++) {
-		struct audit_field *f = &entry->rule.fields[i];
+		audit_field *f = &entry->rule.fields[i];
 
 		err = -EINVAL;
 		if (!(data->fieldflags[i] & AUDIT_OPERATORS) ||
@@ -654,9 +654,9 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		}
 	}
 
-	f = entry->rule.inode_f;
-	if (f) {
-		switch(f->op) {
+	ino_f = entry->rule.inode_f;
+	if (ino_f) {
+		switch(ino_f->op) {
 		case AUDIT_NOT_EQUAL:
 			entry->rule.inode_f = NULL;
 		case AUDIT_EQUAL:
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 12e7183..16c3abd 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1292,7 +1292,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 			break; }
 
 		case AUDIT_SOCKETCALL: {
-			int i;
 			struct audit_aux_data_socketcall *axs = (void *)aux;
 			audit_log_format(ab, "nargs=%d", axs->nargs);
 			for (i=0; i<axs->nargs; i++)
@@ -1317,7 +1316,6 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 
 	for (aux = context->aux_pids; aux; aux = aux->next) {
 		struct audit_aux_data_pids *axs = (void *)aux;
-		int i;
 
 		for (i = 0; i < axs->pid_count; i++)
 			if (audit_log_pid_context(context, axs->target_pid[i],
-- 
1.5.5.rc1.135.g8527


