Return-Path: <linux-kernel-owner+w=401wt.eu-S1764028AbZFPUmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764028AbZFPUmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762613AbZFPUkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:40:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59594 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761839AbZFPUkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:40:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/17] RxRPC: Record extra data in key
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 16 Jun 2009 21:39:52 +0100
Message-ID: <20090616203952.4526.76006.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
References: <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Institute key data version 2 to allow the kernel to store the vice_id and the
ticket start time as well as the other fields.  Whilst these aren't actually
required for the network protocol, they are required to be returned by the
VIOCGETTOK/PGetTokens pioctl of AFS.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/keys/rxrpc-type.h |   46 +++++++++++++++++
 net/rxrpc/ar-internal.h   |   16 ------
 net/rxrpc/ar-key.c        |  121 ++++++++++++++++++++++++++++++---------------
 net/rxrpc/rxkad.c         |    1 
 4 files changed, 129 insertions(+), 55 deletions(-)


diff --git a/include/keys/rxrpc-type.h b/include/keys/rxrpc-type.h
index 7609365..42d6d91 100644
--- a/include/keys/rxrpc-type.h
+++ b/include/keys/rxrpc-type.h
@@ -21,4 +21,50 @@ extern struct key_type key_type_rxrpc;
 
 extern struct key *rxrpc_get_null_key(const char *);
 
+/*
+ * RxRPC key for Kerberos (type-2 security)
+ */
+struct rxkad_key {
+	u16	security_index;		/* RxRPC header security index */
+	u16	ticket_len;		/* length of ticket[] */
+	u32	vice_id;
+	u32	start;			/* time at which ticket starts */
+	u32	expiry;			/* time at which ticket expires */
+	u32	kvno;			/* key version number */
+	u8	session_key[8];		/* DES session key */
+	u8	ticket[0];		/* the encrypted ticket */
+};
+
+/*
+ * structure of raw payloads passed to add_key() or instantiate key
+ */
+struct rxrpc_key_data_v1 {
+	u32		kif_version;		/* 1 */
+	u16		security_index;
+	u16		ticket_length;
+	u32		expiry;			/* time_t */
+	u32		kvno;
+	u8		session_key[8];
+	u8		ticket[0];
+};
+
+struct rxrpc_key_data_v2 {
+	u32		kif_version;		/* 2 */
+	u16		security_index;
+	u16		ticket_length;
+	u32		vice_id;
+	u32		start;			/* time_t */
+	u32		expiry;			/* time_t */
+	u32		kvno;
+	u8		session_key[8];
+	u8		ticket[0];
+};
+
+/*
+ * structure of data attached to rxrpc key struct
+ */
+struct rxrpc_key_payload {
+	struct rxkad_key k;
+};
+
 #endif /* _KEYS_RXRPC_TYPE_H */
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 3e7318c..46c6d88 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -402,22 +402,6 @@ struct rxrpc_call {
 };
 
 /*
- * RxRPC key for Kerberos (type-2 security)
- */
-struct rxkad_key {
-	u16	security_index;		/* RxRPC header security index */
-	u16	ticket_len;		/* length of ticket[] */
-	u32	expiry;			/* time at which expires */
-	u32	kvno;			/* key version number */
-	u8	session_key[8];		/* DES session key */
-	u8	ticket[0];		/* the encrypted ticket */
-};
-
-struct rxrpc_key_payload {
-	struct rxkad_key k;
-};
-
-/*
  * locally abort an RxRPC call
  */
 static inline void rxrpc_abort_call(struct rxrpc_call *call, u32 abort_code)
