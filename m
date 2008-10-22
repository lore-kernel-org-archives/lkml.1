Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYJVDhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYJVDhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYJVDg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:36:59 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:24401 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751126AbYJVDg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:36:56 -0400
X-YMail-OSG: 77BTkv4VM1l8rETrrAAmSXJNN3RQX0Nv693jijn8.FVlIHhJnxQv5aemWlR6aEEMbqZV44ZC9LN077rww1BYnGRdHeR7jlnWBEm0Gt.IrG0zjecXdRkNdUBvgZ8_t1Ir9pv7dnpszh6Fvh_oi0tIqaIbCHr2jPokjCZGBrotbrXgJO1bfC8w0JPPFsWrx8I1gUbzTLo5knb9Sko0tOdPnxCtvCP5WAtKQQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <48FE9FCB.6070202@schaufler-ca.com>
Date: Tue, 21 Oct 2008 20:36:43 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Tilman Baumann <tilman.baumann@collax.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <48DC5A45.8020801@schaufler-ca.com> <E33DFA86-F040-413F-8156-EDCB879F4CEE@collax.com> <48DDBE2E.3010006@schaufler-ca.com> <48E1007F.4000400@collax.com> <48E19D01.9050809@schaufler-ca.com> <48E35F36.4030203@collax.com> <48E3957A.7040201@schaufler-ca.com> <48E3AB97.8020305@collax.com> <48E3BFDE.7010300@schaufler-ca.com> <48EA0B30.6080907@collax.com> <48EACC91.8040008@schaufler-ca.com> <48F8C3EC.1030607@collax.com> <48F8D122.3010105@schaufler-ca.com> <48FC744F.6030507@collax.com>
In-Reply-To: <48FC744F.6030507@collax.com>
Content-Type: multipart/mixed;
 boundary="------------060101040008020100080707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060101040008020100080707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Tilman Baumann wrote:
>> If you're up to trying out something that you know is going to get
>> rewhacked before it goes in anywhere let me know.
>
> Sure. I will be happy to use that.
> Just tell me where to find it and how to use it and what I should look 
> out for.
>

You'll need to start out with Paul Moore's testing tree:

% git clone git://git.infradead.org/users/pcmoore/lblnet-2.6_testing

Apply the attached patch (attachments are discouraged for review purposes,
but this is handier for this purpose) and compile.

This is NOT production code. Again, we're hashing out the netlabel api and
we know that they are going to change. This is demo only. The amount of
testing it's gotten is really small.

I have created a new system label "@", pronounced "at" and referred to as
the internet label. Processes cannot be assigned the internet label. A
subject with the internet label (as identified by a packet thus labeled)
can write to any object and any subject can write to an object thus labeled,
thereby explicitly blowing a hole in the Access Control Policy.

Have fun, let me know what you hit next.

Thank you.




--------------060101040008020100080707
Content-Type: text/plain;
 name="lblnet081021.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lblnet081021.patch"

diff -uprN -X lblnet-2.6_testing/Documentation/dontdiff lblnet-2.6_testing/include/net/netlabel.h lblnet-2.6-1011/include/net/netlabel.h
--- lblnet-2.6_testing/include/net/netlabel.h	2008-10-07 10:56:35.000000000 -0700
+++ lblnet-2.6-1011/include/net/netlabel.h	2008-10-11 06:31:40.000000000 -0700
@@ -356,6 +356,19 @@ static inline void netlbl_secattr_free(s
 int netlbl_cfg_map_del(const char *domain, struct netlbl_audit *audit_info);
 int netlbl_cfg_unlbl_add_map(const char *domain,
 			     struct netlbl_audit *audit_info);
+int netlbl_cfg_unlbl_add_fallback(struct net *net,
+				  const char *dev_name,
+				  const void *addr,
+				  const void *mask,
+				  u16 family,
+				  u32 secid,
+				  struct netlbl_audit *audit_info);
+int netlbl_cfg_unlbl_del_fallback(struct net *net,
+				  const char *dev_name,
+				  const void *addr,
+				  const void *mask,
+				  u16 family,
+				  struct netlbl_audit *audit_info);
 int netlbl_cfg_cipsov4_add_map(struct cipso_v4_doi *doi_def,
 			       const char *domain,
 			       struct netlbl_audit *audit_info);
@@ -412,6 +425,25 @@ static inline int netlbl_cfg_unlbl_add_m
 {
 	return -ENOSYS;
 }
+static inline int netlbl_cfg_unlbl_add_fallback(struct net *net,
+						const char *dev_name,
+						const void *addr,
+						const void *mask,
+						u16 family,
+						u32 secid,
+						struct netlbl_audit *audit_info)
+{
+	return -ENOSYS;
+}
+static inline int netlbl_cfg_unlbl_del_fallback(struct net *net,
+						const char *dev_name,
+						const void *addr,
+						const void *mask,
+						u16 family,
+						struct netlbl_audit *audit_info)
+{
+	return -ENOSYS;
+}
 static inline int netlbl_cfg_cipsov4_add_map(struct cipso_v4_doi *doi_def,
 					     const char *domain,
 					     struct netlbl_audit *audit_info)
diff -uprN -X lblnet-2.6_testing/Documentation/dontdiff lblnet-2.6_testing/net/netlabel/netlabel_kapi.c lblnet-2.6-1011/net/netlabel/netlabel_kapi.c
--- lblnet-2.6_testing/net/netlabel/netlabel_kapi.c	2008-10-07 10:56:46.000000000 -0700
+++ lblnet-2.6-1011/net/netlabel/netlabel_kapi.c	2008-10-11 06:31:40.000000000 -0700
@@ -103,6 +103,92 @@ cfg_unlbl_add_map_failure:
 	return ret_val;
 }
 
