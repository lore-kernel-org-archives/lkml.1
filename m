Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbXKEA5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbXKEA5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 19:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbXKEA5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 19:57:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:58611 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbXKEA5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:57:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=pTFaZK/n+fdcxCsOca6gSRyiEN7A4zKfYRxNWJb2yEf1EsasHFkJIpuTY4Nxn0On0g2AyztqzpQOqpOISREL0AeTHATomII2uDtKLBtr59LumH6PnML3t3ghlv1K7UCg/2Du0pPfgnzjZz4jHdAvijHP6j5pQenJwRJ8sx6jjMo=
Date: Mon, 5 Nov 2007 02:56:33 +0200
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] Smackv10: Smack rules grammar + their stateful parser(2)
Message-ID: <20071105005625.GA18030@ubuntu>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071103164303.GA26707@ubuntu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 06:43:06PM +0200, Ahmed S. Darwish wrote:
> On Fri, Nov 02, 2007 at 01:50:55PM -0700, Casey Schaufler wrote:
> > 
> > Still to come:
> > 
> >   - Final cleanup of smack_load_write and smack_cipso_write.
> 
> Hi All,
> 
> After agreeing with Casey on the "load" input grammar yesterday, here's
> the final grammar and its parser (which needs more testing):
> 
> A Smack Rule in an "egrep" format is:
> 
> "^[:space:]*Subject[:space:]+Object[:space:]+[rwxaRWXA-]+[:space:]*\n"
> 
> where Subject/Object strings are in the form:
> 
> "^[^/[:space:][:cntrl:]]{1,SMK_MAXLEN}$"
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> 

Same parser with adhering Casey's concers about previous one 
and with using the FSM states in a more readable way. 

I've double-checked the code for any possible off-by-one/overflow 
errors. Could someone overcheck this for any possible hidden 
security holes. Al, please :) ?

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 3572ae5..c9461cb 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -25,6 +25,7 @@
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
 #include <linux/seq_file.h>
+#include <linux/ctype.h>
 #include "smack.h"
 
 /*
@@ -67,6 +68,47 @@ struct smk_list_entry *smack_list;
 #define	SEQ_READ_FINISHED	1
 
 /*
+ * Disable concurrent writing open() operations
+ */
+static struct semaphore smack_write_sem;
+
+/*
+ * States for parsing /smack/load rules
+ */
+enum load_state {
+	bol          = 0,            /* At Beginning Of Line */
+	subject      = 1,            /* At a "subject" token */
+	object       = 2,            /* At an "object" token */
+	access       = 3,            /* At an "access" token */
+	newline      = 4,            /* At end Of Line */
+	blank        = 5,            /* At a space or tab */
+};
+
+/*
+ * Represent current parsing state of /smack/load. Struct
+ * also stores data needed between an open-release session's
+ * multiple write() calls
+ */
+static struct smack_load_state {
+	enum load_state state;       /* Current FSM parsing state */
+	enum load_state prevstate;   /* Previous FSM state */
+	enum load_state prevtoken;   /* Handle state = prevstate = blank */
+	struct smack_rule rule;      /* Rule to be loaded */
+	int label_len;               /* Subject/Object labels length so far */
+	char subject[SMK_LABELLEN];  /* Subject label */
+	char object[SMK_LABELLEN];   /* Object label */
+} *load_state;
+
+/*
+ * Rule's tokens separators are spaces and tabs only
+ */
+static inline int isblank(char c)
+{
+	return (c == ' ' || c == '\t');
+}
+
+
+/*
  * Seq_file read operations for /smack/load
  */
 
