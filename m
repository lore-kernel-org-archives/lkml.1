Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbXFRMBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbXFRMBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 08:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762048AbXFRMBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 08:01:43 -0400
Received: from styx.suse.cz ([82.119.242.94]:39836 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754879AbXFRMBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 08:01:42 -0400
Date: Mon, 18 Jun 2007 14:14:55 +0200
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Quota netlink interface
Message-ID: <20070618121455.GI9319@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

  I've written a patch implementing quota netlink interface. Whenever some
event happens (like user exceeding softlimit), a message is sent to
userpace. Then, in userspace we can decide what to do with the message -
print it to console, show a dialog or whatever... I've also written a new
daemon that listens to netlink and sends the received message to DBus and/or
to the console the user has last written to.
  If somebody is interested in trying it out, he can checkout latest
quota-tools CVS and I can provide him with the modified libnl providing
better support for generic netlink handling.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--TB36FDmn/VVEgNH/
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="quota-2.6.22-rc5-1-quota_messages.diff"

Implement sending of quota messages via netlink interface. The advantage is
that in userspace we can better decide what to do with the message - for
example display a dialogue in your X session or just write the message to the
console. As a bonus, we can get rid of problems with console locking deep
inside filesystem code once we remove the old printing mechanism.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.22-rc5/fs/dquot.c linux-2.6.22-rc5-1-quota_messages/fs/dquot.c
--- linux-2.6.22-rc5/fs/dquot.c	2007-06-18 12:12:38.000000000 +0200
+++ linux-2.6.22-rc5-1-quota_messages/fs/dquot.c	2007-06-18 12:13:26.000000000 +0200
@@ -79,6 +79,10 @@
 #include <linux/capability.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h> /* for inode_lock, oddly enough.. */
+#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
+#include <net/netlink.h>
+#include <net/genetlink.h>
+#endif
 
 #include <asm/uaccess.h>
 
@@ -818,6 +822,7 @@ static inline void dquot_decr_space(stru
 	clear_bit(DQ_BLKS_B, &dquot->dq_flags);
 }
 
+#ifdef CONFIG_PRINT_QUOTA_WARNING
 static int flag_print_warnings = 1;
 
 static inline int need_print_warning(struct dquot *dquot)
@@ -834,22 +839,15 @@ static inline int need_print_warning(str
 	return 0;
 }
 
-/* Values of warnings */
-#define NOWARN 0
-#define IHARDWARN 1
-#define ISOFTLONGWARN 2
-#define ISOFTWARN 3
-#define BHARDWARN 4
-#define BSOFTLONGWARN 5
-#define BSOFTWARN 6
-
 /* Print warning to user which exceeded quota */
 static void print_warning(struct dquot *dquot, const char warntype)
 {
 	char *msg = NULL;
 	struct tty_struct *tty;
-	int flag = (warntype == BHARDWARN || warntype == BSOFTLONGWARN) ? DQ_BLKS_B :
-	  ((warntype == IHARDWARN || warntype == ISOFTLONGWARN) ? DQ_INODES_B : 0);
+	int flag = (warntype == QUOTA_NL_BHARDWARN ||
+		warntype == QUOTA_NL_BSOFTLONGWARN) ? DQ_BLKS_B :
+		((warntype == QUOTA_NL_IHARDWARN ||
+		warntype == QUOTA_NL_ISOFTLONGWARN) ? DQ_INODES_B : 0);
 
 	if (!need_print_warning(dquot) || (flag && test_and_set_bit(flag, &dquot->dq_flags)))
 		return;
@@ -859,28 +857,28 @@ static void print_warning(struct dquot *
 	if (!tty)
 		goto out_lock;
 	tty_write_message(tty, dquot->dq_sb->s_id);
-	if (warntype == ISOFTWARN || warntype == BSOFTWARN)
+	if (warntype == QUOTA_NL_ISOFTWARN || warntype == QUOTA_NL_BSOFTWARN)
 		tty_write_message(tty, ": warning, ");
 	else
 		tty_write_message(tty, ": write failed, ");
 	tty_write_message(tty, quotatypes[dquot->dq_type]);
 	switch (warntype) {
-		case IHARDWARN:
+		case QUOTA_NL_IHARDWARN:
 			msg = " file limit reached.\r\n";
 			break;
-		case ISOFTLONGWARN:
+		case QUOTA_NL_ISOFTLONGWARN:
 			msg = " file quota exceeded too long.\r\n";
 			break;
-		case ISOFTWARN:
+		case QUOTA_NL_ISOFTWARN:
 			msg = " file quota exceeded.\r\n";
 			break;
-		case BHARDWARN:
+		case QUOTA_NL_BHARDWARN:
 			msg = " block limit reached.\r\n";
 			break;
-		case BSOFTLONGWARN:
+		case QUOTA_NL_BSOFTLONGWARN:
 			msg = " block quota exceeded too long.\r\n";
 			break;
-		case BSOFTWARN:
+		case QUOTA_NL_BSOFTWARN:
 			msg = " block quota exceeded.\r\n";
 			break;
 	}
@@ -888,14 +886,89 @@ static void print_warning(struct dquot *
 out_lock:
 	mutex_unlock(&tty_mutex);
 }
+#endif
+
+#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
+
+/* Size of quota netlink message - actually an upperbound for buffer size */
+#define QUOTA_NL_MSG_SIZE 32
+
+/* Netlink family structure for quota */
+static struct genl_family quota_genl_family = {
+	.id = GENL_ID_GENERATE,
+	.hdrsize = 0,
+	.name = "VFS_DQUOT",
+	.version = 1,
+	.maxattr = QUOTA_NL_A_MAX,
+};
+
+/* Send warning to userspace about user which exceeded quota */
+static void send_warning(const struct dquot *dquot, const char warntype)
+{
+	static unsigned long seq;
+	struct sk_buff *skb;
+	void *msg_head;
+	int ret;
+
+	skb = genlmsg_new(QUOTA_NL_MSG_SIZE, GFP_NOFS);
+	if (!skb) {
+		printk(KERN_ERR
+		  "VFS: Not enough memory to send quota warning.\n");
+		return;
+	}
+	msg_head = genlmsg_put(skb, 0, seq++, &quota_genl_family, 0, QUOTA_NL_C_WARNING);
+	if (!msg_head) {
+		printk(KERN_ERR
+		  "VFS: Cannot store netlink header in quota warning.\n");
+		goto err_out;
+	}
+	ret = nla_put_u32(skb, QUOTA_NL_A_QTYPE, dquot->dq_type);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID, dquot->dq_id);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, QUOTA_NL_A_WARNING, warntype);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MAJOR,
+		MAJOR(dquot->dq_sb->s_dev));
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MINOR,
+		MINOR(dquot->dq_sb->s_dev));
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current->user->uid);
+	if (ret)
+		goto attr_err_out;
+	genlmsg_end(skb, msg_head);
+
+	ret = genlmsg_multicast(skb, 0, quota_genl_family.id, GFP_NOFS);
+	if (ret < 0 && ret != -ESRCH)
+		printk(KERN_ERR
+			"VFS: Failed to send notification message: %d\n", ret);
+	return;
+attr_err_out:
+	printk(KERN_ERR "VFS: Failed to compose quota message: %d\n", ret);
+err_out:
+	kfree_skb(skb);
+}
+#endif
 
 static inline void flush_warnings(struct dquot **dquots, char *warntype)
 {
 	int i;
 
 	for (i = 0; i < MAXQUOTAS; i++)
-		if (dquots[i] != NODQUOT && warntype[i] != NOWARN)
+		if (dquots[i] != NODQUOT && warntype[i] != QUOTA_NL_NOWARN) {
+#ifdef CONFIG_PRINT_QUOTA_WARNING
 			print_warning(dquots[i], warntype[i]);
+#endif
+#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
+			send_warning(dquots[i], warntype[i]);
+#endif
+		}
 }
 
 static inline char ignore_hardlimit(struct dquot *dquot)
