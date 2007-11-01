Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbXKAPzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbXKAPzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXKAPzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:55:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:11738 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbXKAPzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:55:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=uLlwkn9jF2kST29l3NZItOmuxmifgQoau4o+ACQaKql05tej8yJjyJPhvk15Cai7lmO2O3+eoHYtQBuIw9YvoFp9iemh52kccwOaCKj07wrq4SN46rf15aumrWBZDsGwyfFKDXf7d6pCFdDdyDwvsVaakaFb02vPqWULOBaR8uY=
Date: Thu, 1 Nov 2007 17:54:45 +0200
To: casey@schaufler-ca.com
Cc: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk
Subject: [PATCH] Smackv9: Use a stateful parser for parsing Smack rules
Message-ID: <20071101155445.GB19231@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47201183.1090107@schaufler-ca.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Casey/Al/all,

A patch that utilizes Al Viro's concerns on previous smack parser
and solves pevious parser bugs discovered by Ahmed Darwish. By now,
no problem will occur if given smack rules are fragmented over
multiple write() calls.

CC: Al Viro <viro@ftp.linux.org.uk>
Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

A similar patch for parsing CIPSO rules will be sent soon.

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 88b3f7b..9b56281 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -67,6 +67,39 @@ static int smack_cipso_count;
 struct smk_list_entry *smack_list;
 
 /*
+ * Disable concurrent writing open() operations
+ */
+static struct semaphore smack_write_sem;
+
+/*
+ * States for parsing /smack/load rules
+ */
+enum load_state {
+	subject      = 0,
+	object       = 1,
+	access       = 2,
+	eol          = 3,
+};
+
+/*
+ * Represent current parsing state of /smack/load. Struct
+ * also stores data needed between an open-release session's
+ * multiple write() calls
+ */
+static struct smack_load_state {
+	enum load_state state;
+	struct  smack_rule rule;
+	int     label_len;
+	char    subject[SMK_LABELLEN];
+	char    object[SMK_LABELLEN];
+} *load_state;
+
+static inline int isblank(char c)
+{
+	return (c == ' ' || c == '\t');
+}
+
+/*
  * Seq_file read operations for /smack/load
  */
 
@@ -127,12 +160,43 @@ static struct seq_operations load_seq_ops = {
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
@@ -171,7 +235,6 @@ static void smk_set_access(struct smack_rule *srp)
 	return;
 }
 
-
 /**
  * smk_write_load - write() for /smack/load
  * @filp: file pointer, not actually used
@@ -179,19 +242,20 @@ static void smk_set_access(struct smack_rule *srp)
  * @count: bytes sent
  * @ppos: where to start
  *
- * Returns number of bytes written or error code, as appropriate
+ * Parse smack rules of format "subject object accesss". Handle
+ * defragmented rules over several write calls using the
+ * load_state structure.
  */
 static ssize_t smk_write_load(struct file *file, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct smack_rule rule;
-	ssize_t rc = count;
+	struct smack_rule *rule = &load_state->rule;
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
@@ -205,7 +269,7 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 	 * 80 characters per line ought to be enough.
 	 */
 	if (count > SMACK_LIST_MAX * 80)
-		return -ENOMEM;
+		return -EFBIG;
 
 	data = kzalloc(count + 1, GFP_KERNEL);
 	if (data == NULL)
@@ -218,30 +282,74 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 
 	*(data + count) = '\0';
 
-	for (cp = data - 1; cp != NULL; cp = strchr(cp + 1, '\n')) {
-		if (*++cp == '\0')
+	for (i = 0; i < count && data[i]; i ++)
+		switch (load_state->state) {
+		case subject:
+			if (isblank(data[i])) {
+				load_state->state = object;
+				subjectstr[*label_len] = '\0';
+				*label_len = 0;
+				break;
+			}
+			if (*label_len >= SMK_MAXLEN)
+				goto out;
+			subjectstr[(*label_len) ++] = data[i];
 			break;
-		if (sscanf(cp, "%23s %23s %7s\n", subjectstr, objectstr,
-			   modestr) != 3)
+
+		case object:
+			if (isblank(data[i])) {
+				load_state->state = access;
+				objectstr[*label_len] = '\0';
+				*label_len = 0;
+				break;
+			}
+
+			if (*label_len >= SMK_MAXLEN)
+				goto out;
+			objectstr[(*label_len) ++] = data[i];
 			break;
-		rule.smk_subject = smk_import(subjectstr, 0);
-		if (rule.smk_subject == NULL)
+
+		case access:
+			if (isblank(data[i]) || data[i] == '\n') {
+				load_state->state = eol;
+				/* Let "eol" take control from current char */
+				--i;
+				break;
+			}
+
+			if (data[i] == 'r')
+				rule->smk_access |= MAY_READ;
+			else if (data[i] == 'w')
+				rule->smk_access |= MAY_WRITE;
+			else if (data[i] == 'x')
+				rule->smk_access |= MAY_EXEC;
+			else if (data[i] == 'a')
+				rule->smk_access |= MAY_APPEND;
+			else
+				goto out;
 			break;
-		rule.smk_object = smk_import(objectstr, 0);
-		if (rule.smk_object == NULL)
+
+		case eol:
+			if (isblank(data[i]))
+				break;
+
+			load_state->state = subject;
+			*label_len = 0;
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
-	}
+		}
 
+	rc = count;
+out:
 	kfree(data);
 	return rc;
 }
@@ -251,7 +359,7 @@ static const struct file_operations smk_load_ops = {
 	.read		= seq_read,
 	.llseek         = seq_lseek,
 	.write		= smk_write_load,
-	.release        = seq_release
+	.release        = smk_release_load,
 };
 
 /**
@@ -921,6 +1029,7 @@ static int __init init_smk_fs(void)
 		}
 	}
 
+	sema_init(&smack_write_sem, 1);
 	smk_cipso_doi();
 
 	return err;

--
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
