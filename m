Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYACQcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYACQcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYACQb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:31:58 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:31072 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYACQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:31:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=W9SBJr9b47jTYX4BQxQbhhXdKbkWQqbFmYfCtfaOm1I/Dip9kStLUL1xUhzwFtTm7evTbKvSxnt893RtTX9lYYykuMndTuwa3QeMYk9BNkIXTnI1JXiJRgWXDeEtTHxCk73Uu2R5KehpnrJoq0sGt9sjpPl1FiAWtbRGhYCKZo8=
Date: Thu, 3 Jan 2008 19:31:38 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86] kernel/audit.c cleanup according to checkpatch.pl
Message-ID: <20080103163138.GI8046@cvg>
References: <20080103111925.GC8046@cvg> <20080103112957.GA14693@lazybastard.org> <20080103140549.GA19363@elte.hu> <1199370550.3697.79.camel@shinybook.infradead.org> <20080103143711.GA29606@elte.hu> <1199371044.3697.80.camel@shinybook.infradead.org> <20080103145028.GH8046@cvg> <1199372228.3697.82.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199372228.3697.82.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Woodhouse - Thu, Jan 03, 2008 at 02:57:08PM +0000]
| 
| On Thu, 2008-01-03 at 17:50 +0300, Cyrill Gorcunov wrote:
| > 
| > 
| > so what i would do now? i could post updated patch *without* that
| > splitted line, should I?
| 
| And with the if (rc == 0) thing fixed too. Yes please.
| 
| -- 
| dwmw2
| 

here is an updated patch

---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [x86] kernel/audit.c cleanup according to checkpatch.pl

This patch eliminates most of errors pointed by checkpatch.pl
over kernel/audit.c file.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

David, to use 'if (rc)' form instead of 'if (rc == 0)' i had
to move 'kfree(ctx)' out of if-else condition but that is OK
'case a lot of further audit.c code was doing the same ;)

 kernel/audit.c |  126 +++++++++++++++++++++++++++++--------------------------
 1 files changed, 66 insertions(+), 60 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index f93c271..2961ee4 100644
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
@@ -136,7 +136,7 @@ static DEFINE_MUTEX(audit_cmd_mutex);
 
 /* AUDIT_MAXFREE is the number of empty audit_buffers we keep on the
  * audit_freelist.  Doing so eliminates many kmalloc/kfree calls. */
-#define AUDIT_MAXFREE  (2*NR_CPUS)
+#define AUDIT_MAXFREE (2 * NR_CPUS)
 
 /* The audit_buffer is used when formatting an audit record.  The caller
  * locks briefly to get the record off the freelist or to allocate the
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
@@ -253,14 +253,15 @@ static int audit_set_rate_limit(int limit, uid_t loginuid, u32 sid)
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
-		if ((rc = selinux_sid_to_string(sid, &ctx, &len)) == 0) {
-			audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
-				"audit_rate_limit=%d old=%d by auid=%u"
-				" subj=%s res=%d",
-				limit, old, loginuid, ctx, res);
-			kfree(ctx);
-		} else
+		rc = selinux_sid_to_string(sid, &ctx, &len);
+		if (rc)
 			res = 0; /* Something weird, deny request */
+		else
+			audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
+				  "audit_rate_limit=%d old=%d by auid=%u"
+				  " subj=%s res=%d",
+				  limit, old, loginuid, ctx, res);
+		kfree(ctx);
 	}
 	audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
 		"audit_rate_limit=%d old=%d by auid=%u res=%d",
@@ -288,14 +289,15 @@ static int audit_set_backlog_limit(int limit, uid_t loginuid, u32 sid)
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
-		if ((rc = selinux_sid_to_string(sid, &ctx, &len)) == 0) {
-			audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
-				"audit_backlog_limit=%d old=%d by auid=%u"
-				" subj=%s res=%d",
-				limit, old, loginuid, ctx, res);
-			kfree(ctx);
-		} else
+		rc = selinux_sid_to_string(sid, &ctx, &len);
+		if (rc)
 			res = 0; /* Something weird, deny request */
+		else
+			audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
+				  "audit_backlog_limit=%d old=%d by auid=%u"
+				  " subj=%s res=%d",
+				  limit, old, loginuid, ctx, res);
+		kfree(ctx);
 	}
 	audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
 		"audit_backlog_limit=%d old=%d by auid=%u res=%d",
@@ -326,14 +328,15 @@ static int audit_set_enabled(int state, uid_t loginuid, u32 sid)
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
-		if ((rc = selinux_sid_to_string(sid, &ctx, &len)) == 0) {
-			audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
-				"audit_enabled=%d old=%d by auid=%u"
-				" subj=%s res=%d",
-				state, old, loginuid, ctx, res);
-			kfree(ctx);
-		} else
+		rc = selinux_sid_to_string(sid, &ctx, &len);
+		if (rc)
 			res = 0; /* Something weird, deny request */
+		else
+			audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
+				  "audit_enabled=%d old=%d by auid=%u"
+				  " subj=%s res=%d",
+				  state, old, loginuid, ctx, res);
+		kfree(ctx);
 	}
 	audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
 		"audit_enabled=%d old=%d by auid=%u res=%d",