@@ -909,14 +982,14 @@ static inline char ignore_hardlimit(stru
 /* needs dq_data_lock */
 static int check_idq(struct dquot *dquot, ulong inodes, char *warntype)
 {
-	*warntype = NOWARN;
+	*warntype = QUOTA_NL_NOWARN;
 	if (inodes <= 0 || test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
 	if (dquot->dq_dqb.dqb_ihardlimit &&
 	   (dquot->dq_dqb.dqb_curinodes + inodes) > dquot->dq_dqb.dqb_ihardlimit &&
             !ignore_hardlimit(dquot)) {
-		*warntype = IHARDWARN;
+		*warntype = QUOTA_NL_IHARDWARN;
 		return NO_QUOTA;
 	}
 
@@ -924,14 +997,14 @@ static int check_idq(struct dquot *dquot
 	   (dquot->dq_dqb.dqb_curinodes + inodes) > dquot->dq_dqb.dqb_isoftlimit &&
 	    dquot->dq_dqb.dqb_itime && get_seconds() >= dquot->dq_dqb.dqb_itime &&
             !ignore_hardlimit(dquot)) {
-		*warntype = ISOFTLONGWARN;
+		*warntype = QUOTA_NL_ISOFTLONGWARN;
 		return NO_QUOTA;
 	}
 
 	if (dquot->dq_dqb.dqb_isoftlimit &&
 	   (dquot->dq_dqb.dqb_curinodes + inodes) > dquot->dq_dqb.dqb_isoftlimit &&
 	    dquot->dq_dqb.dqb_itime == 0) {
-		*warntype = ISOFTWARN;
+		*warntype = QUOTA_NL_ISOFTWARN;
 		dquot->dq_dqb.dqb_itime = get_seconds() + sb_dqopt(dquot->dq_sb)->info[dquot->dq_type].dqi_igrace;
 	}
 
@@ -941,7 +1014,7 @@ static int check_idq(struct dquot *dquot
 /* needs dq_data_lock */
 static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *warntype)
 {
-	*warntype = 0;
+	*warntype = QUOTA_NL_NOWARN;
 	if (space <= 0 || test_bit(DQ_FAKE_B, &dquot->dq_flags))
 		return QUOTA_OK;
 
@@ -949,7 +1022,7 @@ static int check_bdq(struct dquot *dquot
 	   toqb(dquot->dq_dqb.dqb_curspace + space) > dquot->dq_dqb.dqb_bhardlimit &&
             !ignore_hardlimit(dquot)) {
 		if (!prealloc)
-			*warntype = BHARDWARN;
+			*warntype = QUOTA_NL_BHARDWARN;
 		return NO_QUOTA;
 	}
 
@@ -958,7 +1031,7 @@ static int check_bdq(struct dquot *dquot
 	    dquot->dq_dqb.dqb_btime && get_seconds() >= dquot->dq_dqb.dqb_btime &&
             !ignore_hardlimit(dquot)) {
 		if (!prealloc)
-			*warntype = BSOFTLONGWARN;
+			*warntype = QUOTA_NL_BSOFTLONGWARN;
 		return NO_QUOTA;
 	}
 
@@ -966,7 +1039,7 @@ static int check_bdq(struct dquot *dquot
 	   toqb(dquot->dq_dqb.dqb_curspace + space) > dquot->dq_dqb.dqb_bsoftlimit &&
 	    dquot->dq_dqb.dqb_btime == 0) {
 		if (!prealloc) {
-			*warntype = BSOFTWARN;
+			*warntype = QUOTA_NL_BSOFTWARN;
 			dquot->dq_dqb.dqb_btime = get_seconds() + sb_dqopt(dquot->dq_sb)->info[dquot->dq_type].dqi_bgrace;
 		}
 		else
@@ -1061,7 +1134,7 @@ out_add:
 		return QUOTA_OK;
 	}
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		warntype[cnt] = NOWARN;
+		warntype[cnt] = QUOTA_NL_NOWARN;
 
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	if (IS_NOQUOTA(inode)) {	/* Now we can do reliable test... */
@@ -1107,7 +1180,7 @@ int dquot_alloc_inode(const struct inode
 	if (IS_NOQUOTA(inode))
 		return QUOTA_OK;
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
-		warntype[cnt] = NOWARN;
+		warntype[cnt] = QUOTA_NL_NOWARN;
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	if (IS_NOQUOTA(inode)) {
 		up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
@@ -1229,7 +1302,7 @@ int dquot_transfer(struct inode *inode, 
 	/* Clear the arrays */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		transfer_to[cnt] = transfer_from[cnt] = NODQUOT;
-		warntype[cnt] = NOWARN;
+		warntype[cnt] = QUOTA_NL_NOWARN;
 	}
 	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	/* Now recheck reliably when holding dqptr_sem */
@@ -1803,6 +1876,7 @@ static ctl_table fs_dqstats_table[] = {
 		.mode		= 0444,
 		.proc_handler	= &proc_dointvec,
 	},
+#ifdef CONFIG_PRINT_QUOTA_WARNING
 	{
 		.ctl_name	= FS_DQ_WARNINGS,
 		.procname	= "warnings",
@@ -1811,6 +1885,7 @@ static ctl_table fs_dqstats_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#endif
 	{ .ctl_name = 0 },
 };
 
@@ -1872,6 +1947,11 @@ static int __init dquot_init(void)
 
 	set_shrinker(DEFAULT_SEEKS, shrink_dqcache_memory);
 
+#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
+	if (genl_register_family(&quota_genl_family) != 0)
+		printk(KERN_ERR "VFS: Failed to create quota netlink interface.\n");
+#endif
+
 	return 0;
 }
 module_init(dquot_init);
diff -rupX /home/jack/.kerndiffexclude linux-2.6.22-rc5/fs/Kconfig linux-2.6.22-rc5-1-quota_messages/fs/Kconfig
--- linux-2.6.22-rc5/fs/Kconfig	2007-06-18 12:12:37.000000000 +0200
+++ linux-2.6.22-rc5-1-quota_messages/fs/Kconfig	2007-06-18 12:14:54.000000000 +0200
@@ -537,6 +537,25 @@ config QUOTA
 	  with the quota tools. Probably the quota support is only useful for
 	  multi user systems. If unsure, say N.
 
+config QUOTA_NETLINK_INTERFACE
+	bool "Report quota messages through netlink interface"
+	depends on QUOTA
+	select NET
+	help
+	  If you say Y here, quota warnings (about exceeding softlimit, reaching
+	  hardlimit, etc.) will be reported through netlink interface. If unsure,
+	  say Y.
+
+config PRINT_QUOTA_WARNING
+	bool "Print quota warnings to console (OBSOLETE)"
+	depends on QUOTA
+	default y
+	help
+	  If you say Y here, quota warnings (about exceeding softlimit, reaching
+	  hardlimit, etc.) will be printed to the process' controlling terminal.
+	  Note that this behavior is currently deprecated and may go away in
+	  future. Please use notification via netlink socket instead.
+
 config QFMT_V1
 	tristate "Old quota format support"
 	depends on QUOTA

--TB36FDmn/VVEgNH/--