+
+/**
+ * netlbl_cfg_unlbl_add_fallback - Adds a new fallback label
+ * @net: network namespace
+ * @dev_name: interface name
+ * @addr: IP address in network byte order (struct in[6]_addr)
+ * @mask: address mask in network byte order (struct in[6]_addr)
+ * @family: address family
+ * @secid: LSM secid value for the entry
+ * @audit_info: NetLabel audit information
+ *
+ * Description:
+ * Adds a new NetLabel static/fallback label to be used when protocol provided
+ * labels are not present on incoming traffic.  If @dev_name is NULL then the
+ * default interface will be used.  Returns zero on success, negative values on
+ * failure.
+ *
+ */
+int netlbl_cfg_unlbl_add_fallback(struct net *net,
+				  const char *dev_name,
+				  const void *addr,
+				  const void *mask,
+				  u16 family,
+				  u32 secid,
+				  struct netlbl_audit *audit_info)
+{
+	u32 addr_len;
+
+	switch (family) {
+	case AF_INET:
+		addr_len = 4;
+		break;
+	case AF_INET6:
+		addr_len = 16;
+		break;
+	default:
+		return -EPFNOSUPPORT;
+	}
+
+	return netlbl_unlhsh_add(net,
+				 dev_name, addr, mask, addr_len,
+				 secid, audit_info);
+}
+
+/**
+ * netlbl_cfg_unlbl_del_fallback - Removes an existing fallback label
+ * @net: network namespace
+ * @dev_name: interface name
+ * @addr: IP address in network byte order (struct in[6]_addr)
+ * @mask: address mask in network byte order (struct in[6]_addr)
+ * @family: address family
+ * @secid: LSM secid value for the entry
+ * @audit_info: NetLabel audit information
+ *
+ * Description:
+ * Removes an existing NetLabel static/fallback label used when protocol
+ * provided labels are not present on incoming traffic.  If @dev_name is NULL
+ * then the default interface will be used.  Returns zero on success, negative
+ * values on failure.
+ *
+ */
+int netlbl_cfg_unlbl_del_fallback(struct net *net,
+				  const char *dev_name,
+				  const void *addr,
+				  const void *mask,
+				  u16 family,
+				  struct netlbl_audit *audit_info)
+{
+	u32 addr_len;
+
+	switch (family) {
+	case AF_INET:
+		addr_len = 4;
+		break;
+	case AF_INET6:
+		addr_len = 16;
+		break;
+	default:
+		return -EPFNOSUPPORT;
+	}
+
+	return netlbl_unlhsh_remove(net,
+				    dev_name, addr, mask, addr_len,
+				    audit_info);
+}
+
 /**
  * netlbl_cfg_cipsov4_add_map - Add a new CIPSOv4 DOI definition and mapping
  * @doi_def: the DOI definition
diff -uprN -X lblnet-2.6_testing/Documentation/dontdiff lblnet-2.6_testing/net/netlabel/netlabel_unlabeled.c lblnet-2.6-1011/net/netlabel/netlabel_unlabeled.c
--- lblnet-2.6_testing/net/netlabel/netlabel_unlabeled.c	2008-10-07 10:56:46.000000000 -0700
+++ lblnet-2.6-1011/net/netlabel/netlabel_unlabeled.c	2008-10-11 06:31:40.000000000 -0700
@@ -450,13 +450,13 @@ add_iface_failure:
  * success, negative values on failure.
  *
  */