diff --git a/net/rxrpc/ar-key.c b/net/rxrpc/ar-key.c
index ad8c7a7..00678c5 100644
--- a/net/rxrpc/ar-key.c
+++ b/net/rxrpc/ar-key.c
@@ -70,10 +70,11 @@ struct key_type key_type_rxrpc_s = {
  */
 static int rxrpc_instantiate(struct key *key, const void *data, size_t datalen)
 {
-	const struct rxkad_key *tsec;
+	const struct rxrpc_key_data_v1 *v1 = data;
+	const struct rxrpc_key_data_v2 *v2 = data;
 	struct rxrpc_key_payload *upayload;
 	size_t plen;
-	u32 kver;
+	u32 kver, security_index, ticket_len;
 	int ret;
 
 	_enter("{%x},,%zu", key_serial(key), datalen);
@@ -86,48 +87,74 @@ static int rxrpc_instantiate(struct key *key, const void *data, size_t datalen)
 	ret = -EINVAL;
 	if (datalen <= 4 || !data)
 		goto error;
-	memcpy(&kver, data, sizeof(kver));
-	data += sizeof(kver);
-	datalen -= sizeof(kver);
+	kver = v1->kif_version;
 
 	_debug("KEY I/F VERSION: %u", kver);
 
-	ret = -EKEYREJECTED;
-	if (kver != 1)
+	if (kver == 1) {
+		/* deal with a version 1 data blob */
+		ret = -EINVAL;
+		if (datalen < sizeof(*v1))
+			goto error;
+		security_index = v1->security_index;
+		ticket_len = v1->ticket_length;
+		if (datalen != sizeof(*v1) + ticket_len)
+			goto error;
+
+		_debug("SCIX: %u", security_index);
+		_debug("TLEN: %u", ticket_len);
+		_debug("EXPY: %x", v1->expiry);
+		_debug("KVNO: %u", v1->kvno);
+		_debug("SKEY: %02x%02x%02x%02x%02x%02x%02x%02x",
+		       v1->session_key[0], v1->session_key[1],
+		       v1->session_key[2], v1->session_key[3],
+		       v1->session_key[4], v1->session_key[5],
+		       v1->session_key[6], v1->session_key[7]);
+		if (ticket_len >= 8)
+			_debug("TCKT: %02x%02x%02x%02x%02x%02x%02x%02x",
+			       v1->ticket[0], v1->ticket[1],
+			       v1->ticket[2], v1->ticket[3],
+			       v1->ticket[4], v1->ticket[5],
+			       v1->ticket[6], v1->ticket[7]);
+	} else if (kver == 2) {
+		/* deal with a version 2 data blob */
+		ret = -EINVAL;
+		if (datalen < sizeof(*v2))
+			goto error;
+		security_index = v2->security_index;
+		ticket_len = v2->ticket_length;
+		if (datalen != sizeof(*v2) + ticket_len)
+			goto error;
+
+		_debug("SCIX: %u", security_index);
+		_debug("TLEN: %u", ticket_len);
+		_debug("VICE: %x", v2->vice_id);
+		_debug("STRT: %x", v2->start);
+		_debug("EXPY: %x", v2->expiry);
+		_debug("KVNO: %u", v2->kvno);
+		_debug("SKEY: %02x%02x%02x%02x%02x%02x%02x%02x",
+		       v2->session_key[0], v2->session_key[1],
+		       v2->session_key[2], v2->session_key[3],
+		       v2->session_key[4], v2->session_key[5],
+		       v2->session_key[6], v2->session_key[7]);
+		if (ticket_len >= 8)
+			_debug("TCKT: %02x%02x%02x%02x%02x%02x%02x%02x",
+			       v2->ticket[0], v2->ticket[1],
+			       v2->ticket[2], v2->ticket[3],
+			       v2->ticket[4], v2->ticket[5],
+			       v2->ticket[6], v2->ticket[7]);
+	} else {
+		ret = -EKEYREJECTED;
 		goto error;
-
-	/* deal with a version 1 key */
-	ret = -EINVAL;
-	if (datalen < sizeof(*tsec))
-		goto error;
-
-	tsec = data;
-	if (datalen != sizeof(*tsec) + tsec->ticket_len)
-		goto error;
-
-	_debug("SCIX: %u", tsec->security_index);
-	_debug("TLEN: %u", tsec->ticket_len);
-	_debug("EXPY: %x", tsec->expiry);
-	_debug("KVNO: %u", tsec->kvno);
-	_debug("SKEY: %02x%02x%02x%02x%02x%02x%02x%02x",
-	       tsec->session_key[0], tsec->session_key[1],
-	       tsec->session_key[2], tsec->session_key[3],
-	       tsec->session_key[4], tsec->session_key[5],
-	       tsec->session_key[6], tsec->session_key[7]);
-	if (tsec->ticket_len >= 8)
-		_debug("TCKT: %02x%02x%02x%02x%02x%02x%02x%02x",
-		       tsec->ticket[0], tsec->ticket[1],
-		       tsec->ticket[2], tsec->ticket[3],
-		       tsec->ticket[4], tsec->ticket[5],
-		       tsec->ticket[6], tsec->ticket[7]);
+	}
 
 	ret = -EPROTONOSUPPORT;
-	if (tsec->security_index != 2)
+	if (security_index != 2)
 		goto error;
 
-	key->type_data.x[0] = tsec->security_index;
+	key->type_data.x[0] = security_index;
 
-	plen = sizeof(*upayload) + tsec->ticket_len;
+	plen = sizeof(*upayload) + ticket_len;
 	ret = key_payload_reserve(key, plen);
 	if (ret < 0)
 		goto error;
@@ -138,14 +165,30 @@ static int rxrpc_instantiate(struct key *key, const void *data, size_t datalen)
 		goto error;
 
 	/* attach the data */
-	memcpy(&upayload->k, tsec, sizeof(*tsec));
-	memcpy(&upayload->k.ticket, (void *)tsec + sizeof(*tsec),
-	       tsec->ticket_len);
+	if (kver == 1) {
+		upayload->k.security_index	= security_index;
+		upayload->k.ticket_len		= ticket_len;
+		upayload->k.expiry		= v1->expiry;
+		upayload->k.kvno		= v1->kvno;
+		memcpy(&upayload->k.session_key, &v1->session_key,
+		       8 + ticket_len);
+	} else if (kver == 2) {
+		upayload->k.security_index	= security_index;
+		upayload->k.ticket_len		= ticket_len;
+		upayload->k.vice_id		= v2->vice_id;
+		upayload->k.start		= v2->start;
+		upayload->k.expiry		= v2->expiry;
+		upayload->k.kvno		= v2->kvno;
+		memcpy(&upayload->k.session_key, &v2->session_key,
+		       8 + ticket_len);
+	}
+
 	key->payload.data = upayload;
-	key->expiry = tsec->expiry;
+	key->expiry = upayload->k.expiry;
 	ret = 0;
 
 error:
+	_leave(" = %d", ret);
 	return ret;
 }
 
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index ef8f910..d5a677f 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -16,6 +16,7 @@
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
 #include <linux/ctype.h>
+#include <keys/rxrpc-type.h>
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
 #define rxrpc_debug rxkad_debug

