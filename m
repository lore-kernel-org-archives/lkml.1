Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbXJNSVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbXJNSVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758254AbXJNSVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:21:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45631 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbXJNSVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:21:22 -0400
Date: Sun, 14 Oct 2007 19:21:20 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH] fix breakage in sctp getsockopt
Message-ID: <20071014182120.GX8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() into on-stack array

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/sctp/socket.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9c6a4b5..bd6f42a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5058,6 +5058,7 @@ static int sctp_getsockopt_active_key(struct sock *sk, int len,
 static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 				    char __user *optval, int __user *optlen)
 {
+	struct sctp_authchunks __user *p = (void __user *)optval;
 	struct sctp_authchunks val;
 	struct sctp_association *asoc;
 	struct sctp_chunks_param *ch;
@@ -5066,10 +5067,10 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 	if (len <= sizeof(struct sctp_authchunks))
 		return -EINVAL;
 
-	if (copy_from_user(&val, optval, sizeof(struct sctp_authchunks)))
+	if (copy_from_user(&val, p, sizeof(struct sctp_authchunks)))
 		return -EFAULT;
 
-	to = val.gauth_chunks;
+	to = p->gauth_chunks;
 	asoc = sctp_id2assoc(sk, val.gauth_assoc_id);
 	if (!asoc)
 		return -EINVAL;
@@ -5092,6 +5093,7 @@ static int sctp_getsockopt_peer_auth_chunks(struct sock *sk, int len,
 static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
 				    char __user *optval, int __user *optlen)
 {
+	struct sctp_authchunks __user *p = (void __user *)optval;
 	struct sctp_authchunks val;
 	struct sctp_association *asoc;
 	struct sctp_chunks_param *ch;
@@ -5100,10 +5102,10 @@ static int sctp_getsockopt_local_auth_chunks(struct sock *sk, int len,
 	if (len <= sizeof(struct sctp_authchunks))
 		return -EINVAL;
 
-	if (copy_from_user(&val, optval, sizeof(struct sctp_authchunks)))
+	if (copy_from_user(&val, p, sizeof(struct sctp_authchunks)))
 		return -EFAULT;
 
-	to = val.gauth_chunks;
+	to = p->gauth_chunks;
 	asoc = sctp_id2assoc(sk, val.gauth_assoc_id);
 	if (!asoc && val.gauth_assoc_id && sctp_style(sk, UDP))
 		return -EINVAL;
-- 
1.5.3.GIT