-static int netlbl_unlhsh_add(struct net *net,
-			     const char *dev_name,
-			     const void *addr,
-			     const void *mask,
-			     u32 addr_len,
-			     u32 secid,
-			     struct netlbl_audit *audit_info)
+int netlbl_unlhsh_add(struct net *net,
+		      const char *dev_name,
+		      const void *addr,
+		      const void *mask,
+		      u32 addr_len,
+		      u32 secid,
+		      struct netlbl_audit *audit_info)
 {
 	int ret_val;
 	int ifindex;
@@ -716,12 +716,12 @@ unlhsh_condremove_failure:
  * Returns zero on success, negative values on failure.
  *
  */
-static int netlbl_unlhsh_remove(struct net *net,
-				const char *dev_name,
-				const void *addr,
-				const void *mask,
-				u32 addr_len,
-				struct netlbl_audit *audit_info)
+int netlbl_unlhsh_remove(struct net *net,
+			 const char *dev_name,
+			 const void *addr,
+			 const void *mask,
+			 u32 addr_len,
+			 struct netlbl_audit *audit_info)
 {
 	int ret_val;
 	struct net_device *dev;
diff -uprN -X lblnet-2.6_testing/Documentation/dontdiff lblnet-2.6_testing/net/netlabel/netlabel_unlabeled.h lblnet-2.6-1011/net/netlabel/netlabel_unlabeled.h
--- lblnet-2.6_testing/net/netlabel/netlabel_unlabeled.h	2008-10-07 10:56:46.000000000 -0700
+++ lblnet-2.6-1011/net/netlabel/netlabel_unlabeled.h	2008-10-11 06:31:40.000000000 -0700
@@ -221,6 +221,21 @@ int netlbl_unlabel_genl_init(void);
 /* General Unlabeled init function */
 int netlbl_unlabel_init(u32 size);
 
+/* Static/Fallback label management functions */
+int netlbl_unlhsh_add(struct net *net,
+		      const char *dev_name,
+		      const void *addr,
+		      const void *mask,
+		      u32 addr_len,
+		      u32 secid,
+		      struct netlbl_audit *audit_info);
+int netlbl_unlhsh_remove(struct net *net,
+			 const char *dev_name,
+			 const void *addr,
+			 const void *mask,
+			 u32 addr_len,
+			 struct netlbl_audit *audit_info);
+
 /* Process Unlabeled incoming network packets */
 int netlbl_unlabel_getattr(const struct sk_buff *skb,
 			   u16 family,
diff -uprN -X lblnet-2.6_testing/Documentation/dontdiff lblnet-2.6_testing/security/smack/smack_access.c lblnet-2.6-1011/security/smack/smack_access.c
--- lblnet-2.6_testing/security/smack/smack_access.c	2008-10-07 10:56:47.000000000 -0700
+++ lblnet-2.6-1011/security/smack/smack_access.c	2008-10-11 06:31:40.000000000 -0700
@@ -57,7 +57,14 @@ struct smack_known smack_known_invalid =
 	.smk_cipso	= NULL,
 };
 
-struct smack_known *smack_known = &smack_known_invalid;
+struct smack_known smack_known_internet = {
+	.smk_next	= &smack_known_invalid,
+	.smk_known	= "@",
+	.smk_secid	= 7,
+	.smk_cipso	= NULL,
+};
+
+struct smack_known *smack_known = &smack_known_internet;
 
 /*
  * The initial value needs to be bigger than any of the
@@ -99,6 +106,16 @@ int smk_access(char *subject_label, char
 	    strcmp(subject_label, smack_known_star.smk_known) == 0)
 		return -EACCES;
 	/*
+	 * An internet object can be accessed by any subject.
+	 * Tasks cannot be assigned the internet label.
+	 * An internet subject can access any object.
+	 */
+	if (object_label == smack_known_internet.smk_known ||
+	    subject_label == smack_known_internet.smk_known ||
+	    strcmp(object_label, smack_known_internet.smk_known) == 0 ||
+	    strcmp(subject_label, smack_known_internet.smk_known) == 0)
+		return 0;
+	/*
 	 * A star object can be accessed by any subject.
 	 */
 	if (object_label == smack_known_star.smk_known ||
diff -uprN -X lblnet-2.6_testing/Documentation/dontdiff lblnet-2.6_testing/security/smack/smackfs.c lblnet-2.6-1011/security/smack/smackfs.c
--- lblnet-2.6_testing/security/smack/smackfs.c	2008-10-07 10:56:47.000000000 -0700
+++ lblnet-2.6-1011/security/smack/smackfs.c	2008-10-12 12:59:36.000000000 -0700
@@ -20,6 +20,7 @@
 #include <linux/vmalloc.h>
 #include <linux/security.h>
 #include <linux/mutex.h>
+#include <net/net_namespace.h>
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
 #include <linux/seq_file.h>
@@ -39,6 +40,8 @@ enum smk_inos {
 	SMK_DIRECT	= 6,	/* CIPSO level indicating direct label */
 	SMK_AMBIENT	= 7,	/* internet ambient label */
 	SMK_NLTYPE	= 8,	/* label scheme to use by default */
+	SMK_ONLYCAP	= 9,	/* the only "capable" label */
+	SMK_SLHOST	= 10,	/* single label hosts */
 };
 
 /*
@@ -47,6 +50,7 @@ enum smk_inos {
 static DEFINE_MUTEX(smack_list_lock);
 static DEFINE_MUTEX(smack_cipso_lock);
 static DEFINE_MUTEX(smack_ambient_lock);
+static DEFINE_MUTEX(smk_slhost_lock);
 
 /*
  * This is the "ambient" label for network traffic.
@@ -68,6 +72,23 @@ int smack_net_nltype = NETLBL_NLTYPE_CIP
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
+/*
+ * Certain IP addresses may be designated as single label hosts.
+ * Packets are sent there unlabeled, but only from tasks that
+ * can write to the specified label.
+ */
+struct smk_slhost *smack_slhosts;
+
 static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 struct smk_list_entry *smack_list;
 
@@ -93,6 +114,13 @@ struct smk_list_entry *smack_list;
 #define SMK_ACCESSLEN (sizeof(SMK_ACCESS) - 1)
 #define SMK_LOADLEN   (SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSLEN)
 
+/*
+ * Values for parsing single label host rules
+ * "1.2.3.4 X"
+ * "192.168.138.129 abcdefghijklmnopqrstuvw"
+ */
+#define SMK_SLHOSTMIN	9
+#define SMK_SLHOSTMAX	39
 
 /*
  * Seq_file read operations for /smack/load
@@ -580,6 +608,196 @@ static const struct file_operations smk_
 	.release        = seq_release,
 };
 
+/*
+ * Seq_file read operations for /smack/slhost
+ */
+
+static void *slhost_seq_start(struct seq_file *s, loff_t *pos)
+{
+	if (*pos == SEQ_READ_FINISHED)
+		return NULL;
+
+	return smack_slhosts;
+}
+
+static void *slhost_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct smk_slhost *skp = ((struct smk_slhost *) v)->smk_next;
+
+	if (skp == NULL)
+		*pos = SEQ_READ_FINISHED;
+
+	return skp;
+}
+
+/*
+ * Print host/label pairs
+ */
+static int slhost_seq_show(struct seq_file *s, void *v)
+{
+	struct smk_slhost *skp = (struct smk_slhost *) v;
+	unsigned char *hp = (char *) &skp->smk_host.sin_addr.s_addr;
+
+	seq_printf(s, "%u.%u.%u.%u %s\n", hp[0], hp[1], hp[2], hp[3],
+		skp->smk_label);
+
+	return 0;
+}
+
+static void slhost_seq_stop(struct seq_file *s, void *v)
+{
+	/* No-op */
+}
+
+static struct seq_operations slhost_seq_ops = {
+	.start = slhost_seq_start,
+	.stop  = slhost_seq_stop,
+	.next  = slhost_seq_next,
+	.show  = slhost_seq_show,
+};
+
+/**
+ * smk_open_slhost - open() for /smack/slhost
+ * @inode: inode structure representing file
+ * @file: "slhost" file pointer
+ *
+ * Connect our slhost_seq_* operations with /smack/slhost
+ * file_operations
+ */
+static int smk_open_slhost(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &slhost_seq_ops);
+}
+
+/**
+ * smk_write_slhost - write() for /smack/slhost
+ * @filp: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Accepts only one slhost per write call.
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t smk_write_slhost(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct smk_slhost *skp;
+	struct sockaddr_in newname;
+	char smack[SMK_LABELLEN];
+	char *sp;
+	char data[SMK_SLHOSTMAX];
+	char *host = (char *)&newname.sin_addr.s_addr;
+	int rc;
+	int replace = 1;
+	struct netlbl_audit audit_info;
+	struct in_addr mask;
+	unsigned int m = 32;
+	__be32 bebits = 0x80000000;
+	__be32 nsa;
+
+	/*
+	 * Must have privilege.
+	 * No partial writes.
+	 * Enough data must be present.
+	 * "<addr, as a.b.c.d><space><label>"
+	 */
+	if (!capable(CAP_MAC_ADMIN))
+		return -EPERM;
+	if (*ppos != 0)
+		return -EINVAL;
+	if (count < SMK_SLHOSTMIN || count > SMK_SLHOSTMAX)
+		return -EINVAL;
+	if (copy_from_user(data, buf, count) != 0)
+		return -EFAULT;
+
+	data[count] = '\0';
+
+	rc = sscanf(data, "%hhd.%hhd.%hhd.%hhd/%d %s",
+		&host[0], &host[1], &host[2], &host[3], &m, smack);
+	if (rc != 6) {
+		rc = sscanf(data, "%hhd.%hhd.%hhd.%hhd %s",
+			&host[0], &host[1], &host[2], &host[3], smack);
+		if (rc != 5)
+			return -EINVAL;
+	}
+	if (m > 32)
+		return -EINVAL;
+
+	sp = smk_import(smack, 0);
+	if (sp == NULL)
+		return -EINVAL;
+
+	for (mask.s_addr = 0; m > 0; m--) {
+		mask.s_addr |= bebits;
+		bebits >>= 1;
+	}
+	/*
+	 * Only allow one writer at a time. Writes should be
+	 * quite rare and small in any case.
+	 */
+	mutex_lock(&smk_slhost_lock);
+
+	nsa = newname.sin_addr.s_addr;
+	for (skp = smack_slhosts; skp != NULL; skp = skp->smk_next)
+		if (skp->smk_host.sin_addr.s_addr == nsa &&
+		    skp->smk_mask.s_addr == mask.s_addr)
+			break;
+
+	/*
+	 * The else clause is necessary because the label must
+	 * be set before the entry is added to the list
+	 */
+	if (skp == NULL) {
+		skp = kzalloc(sizeof(*skp), GFP_KERNEL);
+		if (skp == NULL) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		skp->smk_host.sin_addr.s_addr = newname.sin_addr.s_addr;
+		skp->smk_mask.s_addr = mask.s_addr;
+		skp->smk_next = smack_slhosts;
+		skp->smk_label = sp;
+		smack_slhosts = skp;
+		replace = 0;
+	} else
+		skp->smk_label = sp;
+
+	/*
+	 * Now tell netlabel about the single label nature of
+	 * this host so that incoming packets get labeled.
+	 */
+	audit_info.loginuid = audit_get_loginuid(current);
+	audit_info.sessionid = audit_get_sessionid(current);
+	audit_info.secid = smack_to_secid(current->security);
+
+	if (replace) {
+		rc = netlbl_cfg_unlbl_del_fallback(&init_net, NULL,
+			&skp->smk_host.sin_addr, &skp->smk_mask,
+			PF_INET, &audit_info);
+		if (rc != 0)
+			goto out;
+	}
+
+	rc = netlbl_cfg_unlbl_add_fallback(&init_net, NULL,
+		&skp->smk_host.sin_addr, &skp->smk_mask, PF_INET,
+		smack_to_secid(skp->smk_label), &audit_info);
+
+	if (rc == 0)
+		rc = count;
+out:
+	mutex_unlock(&smk_slhost_lock);
+	return rc;
+}
+
+static const struct file_operations smk_slhost_ops = {
+	.open           = smk_open_slhost,
+	.read		= seq_read,
+	.llseek         = seq_lseek,
+	.write		= smk_write_slhost,
+	.release        = seq_release,
+};
+
 /**
  * smk_read_doi - read() for /smack/doi
  * @filp: file pointer, not actually used
@@ -789,6 +1007,85 @@ static const struct file_operations smk_
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
@@ -921,6 +1218,10 @@ static int smk_fill_super(struct super_b
 			{"ambient", &smk_ambient_ops, S_IRUGO|S_IWUSR},
 		[SMK_NLTYPE]	=
 			{"nltype", &smk_nltype_ops, S_IRUGO|S_IWUSR},
+		[SMK_ONLYCAP]	=
+			{"onlycap", &smk_onlycap_ops, S_IRUGO|S_IWUSR},
+		[SMK_SLHOST]	=
+			{"slhost", &smk_slhost_ops, S_IRUGO|S_IWUSR},
 		/* last one */ {""}
 	};
 
