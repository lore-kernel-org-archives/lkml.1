Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbXGZATb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbXGZATb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 20:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbXGZATC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 20:19:02 -0400
Received: from [12.38.223.190] ([12.38.223.190]:30924 "EHLO
	mail.sw.starentnetworks.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751591AbXGZAS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 20:18:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18087.57737.908842.337891@zeus.sw.starentnetworks.com>
Date: Wed, 25 Jul 2007 19:49:29 -0400
From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
To: lksctp-developers@lists.sourceforge.net, vladislav.yasevich@hp.com
Cc: linux-kernel@vger.kernel.org,
       "Srinivas Akkipeddi" <sakkiped@starentnetworks.com>
Subject: [PATCH] SCTP: IPv4 mapped addr not returned in SCTPv6 accept()
X-Mailer: VM 7.17 under 21.4 (patch 17) "Jumbo Shrimp" XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


An accept() call on a SCTPv6 socket that returns due to connection of
a IPv4 mapped peer will fill out the 'struct sockaddr' with a zero
IPv6 address instead of the IPv4 mapped address of the peer.

This is due to the v4mapped flag not getting copied into the new
socket on accept() as well as a missing check for INET6 socket type in
sctp_v4_to_sk_*addr().

Signed-off-by: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Cc: Srinivas Akkipeddi <sakkiped@starentnetworks.com>

===== net/sctp/ipv6.c 1.108 vs edited =====
--- 1.108/net/sctp/ipv6.c	2007-07-05 20:40:15 -04:00
+++ edited/net/sctp/ipv6.c	2007-07-25 16:30:41 -04:00
@@ -641,6 +641,8 @@
 	newsctp6sk = (struct sctp6_sock *)newsk;
 	inet_sk(newsk)->pinet6 = &newsctp6sk->inet6;
 
+	sctp_sk(newsk)->v4mapped = sctp_sk(sk)->v4mapped;
+
 	newinet = inet_sk(newsk);
 	newnp = inet6_sk(newsk);
 
===== net/sctp/protocol.c 1.130 vs edited =====
--- 1.130/net/sctp/protocol.c	2007-05-04 16:36:30 -04:00
+++ edited/net/sctp/protocol.c	2007-07-25 16:28:21 -04:00
@@ -257,13 +257,28 @@
 /* Initialize sk->sk_rcv_saddr from sctp_addr. */
 static void sctp_v4_to_sk_saddr(union sctp_addr *addr, struct sock *sk)
 {
-	inet_sk(sk)->rcv_saddr = addr->v4.sin_addr.s_addr;
+	if ((sk->sk_family == PF_INET6) && (sctp_sk(sk)->v4mapped)) {
+		inet6_sk(sk)->rcv_saddr.s6_addr32[0] = 0;
+		inet6_sk(sk)->rcv_saddr.s6_addr32[1] = 0;
+		inet6_sk(sk)->rcv_saddr.s6_addr32[2] = htonl(0x0000ffff);
+		inet6_sk(sk)->rcv_saddr.s6_addr32[3] =
+			addr->v4.sin_addr.s_addr;
+	} else {
+		inet_sk(sk)->rcv_saddr = addr->v4.sin_addr.s_addr;
+	}
 }
 
 /* Initialize sk->sk_daddr from sctp_addr. */
 static void sctp_v4_to_sk_daddr(union sctp_addr *addr, struct sock *sk)
 {
-	inet_sk(sk)->daddr = addr->v4.sin_addr.s_addr;
+	if ((sk->sk_family == PF_INET6) && (sctp_sk(sk)->v4mapped)) {
+		inet6_sk(sk)->daddr.s6_addr32[0] = 0;
+		inet6_sk(sk)->daddr.s6_addr32[1] = 0;
+		inet6_sk(sk)->daddr.s6_addr32[2] = htonl(0x0000ffff);
+		inet6_sk(sk)->daddr.s6_addr32[3] = addr->v4.sin_addr.s_addr;
+	} else {
+		inet_sk(sk)->daddr = addr->v4.sin_addr.s_addr;
+	}
 }
 
 /* Initialize a sctp_addr from an address parameter. */
@@ -557,6 +572,8 @@
 	newsk->sk_protocol = IPPROTO_SCTP;
 	newsk->sk_backlog_rcv = sk->sk_prot->backlog_rcv;
 	sock_reset_flag(newsk, SOCK_ZAPPED);
+
+	sctp_sk(newsk)->v4mapped = sctp_sk(sk)->v4mapped;
 
 	newinet = inet_sk(newsk);
 

