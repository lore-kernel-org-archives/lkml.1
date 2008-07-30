Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYG3Wha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYG3Wha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYG3WhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:37:20 -0400
Received: from smtp108.prem.mail.sp1.yahoo.com ([98.136.44.63]:36702 "HELO
	smtp108.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752410AbYG3WhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:37:19 -0400
X-YMail-OSG: R9Tu2NQVM1kWAh1wAhPLp0N2y7DOIlaLaBorwWPaxk6WvNQVUC6tPhrz42sRk1TZ_QQ2bExn8j5LpYgCUx.0khZM6O_jV3i5KlcQhiZ8bjqkcYoYwugiT.se3rZqm_5Mx9M7riLPjtsJtKEbOjwiGGGg2mLFn4tCzOAw1n8QFfyGeVKohA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4890ED17.6050305@schaufler-ca.com>
Date: Wed, 30 Jul 2008 15:37:11 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Peter.Wahl@oracle.com
Subject: [PATCH] smack: limit privilege by label
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

There have been a number of requests to make the Smack LSM
enforce MAC even in the face of privilege, either capability
based or superuser based. This is not universally desired,
however, so it seems desirable to make it optional. Further,
at least one legacy OS implemented a scheme whereby only
processes running with one particular label could be exempt
from MAC. This patch supports these three cases.

If /smack/onlycap is empty (unset or null-string) privilege
is enforced in the normal way.

If /smack/onlycap contains a label only processes running with
that label may be MAC exempt.

If the label in /smack/onlycap is the star label ("*") the
semantics of the star label combine with the privilege
restrictions to prevent any violations of MAC, even in the
presence of privilege.

Again, this will be independent of the privilege scheme.



Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 security/smack/smack.h        |    1 
 security/smack/smack_access.c |   10 +++
 security/smack/smackfs.c      |   92 ++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 1 deletion(-)

diff -uprN -X linux-2.6.26/Documentation/dontdiff linux-2.6.26/security/smack/smack_access.c linux-2.6.26-new/security/smack/smack_access.c
--- linux-2.6.26/security/smack/smack_access.c	2008-07-13 14:51:29.000000000 -0700
+++ linux-2.6.26-new/security/smack/smack_access.c	2008-07-18 12:44:49.000000000 -0700
@@ -157,7 +157,7 @@ int smk_access(char *subject_label, char
  *
  * This function checks the current subject label/object label pair
  * in the access rule list and returns 0 if the access is permitted,
- * non zero otherwise. It allows that current my have the capability
+ * non zero otherwise. It allows that current may have the capability
  * to override the rules.
  */
 int smk_curacc(char *obj_label, u32 mode)
@@ -168,6 +168,14 @@ int smk_curacc(char *obj_label, u32 mode
 	if (rc == 0)
 		return 0;
 
+	/*
+	 * Return if a specific label has been designated as the
+	 * only one that gets privilege and current does not
+	 * have that label.
+	 */
+	if (smack_onlycap != NULL && smack_onlycap != current->security)
+		return rc;
+
 	if (capable(CAP_MAC_OVERRIDE))
 		return 0;
 
diff -uprN -X linux-2.6.26/Documentation/dontdiff linux-2.6.26/security/smack/smackfs.c linux-2.6.26-new/security/smack/smackfs.c
--- linux-2.6.26/security/smack/smackfs.c	2008-07-13 14:51:29.000000000 -0700
+++ linux-2.6.26-new/security/smack/smackfs.c	2008-07-19 06:06:50.000000000 -0700
@@ -39,6 +39,7 @@ enum smk_inos {
 	SMK_DIRECT	= 6,	/* CIPSO level indicating direct label */
 	SMK_AMBIENT	= 7,	/* internet ambient label */
 	SMK_NLTYPE	= 8,	/* label scheme to use by default */
+	SMK_ONLYCAP	= 9,	/* the only "capable" label */
 };
 
 /*
@@ -68,6 +69,16 @@ int smack_net_nltype = NETLBL_NLTYPE_CIP
  */
 int smack_cipso_direct = SMACK_CIPSO_DIRECT_DEFAULT;
 
+/*
+ * Unless a process is running with this label even
+ * having CAP_MAC_OVERRIDE isn't enough to grant
+ * privilege to violate MAC policy. If no label is
+ * designated (the NULL case) capabilities apply to
+ * everyone. It is expected that the hat (^) label
+ * will be used if any label is used.
+ */
+char *smack_onlycap;
+
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 struct smk_list_entry *smack_list;
 
@@ -787,6 +798,85 @@ static const struct file_operations smk_
 	.write		= smk_write_ambient,
 };
 
+/**
+ * smk_read_onlycap - read() for /smack/onlycap
+ * @filp: file pointer, not actually used
+ * @buf: where to put the result
+ * @cn: maximum to send along
+ * @ppos: where to start
+ *
+ * Returns number of bytes read or error code, as appropriate
+ */
+static ssize_t smk_read_onlycap(struct file *filp, char __user *buf,
+				size_t cn, loff_t *ppos)
+{
+	char *smack = "";
+	ssize_t rc = -EINVAL;
+	int asize;
+
+	if (*ppos != 0)
+		return 0;
+
+	if (smack_onlycap != NULL)
+		smack = smack_onlycap;
+
+	asize = strlen(smack) + 1;
+
+	if (cn >= asize)
+		rc = simple_read_from_buffer(buf, cn, ppos, smack, asize);
+
+	return rc;
+}
+
+/**
+ * smk_write_onlycap - write() for /smack/onlycap
+ * @filp: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	char in[SMK_LABELLEN];
+	char *sp = current->security;
+
+	if (!capable(CAP_MAC_ADMIN))
+		return -EPERM;
+
+	/*
+	 * This can be done using smk_access() but is done
+	 * explicitly for clarity. The smk_access() implementation
+	 * would use smk_access(smack_onlycap, MAY_WRITE)
+	 */
+	if (smack_onlycap != NULL && smack_onlycap != sp)
+		return -EPERM;
+
+	if (count >= SMK_LABELLEN)
+		return -EINVAL;
+
+	if (copy_from_user(in, buf, count) != 0)
+		return -EFAULT;
+
+	/*
+	 * Should the null string be passed in unset the onlycap value.
+	 * This seems like something to be careful with as usually
+	 * smk_import only expects to return NULL for errors. It
+	 * is usually the case that a nullstring or "\n" would be
+	 * bad to pass to smk_import but in fact this is useful here.
+	 */
+	smack_onlycap = smk_import(in, count);
+
+	return count;
+}
+
+static const struct file_operations smk_onlycap_ops = {
+	.read		= smk_read_onlycap,
+	.write		= smk_write_onlycap,
+};
+
 struct option_names {
 	int	o_number;
 	char	*o_name;
@@ -919,6 +1009,8 @@ static int smk_fill_super(struct super_b
 			{"ambient", &smk_ambient_ops, S_IRUGO|S_IWUSR},
 		[SMK_NLTYPE]	=
 			{"nltype", &smk_nltype_ops, S_IRUGO|S_IWUSR},
+		[SMK_ONLYCAP]	=
+			{"onlycap", &smk_onlycap_ops, S_IRUGO|S_IWUSR},
 		/* last one */ {""}
 	};
 
diff -uprN -X linux-2.6.26/Documentation/dontdiff linux-2.6.26/security/smack/smack.h linux-2.6.26-new/security/smack/smack.h
--- linux-2.6.26/security/smack/smack.h	2008-07-13 14:51:29.000000000 -0700
+++ linux-2.6.26-new/security/smack/smack.h	2008-07-18 12:14:02.000000000 -0700
@@ -178,6 +178,7 @@ u32 smack_to_secid(const char *);
 extern int smack_cipso_direct;
 extern int smack_net_nltype;
 extern char *smack_net_ambient;
+extern char *smack_onlycap;
 
 extern struct smack_known *smack_known;
 extern struct smack_known smack_known_floor;