diff -uprN -X lblnet-2.6_testing/Documentation/dontdiff lblnet-2.6_testing/security/smack/smack.h lblnet-2.6-1011/security/smack/smack.h
--- lblnet-2.6_testing/security/smack/smack.h	2008-10-07 10:56:47.000000000 -0700
+++ lblnet-2.6-1011/security/smack/smack.h	2008-10-12 06:17:19.000000000 -0700
@@ -16,6 +16,7 @@
 #include <linux/capability.h>
 #include <linux/spinlock.h>
 #include <linux/security.h>
+#include <linux/in.h>
 #include <net/netlabel.h>
 
 /*
@@ -39,6 +40,7 @@ struct superblock_smack {
 struct socket_smack {
 	char		*smk_out;			/* outbound label */
 	char		*smk_in;			/* inbound label */
+	int		smk_labeled;			/* label scheme */
 	char		smk_packet[SMK_LABELLEN];	/* TCP peer label */
 };
 
@@ -80,6 +82,16 @@ struct smack_cipso {
 };
 
 /*
+ * An entry in the table identifying single label hosts.
+ */
+struct smk_slhost {
+	struct smk_slhost	*smk_next;
+	struct sockaddr_in	smk_host;	/* network address */
+	struct in_addr		smk_mask;	/* network mask */
+	char			*smk_label;	/* label */
+};
+
+/*
  * This is the repository for labels seen so that it is
  * not necessary to keep allocating tiny chuncks of memory
  * and so that they can be shared.
@@ -127,7 +139,20 @@ struct smack_known {
 #define XATTR_NAME_SMACKIPOUT	XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT
 
 /*
- * smackfs macic number
+ * How communications on this socket are treated.
+ * Usually it's determined by the underlying netlabel code
+ * but there are certain cases, including single label hosts
+ * and potentially single label interfaces for which the
+ * treatment can not be known in advance.
+ *
+ * The possibility of additional labeling schemes being
+ * introduced in the future exists as well.
+ */
+#define SMACK_UNLABELED_SOCKET	0
+#define SMACK_CIPSO_SOCKET	1
+
+/*
+ * smackfs magic number
  */
 #define SMACK_MAGIC	0x43415d53 /* "SMAC" */
 
