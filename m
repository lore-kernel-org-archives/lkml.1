Return-Path: <linux-kernel-owner+w=401wt.eu-S1758430AbXHKXWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430AbXHKXWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 19:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbXHKXW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 19:22:28 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:21604 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751549AbXHKXW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 19:22:27 -0400
X-YMail-OSG: pYujFdMVM1mTxCYuJh0ssq209cNpikZXN3SE_yydRBuibdhJ2mnoozJA2SGUSQ8NyCVmWVjV6ZplFozLDFgOf6EiTMSYezVYoxBfjdZbjqRaXwilzGw-
X-RocketYMMF: rancidfat
Date: Sat, 11 Aug 2007 16:22:26 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Jan Engelhardt <jengelh@computergmbh.de>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
In-Reply-To: <Pine.LNX.4.64.0708112139340.9166@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <228687.90899.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Aug 11 2007 10:57, Casey Schaufler wrote:
> >
> >    "*" - pronounced "star"
> wall
> >    "_" - pronounced "floor"
> floor
> >    "^" - pronounced "hat"
> roof
> >    "?" - pronounced "huh"
> it's dark in here :)

It's almost worth considering the change for the joke. Almost.

> >+config SECURITY_SMACK
> >+	bool "Simplified Mandatory Access Control Kernel Support"
> >+	depends on NETLABEL && SECURITY_NETWORK
> 
> Is this a hard dependency, or can this work without network sec labels?

Smack uses netlabel to communicate label information even locally.
Without this only processes running with the ambient label would
be able to use sockets.

> >+	default n
> >+	help
> >+	  This selects the Simplified Mandatory Access Control Kernel.
> >+	  SMACK is useful for sensitivity, integrity, and a variety
> >+          of other madatory security schemes.
> >+	  If you are unsure how to answer this question, answer N.
> 
> I smell broken tabs.

Yup. Fixed.
 
> >+++ linux-2.6.22/security/smack/Makefile	2007-07-10 01:08:05.000000000 -0700
> >@@ -0,0 +1,8 @@
> >+#
> >+# Makefile for the SMACK LSM
> >+#
> >+
> >+obj-$(CONFIG_SECURITY_SMACK) := smack.o
> >+
> >+smack-y := smack_lsm.o smack_access.o smackfs.o
> 
> smack-objs :=

Added.

> >+++ linux-2.6.22/security/smack/smack_access.c	2007-07-24 15:36:18.000000000
> -0700
> >@@ -0,0 +1,113 @@
> >+extern struct smk_list_entry *smack_list;
> >+
> >+static int smk_get_access(smack_t sub, smack_t obj)
> >+{
> >+	struct smk_list_entry *sp = smack_list;
> 
> proposes const struct. should be used elsewhere too.

I've hit a few places.

> >+	if (sub == SMK_STAR)
> 
> I just remember MechWarrior2 (game from Activison), where SMK stood for their
> movie format... it's also a nice abbreviation for Seamonkey (browser suite).

Err, yeah. Okay.

> >+	if (sub == SMK_HAT && ((request & MAY_ANYREAD) == request))
> >+		return 0;
> >+
> >+	if (obj == SMK_FLOOR && ((request & MAY_ANYREAD) == request))
> >+		return 0;
> 
> Redundant parentheses, be gone.

Done.

> Never was it easier to say what ^ is called in your language :)
> 
> 	if (sub == '^' && ...)
> 		return 0;
> 	if (obj == '_' && ...)
>
> >+/*
> >+ * The value that this adds is that everything after any
> >+ * character that's not allowed in a smack will be null
> >+ */
> >+smack_t smk_from_string(char *str)
> >+{
> >+	smack_t smack = 0LL;
> 
> "smack_t smack = 0;" is enough here.

Ok.

> >+	char *cp;
> >+	int i;
> >+
> >+	for (cp = (char *)&smack, i = 0; i < sizeof(smack_t); str++,cp++,i++) {
> 
> Whatever it tries to do, this is not endian-safe. Except if @str
> actually points to another smack_t. Yuck.

Small string stuck in a large integer. The only operation is
comparison. Big or little endian the string will come out right,
and that's what's important.

> >+		if (*str <= ' ' || *str > '~')
> >+			return smack;
> >+		*cp = *str;
> >+	}
> >+	/*
> >+	 * Too long.
> >+	 */
> >+	return SMK_INVALID;
> >+}
> >diff -uprN -X linux-2.6.22-base/Documentation/dontdiff
> linux-2.6.22-base/security/smack/smackfs.c
> linux-2.6.22/security/smack/smackfs.c
> >--- linux-2.6.22-base/security/smack/smackfs.c	1969-12-31 16:00:00.000000000
> -0800
> >+++ linux-2.6.22/security/smack/smackfs.c	2007-07-24 21:51:30.000000000
> -0700
> 
> Can't securityfs and/or sysfs be used?

