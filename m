Return-Path: <linux-kernel-owner+w=401wt.eu-S935009AbXGZTnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935009AbXGZTnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765727AbXGZTm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:42:59 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:53957 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762801AbXGZTm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:42:58 -0400
Message-ID: <46A8F926.1070606@hp.com>
Date: Thu, 26 Jul 2007 15:42:30 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Cc: lksctp-developers@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Srinivas Akkipeddi <sakkiped@starentnetworks.com>
Subject: Re: [PATCH] SCTP: IPv4 mapped addr not returned in SCTPv6 accept()
References: <18087.57737.908842.337891@zeus.sw.starentnetworks.com>	<46A8E027.10802@hp.com> <18088.61269.5608.925496@zeus.sw.starentnetworks.com>
In-Reply-To: <18088.61269.5608.925496@zeus.sw.starentnetworks.com>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------040900040902050304040702"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040900040902050304040702
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dave Johnson wrote:
> Vlad Yasevich writes:
>> Can you explain why the sctp_v4 changes are need for the this case?
>> I don't see how the code in sctp/protocol.c comes into play for this
>> particular bug.
> 
> connect() on v6 socket to v4 mapped address will trigger
> sctp_v4_to_sk_daddr:
> 
> strace:
> 
> socket(PF_INET6, SOCK_STREAM, 0x84 /* IPPROTO_??? */) = 3
> bind(3, {sa_family=AF_INET6, sin6_port=htons(0), inet_pton(AF_INET6, "::", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, 128) = 0
> connect(3, {sa_family=AF_INET6, sin6_port=htons(33333), inet_pton(AF_INET6, "::ffff:192.168.207.231", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, 128) = 0
> getsockname(3, {sa_family=AF_INET6, sin6_port=htons(32771), inet_pton(AF_INET6, "::ffff:192.168.207.234", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, [28]) = 0
> getpeername(3, {sa_family=AF_INET6, sin6_port=htons(33333), inet_pton(AF_INET6, "::ffff:192.168.207.231", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, [28]) = 0
> 
> stack dump:
> 
>  [<f8c539de>] sctp_v4_to_sk_daddr+0x3e/0x80 [sctp]
>  [<f8c5f6c4>] __sctp_connect+0x2a4/0x520 [sctp]
>  [<f8c61810>] sctp_connect+0x60/0x70 [sctp]
>  [<c02c4b2c>] inet_dgram_connect+0x4c/0x80
>  [<c026dbab>] sys_connect+0x8b/0xd0
>  [<c026e711>] sys_socketcall+0xb1/0x260
>  [<c0103013>] syscall_call+0x7/0xb
> 
> I'm unsure if there is a path to call sctp_v4_to_sk_saddr() but it was
> added just to be complete.
> 
> v4mapped in sctp_v4_create_accept_sk() probably isn't needed, but
> since v4mapped is in sctp_sock not sctp6_sock copying it seems like a
> good idea.

Ok.  First, this is a different bug, so I would prefer a separate patch.
Also, I see the problem and it's ugly, but this solution is not really correct,
both conceptually and code wise.

Conceptually, the v4 code should never worry about V4-mapped addresses and shouldn't
muck with them.  They are IPv6 addresses and there should be a clean separation.

Code wise, the code in the __sctp_connect() is terrible.

Does the attached patch work for you in this case.

Thanks
-vlad

--------------040900040902050304040702
Content-Type: text/plain;
 name="connect_bug.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="connect_bug.txt"

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b1917f6..1577814 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -977,7 +977,7 @@ static int __sctp_connect(struct sock* sk,
 	int err = 0;
 	int addrcnt = 0;
 	int walk_size = 0;
-	union sctp_addr *sa_addr;
+	union sctp_addr *sa_addr = NULL;
 	void *addr_buf;
 	unsigned short port;
 	unsigned int f_flags = 0;
@@ -1011,7 +1011,10 @@ static int __sctp_connect(struct sock* sk,
 			goto out_free;
 		}
 
-		err = sctp_verify_addr(sk, sa_addr, af->sockaddr_len);
+		/* Save current address so we can work with it */
+		memcpy(&to, sa_addr, af->sockaddr_len);
+
+		err = sctp_verify_addr(sk, &to, af->sockaddr_len);
 		if (err)
 			goto out_free;
 
@@ -1021,12 +1024,11 @@ static int __sctp_connect(struct sock* sk,
 		if (asoc && asoc->peer.port && asoc->peer.port != port)
 			goto out_free;
 
-		memcpy(&to, sa_addr, af->sockaddr_len);
 
 		/* Check if there already is a matching association on the
 		 * endpoint (other than the one created here).
 		 */
-		asoc2 = sctp_endpoint_lookup_assoc(ep, sa_addr, &transport);
+		asoc2 = sctp_endpoint_lookup_assoc(ep, &to, &transport);
 		if (asoc2 && asoc2 != asoc) {
 			if (asoc2->state >= SCTP_STATE_ESTABLISHED)
 				err = -EISCONN;
@@ -1039,7 +1041,7 @@ static int __sctp_connect(struct sock* sk,
 		 * make sure that there is no peeled-off association matching
 		 * the peer address even on another socket.
 		 */
-		if (sctp_endpoint_is_peeled_off(ep, sa_addr)) {
+		if (sctp_endpoint_is_peeled_off(ep, &to)) {
 			err = -EADDRNOTAVAIL;
 			goto out_free;
 		}
@@ -1070,7 +1072,7 @@ static int __sctp_connect(struct sock* sk,
 				}
 			}
 
-			scope = sctp_scope(sa_addr);
+			scope = sctp_scope(&to);
 			asoc = sctp_association_new(ep, sk, scope, GFP_KERNEL);
 			if (!asoc) {
 				err = -ENOMEM;
@@ -1079,7 +1081,7 @@ static int __sctp_connect(struct sock* sk,
 		}
 
 		/* Prime the peer's transport structures.  */
-		transport = sctp_assoc_add_peer(asoc, sa_addr, GFP_KERNEL,
+		transport = sctp_assoc_add_peer(asoc, &to, GFP_KERNEL,
 						SCTP_UNKNOWN);
 		if (!transport) {
 			err = -ENOMEM;
@@ -1103,8 +1105,8 @@ static int __sctp_connect(struct sock* sk,
 
 	/* Initialize sk's dport and daddr for getpeername() */
 	inet_sk(sk)->dport = htons(asoc->peer.port);
-	af = sctp_get_af_specific(to.sa.sa_family);
-	af->to_sk_daddr(&to, sk);
+	af = sctp_get_af_specific(sa_addr->sa.sa_family);
+	af->to_sk_daddr(sa_addr, sk);
 	sk->sk_err = 0;
 
 	/* in-kernel sockets don't generally have a file allocated to them

--------------040900040902050304040702--