@@ -178,6 +203,7 @@ u32 smack_to_secid(const char *);
 extern int smack_cipso_direct;
 extern int smack_net_nltype;
 extern char *smack_net_ambient;
+extern char *smack_onlycap;
 
 extern struct smack_known *smack_known;
 extern struct smack_known smack_known_floor;
@@ -186,8 +212,10 @@ extern struct smack_known smack_known_hu
 extern struct smack_known smack_known_invalid;
 extern struct smack_known smack_known_star;
 extern struct smack_known smack_known_unset;
+extern struct smack_known smack_known_internet;
 
 extern struct smk_list_entry *smack_list;
+extern struct smk_slhost *smack_slhosts;
 extern struct security_operations smack_ops;
 
 /*
diff -uprN -X lblnet-2.6_testing/Documentation/dontdiff lblnet-2.6_testing/security/smack/smack_lsm.c lblnet-2.6-1011/security/smack/smack_lsm.c
--- lblnet-2.6_testing/security/smack/smack_lsm.c	2008-10-07 10:56:47.000000000 -0700
+++ lblnet-2.6-1011/security/smack/smack_lsm.c	2008-10-11 06:31:40.000000000 -0700
@@ -1232,6 +1232,7 @@ static int smack_sk_alloc_security(struc
 
 	ssp->smk_in = csp;
 	ssp->smk_out = csp;
+	ssp->smk_labeled = SMACK_CIPSO_SOCKET;
 	ssp->smk_packet[0] = '\0';
 
 	sk->sk_security = ssp;
@@ -1318,23 +1319,50 @@ static void smack_to_secattr(char *smack
 /**
  * smack_netlabel - Set the secattr on a socket
  * @sk: the socket
+ * @labeled: socket label scheme
  *
  * Convert the outbound smack value (smk_out) to a
  * secattr and attach it to the socket.
  *
  * Returns 0 on success or an error code
  */
