Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYBMB20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYBMB20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbYBMB2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:28:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:58604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbYBMB2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:28:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=wLqIs8zYH0fZx7qHTjN+CTgEqI8Sv05Y4omzga9zrQU3pd8MTnyfYgZhck/wYqedAKvi9NRzBXHovNEEF0OjONeB6QjHtxisHmRVmv84yGq/8iUSyOs+ROpMn1CSZBvyhPDOIzBSxNpEcMu+wEv1trq7Q59a54dxoI2/ja0Q+d4=
Date: Wed, 13 Feb 2008 03:25:23 +0200
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Casey Schaufler <casey@schuafler-ca.com>, Joerg Platte <jplatte@naasa.net>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Subject: [PATCH BUGFIX 25-rc1] Smack: Don't fail against Nulled sk sockets
Message-ID: <20080213012523.GA12416@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!,

Appropriately handle sockets with sk = NULL. This is usually the socket
case when starting kernel nfsd.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Casey Schaufler <casey@schuafler-ca.com>
Tested-by: Joerg Platte <jplatte@naasa.net>
--

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 1c11e42..eb04278 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -701,7 +701,7 @@ static int smack_inode_getsecurity(const struct inode *inode,
 		return -EOPNOTSUPP;
 
 	sock = SOCKET_I(ip);
-	if (sock == NULL)
+	if (sock == NULL || sock->sk == NULL)
 		return -EOPNOTSUPP;
 
 	ssp = sock->sk->sk_security;
@@ -1280,10 +1280,12 @@ static void smack_to_secattr(char *smack, struct netlbl_lsm_secattr *nlsp)
  */
 static int smack_netlabel(struct sock *sk)
 {
-	struct socket_smack *ssp = sk->sk_security;
+	struct socket_smack *ssp;
 	struct netlbl_lsm_secattr secattr;
 	int rc = 0;
 
+	BUG_ON(sk == NULL);
+	ssp = sk->sk_security;
 	netlbl_secattr_init(&secattr);
 	smack_to_secattr(ssp->smk_out, &secattr);
 	if (secattr.flags != NETLBL_SECATTR_NONE)
@@ -1331,7 +1333,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 		return -EOPNOTSUPP;
 
 	sock = SOCKET_I(inode);
-	if (sock == NULL)
+	if (sock == NULL || sock->sk == NULL)
 		return -EOPNOTSUPP;
 
 	ssp = sock->sk->sk_security;
@@ -1362,7 +1364,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 static int smack_socket_post_create(struct socket *sock, int family,
 				    int type, int protocol, int kern)
 {
-	if (family != PF_INET)
+	if (family != PF_INET || sock->sk == NULL)
 		return 0;
 	/*
 	 * Set the outbound netlbl.


Warm regards

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

