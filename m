Return-Path: <linux-kernel-owner+w=401wt.eu-S1759842AbZENWya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759842AbZENWya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbZENWmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:46 -0400
Received: from kroah.org ([198.145.64.141]:51640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487AbZENWmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:13 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:23 2009
Message-Id: <20090514223523.713148717@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-security-module@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Paul Moore <paul.moore@hp.com>
Subject: [patch 21/51] selinux: Set the proper NetLabel security attributes for connection requests
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=selinux-set-the-proper-netlabel-security-attributes-for-connection-requests.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Moore <paul.moore@hp.com>

[NOTE: based on 389fb800ac8be2832efedd19978a2b8ced37eb61]

This patch ensures the correct labeling of incoming connection requests
responses via NetLabel by enabling the recent changes to NetLabel and the
SELinux/Netlabel glue code.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 security/selinux/hooks.c            |   45 +++++++++---------------------------
 security/selinux/include/netlabel.h |    6 +---
 security/selinux/netlabel.c         |    8 +-----
 3 files changed, 16 insertions(+), 43 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -311,7 +311,7 @@ static int sk_alloc_security(struct sock
 	ssec->sid = SECINITSID_UNLABELED;
 	sk->sk_security = ssec;
 
-	selinux_netlbl_sk_security_reset(ssec, family);
+	selinux_netlbl_sk_security_reset(ssec);
 
 	return 0;
 }
@@ -2952,7 +2952,6 @@ static void selinux_inode_getsecid(const
 static int selinux_revalidate_file_permission(struct file *file, int mask)
 {
 	const struct cred *cred = current_cred();
-	int rc;
 	struct inode *inode = file->f_path.dentry->d_inode;
 
 	if (!mask) {
@@ -2964,30 +2963,16 @@ static int selinux_revalidate_file_permi
 	if ((file->f_flags & O_APPEND) && (mask & MAY_WRITE))
 		mask |= MAY_APPEND;
 
-	rc = file_has_perm(cred, file,
-			   file_mask_to_av(inode->i_mode, mask));
-	if (rc)
-		return rc;
-
-	return selinux_netlbl_inode_permission(inode, mask);
+	return file_has_perm(cred, file, file_mask_to_av(inode->i_mode, mask));
 }
 
 static int selinux_file_permission(struct file *file, int mask)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct file_security_struct *fsec = file->f_security;
-	struct inode_security_struct *isec = inode->i_security;
-	u32 sid = current_sid();
-
 	if (!mask) {
 		/* No permission to check.  Existence test. */
 		return 0;
 	}
 
-	if (sid == fsec->sid && fsec->isid == isec->sid
-	    && fsec->pseqno == avc_policy_seqno())
-		return selinux_netlbl_inode_permission(inode, mask);
-
 	return selinux_revalidate_file_permission(file, mask);
 }
 
@@ -3990,13 +3975,7 @@ static int selinux_socket_accept(struct 
 static int selinux_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 				  int size)
 {
-	int rc;
-
-	rc = socket_has_perm(current, sock, SOCKET__WRITE);
-	if (rc)
-		return rc;
-
-	return selinux_netlbl_inode_permission(SOCK_INODE(sock), MAY_WRITE);
+	return socket_has_perm(current, sock, SOCKET__WRITE);
 }
 
 static int selinux_socket_recvmsg(struct socket *sock, struct msghdr *msg,
@@ -4384,7 +4363,7 @@ static void selinux_sk_clone_security(co
 	newssec->peer_sid = ssec->peer_sid;
 	newssec->sclass = ssec->sclass;
 
-	selinux_netlbl_sk_security_reset(newssec, newsk->sk_family);
+	selinux_netlbl_sk_security_reset(newssec);
 }
 
 static void selinux_sk_getsecid(struct sock *sk, u32 *secid)
@@ -4429,15 +4408,15 @@ static int selinux_inet_conn_request(str
 		req->secid = sksec->sid;
 		req->peer_secid = SECSID_NULL;
 		return 0;
+	} else {
+		err = security_sid_mls_copy(sksec->sid, peersid, &newsid);
+		if (err)
+			return err;
+		req->secid = newsid;
+		req->peer_secid = peersid;
 	}
 
-	err = security_sid_mls_copy(sksec->sid, peersid, &newsid);
-	if (err)
-		return err;
-
-	req->secid = newsid;
-	req->peer_secid = peersid;
-	return 0;
+	return selinux_netlbl_inet_conn_request(req, family);
 }
 
 static void selinux_inet_csk_clone(struct sock *newsk,
@@ -4454,7 +4433,7 @@ static void selinux_inet_csk_clone(struc
 
 	/* We don't need to take any sort of lock here as we are the only
 	 * thread with access to newsksec */
-	selinux_netlbl_sk_security_reset(newsksec, req->rsk_ops->family);
+	selinux_netlbl_inet_csk_clone(newsk, req->rsk_ops->family);
 }
 
 static void selinux_inet_conn_established(struct sock *sk, struct sk_buff *skb)
--- a/security/selinux/include/netlabel.h
+++ b/security/selinux/include/netlabel.h
@@ -43,8 +43,7 @@ void selinux_netlbl_cache_invalidate(voi
 void selinux_netlbl_err(struct sk_buff *skb, int error, int gateway);
 
 void selinux_netlbl_sk_security_free(struct sk_security_struct *ssec);
-void selinux_netlbl_sk_security_reset(struct sk_security_struct *ssec,
-				      int family);
+void selinux_netlbl_sk_security_reset(struct sk_security_struct *ssec);
 
 int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
 				 u16 family,
@@ -87,8 +86,7 @@ static inline void selinux_netlbl_sk_sec
 }
 
 static inline void selinux_netlbl_sk_security_reset(
-					       struct sk_security_struct *ssec,
-					       int family)
+					       struct sk_security_struct *ssec)
 {
 	return;
 }
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -188,13 +188,9 @@ void selinux_netlbl_sk_security_free(str
  * The caller is responsibile for all the NetLabel sk_security_struct locking.
  *
  */
-void selinux_netlbl_sk_security_reset(struct sk_security_struct *ssec,
-				      int family)
+void selinux_netlbl_sk_security_reset(struct sk_security_struct *ssec)
 {
-	if (family == PF_INET)
-		ssec->nlbl_state = NLBL_REQUIRE;
-	else
-		ssec->nlbl_state = NLBL_UNSET;
+	ssec->nlbl_state = NLBL_UNSET;
 }
 
 /**