-static int smack_netlabel(struct sock *sk)
+static int smack_netlabel(struct sock *sk, int labeled)
 {
 	struct socket_smack *ssp;
 	struct netlbl_lsm_secattr secattr;
-	int rc;
+	int rc = 0;
 
 	ssp = sk->sk_security;
-	netlbl_secattr_init(&secattr);
-	smack_to_secattr(ssp->smk_out, &secattr);
-	rc = netlbl_sock_setattr(sk, &secattr);
-	netlbl_secattr_destroy(&secattr);
+	/*
+	 * Usually the netlabel code will handle changing the
+	 * packet labeling based on the label.
+	 * The case of a single label host is different, because
+	 * a single label host should never get a labeled packet
+	 * even though the label is usually associated with a packet
+	 * label.
+	 */
+	local_bh_disable();
+	bh_lock_sock_nested(sk);
+
+	if (ssp->smk_out == smack_net_ambient ||
+	    labeled == SMACK_UNLABELED_SOCKET)
+		netlbl_sock_delattr(sk);
+	else {
+		netlbl_secattr_init(&secattr);
+		smack_to_secattr(ssp->smk_out, &secattr);
+		rc = netlbl_sock_setattr(sk, &secattr);
+		netlbl_secattr_destroy(&secattr);
+	}
+
+	bh_unlock_sock(sk);
+	local_bh_enable();
+	/*
+	 * Remember the label scheme used so that it is not
+	 * necessary to do the netlabel setting if it has not
+	 * changed the next time through.
+	 */
+	if (rc == 0)
+		ssp->smk_labeled = labeled;
 
 	return rc;
 }