I have to look into that for the configuration values. I don't
think I can do it for the symlinks.

> >+enum smk_inos {
> >+	SMK_ROOT_INO =	2,
> >+	SMK_LOAD =	3,	/* load policy */
> >+	SMK_LINKS = 	4,	/* symlinks */
> >+	SMK_CIPSO = 	5,	/* load label -> CIPSO mapping */
> >+	SMK_DOI = 	6,	/* CIPSO DOI */
> >+	SMK_DIRECT = 	7,	/* CIPSO level indicating direct label */
> >+	SMK_AMBIENT = 	8,	/* internet ambient label */
> >+	SMK_NLTYPE = 	9,	/* label scheme to use by default */
> >+	SMK_TMP =	100,	/* MUST BE LAST! /smack/tmp */
> >+};
> 
> Generally, =s are aligned too.

It's pretty inconsistant, but that's what I prefer, too. I'll do it.

> >+static struct smk_cipso_entry smack_cipso_floor = {
> >+        .smk_next = NULL,
> >+        .smk_smack = SMK_FLOOR,
> >+        .smk_level = 0,
> >+        .smk_catset = 0LL,
> >+};
> 
> const me.

This is the correct tinitial value, but could be changed.

> >+/*
> >+ * 'ssssssss oooooooo mmmm\n\0' 
> >+ */
> 
> I wonder why it's limited to 8 characters? Ah right.. sizeof(smack_t).
> uhm.. are you trying to tell me that smack_t [typedef'ed to u64]
> are actually meant as a char[8]? (/me scrathces head)

Yes. "s == o" vs "strcmp(s,o) == 0".

> >+	for (cp = result; slp != NULL; slp = slp->smk_next) {
> >+		srp = &slp->smk_rule;
> >+		sprintf(cp, "%-8s %-8s",
> >+			(char *)&srp->smk_subject, (char *)&srp->smk_object);
> 
> I like (const char *).
> 
> >+			printk("%s:%d bad scan\n",
> >+				__FUNCTION__, __LINE__);
> 
> __FUNCTION__ is a GNU extension, C99 uses __func__.

Changed, although it's used extensively elsewhere.

> Not sure what they've got for __LINE__.

No clue. Leaving it as is.

> >+		if (strchr(modestr, 'r') || strchr(modestr, 'R'))
> >+			rule.smk_access |= MAY_READ;
> >+		if (strchr(modestr, 'w') || strchr(modestr, 'W'))
> >+			rule.smk_access |= MAY_WRITE;
> >+		if (strchr(modestr, 'x') || strchr(modestr, 'X'))
> >+			rule.smk_access |= MAY_EXEC;
> >+		if (strchr(modestr, 'a') || strchr(modestr, 'A'))
> >+			rule.smk_access |= MAY_APPEND;
> 
> There's strpbrk() available for you.

Makes it a little cleaner. Thank you.

> >+static char *smk_digit(char *cp)
> >+{
> >+	for (; *cp != '\0'; cp++)
> >+		if (*cp >= '0' && *cp <= '9')
> >+			return cp;
> >+
> >+	return NULL;
> >+}
> 
> strpbrk again.

Thank you again.

> >+static int smk_cipso_doied;
> >+static int smk_cipso_written;
> 
> Votes for unsigned int if it {can never be, is not intended to be} negative.

No problem. Changed.

> >+	for (slp = smack_cipso; slp != NULL; slp = slp->smk_next) {
> >+		sprintf(cp, "%-8s %3d", (char *)&slp->smk_smack,slp->smk_level);
> >+		cp += strlen(cp);
> 
> sprintf returns the number of bytes it has written, so
> 	cp += sprintf(cp, ...)
> might be used. [Can sprintf even return -1 here?]

Better.

> >+	*(data + count) = '\0';
> 
> data[count] = '\0';

Yeah, it's clearer.


> >+	char temp[80];
> >+	ssize_t rc;
> >+
> >+	if (*ppos != 0)
> >+		return 0;
> >+
> >+	sprintf(temp, "%d", smk_cipso_doi_value);
> >+	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
> 
> 80 is plenty for a 11 char string.
> 
> Look, they've got funny ideas! :)
> net/ipv4/netfilter/nf_nat_irc.c:char buffer[sizeof("4294967296 65635")];
> 
> >+static struct option_names netlbl_choices[] = {
> >+	{ NETLBL_NLTYPE_RIPSO,
> >+		NETLBL_NLTYPE_RIPSO_NAME,	"ripso" },
> >+	{ NETLBL_NLTYPE_CIPSOV4,
> >+		NETLBL_NLTYPE_CIPSOV4_NAME,	"cipsov4" },
> >+	{ NETLBL_NLTYPE_CIPSOV4,
> >+		NETLBL_NLTYPE_CIPSOV4_NAME,	"cipso" },
> >+	{ NETLBL_NLTYPE_CIPSOV6,
> >+		NETLBL_NLTYPE_CIPSOV6_NAME,	"cipsov6" },
> >+	{ NETLBL_NLTYPE_UNLABELED,
> >+		NETLBL_NLTYPE_UNLABELED_NAME,	"unlabeled" },
> >+};
> >+#define NCHOICES (sizeof(netlbl_choices) / sizeof(struct option_names))
> 
> ARRAY_SIZE()..

Spiffy. Used.

> >+	for (i = 0; i < NCHOICES; i++)
> >+		if (smack_net_nltype == netlbl_choices[i].o_number) {
> >+			sprintf(bound, "%s", netlbl_choices[i].o_name);
> 
> looks dangerous; to overflow.

Constant strings all fit.

> >+	for (i = 0; i < NCHOICES; i++)
> >+		if ((strcmp(bound, netlbl_choices[i].o_name) == 0) ||
> >+		    (strcmp(bound, netlbl_choices[i].o_alias) == 0)) {
> 
> redundant ()

Removed.


> >+#define SMK_TMPPATH_SIZE        32
> >+#define SMK_TMPPATH_ROOT        "/moldy/"
> 
> What is going to be mold?

/tmp -> /smack/tmp -> /moldy/<yoursmacklabelhere>

> >+	if (slp == NULL) {
> >+		printk("%s:%d failed\n", __FUNCTION__, __LINE__);
> 
> KERN_<level> is missing. (Check other places too)

printks in excess. Cleanup and correction in order.

> 
> >+#define SMK_MAXLEN	(sizeof(smack_t) - 1)	/* NULL terminated */
> 
> >+
> >+/*
> >+ * I hope these are the hokeyist lines of code in the module. Casey.
> >+ */
> >+#define DEVPTS_SUPER_MAGIC	0x1cd1
> >+#define SOCKFS_MAGIC		0x534F434B
> >+#define PIPEFS_MAGIC		0x50495045
> >+#define TMPFS_MAGIC		0x01021994
>
> Try moving them to linux/magic.h.

Worth looking into.
 
> >+extern int smack_net_nltype;
> >+extern int smack_cipso_direct;
> >+extern struct smk_cipso_entry *smack_cipso;
> 
> for consistency reasons, add extern to the other vars too...

the others?

> >+struct inode_smack *new_inode_smack(smack_t smack)
> >+{
> >+	struct inode_smack *isp;
> >+
> >+        isp = kzalloc(sizeof(struct inode_smack), GFP_KERNEL);
> >+        if (isp == NULL)
> >+                return NULL;
> >+
> >+	isp->smk_inode = smack;
> >+	isp->smk_flags = 0;
> >+	mutex_init(&isp->smk_lock);
> >+
> >+	return isp;
> >+}
> 
> Tabs or so.

Yup. Fixed.

> >+static int smack_task_movememory(struct task_struct *p)
> >+{
> >+	int rc;
> >+
> >+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
> >+	return rc;
> >+}
> 
> Uh...
> 
> {
> 	return smk_curacc(smk_of_task(p), MAY_WRITE);
> }
> 
> (also others)

That was a little excessive, wasn't it?

> >+
> >+static int smack_task_kill(struct task_struct *p, struct siginfo *info,
> >+			   int sig, u32 secid)
> >+{
> >+	smack_t *tsp = smk_of_task(p);
> >+	int rc;
> >+
> >+	/*
> >+	 * Sending a signal requires that the sender
> >+	 * can write the receiver.
> >+	 */
> >+	rc = smk_curacc(tsp, MAY_WRITE);
> >+
> >+	return rc;
> >+}
> >+
> >+static int smack_sb_statfs(struct dentry *dentry)
> >+{
> >+	struct superblock_smack *sbp;
> >+
> >+	if (dentry == NULL || dentry->d_sb == NULL ||
> >+	    dentry->d_sb->s_security == NULL)
> >+		return 0;
> >+
> >+	sbp = dentry->d_sb->s_security;
> >+
> >+	return smk_curacc(&sbp->smk_floor, MAY_READ);
> >+}
> 
> >+/*
> >+ * Inode hooks
> >+ */
> >+static int smack_inode_alloc_security(struct inode *inode)
> >+{
> >+	smack_t *csp = smk_of_task(current);
> >+
> >+        inode->i_security = new_inode_smack(*csp);
> >+        if (inode->i_security == NULL)
> >+                return -ENOMEM;
> >+	return 0;
> >+}
> 
> Tabz.

Fixxxed.

 
> >+static int smack_inode_init_security(struct inode *inode, struct inode
> *dir,
> >+                               char **name, void **value, size_t *len)
> >+{
> >+	smack_t *isp = smk_of_inode(inode);
> >+
> >+	if (name && (*name = kstrdup(XATTR_SMACK_SUFFIX, GFP_KERNEL)) == NULL)
> >+		return -ENOMEM;
> >+
> >+	if (value && (*value = kstrdup((char *)isp, GFP_KERNEL)) == NULL)
> >+		return -ENOMEM;
> 
> Try not to do big assignments in if.

Fixed.

> >+static const char *smack_inode_xattr_getsuffix(void)
> >+{
> >+	return XATTR_SMACK_SUFFIX;
> >+}
> 
> inline it, or opencode.

Better yet, no one is using the hook. nuked.

> >+static int smack_inode_setsecurity(struct inode *inode, const char *name,
> >+				   const void *value, size_t size, int flags)
> >+{
> >+	smack_t smack;
> >+	smack_t *isp = smk_of_inode(inode);
> >+	struct socket_smack *ssp;
> >+	struct socket *sock;
> >+	struct super_block *sbp;
> >+	struct inode *ip = (struct inode *)inode;
> 
> This cast is really pointless.

The variable is really pointless. Repaired.

> >+static int smack_inode_listsecurity(struct inode *inode, char *buffer,
> >+				    size_t buffer_size)
> 
> Whitespace broken.

Fixed

> 
> [attention span ran out]

It's a summer Saturday. Thank you for your helpful comments.
 
> Nice.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
