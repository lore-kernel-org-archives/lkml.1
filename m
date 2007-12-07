Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXLGU5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXLGU5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXLGU5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:57:33 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:15046 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbXLGU5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:57:32 -0500
Message-ID: <4759B3B9.6080903@schaufler-ca.com>
Date: Fri, 07 Dec 2007 12:57:29 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH] (2.6.24-rc4-mm1) -mm Smack getpeercred_stream fix for SO_PEERSEC
 and TCP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

Collect the Smack label of the other end on connection so that
getsockopt(..., SO_PEERSEC, ...) can report it. This is done
in smack_inet_conn_request(). Report the correct value in
smack_socket_getpeersec_stream(). Initialize the smk_packet
field in the socket blob. Comment on the purpose of smk_packet
in the header file and remove the unused smk_depth field from
the blob.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 security/smack/smack.h     |    7 +++----
 security/smack/smack_lsm.c |   14 +++++++++++---
 2 files changed, 14 insertions(+), 7 deletions(-)

diff -uprN -X linux-2.6.24-rc4-mm1-base/Documentation/dontdiff linux-2.6.24-rc4-mm1-base/security/smack/smack.h linux-2.6.24-rc4-mm1-smack/security/smack/smack.h
--- linux-2.6.24-rc4-mm1-base/security/smack/smack.h	2007-12-04 19:20:59.000000000 -0800
+++ linux-2.6.24-rc4-mm1-smack/security/smack/smack.h	2007-12-07 09:25:16.000000000 -0800
@@ -44,10 +44,9 @@ struct superblock_smack {
 };
 
 struct socket_smack {
-	char		*smk_out;	/* outbound label */
-	char		*smk_in;	/* inbound label */
-	char		smk_packet[SMK_LABELLEN];
-	int		smk_depth;
+	char		*smk_out;			/* outbound label */
+	char		*smk_in;			/* inbound label */
+	char		smk_packet[SMK_LABELLEN];	/* TCP peer label */
 };
 
 /*
diff -uprN -X linux-2.6.24-rc4-mm1-base/Documentation/dontdiff linux-2.6.24-rc4-mm1-base/security/smack/smack_lsm.c linux-2.6.24-rc4-mm1-smack/security/smack/smack_lsm.c
--- linux-2.6.24-rc4-mm1-base/security/smack/smack_lsm.c	2007-12-04 19:20:59.000000000 -0800
+++ linux-2.6.24-rc4-mm1-smack/security/smack/smack_lsm.c	2007-12-07 11:10:58.000000000 -0800
@@ -1232,6 +1232,7 @@ static int smack_sk_alloc_security(struc
 
 	ssp->smk_in = csp;
 	ssp->smk_out = csp;
+	ssp->smk_packet[0] = '\0';
 
 	sk->sk_security = ssp;
 
@@ -2115,11 +2116,11 @@ static int smack_socket_getpeersec_strea
 	int rc = 0;
 
 	ssp = sock->sk->sk_security;
-	slen = strlen(ssp->smk_out);
+	slen = strlen(ssp->smk_packet) + 1;
 
 	if (slen > len)
 		rc = -ERANGE;
-	else if (copy_to_user(optval, ssp->smk_out, slen) != 0)
+	else if (copy_to_user(optval, ssp->smk_packet, slen) != 0)
 		rc = -EFAULT;
 
 	if (put_user(slen, optlen) != 0)
@@ -2251,8 +2252,15 @@ static int smack_inet_conn_request(struc
 	/*
 	 * Receiving a packet requires that the other end
 	 * be able to write here. Read access is not required.
+	 *
+	 * If the request is successful save the peer's label
+	 * so that SO_PEERCRED can report it.
 	 */
-	return smk_access(smack, ssp->smk_in, MAY_WRITE);
+	rc = smk_access(smack, ssp->smk_in, MAY_WRITE);
+	if (rc == 0)
+		strncpy(ssp->smk_packet, smack, SMK_MAXLEN);
+
+	return rc;
 }
 
 /*