@@ -1387,7 +1415,7 @@ static int smack_inode_setsecurity(struc
 		ssp->smk_in = sp;
 	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0) {
 		ssp->smk_out = sp;
-		rc = smack_netlabel(sock->sk);
+		rc = smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
 		if (rc != 0)
 			printk(KERN_WARNING "Smack: \"%s\" netlbl error %d.\n",
 			       __func__, -rc);
@@ -1417,7 +1445,69 @@ static int smack_socket_post_create(stru
 	/*
 	 * Set the outbound netlbl.
 	 */
-	return smack_netlabel(sock->sk);
+	return smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
+}
+
+
+/**
+ * smack_host_label - check host based restrictions
+ * @sip: the object end
+ *
+ * looks for host based access restrictions
+ *
+ * Returns the label of the far end or NULL if it's not special.
+ */
+static char *smack_host_label(struct sockaddr_in *sip)
+{
+	struct smk_slhost *slp;
+
+	if (sip->sin_addr.s_addr == 0)
+		return NULL;
+
+	for (slp = smack_slhosts; slp != NULL; slp = slp->smk_next)
+		if (slp->smk_host.sin_addr.s_addr == sip->sin_addr.s_addr)
+			return slp->smk_label;
+
+	return NULL;
+}
+
+/**
+ * smack_socket_connect - connect access check
+ * @sock: the socket
+ * @sap: the other end
+ * @addrlen: size of sap
+ *
+ * Verifies that a connection may be possible
+ *
+ * Returns 0 on success, and error code otherwise
+ */
+static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
+				int addrlen)
+{
+	struct socket_smack *ssp = sock->sk->sk_security;
+	char *hostsp;
+	int rc;
+
+	if (sock->sk == NULL || sock->sk->sk_family != PF_INET)
+		return 0;
+
+	if (addrlen < sizeof(struct sockaddr_in))
+		return -EINVAL;
+
+	hostsp = smack_host_label((struct sockaddr_in *)sap);
+	if (hostsp == NULL) {
+		if (ssp->smk_labeled != SMACK_CIPSO_SOCKET)
+			return smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
+		return 0;
+	}
+
+	rc = smk_access(ssp->smk_out, hostsp, MAY_WRITE);
+	if (rc != 0)
+		return rc;
+
+	if (ssp->smk_labeled != SMACK_UNLABELED_SOCKET)
+		return smack_netlabel(sock->sk, SMACK_UNLABELED_SOCKET);
+	return 0;
 }
 
 /**
@@ -2055,6 +2145,12 @@ static int smack_setprocattr(struct task
 	if (newsmack == NULL)
 		return -EINVAL;
 
+	/*
+	 * No process is ever allowed the internet ("@") label.
+	 */
+	if (newsmack == smack_known_internet.smk_known)
+		return -EPERM;
+
 	p->security = newsmack;
 	return size;
 }
@@ -2094,6 +2190,49 @@ static int smack_unix_may_send(struct so
 }
 
 /**
+ * smack_socket_sendmsg - Smack check based on destination host
+ * @sock: the socket
+ * @msghdr: the message
+ * @size: the size of the message
+ *
+ * Return 0 if the current subject can write to the destination
+ * host. This is only a question if the destination is a single
+ * label host.
+ */
+static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
+				int size)
+{
+	struct sockaddr_in *sip = (struct sockaddr_in *) msg->msg_name;
+	struct socket_smack *ssp = sock->sk->sk_security;
+	char *hostsp;
+	int rc;
+
+	/*
+	 * Perfectly reasonable for this to be NULL
+	 */
+	if (sip == NULL || sip->sin_family != PF_INET)
+		return 0;
+
+	hostsp = smack_host_label(sip);
+	if (hostsp == NULL) {
+		if (ssp->smk_labeled != SMACK_CIPSO_SOCKET)
+			return smack_netlabel(sock->sk, SMACK_CIPSO_SOCKET);
+		return 0;
+	}
+
+	rc = smk_access(ssp->smk_out, hostsp, MAY_WRITE);
+	if (rc != 0)
+		return rc;
+
+	if (ssp->smk_labeled != SMACK_UNLABELED_SOCKET)
+		return smack_netlabel(sock->sk, SMACK_UNLABELED_SOCKET);
+
+	return 0;
+
+}
+
+
+/**
  * smack_from_secattr - Convert a netlabel attr.mls.lvl/attr.mls.cat
  * 	pair to smack
  * @sap: netlabel secattr
@@ -2104,44 +2243,61 @@ static int smack_unix_may_send(struct so
 static void smack_from_secattr(struct netlbl_lsm_secattr *sap, char *sip)
 {
 	char smack[SMK_LABELLEN];
+	char *sp;
 	int pcat;
 
-	if ((sap->flags & NETLBL_SECATTR_MLS_LVL) == 0) {
+	if ((sap->flags & NETLBL_SECATTR_MLS_LVL) != 0) {
 		/*
-		 * If there are flags but no level netlabel isn't
-		 * behaving the way we expect it to.
+		 * Looks like a CIPSO packet.
 		 *
-		 * Without guidance regarding the smack value
-		 * for the packet fall back on the network
-		 * ambient value.
+		 * Get the categories, if any
 		 */
