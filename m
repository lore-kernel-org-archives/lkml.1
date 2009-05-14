Return-Path: <linux-kernel-owner+w=401wt.eu-S1761751AbZENWyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761751AbZENWyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZENWmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:46 -0400
Received: from kroah.org ([198.145.64.141]:51650 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935AbZENWmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:24 2009
Message-Id: <20090514223523.889593969@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:57 -0700
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
Subject: [patch 22/51] selinux: Remove dead code labeled networking code
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=selinux-remove-dead-code-labeled-networking-code.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Moore <paul.moore@hp.com>

[NOTE: based on 389fb800ac8be2832efedd19978a2b8ced37eb61]

Remove code that is no longer needed by NetLabel and/or SELinux.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 security/selinux/netlabel.c |   77 --------------------------------------------
 1 file changed, 77 deletions(-)

--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -100,41 +100,6 @@ static struct netlbl_lsm_secattr *selinu
 }
 
 /**
- * selinux_netlbl_sock_setsid - Label a socket using the NetLabel mechanism
- * @sk: the socket to label
- *
- * Description:
- * Attempt to label a socket using the NetLabel mechanism.  Returns zero values
- * on success, negative values on failure.
- *
- */
-static int selinux_netlbl_sock_setsid(struct sock *sk)
-{
-	int rc;
-	struct sk_security_struct *sksec = sk->sk_security;
-	struct netlbl_lsm_secattr *secattr;
-
-	if (sksec->nlbl_state != NLBL_REQUIRE)
-		return 0;
-
-	secattr = selinux_netlbl_sock_genattr(sk);
-	if (secattr == NULL)
-		return -ENOMEM;
-	rc = netlbl_sock_setattr(sk, secattr);
-	switch (rc) {
-	case 0:
-		sksec->nlbl_state = NLBL_LABELED;
-		break;
-	case -EDESTADDRREQ:
-		sksec->nlbl_state = NLBL_REQSKB;
-		rc = 0;
-		break;
-	}
-
-	return rc;
-}
-
-/**
  * selinux_netlbl_cache_invalidate - Invalidate the NetLabel cache
  *
  * Description:
@@ -361,48 +326,6 @@ int selinux_netlbl_socket_post_create(st
 }
 
 /**
- * selinux_netlbl_inode_permission - Verify the socket is NetLabel labeled
- * @inode: the file descriptor's inode
- * @mask: the permission mask
- *
- * Description:
- * Looks at a file's inode and if it is marked as a socket protected by
- * NetLabel then verify that the socket has been labeled, if not try to label
- * the socket now with the inode's SID.  Returns zero on success, negative
- * values on failure.
- *
- */
-int selinux_netlbl_inode_permission(struct inode *inode, int mask)
-{
-	int rc;
-	struct sock *sk;
-	struct socket *sock;
-	struct sk_security_struct *sksec;
-
-	if (!S_ISSOCK(inode->i_mode) ||
-	    ((mask & (MAY_WRITE | MAY_APPEND)) == 0))
-		return 0;
-	sock = SOCKET_I(inode);
-	sk = sock->sk;
-	if (sk == NULL)
-		return 0;
-	sksec = sk->sk_security;
-	if (sksec == NULL || sksec->nlbl_state != NLBL_REQUIRE)
-		return 0;
-
-	local_bh_disable();
-	bh_lock_sock_nested(sk);
-	if (likely(sksec->nlbl_state == NLBL_REQUIRE))
-		rc = selinux_netlbl_sock_setsid(sk);
-	else
-		rc = 0;
-	bh_unlock_sock(sk);
-	local_bh_enable();
-
-	return rc;
-}
-
-/**
  * selinux_netlbl_sock_rcv_skb - Do an inbound access check using NetLabel
  * @sksec: the sock's sk_security_struct
  * @skb: the packet


