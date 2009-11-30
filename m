Return-Path: <linux-kernel-owner+w=401wt.eu-S1752305AbZK3Vxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbZK3Vxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZK3Vxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:53:49 -0500
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:42425 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZK3Vxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:53:48 -0500
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 16:53:47 EST
Subject: [PATCH] Dynamic port labeling V2
From: Paul Nuzzi <pjnuzzi@tycho.ncsc.mil>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org,
       selinux@tycho.nsa.gov, "George S. Coker, II" <gscoker@alpha.ncsc.mil>,
       Eamon Walsh <ewalsh@tycho.nsa.gov>, Stephen Smalley <sds@tycho.nsa.gov>
Content-Type: text/plain
Date: Mon, 30 Nov 2009 16:27:40 -0500
Message-Id: <1259616460.2444.9.camel@moss-stripedbass.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second version of the dynamic port labeling patch.  Changed the name of
the selinuxfs interface to portcon and changed the interface to only
allow five arguments instead of the variable four or five.   

Added a mechanism to add/delete/update port labels with an interface in 
the selinuxfs filesystem.  This will give administrators the ability to
update port labels faster than reloading the entire policy with
semanage.  The administrator will also need less privilege since they
don't have to be authorized to reload the full policy.

A listing of all port labels will be output if the file /selinux/portcon
is read.  Labels could be added or deleted with the following commands 

echo -n "del system_u:object_r:ssh_port_t:s0 6 22 22" > /selinux/portcon
echo -n "add system_u:object_r:telnetd_port_t:s0 6 22 22" > /selinux/portcon

Labels can be atomically changed with the add command.  


Signed-off-by: Paul Nuzzi <pjnuzzi@tycho.ncsc.mil>

--- 
 security/selinux/hooks.c            |    1
 security/selinux/include/classmap.h |    2
 security/selinux/include/security.h |    9 ++
 security/selinux/selinuxfs.c        |   96 ++++++++++++++++++++++
 security/selinux/ss/services.c      |  154 ++++++++++++++++++++++++++++++++++++
 5 files changed, 260 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a29d661..5aceb74 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1224,7 +1224,6 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 	struct inode_security_struct *isec = inode->i_security;
 	u32 sid;
 	struct dentry *dentry;