@@ -131,12 +173,43 @@ static struct seq_operations load_seq_ops = {
  * @inode: inode structure representing file
  * @file: "load" file pointer
  *
- * Connect our load_seq_* operations with /smack/load
- * file_operations
+ * For reading, use load_seq_* seq_file reading operations.
+ * For writing, prepare a load_state struct to parse
+ * incoming rules.
  */
 static int smk_open_load(struct inode *inode, struct file *file)
 {
-	return seq_open(file, &load_seq_ops);
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
+		return seq_open(file, &load_seq_ops);
+
+	if (down_interruptible(&smack_write_sem))
+		return -ERESTARTSYS;
+
+	load_state = kzalloc(sizeof(struct smack_load_state), GFP_KERNEL);
+	if (!load_state)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/**
+ * smk_release_load - release() for /smack/load
+ * @inode: inode structure representing file
+ * @file: "load" file pointer
+ *
+ * For a reading session, use the seq_file release
+ * implementation.
+ * Otherwise, we are at the end of a writing session so
+ * clean everything up.
+ */
+static int smk_release_load(struct inode *inode, struct file *file)
+{
+	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
+		return seq_release(inode, file);
+
+	kfree(load_state);
+	up(&smack_write_sem);
+	return 0;
 }
 
 /**
@@ -174,7 +247,6 @@ static void smk_set_access(struct smack_rule *srp)
 	return;
 }
 
-
 /**
  * smk_write_load - write() for /smack/load
  * @filp: file pointer, not actually used
@@ -182,19 +254,26 @@ static void smk_set_access(struct smack_rule *srp)
  * @count: bytes sent
  * @ppos: where to start
  *
- * Returns number of bytes written or error code, as appropriate
+ * Parse smack rules in below extended regex format:
+ * "^[:space:]*Subject[:space:]+Object[:space:]+[rwxaRWXA-]+[:space:]*$"
+ * Where Subject/Object are: "^[^/[:space:][:cntrl:]]{1,SMK_MAXLEN}$"
+ *
+ * Handle defragmented rules over several write calls using the
+ * load_state structure.
  */
 static ssize_t smk_write_load(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct smack_rule rule;
-	ssize_t rc = count;
+	struct smack_rule *rule = &load_state->rule;
+	enum load_state *state = &load_state->state;
+	enum load_state *prevstate = &load_state->prevstate;
+	enum load_state *prevtoken = &load_state->prevtoken;
+	int *label_len = &load_state->label_len;
+	char *subjectstr = load_state->subject;
+	char *objectstr = load_state->object;
+	ssize_t rc = -EINVAL;
 	char *data = NULL;
-	char subjectstr[SMK_LABELLEN];
-	char objectstr[SMK_LABELLEN];
-	char modestr[8];
-	char *cp;
-
+	int i;
 
 	if (!capable(CAP_MAC_OVERRIDE))
 		return -EPERM;
@@ -208,7 +287,7 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 	 * 80 characters per line ought to be enough.
 	 */
 	if (count > SMACK_LIST_MAX * 80)
-		return -ENOMEM;
+		return -EFBIG;
 
 	data = kzalloc(count + 1, GFP_KERNEL);
 	if (data == NULL)
@@ -221,30 +300,94 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 
 	data[count] = '\0';
 
-	for (cp = data - 1; cp != NULL; cp = strchr(cp + 1, '\n')) {
-		if (*++cp == '\0')
+	for (i = 0; i < count && data[i]; i++) {
+		if (!isgraph(data[i]) && !isspace(data[i]))
+			goto out;
+
+		if (isblank(data[i])) {
+			*state = blank;
+			/* A token-blank trasition */
+			if (*prevstate != blank)
+				*prevtoken = *prevstate;
+		} else {
+			if (data[i] == '\n')
+				*state = newline;
+			/* A blank-token transition */
+			else if (*prevstate == blank)
+				*state = *prevtoken + 1;
+			else
+				*state = *prevstate;
+		}
+
+		switch (*state) {
+		case bol:
+		case subject:
+			if (*label_len >= SMK_MAXLEN)
+				goto out;
+			subjectstr[(*label_len)++] = data[i];
+			*prevstate = subject;
 			break;
-		if (sscanf(cp, "%23s %23s %7s\n", subjectstr, objectstr,
-			   modestr) != 3)
+
+		case object:
+			if (*prevstate == blank) {
+				subjectstr[*label_len] = '\0';
+				*label_len = 0;
+			}
+
+			if (*label_len >= SMK_MAXLEN)
+				goto out;
+			objectstr[(*label_len)++] = data[i];
+			*prevstate = object;
+			break;
+
+		case access:
+			if (*prevstate == blank) {
+				objectstr[*label_len] = '\0';
+				*label_len = 0;
+			}
+
+			if (data[i] == 'R' || data[i] == 'r')
+				rule->smk_access |= MAY_READ;
+			else if (data[i] == 'W' || data[i] == 'w')
+				rule->smk_access |= MAY_WRITE;
+			else if (data[i] == 'X' || data[i] == 'x')
+				rule->smk_access |= MAY_EXEC;
+			else if (data[i] == 'A' || data[i] == 'a')
+				rule->smk_access |= MAY_APPEND;
+			else if (data[i] == '-')
+				/* No-Op, '-' is a placeholder */;
+			else
+				goto out;
+
+			*prevstate = *prevtoken = access;
 			break;
-		rule.smk_subject = smk_import(subjectstr, 0);
-		if (rule.smk_subject == NULL)
+
+		case newline:
+			if (*prevtoken != access || data[i] != '\n')
+				goto out;
+
+			rule->smk_subject = smk_import(subjectstr, 0);
+			if (rule->smk_subject == NULL)
+				goto out;
+
+			rule->smk_object = smk_import(objectstr, 0);
+			if (rule->smk_object == NULL)
+				goto out;
+
+			smk_set_access(rule);
+
+			/* Reset everything, a new rule will come */
+			memset(load_state, 0, sizeof(*load_state));
 			break;
-		rule.smk_object = smk_import(objectstr, 0);
-		if (rule.smk_object == NULL)
+
+		case blank:
+			*prevstate = blank;
 			break;
-		rule.smk_access = 0;
-		if (strpbrk(modestr, "rR") != NULL)
-			rule.smk_access |= MAY_READ;
-		if (strpbrk(modestr, "wW") != NULL)
-			rule.smk_access |= MAY_WRITE;
-		if (strpbrk(modestr, "xX") != NULL)
-			rule.smk_access |= MAY_EXEC;
-		if (strpbrk(modestr, "aA") != NULL)
-			rule.smk_access |= MAY_APPEND;
-		smk_set_access(&rule);
+		}
 	}
 
+	rc = count;
+out:
 	kfree(data);
 	return rc;
 }
@@ -254,7 +397,7 @@ static const struct file_operations smk_load_ops = {
 	.read		= seq_read,
 	.llseek         = seq_lseek,
 	.write		= smk_write_load,
-	.release        = seq_release
+	.release        = smk_release_load,
 };
 
 /**
@@ -924,6 +1067,7 @@ static int __init init_smk_fs(void)
 		}
 	}
 
+	sema_init(&smack_write_sem, 1);
 	smk_cipso_doi();
 
 	return err;

--
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
