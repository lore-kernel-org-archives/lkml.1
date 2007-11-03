Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbXKCQno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbXKCQno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 12:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbXKCQnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 12:43:35 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:31437 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbXKCQnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 12:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=qqdkvVSSR/sstUwRKpmBGuZzjoPg2UZC5PVZne5jYAkOCPYtH3/KQMCtpd1Cn71HI0uLp/BbDb4/xhvE8awQ30hSur4RBUvdgzkQOxA76adRNUMqAg0pbCqo/VNW78RO0SilvIFvYuEBso1za43jeVjQIFV2thcCHLJLXrB+z/8=
Date: Sat, 3 Nov 2007 18:43:06 +0200
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071103164303.GA26707@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472B8DAF.9080706@schaufler-ca.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 01:50:55PM -0700, Casey Schaufler wrote:
> 
> Still to come:
> 
>   - Final cleanup of smack_load_write and smack_cipso_write.

Hi All,

After agreeing with Casey on the "load" input grammar yesterday, here's
the final grammar and its parser (which needs more testing):

A Smack Rule in an "egrep" format is:

"^[:space:]*Subject[:space:]+Object[:space:]+[rwxaRWXA-]+[:space:]*\n"

where Subject/Object strings are in the form:

"^[^/[:space:][:cntrl:]]{1,SMK_MAXLEN}$"

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

Bashv3 builtin "echo" behaves very strangely to -EINVAL. It sends all
the buffers that causes -EINVAL again in subsequent echo invocations.

i.e.
echo "Invalid Rule" > /smack/load  # -EINVAL returned
echo "Valid Rule" > /smack/load

In seconod iteration, echo sends the first invalid buffer again 
then sends the new one. This causes a 
"Invalid Rule\nValid Rule" buffer sent to write().

IMHO, this is a bug in builtin echo. The external /bin/echo doesn't 
cause such strange behaviour.

diff --git a/security/smack/smack.h b/security/smack/smack.h
index e0b7d26..8dcdb79 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -219,4 +219,16 @@ static inline char *smk_of_inode(const struct inode *isp)
 	return sip->smk_inode;
 }
 
+static inline int isblank(char c)
+{
+	return (c == ' ' || c == '\t');
+}
+
+#define swap(x, y, type)      \
+do {			      \
+	type tmp = x;	      \
+	x = y;		      \
+	y = tmp;	      \
+} while (0);		      \
+
 #endif  /* _SECURITY_SMACK_H */
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 3572ae5..0b1b530 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -25,6 +25,7 @@
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
 #include <linux/seq_file.h>
+#include <linux/ctype.h>
 #include "smack.h"
 
 /*
@@ -67,6 +68,39 @@ struct smk_list_entry *smack_list;
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
+	struct smack_rule rule;      /* Rule to be loaded */
+	int label_len;               /* Subject/Object labels length so far */
+	char subject[SMK_LABELLEN];  /* Subject label */
+	char object[SMK_LABELLEN];   /* Object label */
+	int access;                  /* Bool, parsed an "access" token ? */
+} *load_state;
+
+
+/*
  * Seq_file read operations for /smack/load
  */
 
@@ -131,12 +165,43 @@ static struct seq_operations load_seq_ops = {
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
@@ -174,7 +239,6 @@ static void smk_set_access(struct smack_rule *srp)
 	return;
 }
 
