Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYACLTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYACLTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYACLTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:19:40 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:38529 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbYACLTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:19:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=r4QEW6vor+s+Ooxfj7rQaSol7GqCXoH6gW8tx/6gfPUspJwrkvqaZ+Fy4Xfmm4XeSoLLMahfzmAv2A4jX+sbkRF0wq4e7D1UqZRAjaEMHDLdYOJiL0rM3Os7pvNJa1fTFIWP4qLnVuwxIGnrFrX/YNS3UZWNQ4Kzp6t/OwCIa+k=
Date: Thu, 3 Jan 2008 14:19:25 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>
Subject: [x86] kernel/audit.c cleanup according to checkpatch.pl
Message-ID: <20080103111925.GC8046@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch eliminates code-style errors according
to checkpatch.pl

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Ingo, David, md5sums will be different for old and patched
asm listings due to:

	- zero initialized static vars take off
	- assignments moved out from 'if' conditions
	- EXPORT_SYMBOL's set at appropriate places

anyway the changes are trivial, so even a glance review
would be enough to ensure that it doesn't bring errors
into the kernel

before:
	total: 20 errors, 17 warnings, 1473 lines checked
after:
	total: 2 errors, 12 warnings, 1480 lines checked

Any comments are welcome.

 kernel/audit.c |   69 ++++++++++++++++++++++++++++++-------------------------
 1 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index f93c271..4e71602 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -89,7 +89,7 @@ static int	audit_rate_limit;
 /* Number of outstanding audit_buffers allowed. */
 static int	audit_backlog_limit = 64;
 static int	audit_backlog_wait_time = 60 * HZ;
-static int	audit_backlog_wait_overflow = 0;
+static int	audit_backlog_wait_overflow;
 
 /* The identity of the user shutting down the audit system. */
 uid_t		audit_sig_uid = -1;
