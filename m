Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbZFPUpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbZFPUpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758518AbZFPUla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:41:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35513 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763518AbZFPUl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:41:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/17] RxRPC: Declare the security index constants symbolically
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:39:57 +0100
Message-ID: <20090616203957.4526.9288.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare the security index constants symbolically rather than just referring
to them numerically.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/rxrpc.h |    7 +++++++
 net/rxrpc/ar-key.c    |    4 ++--
 net/rxrpc/rxkad.c     |    6 +++---
 3 files changed, 12 insertions(+), 5 deletions(-)


diff --git a/include/linux/rxrpc.h b/include/linux/rxrpc.h
index f7b826b..a53915c 100644
--- a/include/linux/rxrpc.h
+++ b/include/linux/rxrpc.h
@@ -58,5 +58,12 @@ struct sockaddr_rxrpc {
 #define RXRPC_SECURITY_AUTH	1	/* authenticated packets */
 #define RXRPC_SECURITY_ENCRYPT	2	/* encrypted packets */
 
+/*
+ * RxRPC security indices
+ */
+#define RXRPC_SECURITY_NONE	0	/* no security protocol */
+#define RXRPC_SECURITY_RXKAD	2	/* kaserver or kerberos 4 */
+#define RXRPC_SECURITY_RXGK	4	/* gssapi-based */
+#define RXRPC_SECURITY_RXK5	5	/* kerberos 5 */
 
 #endif /* _LINUX_RXRPC_H */
diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index 00678c5..3ed1a44 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -149,7 +149,7 @@ static int rxrpc_instantiate(struct key *key, const void *data, size_t datalen)
 	}
 
 	ret = -EPROTONOSUPPORT;
-	if (security_index != 2)
+	if (security_index != RXRPC_SECURITY_RXKAD)
 		goto error;
 
 	key->type_data.x[0] = security_index;
@@ -351,7 +351,7 @@ int rxrpc_get_server_data_key(struct rxrpc_connection *conn,
 	_debug("key %d", key_serial(key));
 
 	data.kver = 1;
-	data.tsec.security_index = 2;
+	data.tsec.security_index = RXRPC_SECURITY_RXKAD;
 	data.tsec.ticket_len = 0;
 	data.tsec.expiry = expiry;
 	data.tsec.kvno = 0;
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index d5a677f..34fc0c4 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -43,7 +43,7 @@ struct rxkad_level2_hdr {
 	__be32	checksum;	/* decrypted data checksum */
 };
 
-MODULE_DESCRIPTION("RxRPC network protocol type-2 security (Kerberos)");
+MODULE_DESCRIPTION("RxRPC network protocol type-2 security (Kerberos 4)");
 MODULE_AUTHOR("Red Hat, Inc.");
 MODULE_LICENSE("GPL");
 
@@ -507,7 +507,7 @@ static int rxkad_verify_packet(const struct rxrpc_call *call,
 	if (!call->conn->cipher)
 		return 0;
 
-	if (sp->hdr.securityIndex != 2) {
+	if (sp->hdr.securityIndex != RXRPC_SECURITY_RXKAD) {
 		*_abort_code = RXKADINCONSISTENCY;
 		_leave(" = -EPROTO [not rxkad]");
 		return -EPROTO;
@@ -1123,7 +1123,7 @@ static void rxkad_clear(struct rxrpc_connection *conn)
 static struct rxrpc_security rxkad = {
 	.owner				= THIS_MODULE,
 	.name				= "rxkad",
-	.security_index			= RXKAD_VERSION,
+	.security_index			= RXRPC_SECURITY_RXKAD,
 	.init_connection_security	= rxkad_init_connection_security,
 	.prime_packet_security		= rxkad_prime_packet_security,
 	.secure_packet			= rxkad_secure_packet,

