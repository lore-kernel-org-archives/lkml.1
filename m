Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbZBRVQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbZBRVQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZBRVQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:16:16 -0500
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:47627 "EHLO
	smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZBRVQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:16:14 -0500
Message-ID: <499C7A98.7000907@numericable.fr>
Date: Wed, 18 Feb 2009 22:16:08 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Paul Moore <paul.moore@hp.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
Subject: [PATCH] SMACK netlabel fixes
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <200902171852.21061.paul.moore@hp.com> <499BB76C.1030109@numericable.fr> <200902181005.24952.paul.moore@hp.com> <499C5377.8050408@numericable.fr> <499C5C44.4020902@schaufler-ca.com>
In-Reply-To: <499C5C44.4020902@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

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
 security/smack/smack_lsm.c |   38 ++++++----------------------
 security/smack/smackfs.c   |   60 +++++++++++++++++++++++++++++++++----------
 2 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0278bc0..427595e 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1498,10 +1498,7 @@ static int smack_socket_post_create(struct socket *sock, int family,
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
@@ -1512,41 +1509,22 @@ static char *smack_host_label(struct sockaddr_in *sip)
 	struct in_addr *siap = &sip->sin_addr;
 	struct in_addr *liap;
 	struct in_addr *miap;
-	struct in_addr bestmask;
 
 	if (siap->s_addr == 0)
 		return NULL;
 
-	bestmask.s_addr = 0;
-
 	for (snp = smack_netlbladdrs; snp != NULL; snp = snp->smk_next) {
 		liap = &snp->smk_host.sin_addr;
 		miap = &snp->smk_mask;
 		/*
-		 * If the addresses match after applying the list entry mask
-		 * the entry matches the address. If it doesn't move along to
-		 * the next entry.
-		 */
-		if ((liap->s_addr & miap->s_addr) !=
-		    (siap->s_addr & miap->s_addr))
-			continue;
-		/*
-		 * If the list entry mask identifies a single address
-		 * it can't get any more specific.
-		 */
-		if (miap->s_addr == 0xffffffff)
-			return snp->smk_label;
-		/*
-		 * If the list entry mask is less specific than the best
-		 * already found this entry is uninteresting.
+		 * we break after finding the first match because
+		 * the list is sorted from longest to shortest mask
+		 * so we have found the most specific match
 		 */
-		if ((miap->s_addr | bestmask.s_addr) == bestmask.s_addr)
-			continue;
-		/*
-		 * This is better than any entry found so far.
-		 */
-		bestmask.s_addr = miap->s_addr;
-		bestlabel = snp->smk_label;
+		if (liap->s_addr  == (siap->s_addr & miap->s_addr)) {
+			bestlabel = snp->smk_label;
+			break;
+		}
 	}
 
 	return bestlabel;
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 8e42800..4d4332b 100644
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
 	int maskn = 0;
+	u32 temp_mask = be32_to_cpu(skp->smk_mask.s_addr);
 
-	for (bebits = BEMASK; bebits != 0; maskn++, bebits <<= 1)
-		if ((skp->smk_mask.s_addr & bebits) == 0)
-			break;
+	for ( ; temp_mask; temp_mask <<= 1, maskn++);
 
 	seq_printf(s, "%u.%u.%u.%u/%d %s\n",
 		hp[0], hp[1], hp[2], hp[3], maskn, skp->smk_label);
@@ -702,6 +696,40 @@ static int smk_open_netlbladdr(struct inode *inode, struct file *file)
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
+	if (smack_netlbladdrs == NULL) {
+		smack_netlbladdrs = new;
+		return;
+	}
+	/** the comparison '>' is a bit hacky, but works */
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
@@ -724,8 +752,9 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	struct netlbl_audit audit_info;
 	struct in_addr mask;
 	unsigned int m;
-	__be32 bebits = BEMASK;
+	u32 mask_bits = (1<<31);
 	__be32 nsa;
+	u32 temp_mask;
 
 	/*
 	 * Must have privilege.
@@ -761,10 +790,13 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
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
@@ -772,6 +804,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	mutex_lock(&smk_netlbladdr_lock);
 
 	nsa = newname.sin_addr.s_addr;
+	/* try to find if the prefix is already in the list */
 	for (skp = smack_netlbladdrs; skp != NULL; skp = skp->smk_next)
 		if (skp->smk_host.sin_addr.s_addr == nsa &&
 		    skp->smk_mask.s_addr == mask.s_addr)
@@ -787,9 +820,8 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
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


=============================================================
TESTS
=============================================================

root@etienne-desktop:/home/etienne/linux-2.6# cat /smack/netlabel
212.180.1.0/26 toto
212.180.1.0/25 @
217.146.186.0/24 _
212.180.0.0/23 tit
212.180.0.0/15 @

root@etienne-desktop:/home/etienne/linux-2.6# cat /proc/self/attr/current
_root@etienne-desktop:/home/etienne/linux-2.6#
root@etienne-desktop:/home/etienne/linux-2.6# ping 212.180.1.65 -c 1
PING 212.180.1.65 (212.180.1.65) 56(84) bytes of data.
64 bytes from 212.180.1.65: icmp_seq=1 ttl=56 time=7.04 ms

--- 212.180.1.65 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 7.040/7.040/7.040/0.000 ms
root@etienne-desktop:/home/etienne/linux-2.6# ping 212.180.1.1 -c 1
Do you want to ping broadcast? Then -b
root@etienne-desktop:/home/etienne/linux-2.6# echo toto > /proc/self/attr/current
root@etienne-desktop:/home/etienne/linux-2.6# ping 212.180.1.1 -c 1
PING 212.180.1.1 (212.180.1.1) 56(84) bytes of data.
64 bytes from 212.180.1.1: icmp_seq=1 ttl=248 time=13.6 ms

--- 212.180.1.1 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 13.632/13.632/13.632/0.000 ms
root@etienne-desktop:/home/etienne/linux-2.6# ping 212.180.1.65 -c 1
PING 212.180.1.65 (212.180.1.65) 56(84) bytes of data.
64 bytes from 212.180.1.65: icmp_seq=1 ttl=56 time=9.87 ms

--- 212.180.1.65 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 9.876/9.876/9.876/0.000 ms
root@etienne-desktop:/home/etienne/linux-2.6# ping 212.180.0.1 -c 1
Do you want to ping broadcast? Then -b
root@etienne-desktop:/home/etienne/linux-2.6# echo titi > /proc/self/attr/current
root@etienne-desktop:/home/etienne/linux-2.6# ping 212.180.0.1 -c 1
Do you want to ping broadcast? Then -b
root@etienne-desktop:/home/etienne/linux-2.6# echo tit > /proc/self/attr/current
root@etienne-desktop:/home/etienne/linux-2.6# ping 212.180.0.1 -c 1
PING 212.180.0.1 (212.180.0.1) 56(84) bytes of data.
^C
--- 212.180.0.1 ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms




  

