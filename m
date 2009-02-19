Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbZBSXWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbZBSXWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 18:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZBSXWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 18:22:16 -0500
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:36755 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbZBSXWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 18:22:15 -0500
Message-ID: <499DE9A3.7070702@numericable.fr>
Date: Fri, 20 Feb 2009 00:22:11 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: Casey Schaufler <casey@schaufler-ca.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: [PATCH] SMACK netlabel fixes v2
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <499C5C44.4020902@schaufler-ca.com> <499C7A98.7000907@numericable.fr> <200902191024.50198.paul.moore@hp.com>
In-Reply-To: <200902191024.50198.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

thanks for your comments, please find below an updated version of the patch, I hope it is fine with you and Casey.
(i didnt remove the 'mask_bits = (1<<31)' of your last comment :
=> i think it's much obvious that it represent binary 1000..00 than 0x80000000, but that may be just me :)

I redid some basics tests, it seems i've not messed things too much :)

For the moving to standard list, I guess I could try to do that; (even other smack list, yes want my bonus points! ;) )
After a quick list.h grep i think i'll have to implement a 'sorted insert' anyway. 
But please allow me to do that on top of my patch


regards
Etienne

--

the following patch (against 2.6.29rc5) fixes a few issues in the smack/netlabel area :
1) smack_host_label disregard a "0.0.0.0/0 @" rule (or other label), preventing 'tagged' tasks to access Internet (many systems drop packets with IP options)
2) netmasks were not handled correctly, they were stored in a way _not equivalent_  to conversion to be32 (it was equivalent for /0, /8, /16, /24, /32 masks but not other masks)
3) smack_netlbladdr prefixes (IP/mask) were not consistent (mask&IP was not done), so there could have been different list entries for the same IP prefix; if those entries had different labels, well ... 
4) they were not sorted 

1) 2) 3) are bugs, 4) is a more cosmetic issue.
The patch :
-creates a new helper smk_netlbladdr_insert to insert a smk_netlbladdr, sorted by netmask length
-use the new sorted nature of  smack_netlbladdrs list to simplify smack_host_label : 
 the first match _will_ be the more specific
-corrects endianness issues in smk_write_netlbladdr &  netlbladdr_seq_show

The patch are "tested" so that they no crash the system; cat /smack/netlabel is now sorted and always consistent.
Some basics ping tests to '@' and other label combination seems ok 
See   an extract of my tests bellow the patch 

regards,
Etienne

Signed-off-by: <etienne.basset@numericable.fr>
---