-#define INITCONTEXTLEN 255
 	char *context = NULL;
 	unsigned len = 0;
 	int rc = 0;
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 8b32e95..925edb6 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -16,7 +16,7 @@ struct security_class_mapping secclass_map[] = {
 	  { "compute_av", "compute_create", "compute_member",
 	    "check_context", "load_policy", "compute_relabel",
 	    "compute_user", "setenforce", "setbool", "setsecparam",
-	    "setcheckreqprot", NULL } },
+	    "setcheckreqprot", "portcon", NULL } },
 	{ "process",
 	  { "fork", "transition", "sigchld", "sigkill",
 	    "sigstop", "signull", "signal", "ptrace", "getsched", "setsched",
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 2553266..25a5054 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -169,6 +169,15 @@ int security_fs_use(const char *fstype, unsigned int *behavior,
 int security_genfs_sid(const char *fstype, char *name, u16 sclass,
 	u32 *sid);
 
+int security_ocon_port_add(u16 protocol, u16 low, u16 high, u32 sid,
+			   char *scontext);
+
+int security_ocon_port_del(u16 protocol, u16 low, u16 high, u32 sid,
+			   char *scontext);
+
+int security_ocon_port_read(char **buf);
+#define INITCONTEXTLEN 255
+
 #ifdef CONFIG_NETLABEL
 int security_netlbl_secattr_to_sid(struct netlbl_lsm_secattr *secattr,
 				   u32 *sid);
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index fab36fd..a21be6c 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -110,6 +110,7 @@ enum sel_inos {
 	SEL_COMPAT_NET,	/* whether to use old compat network packet controls */
 	SEL_REJECT_UNKNOWN, /* export unknown reject handling to userspace */
 	SEL_DENY_UNKNOWN, /* export unknown deny handling to userspace */
+	SEL_OCON_PORT,  /* add OCON_PORT to the list */
 	SEL_INO_NEXT,	/* The next inode number to use */
 };
 
@@ -253,6 +254,100 @@ static const struct file_operations sel_disable_ops = {
 	.write		= sel_write_disable,
 };
 
+static ssize_t sel_write_ocon_port(struct file *file, const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	ssize_t length;
+	unsigned int low = 0, high = 0, protocol = 0;
+	char *page, *scontext, *command;
+	u32 sid;
+#define OCONCOMMANDLEN 4
+#define OCON_ADD_COMMAND "add"
+#define OCON_DEL_COMMAND "del"
+
+	length = task_has_security(current, SECURITY__PORTCON);
+	if (length)
+		return length;
+
+	if (count >= PAGE_SIZE)
+		return -ENOMEM;
+	if (*ppos != 0) {
+		/* No partial writes. */
+		return -EINVAL;
+	}
+	page = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!page)
+		goto nomem;
+	scontext = kzalloc(INITCONTEXTLEN, GFP_KERNEL);
+	if (!scontext)
+		goto nomem1;
+	command = kzalloc(OCONCOMMANDLEN, GFP_KERNEL);
+	if (!command)
+		goto nomem2;
+
+	length = -EFAULT;
+	if (copy_from_user(page, buf, count))
+		goto out;
+
+	length = sscanf(page, "%3s %255s %u %u %u", command, scontext,
+			 &protocol, &low, &high);
+	if (length < 5) {
+		length = -EINVAL;
+		goto out;
+	}
+	length = security_context_to_sid(scontext, strlen(scontext), &sid);
+	if (length < 0) {
+		length = -EINVAL;
+		goto out;
+	}
+
+	if (strncmp(OCON_ADD_COMMAND, command, strlen(OCON_ADD_COMMAND)) == 0)
+		length = security_ocon_port_add(protocol, low, high, sid,
+						 scontext);
+	else if (strncmp(OCON_DEL_COMMAND, command, strlen(OCON_DEL_COMMAND))
+		 == 0)
+		length = security_ocon_port_del(protocol, low, high, sid,
+						scontext);
+	else {
+		length = -EINVAL;
+		goto out;
+	}
+	if (length < 0)
+		goto out;
+	length = count;
+out:
+	kfree(command);
+	kfree(scontext);
+	free_page((unsigned long) page);
+	return length;
+
+nomem2:
+	kfree(scontext);
+nomem1:
+	free_page((unsigned long) page);
+nomem:
+	return -ENOMEM;
+}
+
+static ssize_t sel_read_ocon_port(struct file *filp, char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	ssize_t length;
+	char *buf_tmp = NULL;
+
+	length = task_has_security(current, SECURITY__PORTCON);
+	if (length)
+		return length;
+
+	length = security_ocon_port_read(&buf_tmp);
+	return simple_read_from_buffer(buf, count, ppos, buf_tmp, length);
+}
+
+static const struct file_operations sel_ocon_port_ops = {
+	.write		= sel_write_ocon_port,
+	.read		= sel_read_ocon_port,
+};
+
 static ssize_t sel_read_policyvers(struct file *filp, char __user *buf,
 				   size_t count, loff_t *ppos)
 {
@@ -1596,6 +1691,7 @@ static int sel_fill_super(struct super_block *sb, void *data, int silent)
 		[SEL_CHECKREQPROT] = {"checkreqprot", &sel_checkreqprot_ops, S_IRUGO|S_IWUSR},
 		[SEL_REJECT_UNKNOWN] = {"reject_unknown", &sel_handle_unknown_ops, S_IRUGO},
 		[SEL_DENY_UNKNOWN] = {"deny_unknown", &sel_handle_unknown_ops, S_IRUGO},
+		[SEL_OCON_PORT] = {"portcon", &sel_ocon_port_ops, S_IRUSR|S_IWUSR},
 		/* last one */ {""}
 	};
 	ret = simple_fill_super(sb, SELINUX_MAGIC, selinux_files);
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index f270e37..3b920e3 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1827,6 +1827,160 @@ err:
 
 }
 
+int security_ocon_port_add(u16 protocol, u16 low, u16 high, u32 sid,
+							 char *scontext)
+{
+	int rc = 0;
+	struct ocontext *c;
+	struct context ctx;
+	struct ocontext *add = kzalloc(sizeof(struct ocontext), GFP_KERNEL);
+
+	if (!add)
+		return -ENOMEM;
+	else if (low > high) {
+		kfree(add);
+		return -EINVAL;
+	}
+
+	read_lock(&policy_rwlock);
+	rc = string_to_context_struct(&policydb, &sidtab, scontext,
+					 strlen(scontext), &ctx, sid);
+	if (rc) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	add->u.port.protocol = protocol;
+	add->u.port.low_port = low;
+	add->u.port.high_port = high;
+	add->sid[0] = sid;
+	add->context[0] = ctx;
+	for (c = policydb.ocontexts[OCON_PORT]; c; c = c->next) {
+		if (add->u.port.protocol == c->u.port.protocol &&
+		    add->u.port.low_port == c->u.port.low_port &&
+		    add->u.port.high_port == c->u.port.high_port) {
+			printk(KERN_DEBUG "Duplicate netport %d - %d.. "
+					  "changing permissions\n",
+			       add->u.port.low_port, add->u.port.high_port);
+			c->sid[0] = add->sid[0];
+			context_destroy(&c->context[0]);
+			c->context[0] = add->context[0];
+			context_destroy(&add->context[0]);
+			kfree(add);
+			avc_ss_reset(0);
+			goto out;
+		}
+	}
+
+	add->next = policydb.ocontexts[OCON_PORT];
+	policydb.ocontexts[OCON_PORT] = add;
+	avc_ss_reset(0);
+out:
+	if (rc) {
+		context_destroy(&add->context[0]);
+		kfree(add);
+	}
+	read_unlock(&policy_rwlock);
+	return rc;
+}
+
+int security_ocon_port_del(u16 protocol, u16 low, u16 high, u32 sid,
+							char *scontext)
+{
+	int rc = 0;
+	struct ocontext *c, *before_c;
+	struct context ctx;
+
+	if (low > high)
+		return -EINVAL;
+
+	read_lock(&policy_rwlock);
+	rc = string_to_context_struct(&policydb, &sidtab, scontext,
+					 strlen(scontext), &ctx, sid);
+	if (rc) {
+		rc = -EINVAL;
+		goto out;
+	}
+	for (before_c = NULL, c = policydb.ocontexts[OCON_PORT]; c;
+	     before_c = c, c = c->next) {
+		if (c->u.port.protocol == protocol &&
+		    c->u.port.low_port == low &&
+		    c->u.port.high_port == high &&
+		    c->context[0].type == ctx.type &&
+		    c->context[0].role == ctx.role &&
+		    c->context[0].user == ctx.user) {
+			if (before_c == NULL)
+				policydb.ocontexts[OCON_PORT] = c->next;
+			else
+				before_c->next = c->next;
+			context_destroy(&c->context[0]);
+			kfree(c);
+			avc_ss_reset(0);
+			break;
+		}
+	}
+	if (c == NULL) {
+		printk(KERN_DEBUG "Netport not found %d - %d\n", low, high);
+		rc = -ENXIO;
+	}
+out:
+	context_destroy(&ctx);
+	read_unlock(&policy_rwlock);
+	return rc;
+}
+
+int security_ocon_port_read(char **buf)
+{
+	unsigned int buf_size = 0, old_size = 0, len;
+	struct ocontext *c;
+	char *scontext;
+	char *buf_tmp = NULL;
+	int rc = 0;
+	int line_size = INITCONTEXTLEN + (sizeof(unsigned int) * 3) +
+			 (sizeof(char) * 5);
+	char addline[line_size];
+
+	/* protocol low-high scontext */
+	read_lock(&policy_rwlock);
+	if (policydb.ocontexts[OCON_PORT] == NULL)
+		goto out;
+
+	for (c = policydb.ocontexts[OCON_PORT]; c; c = c->next) {
+		rc = context_struct_to_string(&(c->context[0]), &scontext,
+					      &len);
+		if (rc < 0) {
+			kfree(buf_tmp);
+			rc = -EINVAL;
+			goto out;
+		}
+		if (len > INITCONTEXTLEN) {
+			kfree(buf_tmp);
+			kfree(scontext);
+			rc = -EOVERFLOW;
+			goto out;
+		}
+		snprintf(addline, line_size, "%u %u-%u %s\n",
+			c->u.port.protocol, c->u.port.low_port,
+			c->u.port.high_port, scontext);
+		kfree(scontext);
+		buf_size += strlen(addline);
+		buf_tmp = krealloc(buf_tmp, buf_size, GFP_KERNEL);
+		if (!buf_tmp) {
+			rc = -ENOMEM;
+			goto out;
+		}
+		for (rc = old_size; rc < buf_size; rc++)
+			buf_tmp[rc] = '\0';
+		strncat(buf_tmp, addline, buf_size);
+		old_size = buf_size;
+	}
+
+	*buf = buf_tmp;
+out:
+	read_unlock(&policy_rwlock);
+	return rc;
+}
+
 /**
  * security_port_sid - Obtain the SID for a port.
  * @protocol: protocol number