-		strncpy(sip, smack_net_ambient, SMK_MAXLEN);
+		memset(smack, '\0', SMK_LABELLEN);
+		if ((sap->flags & NETLBL_SECATTR_MLS_CAT) != 0)
+			for (pcat = -1;;) {
+				pcat = netlbl_secattr_catmap_walk(
+					sap->attr.mls.cat, pcat + 1);
+				if (pcat < 0)
+					break;
+				smack_catset_bit(pcat, smack);
+			}
+		/*
+		 * If it is CIPSO using smack direct mapping
+		 * we are already done. WeeHee.
+		 */
+		if (sap->attr.mls.lvl == smack_cipso_direct) {
+			memcpy(sip, smack, SMK_MAXLEN);
+			return;
+		}
+		/*
+		 * Look it up in the supplied table if it is not
+		 * a direct mapping.
+		 */
+		smack_from_cipso(sap->attr.mls.lvl, smack, sip);
 		return;
 	}
-	/*
-	 * Get the categories, if any
-	 */
-	memset(smack, '\0', SMK_LABELLEN);
-	if ((sap->flags & NETLBL_SECATTR_MLS_CAT) != 0)
-		for (pcat = -1;;) {
-			pcat = netlbl_secattr_catmap_walk(sap->attr.mls.cat,
-							  pcat + 1);
-			if (pcat < 0)
-				break;
-			smack_catset_bit(pcat, smack);
-		}
-	/*
-	 * If it is CIPSO using smack direct mapping
-	 * we are already done. WeeHee.
-	 */
-	if (sap->attr.mls.lvl == smack_cipso_direct) {
-		memcpy(sip, smack, SMK_MAXLEN);
+	if ((sap->flags & NETLBL_SECATTR_SECID) != 0) {
+		/*
+		 * Looks like a fallback, which gives us a secid.
+		 */
+		sp = smack_from_secid(sap->attr.secid);
+		/*
+		 * This has got to be a bug because it is
+		 * impossible to specify a fallback without
+		 * specifying the label, which will ensure
+		 * it has a secid, and the only way to get a
+		 * secid is from a fallback.
+		 */
+		BUG_ON(sp == NULL);
+		strncpy(sip, sp, SMK_MAXLEN);
 		return;
 	}
 	/*
-	 * Look it up in the supplied table if it is not a direct mapping.
+	 * Without guidance regarding the smack value
+	 * for the packet fall back on the network
+	 * ambient value.
 	 */
-	smack_from_cipso(sap->attr.mls.lvl, smack, sip);
+	strncpy(sip, smack_net_ambient, SMK_MAXLEN);
 	return;
 }
 
@@ -2157,6 +2313,7 @@ static int smack_socket_sock_rcv_skb(str
 	struct netlbl_lsm_secattr secattr;
 	struct socket_smack *ssp = sk->sk_security;
 	char smack[SMK_LABELLEN];
+	char *csp;
 	int rc;
 
 	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
@@ -2165,21 +2322,25 @@ static int smack_socket_sock_rcv_skb(str
 	/*
 	 * Translate what netlabel gave us.
 	 */
-	memset(smack, '\0', SMK_LABELLEN);
 	netlbl_secattr_init(&secattr);
+
 	rc = netlbl_skbuff_getattr(skb, sk->sk_family, &secattr);
-	if (rc == 0)
+	if (rc == 0) {
+		memset(smack, '\0', SMK_LABELLEN);
 		smack_from_secattr(&secattr, smack);
-	else
-		strncpy(smack, smack_net_ambient, SMK_MAXLEN);
+		csp = smack;
+	} else
+		csp = smack_net_ambient;
+
 	netlbl_secattr_destroy(&secattr);
+
 	/*
 	 * Receiving a packet requires that the other end
 	 * be able to write here. Read access is not required.
 	 * This is the simplist possible security model
 	 * for networking.
 	 */
-	rc = smk_access(smack, ssp->smk_in, MAY_WRITE);
+	rc = smk_access(csp, ssp->smk_in, MAY_WRITE);
 	if (rc != 0)
 		netlbl_skbuff_err(skb, rc, 0);
 	return rc;
@@ -2292,7 +2453,7 @@ static void smack_sock_graft(struct sock
 	ssp->smk_out = current->security;
 	ssp->smk_packet[0] = '\0';
 
-	rc = smack_netlabel(sk);
+	rc = smack_netlabel(sk, SMACK_CIPSO_SOCKET);
 	if (rc != 0)
 		printk(KERN_WARNING "Smack: \"%s\" netlbl error %d.\n",
 		       __func__, -rc);
@@ -2683,6 +2844,8 @@ struct security_operations smack_ops = {
 	.unix_may_send = 		smack_unix_may_send,
 
 	.socket_post_create = 		smack_socket_post_create,
+	.socket_connect =		smack_socket_connect,
+	.socket_sendmsg =		smack_socket_sendmsg,
 	.socket_sock_rcv_skb = 		smack_socket_sock_rcv_skb,
 	.socket_getpeersec_stream =	smack_socket_getpeersec_stream,
 	.socket_getpeersec_dgram =	smack_socket_getpeersec_dgram,

--------------060101040008020100080707--