security/smack/smack_lsm.c |   43 +++++------------------------
 security/smack/smackfs.c   |   64 +++++++++++++++++++++++++++++++++----------
 2 files changed, 57 insertions(+), 50 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0278bc0..e7ded13 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1498,58 +1498,31 @@ static int smack_socket_post_create(struct socket *sock, int family,
  * looks for host based access restrictions
  *
  * This version will only be appropriate for really small
- * sets of single label hosts. Because of the masking
- * it cannot shortcut out on the first match. There are
- * numerious ways to address the problem, but none of them
- * have been applied here.
+ * sets of single label hosts.
  *
  * Returns the label of the far end or NULL if it's not special.
  */
 static char *smack_host_label(struct sockaddr_in *sip)
 {
 	struct smk_netlbladdr *snp;
-	char *bestlabel = NULL;
 	struct in_addr *siap = &sip->sin_addr;
-	struct in_addr *liap;
-	struct in_addr *miap;
-	struct in_addr bestmask;
 
 	if (siap->s_addr == 0)
 		return NULL;
 
-	bestmask.s_addr = 0;
-
 	for (snp = smack_netlbladdrs; snp != NULL; snp = snp->smk_next) {
-		liap = &snp->smk_host.sin_addr;
-		miap = &snp->smk_mask;
-		/*
-		 * If the addresses match after applying the list entry mask
-		 * the entry matches the address. If it doesn't move along to
-		 * the next entry.
-		 */
-		if ((liap->s_addr & miap->s_addr) !=
-		    (siap->s_addr & miap->s_addr))
-			continue;
 		/*
-		 * If the list entry mask identifies a single address
-		 * it can't get any more specific.
+		 * we break after finding the first match because
+		 * the list is sorted from longest to shortest mask
+		 * so we have found the most specific match
 		 */
-		if (miap->s_addr == 0xffffffff)
+		if ((&snp->smk_host.sin_addr)->s_addr  ==
+			(siap->s_addr & (&snp->smk_mask)->s_addr)) {
 			return snp->smk_label;
-		/*
-		 * If the list entry mask is less specific than the best
-		 * already found this entry is uninteresting.
-		 */
-		if ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr)
-			continue;
-		/*
-		 * This is better than any entry found so far.
-		 */
-		bestmask.s_addr = miap->s_addr;
-		bestlabel = snp->smk_label;
+		}
 	}
 
-	return bestlabel;
+	return NULL;
 }
 
 /**
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 8e42800..51f0efc 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -650,10 +650,6 @@ static void *netlbladdr_seq_next(struct seq_file *s, void *v, loff_t *pos)
 
 	return skp;
 }
-/*
-#define BEMASK	0x80000000
-*/
-#define BEMASK	0x00000001
 #define BEBITS	(sizeof(__be32) * 8)
 
 /*
@@ -663,12 +659,10 @@ static int netlbladdr_seq_show(struct seq_file *s, void *v)
 {
 	struct smk_netlbladdr *skp = (struct smk_netlbladdr *) v;
 	unsigned char *hp = (char *) &skp->smk_host.sin_addr.s_addr;
-	__be32 bebits;
-	int maskn = 0;
+	int maskn;
+	u32 temp_mask = be32_to_cpu(skp->smk_mask.s_addr);
 
-	for (bebits = BEMASK; bebits != 0; maskn++, bebits <<= 1)
-		if ((skp->smk_mask.s_addr & bebits) == 0)
-			break;
+	for (maskn = 0; temp_mask; temp_mask <<= 1, maskn++);
 
 	seq_printf(s, "%u.%u.%u.%u/%d %s\n",
 		hp[0], hp[1], hp[2], hp[3], maskn, skp->smk_label);
@@ -702,6 +696,42 @@ static int smk_open_netlbladdr(struct inode *inode, struct file *file)
 }
 
 /**
+ * smk_netlbladdr_insert
+ * @new : netlabel to insert
+ *
+ * This helper insert netlabel in the smack_netlbladdrs list
+ * sorted by netmask length (longest to smallest)
+ */
+static void smk_netlbladdr_insert(struct smk_netlbladdr *new)
+{
+	struct smk_netlbladdr *m;
+
+	if (smack_netlbladdrs == NULL) {
+		smack_netlbladdrs = new;
+		return;
+	}
+
+	/* the comparison '>' is a bit hacky, but works */
+	if (new->smk_mask.s_addr > smack_netlbladdrs->smk_mask.s_addr) {
+		new->smk_next = smack_netlbladdrs;
+		smack_netlbladdrs = new;
+		return;
+	}
+	for (m = smack_netlbladdrs; m != NULL; m = m->smk_next) {
+		if (m->smk_next == NULL) {
+			m->smk_next = new;
+			return;
+		}
+		if (new->smk_mask.s_addr > m->smk_next->smk_mask.s_addr) {
+			new->smk_next = m->smk_next;
+			m->smk_next = new;
+			return;
+		}
+	}
+}
+
+
+/**
  * smk_write_netlbladdr - write() for /smack/netlabel
  * @filp: file pointer, not actually used
  * @buf: where to get the data from
@@ -724,8 +754,9 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	struct netlbl_audit audit_info;
 	struct in_addr mask;
 	unsigned int m;
-	__be32 bebits = BEMASK;
+	u32 mask_bits = (1<<31);
 	__be32 nsa;
+	u32 temp_mask;
 
 	/*
 	 * Must have privilege.
@@ -761,10 +792,13 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	if (sp == NULL)
 		return -EINVAL;
 
-	for (mask.s_addr = 0; m > 0; m--) {
-		mask.s_addr |= bebits;
-		bebits <<= 1;
+	for (temp_mask = 0; m > 0; m--) {
+		temp_mask |= mask_bits;
+		mask_bits >>= 1;
 	}
+	mask.s_addr = cpu_to_be32(temp_mask);
+
+	newname.sin_addr.s_addr &= mask.s_addr;
 	/*
 	 * Only allow one writer at a time. Writes should be
 	 * quite rare and small in any case.
@@ -772,6 +806,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	mutex_lock(&smk_netlbladdr_lock);
 
 	nsa = newname.sin_addr.s_addr;
+	/* try to find if the prefix is already in the list */
 	for (skp = smack_netlbladdrs; skp != NULL; skp = skp->smk_next)
 		if (skp->smk_host.sin_addr.s_addr == nsa &&
 		    skp->smk_mask.s_addr == mask.s_addr)
@@ -787,9 +822,8 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 			rc = 0;
 			skp->smk_host.sin_addr.s_addr = newname.sin_addr.s_addr;
 			skp->smk_mask.s_addr = mask.s_addr;
-			skp->smk_next = smack_netlbladdrs;
 			skp->smk_label = sp;
-			smack_netlbladdrs = skp;
+			smk_netlbladdr_insert(skp);
 		}
 	} else {
 		rc = netlbl_cfg_unlbl_static_del(&init_net, NULL,