-
 /**
  * smk_write_load - write() for /smack/load
  * @filp: file pointer, not actually used
@@ -182,19 +246,26 @@ static void smk_set_access(struct smack_rule *srp)
  * @count: bytes sent
  * @ppos: where to start
  *
- * Returns number of bytes written or error code, as appropriate
+ * Parse smack rules in below extended regex format:
+ * "^[:space:]*Subject[:space:]+Object[:space:]+[rwxaRWXA-]+[:space:]*\n"
+ * Where Subject/Object are: "^[^/[:space:][:cntrl:]]{1,SMK_MAXLEN}$"
+ *
+ * Handle defragmented rules over several write calls using a Finite
+ * State Machine that saves its state in the load_state structure.
  */
 static ssize_t smk_write_load(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct smack_rule rule;
-	ssize_t rc = count;
+	struct smack_rule *rule = &load_state->rule;
+	enum load_state *state = &load_state->state;
+	enum load_state *prevstate = &load_state->prevstate;
+	int *label_len = &load_state->label_len;
+	char *subjectstr = load_state->subject;
+	char *objectstr = load_state->object;
+	int *accesstok = &load_state->access;
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
@@ -208,7 +279,7 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 	 * 80 characters per line ought to be enough.
 	 */
 	if (count > SMACK_LIST_MAX * 80)
-		return -ENOMEM;
+		return -EFBIG;
 
 	data = kzalloc(count + 1, GFP_KERNEL);
 	if (data == NULL)
@@ -221,30 +292,93 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 
 	data[count] = '\0';
 
-	for (cp = data - 1; cp != NULL; cp = strchr(cp + 1, '\n')) {
-		if (*++cp == '\0')
+	for (i = 0; i < count && data[i]; i++) {
+		if (!isgraph(data[i]) && !isspace(data[i]))
+			goto out;
+
+		/* If a char-blank transition occurred */
+		if (isblank(data[i]) && *state != blank)
+			*prevstate = *state;
+		/* If a blank-char transition occurred */
+		if (!isblank(data[i]) && *state == blank) {
+			swap(*state, *prevstate, typeof(*state));
+			++(*state);
+		}
+
+		if (isblank(data[i]))
+			*state = blank;
+
+		if (data[i] == '\n')
+			*state = newline;
+
+		switch (*state) {
+		case bol:
+		case subject:
+			if (*label_len >= SMK_MAXLEN)
+				goto out;
+			subjectstr[(*label_len)++] = data[i];
+			*state = subject;
+			break;
+
+		case object:
+			if (*prevstate == blank) {
+				subjectstr[*label_len] = '\0';
+				*label_len = 0;
+				*prevstate = *state = object;
+			}
+
+			if (*label_len >= SMK_MAXLEN)
+				goto out;
+			objectstr[(*label_len)++] = data[i];
 			break;
-		if (sscanf(cp, "%23s %23s %7s\n", subjectstr, objectstr,
-			   modestr) != 3)
+
+		case access:
+			if (*prevstate == blank) {
+				objectstr[*label_len] = '\0';
+				*label_len = 0;
+				*prevstate = *state = access;
+			}
+
+			if (data[i] == 'r' || data[i] == 'R')
+				rule->smk_access |= MAY_READ;
+			else if (data[i] == 'w' || data[i] == 'W')
+				rule->smk_access |= MAY_WRITE;
+			else if (data[i] == 'x' || data[i] == 'X')
+				rule->smk_access |= MAY_EXEC;
+			else if (data[i] == 'a' || data[i] == 'A')
+				rule->smk_access |= MAY_APPEND;
+			else if (data[i] == '-')
+				/* No-Op, '-' is a placeholder */;
+			else
+				goto out;
+			*accesstok = 1;
 			break;
-		rule.smk_subject = smk_import(subjectstr, 0);
-		if (rule.smk_subject == NULL)
+
+		case newline:
+			if (*accesstok == 0)
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
@@ -254,7 +388,7 @@ static const struct file_operations smk_load_ops = {
 	.read		= seq_read,
 	.llseek         = seq_lseek,
 	.write		= smk_write_load,
-	.release        = seq_release
+	.release        = smk_release_load,
 };
 
 /**
@@ -924,6 +1058,7 @@ static int __init init_smk_fs(void)
 		}
 	}
 
+	sema_init(&smack_write_sem, 1);
 	smk_cipso_doi();
 
 	return err;

--
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