@@ -366,14 +369,15 @@ static int audit_set_failure(int state, uid_t loginuid, u32 sid)
 	if (sid) {
 		char *ctx = NULL;
 		u32 len;
-		if ((rc = selinux_sid_to_string(sid, &ctx, &len)) == 0) {
-			audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
-				"audit_failure=%d old=%d by auid=%u"
-				" subj=%s res=%d",
-				state, old, loginuid, ctx, res);
-			kfree(ctx);
-		} else
+		rc = selinux_sid_to_string(sid, &ctx, &len);
+		if (rc)
 			res = 0; /* Something weird, deny request */
+		else
+			audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
+				  "audit_failure=%d old=%d by auid=%u"
+				  " subj=%s res=%d",
+				  state, old, loginuid, ctx, res);
+		kfree(ctx);
 	}
 	audit_log(NULL, GFP_KERNEL, AUDIT_CONFIG_CHANGE,
 		"audit_failure=%d old=%d by auid=%u res=%d",
@@ -626,18 +630,20 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
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
@@ -791,7 +797,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		audit_log_format(ab, " op=trim res=1");
 		audit_log_end(ab);
 		break;
-	case AUDIT_MAKE_EQUIV: {
+	case AUDIT_MAKE_EQUIV:
+	{
 		void *bufp = data;
 		u32 sizes[2];
 		size_t len = nlmsg_len(nlh);
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
@@ -996,7 +1004,6 @@ static int __init audit_enable(char *str)
 		audit_enabled = audit_default;
 	return 1;
 }
-
 __setup("audit=", audit_enable);
 
 static void audit_buffer_free(struct audit_buffer *ab)
@@ -1019,8 +1026,8 @@ static void audit_buffer_free(struct audit_buffer *ab)
 	spin_unlock_irqrestore(&audit_freelist_lock, flags);
 }
 
-static struct audit_buffer * audit_buffer_alloc(struct audit_context *ctx,
-						gfp_t gfp_mask, int type)
+static struct audit_buffer *audit_buffer_alloc(struct audit_context *ctx,
+					       gfp_t gfp_mask, int type)
 {
 	unsigned long flags;
 	struct audit_buffer *ab = NULL;
@@ -1078,7 +1085,7 @@ err:
 unsigned int audit_serial(void)
 {
 	static DEFINE_SPINLOCK(serial_lock);
-	static unsigned int serial = 0;
+	static unsigned int serial;
 
 	unsigned long flags;
 	unsigned int ret;
@@ -1185,9 +1192,10 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 	audit_get_stamp(ab->ctx, &t, &serial);
 
 	audit_log_format(ab, "audit(%lu.%03lu:%u): ",
-			 t.tv_sec, t.tv_nsec/1000000, serial);
+			 t.tv_sec, t.tv_nsec / 1000000, serial);
 	return ab;
 }
+EXPORT_SYMBOL(audit_log_start);
 
 /**
  * audit_expand - expand skb in the audit buffer
@@ -1240,7 +1248,7 @@ static void audit_log_vformat(struct audit_buffer *ab, const char *fmt,
 		 * here and AUDIT_BUFSIZ is at least 1024, then we can
 		 * log everything that printk could have logged. */
 		avail = audit_expand(ab,
-			max_t(unsigned, AUDIT_BUFSIZ, 1+len-avail));
+			max_t(unsigned, AUDIT_BUFSIZ, 1 + len - avail));
 		if (!avail)
 			goto out;
 		len = vsnprintf(skb_tail_pointer(skb), avail, fmt, args2);
@@ -1269,6 +1277,7 @@ void audit_log_format(struct audit_buffer *ab, const char *fmt, ...)
 	audit_log_vformat(ab, fmt, args);
 	va_end(args);
 }
+EXPORT_SYMBOL(audit_log_format);
 
 /**
  * audit_log_hex - convert a buffer to hex and append it to the audit skb
@@ -1295,19 +1304,19 @@ void audit_log_hex(struct audit_buffer *ab, const unsigned char *buf,
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
@@ -1397,12 +1406,12 @@ void audit_log_d_path(struct audit_buffer *ab, const char *prefix,
 		audit_log_format(ab, " %s", prefix);
 
 	/* We will allow 11 spaces for ' (deleted)' to be appended */
-	path = kmalloc(PATH_MAX+11, ab->gfp_mask);
+	path = kmalloc(PATH_MAX + 11, ab->gfp_mask);
 	if (!path) {
 		audit_log_format(ab, "<no memory>");
 		return;
 	}
-	p = d_path(dentry, vfsmnt, path, PATH_MAX+11);
+	p = d_path(dentry, vfsmnt, path, PATH_MAX + 11);
 	if (IS_ERR(p)) { /* Should never happen since we send PATH_MAX */
 		/* FIXME: can we save some information here? */
 		audit_log_format(ab, "<too long>");
@@ -1439,6 +1448,7 @@ void audit_log_end(struct audit_buffer *ab)
 	}
 	audit_buffer_free(ab);
 }
+EXPORT_SYMBOL(audit_log_end);
 
 /**
  * audit_log - Log an audit record
@@ -1466,8 +1476,4 @@ void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
 		audit_log_end(ab);
 	}
 }
-
-EXPORT_SYMBOL(audit_log_start);
-EXPORT_SYMBOL(audit_log_end);
-EXPORT_SYMBOL(audit_log_format);
 EXPORT_SYMBOL(audit_log);