@@ -158,8 +158,7 @@ static void audit_set_pid(struct audit_buffer *ab, pid_t pid)
 
 void audit_panic(const char *message)
 {
-	switch (audit_failure)
-	{
+	switch (audit_failure) {
 	case AUDIT_FAIL_SILENT:
 		break;
 	case AUDIT_FAIL_PRINTK:
@@ -173,15 +172,16 @@ void audit_panic(const char *message)
 
 static inline int audit_rate_check(void)
 {
-	static unsigned long	last_check = 0;
-	static int		messages   = 0;
+	static unsigned long	last_check;
+	static int		messages;
 	static DEFINE_SPINLOCK(lock);
 	unsigned long		flags;
 	unsigned long		now;
 	unsigned long		elapsed;
 	int			retval	   = 0;
 
-	if (!audit_rate_limit) return 1;
+	if (!audit_rate_limit)
+		return 1;
 
 	spin_lock_irqsave(&lock, flags);
 	if (++messages < audit_rate_limit) {
@@ -210,7 +210,7 @@ static inline int audit_rate_check(void)
 */
 void audit_log_lost(const char *message)
 {
-	static unsigned long	last_msg = 0;
+	static unsigned long	last_msg;
 	static DEFINE_SPINLOCK(lock);
 	unsigned long		flags;
 	unsigned long		now;
@@ -232,7 +232,8 @@ void audit_log_lost(const char *message)
 
 	if (print) {
 		printk(KERN_WARNING
-		       "audit: audit_lost=%d audit_rate_limit=%d audit_backlog_limit=%d\n",
+		       "audit: audit_lost=%d audit_rate_limit=%d "
+		       "audit_backlog_limit=%d\n",
 		       atomic_read(&audit_lost),
 		       audit_rate_limit,
 		       audit_backlog_limit);
@@ -253,7 +254,8 @@ static int audit_set_rate_limit(int limit, uid_t loginuid, u32 sid)
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
-		if ((rc = selinux_sid_to_string(sid, &ctx, &len)) == 0) {
+		rc = selinux_sid_to_string(sid, &ctx, &len);
+		if (rc == 0) {
 			audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
 				"audit_rate_limit=%d old=%d by auid=%u"
 				" subj=%s res=%d",
@@ -288,7 +290,8 @@ static int audit_set_backlog_limit(int limit, uid_t loginuid, u32 sid)
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
-		if ((rc = selinux_sid_to_string(sid, &ctx, &len)) == 0) {
+		rc = selinux_sid_to_string(sid, &ctx, &len);
+		if (rc == 0) {
 			audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
 				"audit_backlog_limit=%d old=%d by auid=%u"
 				" subj=%s res=%d",
@@ -326,7 +329,8 @@ static int audit_set_enabled(int state, uid_t loginuid, u32 sid)
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
-		if ((rc = selinux_sid_to_string(sid, &ctx, &len)) == 0) {
+		rc = selinux_sid_to_string(sid, &ctx, &len);
+		if (rc == 0) {
 			audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
 				"audit_enabled=%d old=%d by auid=%u"
 				" subj=%s res=%d",
@@ -366,7 +370,8 @@ static int audit_set_failure(int state, uid_t loginuid, u32 sid)
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
-		if ((rc = selinux_sid_to_string(sid, &ctx, &len)) == 0) {
+		rc = selinux_sid_to_string(sid, &ctx, &len);
+		if (rc == 0) {
 			audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
 				"audit_failure=%d old=%d by auid=%u"
 				" subj=%s res=%d",
@@ -626,18 +631,20 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (status_get->mask & AUDIT_STATUS_ENABLED) {
 			err = audit_set_enabled(status_get->enabled,
 							loginuid, sid);
-			if (err < 0) return err;
+			if (err < 0)
+				return err;
 		}
 		if (status_get->mask & AUDIT_STATUS_FAILURE) {
 			err = audit_set_failure(status_get->failure,
 							 loginuid, sid);
-			if (err < 0) return err;
+			if (err < 0)
+				return err;
 		}
 		if (status_get->mask & AUDIT_STATUS_PID) {
 			int old   = audit_pid;
 			if (sid) {
-				if ((err = selinux_sid_to_string(
-						sid, &ctx, &len)))
+				err = selinux_sid_to_string(sid, &ctx, &len);
+				if (err)
 					return err;
 				else
 					audit_log(NULL, GFP_KERNEL,
@@ -925,9 +932,10 @@ static void audit_receive_skb(struct sk_buff *skb)
 		rlen = NLMSG_ALIGN(nlh->nlmsg_len);
 		if (rlen > skb->len)
 			rlen = skb->len;
-		if ((err = audit_receive_msg(skb, nlh))) {
+		err = audit_receive_msg(skb, nlh);
+		if (err)
 			netlink_ack(skb, nlh, err);
-		} else if (nlh->nlmsg_flags & NLM_F_ACK)
+		else if (nlh->nlmsg_flags & NLM_F_ACK)
 			netlink_ack(skb, nlh, 0);
 		skb_pull(skb, rlen);
 	}
@@ -1019,8 +1027,8 @@ static void audit_buffer_free(struct audit_buffer *ab)
 	spin_unlock_irqrestore(&audit_freelist_lock, flags);
 }
 
-static struct audit_buffer * audit_buffer_alloc(struct audit_context *ctx,
-						gfp_t gfp_mask, int type)
+static struct audit_buffer *audit_buffer_alloc(struct audit_context *ctx,
+					       gfp_t gfp_mask, int type)
 {
 	unsigned long flags;
 	struct audit_buffer *ab = NULL;
@@ -1078,7 +1086,7 @@ err:
 unsigned int audit_serial(void)
 {
 	static DEFINE_SPINLOCK(serial_lock);
-	static unsigned int serial = 0;
+	static unsigned int serial;
 
 	unsigned long flags;
 	unsigned int ret;
@@ -1188,6 +1196,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 			 t.tv_sec, t.tv_nsec/1000000, serial);
 	return ab;
 }
+EXPORT_SYMBOL(audit_log_start);
 
 /**
  * audit_expand - expand skb in the audit buffer
@@ -1269,6 +1278,7 @@ void audit_log_format(struct audit_buffer *ab, const char *fmt, ...)
 	audit_log_vformat(ab, fmt, args);
 	va_end(args);
 }
+EXPORT_SYMBOL(audit_log_format);
 
 /**
  * audit_log_hex - convert a buffer to hex and append it to the audit skb
@@ -1295,19 +1305,19 @@ void audit_log_hex(struct audit_buffer *ab, const unsigned char *buf,
 	BUG_ON(!ab->skb);
 	skb = ab->skb;
 	avail = skb_tailroom(skb);
-	new_len = len<<1;
+	new_len = len << 1;
 	if (new_len >= avail) {
 		/* Round the buffer request up to the next multiple */
-		new_len = AUDIT_BUFSIZ*(((new_len-avail)/AUDIT_BUFSIZ) + 1);
+		new_len = AUDIT_BUFSIZ * (((new_len - avail) / AUDIT_BUFSIZ) + 1);
 		avail = audit_expand(ab, new_len);
 		if (!avail)
 			return;
 	}
 
 	ptr = skb_tail_pointer(skb);
-	for (i=0; i<len; i++) {
-		*ptr++ = hex[(buf[i] & 0xF0)>>4]; /* Upper nibble */
-		*ptr++ = hex[buf[i] & 0x0F];	  /* Lower nibble */
+	for (i = 0; i < len; i++) {
+		*ptr++ = hex[(buf[i] & 0xF0) >> 4];	/* Upper nibble */
+		*ptr++ = hex[buf[i] & 0x0F];		/* Lower nibble */
 	}
 	*ptr = 0;
 	skb_put(skb, len << 1); /* new string is twice the old string */
@@ -1402,7 +1412,7 @@ void audit_log_d_path(struct audit_buffer *ab, const char *prefix,
 		audit_log_format(ab, "<no memory>");
 		return;
 	}
-	p = d_path(dentry, vfsmnt, path, PATH_MAX+11);
+	p = d_path(dentry, vfsmnt, path, PATH_MAX + 11);
 	if (IS_ERR(p)) { /* Should never happen since we send PATH_MAX */
 		/* FIXME: can we save some information here? */
 		audit_log_format(ab, "<too long>");
@@ -1439,6 +1449,7 @@ void audit_log_end(struct audit_buffer *ab)
 	}
 	audit_buffer_free(ab);
 }
+EXPORT_SYMBOL(audit_log_end);
 
 /**
  * audit_log - Log an audit record
@@ -1466,8 +1477,4 @@ void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
 		audit_log_end(ab);
 	}
 }
-
-EXPORT_SYMBOL(audit_log_start);
-EXPORT_SYMBOL(audit_log_end);
-EXPORT_SYMBOL(audit_log_format);
 EXPORT_SYMBOL(audit_log);
