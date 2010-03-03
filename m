Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0CCAtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 19:49:21 -0500
Received: from cobra.newdream.net ([66.33.216.30]:54212 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab0CCAqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 19:46:49 -0500
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 18/26] ceph: 'auth_x' authentication scheme
Date: Tue,  2 Mar 2010 16:46:49 -0800
Message-Id: <1267577217-31923-19-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267577217-31923-1-git-send-email-sage@newdream.net>
References: <1267577217-31923-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements the 'auth_x' authentication scheme, which bears
some similarity to Kerberos but is designed to perform well for
large, distributed clusters providing a single 'virtual' service
(as with the ceph osd and mds clusters).

The client authenticates with the monitor and obtains an auth
ticket as well as service tickets for talking to the mds and
osd clusters.  Tickets are periodically renewed, as the servers
rotate their keys.

Each time the client opens a TCP connection to a service, it
provides the ticket, which mutually authenticates the client
to the service and the service to the client.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/armor.c           |   99 +++++++
 fs/ceph/auth_x.c          |  656 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/auth_x.h          |   49 ++++
 fs/ceph/auth_x_protocol.h |   90 ++++++
 fs/ceph/crypto.c          |  408 ++++++++++++++++++++++++++++
 fs/ceph/crypto.h          |   48 ++++
 6 files changed, 1350 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/armor.c
 create mode 100644 fs/ceph/auth_x.c
 create mode 100644 fs/ceph/auth_x.h
 create mode 100644 fs/ceph/auth_x_protocol.h
 create mode 100644 fs/ceph/crypto.c
 create mode 100644 fs/ceph/crypto.h

diff --git a/fs/ceph/armor.c b/fs/ceph/armor.c
new file mode 100644
index 0000000..67b2c03
--- /dev/null
+++ b/fs/ceph/armor.c
@@ -0,0 +1,99 @@
+
+#include <linux/errno.h>
+
+/*
+ * base64 encode/decode.
+ */
+
+const char *pem_key = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+
+static int encode_bits(int c)
+{
+	return pem_key[c];
+}
+
+static int decode_bits(char c)
+{
+	if (c >= 'A' && c <= 'Z')
+		return c - 'A';
+	if (c >= 'a' && c <= 'z')
+		return c - 'a' + 26;
+	if (c >= '0' && c <= '9')
+		return c - '0' + 52;
+	if (c == '+')
+		return 62;
+	if (c == '/')
+		return 63;
+	if (c == '=')
+		return 0; /* just non-negative, please */
+	return -EINVAL;
+}
+
+int ceph_armor(char *dst, const char *src, const char *end)
+{
+	int olen = 0;
+	int line = 0;
+
+	while (src < end) {
+		unsigned char a, b, c;
+
+		a = *src++;
+		*dst++ = encode_bits(a >> 2);
+		if (src < end) {
+			b = *src++;
+			*dst++ = encode_bits(((a & 3) << 4) | (b >> 4));
+			if (src < end) {
+				c = *src++;
+				*dst++ = encode_bits(((b & 15) << 2) |
+						     (c >> 6));
+				*dst++ = encode_bits(c & 63);
+			} else {
+				*dst++ = encode_bits((b & 15) << 2);
+				*dst++ = '=';
+			}
+		} else {
+			*dst++ = encode_bits(((a & 3) << 4));
+			*dst++ = '=';
+			*dst++ = '=';
+		}
+		olen += 4;
+		line += 4;
+		if (line == 64) {
+			line = 0;
+			*(dst++) = '\n';
+			olen++;
+		}
+	}
+	return olen;
+}
+
+int ceph_unarmor(char *dst, const char *src, const char *end)
+{
+	int olen = 0;
+
+	while (src < end) {
+		int a, b, c, d;
+
+		if (src < end && src[0] == '\n')
+			src++;
+		if (src + 4 > end)
+			return -EINVAL;
+		a = decode_bits(src[0]);
+		b = decode_bits(src[1]);
+		c = decode_bits(src[2]);
+		d = decode_bits(src[3]);
+		if (a < 0 || b < 0 || c < 0 || d < 0)
+			return -EINVAL;
+
+		*dst++ = (a << 2) | (b >> 4);
+		if (src[2] == '=')
+			return olen + 1;
+		*dst++ = ((b & 15) << 4) | (c >> 2);
+		if (src[3] == '=')
+			return olen + 2;
+		*dst++ = ((c & 3) << 6) | d;
+		olen += 3;
+		src += 4;
+	}
+	return olen;
+}
diff --git a/fs/ceph/auth_x.c b/fs/ceph/auth_x.c
new file mode 100644
index 0000000..f031842
--- /dev/null
+++ b/fs/ceph/auth_x.c
@@ -0,0 +1,656 @@
+
+#include "ceph_debug.h"
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/random.h>
+
+#include "auth_x.h"
+#include "auth_x_protocol.h"
+#include "crypto.h"
+#include "auth.h"
+#include "decode.h"
+
+struct kmem_cache *ceph_x_ticketbuf_cachep;
+
+#define TEMP_TICKET_BUF_LEN	256
+
+static void ceph_x_validate_tickets(struct ceph_auth_client *ac, int *pneed);
+
+static int ceph_x_is_authenticated(struct ceph_auth_client *ac)
+{
+	struct ceph_x_info *xi = ac->private;
+	int need;
+
+	ceph_x_validate_tickets(ac, &need);
+	dout("ceph_x_is_authenticated want=%d need=%d have=%d\n",
+	     ac->want_keys, need, xi->have_keys);
+	return (ac->want_keys & xi->have_keys) == ac->want_keys;
+}
+
+static int ceph_x_encrypt(struct ceph_crypto_key *secret,
+			  void *ibuf, int ilen, void *obuf, size_t olen)
+{
+	struct ceph_x_encrypt_header head = {
+		.struct_v = 1,
+		.magic = cpu_to_le64(CEPHX_ENC_MAGIC)
+	};
+	size_t len = olen - sizeof(u32);
+	int ret;
+
+	ret = ceph_encrypt2(secret, obuf + sizeof(u32), &len,
+			    &head, sizeof(head), ibuf, ilen);
+	if (ret)
+		return ret;
+	ceph_encode_32(&obuf, len);
+	return len + sizeof(u32);
+}
+
+static int ceph_x_decrypt(struct ceph_crypto_key *secret,
+			  void **p, void *end, void *obuf, size_t olen)
+{
+	struct ceph_x_encrypt_header head;
+	size_t head_len = sizeof(head);
+	int len, ret;
+
+	len = ceph_decode_32(p);
+	if (*p + len > end)
+		return -EINVAL;
+
+	dout("ceph_x_decrypt len %d\n", len);
+	ret = ceph_decrypt2(secret, &head, &head_len, obuf, &olen,
+			    *p, len);
+	if (ret)
+		return ret;
+	if (head.struct_v != 1 || le64_to_cpu(head.magic) != CEPHX_ENC_MAGIC)
+		return -EPERM;
+	*p += len;
+	return olen;
+}
+
+/*
+ * get existing (or insert new) ticket handler
+ */
+struct ceph_x_ticket_handler *get_ticket_handler(struct ceph_auth_client *ac,
+						 int service)
+{
+	struct ceph_x_ticket_handler *th;
+	struct ceph_x_info *xi = ac->private;
+	struct rb_node *parent = NULL, **p = &xi->ticket_handlers.rb_node;
+
+	while (*p) {
+		parent = *p;
+		th = rb_entry(parent, struct ceph_x_ticket_handler, node);
+		if (service < th->service)
+			p = &(*p)->rb_left;
+		else if (service > th->service)
+			p = &(*p)->rb_right;
+		else
+			return th;
+	}
+
+	/* add it */
+	th = kzalloc(sizeof(*th), GFP_NOFS);
+	if (!th)
+		return ERR_PTR(-ENOMEM);
+	th->service = service;
+	rb_link_node(&th->node, parent, p);
+	rb_insert_color(&th->node, &xi->ticket_handlers);
+	return th;
+}
+
+static void remove_ticket_handler(struct ceph_auth_client *ac,
+				  struct ceph_x_ticket_handler *th)
+{
+	struct ceph_x_info *xi = ac->private;
+
+	dout("remove_ticket_handler %p %d\n", th, th->service);
+	rb_erase(&th->node, &xi->ticket_handlers);
+	ceph_crypto_key_destroy(&th->session_key);
+	if (th->ticket_blob)
+		ceph_buffer_put(th->ticket_blob);
+	kfree(th);
+}
+
+static int ceph_x_proc_ticket_reply(struct ceph_auth_client *ac,
+				    struct ceph_crypto_key *secret,
+				    void *buf, void *end)
+{
+	struct ceph_x_info *xi = ac->private;
+	int num;
+	void *p = buf;
+	int ret;
+	char *dbuf;
+	char *ticket_buf;
+	u8 struct_v;
+
+	dbuf = kmem_cache_alloc(ceph_x_ticketbuf_cachep, GFP_NOFS | GFP_ATOMIC);
+	if (!dbuf)
+		return -ENOMEM;
+
+	ret = -ENOMEM;
+	ticket_buf = kmem_cache_alloc(ceph_x_ticketbuf_cachep,
+				      GFP_NOFS | GFP_ATOMIC);
+	if (!ticket_buf)
+		goto out_dbuf;
+
+	ceph_decode_need(&p, end, 1 + sizeof(u32), bad);
+	struct_v = ceph_decode_8(&p);
+	if (struct_v != 1)
+		goto bad;
+	num = ceph_decode_32(&p);
+	dout("%d tickets\n", num);
+	while (num--) {
+		int type;
+		u8 struct_v;
+		struct ceph_x_ticket_handler *th;
+		void *dp, *dend;
+		int dlen;
+		char is_enc;
+		struct timespec validity;
+		struct ceph_crypto_key old_key;
+		void *tp, *tpend;
+
+		ceph_decode_need(&p, end, sizeof(u32) + 1, bad);
+
+		type = ceph_decode_32(&p);
+		dout(" ticket type %d %s\n", type, ceph_entity_type_name(type));
+
+		struct_v = ceph_decode_8(&p);
+		if (struct_v != 1)
+			goto bad;
+
+		th = get_ticket_handler(ac, type);
+		if (IS_ERR(th)) {
+			ret = PTR_ERR(th);
+			goto out;
+		}
+
+		/* blob for me */
+		dlen = ceph_x_decrypt(secret, &p, end, dbuf,
+				      TEMP_TICKET_BUF_LEN);
+		if (dlen <= 0) {
+			ret = dlen;
+			goto out;
+		}
+		dout(" decrypted %d bytes\n", dlen);
+		dend = dbuf + dlen;
+		dp = dbuf;
+
+		struct_v = ceph_decode_8(&dp);
+		if (struct_v != 1)
+			goto bad;
+
+		memcpy(&old_key, &th->session_key, sizeof(old_key));
+		ret = ceph_crypto_key_decode(&th->session_key, &dp, dend);
+		if (ret)
+			goto out;
+
+		ceph_decode_copy(&dp, &th->validity, sizeof(th->validity));
+		ceph_decode_timespec(&validity, &th->validity);
+		th->expires = get_seconds() + validity.tv_sec;
+		th->renew_after = th->expires - (validity.tv_sec / 4);
+		dout(" expires=%lu renew_after=%lu\n", th->expires,
+		     th->renew_after);
+
+		/* ticket blob for service */
+		ceph_decode_8_safe(&p, end, is_enc, bad);
+		tp = ticket_buf;
+		if (is_enc) {
+			/* encrypted */
+			dout(" encrypted ticket\n");
+			dlen = ceph_x_decrypt(&old_key, &p, end, ticket_buf,
+					      TEMP_TICKET_BUF_LEN);
+			if (dlen < 0) {
+				ret = dlen;
+				goto out;
+			}
+			dlen = ceph_decode_32(&tp);
+		} else {
+			/* unencrypted */
+			ceph_decode_32_safe(&p, end, dlen, bad);
+			ceph_decode_need(&p, end, dlen, bad);
+			ceph_decode_copy(&p, ticket_buf, dlen);
+		}
+		tpend = tp + dlen;
+		dout(" ticket blob is %d bytes\n", dlen);
+		ceph_decode_need(&tp, tpend, 1 + sizeof(u64), bad);
+		struct_v = ceph_decode_8(&tp);
+		th->secret_id = ceph_decode_64(&tp);
+		ret = ceph_decode_buffer(&th->ticket_blob, &tp, tpend);
+		if (ret)
+			goto out;
+		dout(" got ticket service %d (%s) secret_id %lld len %d\n",
+		     type, ceph_entity_type_name(type), th->secret_id,
+		     (int)th->ticket_blob->vec.iov_len);
+		xi->have_keys |= th->service;
+	}
+
+	ret = 0;
+out:
+	kmem_cache_free(ceph_x_ticketbuf_cachep, ticket_buf);
+out_dbuf:
+	kmem_cache_free(ceph_x_ticketbuf_cachep, dbuf);
+	return ret;
+
+bad:
+	ret = -EINVAL;
+	goto out;
+}
+
+static int ceph_x_build_authorizer(struct ceph_auth_client *ac,
+				   struct ceph_x_ticket_handler *th,
+				   struct ceph_x_authorizer *au)
+{
+	int len;
+	struct ceph_x_authorize_a *msg_a;
+	struct ceph_x_authorize_b msg_b;
+	void *p, *end;
+	int ret;
+	int ticket_blob_len =
+		(th->ticket_blob ? th->ticket_blob->vec.iov_len : 0);
+
+	dout("build_authorizer for %s %p\n",
+	     ceph_entity_type_name(th->service), au);
+
+	len = sizeof(*msg_a) + sizeof(msg_b) + sizeof(u32) +
+		ticket_blob_len + 16;
+	dout("  need len %d\n", len);
+	if (au->buf && au->buf->alloc_len < len) {
+		ceph_buffer_put(au->buf);
+		au->buf = NULL;
+	}
+	if (!au->buf) {
+		au->buf = ceph_buffer_new(len, GFP_NOFS);
+		if (!au->buf)
+			return -ENOMEM;
+	}
+	au->service = th->service;
+
+	msg_a = au->buf->vec.iov_base;
+	msg_a->struct_v = 1;
+	msg_a->global_id = cpu_to_le64(ac->global_id);
+	msg_a->service_id = cpu_to_le32(th->service);
+	msg_a->ticket_blob.struct_v = 1;
+	msg_a->ticket_blob.secret_id = cpu_to_le64(th->secret_id);
+	msg_a->ticket_blob.blob_len = cpu_to_le32(ticket_blob_len);
+	if (ticket_blob_len) {
+		memcpy(msg_a->ticket_blob.blob, th->ticket_blob->vec.iov_base,
+		       th->ticket_blob->vec.iov_len);
+	}
+	dout(" th %p secret_id %lld %lld\n", th, th->secret_id,
+	     le64_to_cpu(msg_a->ticket_blob.secret_id));
+
+	p = msg_a + 1;
+	p += ticket_blob_len;
+	end = au->buf->vec.iov_base + au->buf->vec.iov_len;
+
+	get_random_bytes(&au->nonce, sizeof(au->nonce));
+	msg_b.struct_v = 1;
+	msg_b.nonce = cpu_to_le64(au->nonce);
+	ret = ceph_x_encrypt(&th->session_key, &msg_b, sizeof(msg_b),
+			     p, end - p);
+	if (ret < 0)
+		goto out_buf;
+	p += ret;
+	au->buf->vec.iov_len = p - au->buf->vec.iov_base;
+	dout(" built authorizer nonce %llx len %d\n", au->nonce,
+	     (int)au->buf->vec.iov_len);
+	return 0;
+
+out_buf:
+	ceph_buffer_put(au->buf);
+	au->buf = NULL;
+	return ret;
+}
+
+static int ceph_x_encode_ticket(struct ceph_x_ticket_handler *th,
+				void **p, void *end)
+{
+	ceph_decode_need(p, end, 1 + sizeof(u64), bad);
+	ceph_encode_8(p, 1);
+	ceph_encode_64(p, th->secret_id);
+	if (th->ticket_blob) {
+		const char *buf = th->ticket_blob->vec.iov_base;
+		u32 len = th->ticket_blob->vec.iov_len;
+
+		ceph_encode_32_safe(p, end, len, bad);
+		ceph_encode_copy_safe(p, end, buf, len, bad);
+	} else {
+		ceph_encode_32_safe(p, end, 0, bad);
+	}
+
+	return 0;
+bad:
+	return -ERANGE;
+}
+
+static void ceph_x_validate_tickets(struct ceph_auth_client *ac, int *pneed)
+{
+	int want = ac->want_keys;
+	struct ceph_x_info *xi = ac->private;
+	int service;
+
+	*pneed = ac->want_keys & ~(xi->have_keys);
+
+	for (service = 1; service <= want; service <<= 1) {
+		struct ceph_x_ticket_handler *th;
+
+		if (!(ac->want_keys & service))
+			continue;
+
+		if (*pneed & service)
+			continue;
+
+		th = get_ticket_handler(ac, service);
+
+		if (!th) {
+			*pneed |= service;
+			continue;
+		}
+
+		if (get_seconds() >= th->renew_after)
+			*pneed |= service;
+		if (get_seconds() >= th->expires)
+			xi->have_keys &= ~service;
+	}
+}
+
+
+static int ceph_x_build_request(struct ceph_auth_client *ac,
+				void *buf, void *end)
+{
+	struct ceph_x_info *xi = ac->private;
+	int need;
+	struct ceph_x_request_header *head = buf;
+	int ret;
+	struct ceph_x_ticket_handler *th =
+		get_ticket_handler(ac, CEPH_ENTITY_TYPE_AUTH);
+
+	ceph_x_validate_tickets(ac, &need);
+
+	dout("build_request want %x have %x need %x\n",
+	     ac->want_keys, xi->have_keys, need);
+
+	if (need & CEPH_ENTITY_TYPE_AUTH) {
+		struct ceph_x_authenticate *auth = (void *)(head + 1);
+		void *p = auth + 1;
+		struct ceph_x_challenge_blob tmp;
+		char tmp_enc[40];
+		u64 *u;
+
+		if (p > end)
+			return -ERANGE;
+
+		dout(" get_auth_session_key\n");
+		head->op = cpu_to_le16(CEPHX_GET_AUTH_SESSION_KEY);
+
+		/* encrypt and hash */
+		get_random_bytes(&auth->client_challenge, sizeof(u64));
+		tmp.client_challenge = auth->client_challenge;
+		tmp.server_challenge = cpu_to_le64(xi->server_challenge);
+		ret = ceph_x_encrypt(&xi->secret, &tmp, sizeof(tmp),
+				     tmp_enc, sizeof(tmp_enc));
+		if (ret < 0)
+			return ret;
+
+		auth->struct_v = 1;
+		auth->key = 0;
+		for (u = (u64 *)tmp_enc; u + 1 <= (u64 *)(tmp_enc + ret); u++)
+			auth->key ^= *u;
+		dout(" server_challenge %llx client_challenge %llx key %llx\n",
+		     xi->server_challenge, le64_to_cpu(auth->client_challenge),
+		     le64_to_cpu(auth->key));
+
+		/* now encode the old ticket if exists */
+		ret = ceph_x_encode_ticket(th, &p, end);
+		if (ret < 0)
+			return ret;
+
+		return p - buf;
+	}
+
+	if (need) {
+		void *p = head + 1;
+		struct ceph_x_service_ticket_request *req;
+
+		if (p > end)
+			return -ERANGE;
+		head->op = cpu_to_le16(CEPHX_GET_PRINCIPAL_SESSION_KEY);
+
+		BUG_ON(!th);
+		ret = ceph_x_build_authorizer(ac, th, &xi->auth_authorizer);
+		if (ret)
+			return ret;
+		ceph_encode_copy(&p, xi->auth_authorizer.buf->vec.iov_base,
+				 xi->auth_authorizer.buf->vec.iov_len);
+
+		req = p;
+		req->keys = cpu_to_le32(need);
+		p += sizeof(*req);
+		return p - buf;
+	}
+
+	return 0;
+}
+
+static int ceph_x_handle_reply(struct ceph_auth_client *ac, int result,
+			       void *buf, void *end)
+{
+	struct ceph_x_info *xi = ac->private;
+	struct ceph_x_reply_header *head = buf;
+	struct ceph_x_ticket_handler *th;
+	int len = end - buf;
+	int op;
+	int ret;
+
+	if (result)
+		return result;  /* XXX hmm? */
+
+	if (xi->starting) {
+		/* it's a hello */
+		struct ceph_x_server_challenge *sc = buf;
+
+		if (len != sizeof(*sc))
+			return -EINVAL;
+		xi->server_challenge = le64_to_cpu(sc->server_challenge);
+		dout("handle_reply got server challenge %llx\n",
+		     xi->server_challenge);
+		xi->starting = false;
+		xi->have_keys &= ~CEPH_ENTITY_TYPE_AUTH;
+		return -EAGAIN;
+	}
+
+	op = le32_to_cpu(head->op);
+	result = le32_to_cpu(head->result);
+	dout("handle_reply op %d result %d\n", op, result);
+	switch (op) {
+	case CEPHX_GET_AUTH_SESSION_KEY:
+		/* verify auth key */
+		ret = ceph_x_proc_ticket_reply(ac, &xi->secret,
+					       buf + sizeof(*head), end);
+		break;
+
+	case CEPHX_GET_PRINCIPAL_SESSION_KEY:
+		th = get_ticket_handler(ac, CEPH_ENTITY_TYPE_AUTH);
+		BUG_ON(!th);
+		ret = ceph_x_proc_ticket_reply(ac, &th->session_key,
+					       buf + sizeof(*head), end);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	if (ret)
+		return ret;
+	if (ac->want_keys == xi->have_keys)
+		return 0;
+	return -EAGAIN;
+}
+
+static int ceph_x_create_authorizer(
+	struct ceph_auth_client *ac, int peer_type,
+	struct ceph_authorizer **a,
+	void **buf, size_t *len,
+	void **reply_buf, size_t *reply_len)
+{
+	struct ceph_x_authorizer *au;
+	struct ceph_x_ticket_handler *th;
+	int ret;
+
+	th = get_ticket_handler(ac, peer_type);
+	if (IS_ERR(th))
+		return PTR_ERR(th);
+
+	au = kzalloc(sizeof(*au), GFP_NOFS);
+	if (!au)
+		return -ENOMEM;
+
+	ret = ceph_x_build_authorizer(ac, th, au);
+	if (ret) {
+		kfree(au);
+		return ret;
+	}
+
+	*a = (struct ceph_authorizer *)au;
+	*buf = au->buf->vec.iov_base;
+	*len = au->buf->vec.iov_len;
+	*reply_buf = au->reply_buf;
+	*reply_len = sizeof(au->reply_buf);
+	return 0;
+}
+
+static int ceph_x_verify_authorizer_reply(struct ceph_auth_client *ac,
+					  struct ceph_authorizer *a, size_t len)
+{
+	struct ceph_x_authorizer *au = (void *)a;
+	struct ceph_x_ticket_handler *th;
+	int ret = 0;
+	struct ceph_x_authorize_reply reply;
+	void *p = au->reply_buf;
+	void *end = p + sizeof(au->reply_buf);
+
+	th = get_ticket_handler(ac, au->service);
+	if (!th)
+		return -EIO;  /* hrm! */
+	ret = ceph_x_decrypt(&th->session_key, &p, end, &reply, sizeof(reply));
+	if (ret < 0)
+		return ret;
+	if (ret != sizeof(reply))
+		return -EPERM;
+
+	if (au->nonce + 1 != le64_to_cpu(reply.nonce_plus_one))
+		ret = -EPERM;
+	else
+		ret = 0;
+	dout("verify_authorizer_reply nonce %llx got %llx ret %d\n",
+	     au->nonce, le64_to_cpu(reply.nonce_plus_one), ret);
+	return ret;
+}
+
+static void ceph_x_destroy_authorizer(struct ceph_auth_client *ac,
+				      struct ceph_authorizer *a)
+{
+	struct ceph_x_authorizer *au = (void *)a;
+
+	ceph_buffer_put(au->buf);
+	kfree(au);
+}
+
+
+static void ceph_x_reset(struct ceph_auth_client *ac)
+{
+	struct ceph_x_info *xi = ac->private;
+
+	dout("reset\n");
+	xi->starting = true;
+	xi->server_challenge = 0;
+}
+
+static void ceph_x_destroy(struct ceph_auth_client *ac)
+{
+	struct ceph_x_info *xi = ac->private;
+	struct rb_node *p;
+
+	dout("ceph_x_destroy %p\n", ac);
+	ceph_crypto_key_destroy(&xi->secret);
+
+	while ((p = rb_first(&xi->ticket_handlers)) != NULL) {
+		struct ceph_x_ticket_handler *th =
+			rb_entry(p, struct ceph_x_ticket_handler, node);
+		remove_ticket_handler(ac, th);
+	}
+
+	kmem_cache_destroy(ceph_x_ticketbuf_cachep);
+
+	kfree(ac->private);
+	ac->private = NULL;
+}
+
+static void ceph_x_invalidate_authorizer(struct ceph_auth_client *ac,
+				   int peer_type)
+{
+	struct ceph_x_ticket_handler *th;
+
+	th = get_ticket_handler(ac, peer_type);
+	if (th && !IS_ERR(th))
+		remove_ticket_handler(ac, th);
+}
+
+
+static const struct ceph_auth_client_ops ceph_x_ops = {
+	.is_authenticated = ceph_x_is_authenticated,
+	.build_request = ceph_x_build_request,
+	.handle_reply = ceph_x_handle_reply,
+	.create_authorizer = ceph_x_create_authorizer,
+	.verify_authorizer_reply = ceph_x_verify_authorizer_reply,
+	.destroy_authorizer = ceph_x_destroy_authorizer,
+	.invalidate_authorizer = ceph_x_invalidate_authorizer,
+	.reset =  ceph_x_reset,
+	.destroy = ceph_x_destroy,
+};
+
+
+int ceph_x_init(struct ceph_auth_client *ac)
+{
+	struct ceph_x_info *xi;
+	int ret;
+
+	dout("ceph_x_init %p\n", ac);
+	xi = kzalloc(sizeof(*xi), GFP_NOFS);
+	if (!xi)
+		return -ENOMEM;
+
+	ret = -ENOMEM;
+	ceph_x_ticketbuf_cachep = kmem_cache_create("ceph_x_ticketbuf",
+				      TEMP_TICKET_BUF_LEN, 8,
+				      (SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD),
+				      NULL);
+	if (!ceph_x_ticketbuf_cachep)
+		goto done_nomem;
+	ret = -EINVAL;
+	if (!ac->secret) {
+		pr_err("no secret set (for auth_x protocol)\n");
+		goto done_nomem;
+	}
+
+	ret = ceph_crypto_key_unarmor(&xi->secret, ac->secret);
+	if (ret)
+		goto done_nomem;
+
+	xi->starting = true;
+	xi->ticket_handlers = RB_ROOT;
+
+	ac->protocol = CEPH_AUTH_CEPHX;
+	ac->private = xi;
+	ac->ops = &ceph_x_ops;
+	return 0;
+
+done_nomem:
+	kfree(xi);
+	if (ceph_x_ticketbuf_cachep)
+		kmem_cache_destroy(ceph_x_ticketbuf_cachep);
+	return ret;
+}
+
+
diff --git a/fs/ceph/auth_x.h b/fs/ceph/auth_x.h
new file mode 100644
index 0000000..ff6f818
--- /dev/null
+++ b/fs/ceph/auth_x.h
@@ -0,0 +1,49 @@
+#ifndef _FS_CEPH_AUTH_X_H
+#define _FS_CEPH_AUTH_X_H
+
+#include <linux/rbtree.h>
+
+#include "crypto.h"
+#include "auth.h"
+#include "auth_x_protocol.h"
+
+/*
+ * Handle ticket for a single service.
+ */
+struct ceph_x_ticket_handler {
+	struct rb_node node;
+	unsigned service;
+
+	struct ceph_crypto_key session_key;
+	struct ceph_timespec validity;
+
+	u64 secret_id;
+	struct ceph_buffer *ticket_blob;
+
+	unsigned long renew_after, expires;
+};
+
+
+struct ceph_x_authorizer {
+	struct ceph_buffer *buf;
+	unsigned service;
+	u64 nonce;
+	char reply_buf[128];  /* big enough for encrypted blob */
+};
+
+struct ceph_x_info {
+	struct ceph_crypto_key secret;
+
+	bool starting;
+	u64 server_challenge;
+
+	unsigned have_keys;
+	struct rb_root ticket_handlers;
+
+	struct ceph_x_authorizer auth_authorizer;
+};
+
+extern int ceph_x_init(struct ceph_auth_client *ac);
+
+#endif
+
diff --git a/fs/ceph/auth_x_protocol.h b/fs/ceph/auth_x_protocol.h
new file mode 100644
index 0000000..671d305
--- /dev/null
+++ b/fs/ceph/auth_x_protocol.h
@@ -0,0 +1,90 @@
+#ifndef __FS_CEPH_AUTH_X_PROTOCOL
+#define __FS_CEPH_AUTH_X_PROTOCOL
+
+#define CEPHX_GET_AUTH_SESSION_KEY      0x0100
+#define CEPHX_GET_PRINCIPAL_SESSION_KEY 0x0200
+#define CEPHX_GET_ROTATING_KEY          0x0400
+
+/* common bits */
+struct ceph_x_ticket_blob {
+	__u8 struct_v;
+	__le64 secret_id;
+	__le32 blob_len;
+	char blob[];
+} __attribute__ ((packed));
+
+
+/* common request/reply headers */
+struct ceph_x_request_header {
+	__le16 op;
+} __attribute__ ((packed));
+
+struct ceph_x_reply_header {
+	__le16 op;
+	__le32 result;
+} __attribute__ ((packed));
+
+
+/* authenticate handshake */
+
+/* initial hello (no reply header) */
+struct ceph_x_server_challenge {
+	__u8 struct_v;
+	__le64 server_challenge;
+} __attribute__ ((packed));
+
+struct ceph_x_authenticate {
+	__u8 struct_v;
+	__le64 client_challenge;
+	__le64 key;
+	/* ticket blob */
+} __attribute__ ((packed));
+
+struct ceph_x_service_ticket_request {
+	__u8 struct_v;
+	__le32 keys;
+} __attribute__ ((packed));
+
+struct ceph_x_challenge_blob {
+	__le64 server_challenge;
+	__le64 client_challenge;
+} __attribute__ ((packed));
+
+
+
+/* authorize handshake */
+
+/*
+ * The authorizer consists of two pieces:
+ *  a - service id, ticket blob
+ *  b - encrypted with session key
+ */
+struct ceph_x_authorize_a {
+	__u8 struct_v;
+	__le64 global_id;
+	__le32 service_id;
+	struct ceph_x_ticket_blob ticket_blob;
+} __attribute__ ((packed));
+
+struct ceph_x_authorize_b {
+	__u8 struct_v;
+	__le64 nonce;
+} __attribute__ ((packed));
+
+struct ceph_x_authorize_reply {
+	__u8 struct_v;
+	__le64 nonce_plus_one;
+} __attribute__ ((packed));
+
+
+/*
+ * encyption bundle
+ */
+#define CEPHX_ENC_MAGIC 0xff009cad8826aa55ull
+
+struct ceph_x_encrypt_header {
+	__u8 struct_v;
+	__le64 magic;
+} __attribute__ ((packed));
+
+#endif
diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
new file mode 100644
index 0000000..291ac28
--- /dev/null
+++ b/fs/ceph/crypto.c
@@ -0,0 +1,408 @@
+
+#include "ceph_debug.h"
+
+#include <linux/err.h>
+#include <linux/scatterlist.h>
+#include <crypto/hash.h>
+
+#include "crypto.h"
+#include "decode.h"
+
+int ceph_crypto_key_encode(struct ceph_crypto_key *key, void **p, void *end)
+{
+	if (*p + sizeof(u16) + sizeof(key->created) +
+	    sizeof(u16) + key->len > end)
+		return -ERANGE;
+	ceph_encode_16(p, key->type);
+	ceph_encode_copy(p, &key->created, sizeof(key->created));
+	ceph_encode_16(p, key->len);
+	ceph_encode_copy(p, key->key, key->len);
+	return 0;
+}
+
+int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end)
+{
+	ceph_decode_need(p, end, 2*sizeof(u16) + sizeof(key->created), bad);
+	key->type = ceph_decode_16(p);
+	ceph_decode_copy(p, &key->created, sizeof(key->created));
+	key->len = ceph_decode_16(p);
+	ceph_decode_need(p, end, key->len, bad);
+	key->key = kmalloc(key->len, GFP_NOFS);
+	if (!key->key)
+		return -ENOMEM;
+	ceph_decode_copy(p, key->key, key->len);
+	return 0;
+
+bad:
+	dout("failed to decode crypto key\n");
+	return -EINVAL;
+}
+
+int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *inkey)
+{
+	int inlen = strlen(inkey);
+	int blen = inlen * 3 / 4;
+	void *buf, *p;
+	int ret;
+
+	dout("crypto_key_unarmor %s\n", inkey);
+	buf = kmalloc(blen, GFP_NOFS);
+	if (!buf)
+		return -ENOMEM;
+	blen = ceph_unarmor(buf, inkey, inkey+inlen);
+	if (blen < 0) {
+		kfree(buf);
+		return blen;
+	}
+
+	p = buf;
+	ret = ceph_crypto_key_decode(key, &p, p + blen);
+	kfree(buf);
+	if (ret)
+		return ret;
+	dout("crypto_key_unarmor key %p type %d len %d\n", key,
+	     key->type, key->len);
+	return 0;
+}
+
+
+
+#define AES_KEY_SIZE 16
+
+static struct crypto_blkcipher *ceph_crypto_alloc_cipher(void)
+{
+	return crypto_alloc_blkcipher("cbc(aes)", 0, CRYPTO_ALG_ASYNC);
+}
+
+const u8 *aes_iv = "cephsageyudagreg";
+
+int ceph_aes_encrypt(const void *key, int key_len, void *dst, size_t *dst_len,
+		     const void *src, size_t src_len)
+{
+	struct scatterlist sg_in[2], sg_out[1];
+	struct crypto_blkcipher *tfm = ceph_crypto_alloc_cipher();
+	struct blkcipher_desc desc = { .tfm = tfm, .flags = 0 };
+	int ret;
+	void *iv;
+	int ivsize;
+	size_t zero_padding = (0x10 - (src_len & 0x0f));
+	char pad[16];
+
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	memset(pad, zero_padding, zero_padding);
+
+	*dst_len = src_len + zero_padding;
+
+	crypto_blkcipher_setkey((void *)tfm, key, key_len);
+	sg_init_table(sg_in, 2);
+	sg_set_buf(&sg_in[0], src, src_len);
+	sg_set_buf(&sg_in[1], pad, zero_padding);
+	sg_init_table(sg_out, 1);
+	sg_set_buf(sg_out, dst, *dst_len);
+	iv = crypto_blkcipher_crt(tfm)->iv;
+	ivsize = crypto_blkcipher_ivsize(tfm);
+
+	memcpy(iv, aes_iv, ivsize);
+	/*
+	print_hex_dump(KERN_ERR, "enc key: ", DUMP_PREFIX_NONE, 16, 1,
+		       key, key_len, 1);
+	print_hex_dump(KERN_ERR, "enc src: ", DUMP_PREFIX_NONE, 16, 1,
+			src, src_len, 1);
+	print_hex_dump(KERN_ERR, "enc pad: ", DUMP_PREFIX_NONE, 16, 1,
+			pad, zero_padding, 1);
+	*/
+	ret = crypto_blkcipher_encrypt(&desc, sg_out, sg_in,
+				     src_len + zero_padding);
+	crypto_free_blkcipher(tfm);
+	if (ret < 0)
+		pr_err("ceph_aes_crypt failed %d\n", ret);
+	/*
+	print_hex_dump(KERN_ERR, "enc out: ", DUMP_PREFIX_NONE, 16, 1,
+		       dst, *dst_len, 1);
+	*/
+	return 0;
+}
+
+int ceph_aes_encrypt2(const void *key, int key_len, void *dst, size_t *dst_len,
+		      const void *src1, size_t src1_len,
+		      const void *src2, size_t src2_len)
+{
+	struct scatterlist sg_in[3], sg_out[1];
+	struct crypto_blkcipher *tfm = ceph_crypto_alloc_cipher();
+	struct blkcipher_desc desc = { .tfm = tfm, .flags = 0 };
+	int ret;
+	void *iv;
+	int ivsize;
+	size_t zero_padding = (0x10 - ((src1_len + src2_len) & 0x0f));
+	char pad[16];
+
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	memset(pad, zero_padding, zero_padding);
+
+	*dst_len = src1_len + src2_len + zero_padding;
+
+	crypto_blkcipher_setkey((void *)tfm, key, key_len);
+	sg_init_table(sg_in, 3);
+	sg_set_buf(&sg_in[0], src1, src1_len);
+	sg_set_buf(&sg_in[1], src2, src2_len);
+	sg_set_buf(&sg_in[2], pad, zero_padding);
+	sg_init_table(sg_out, 1);
+	sg_set_buf(sg_out, dst, *dst_len);
+	iv = crypto_blkcipher_crt(tfm)->iv;
+	ivsize = crypto_blkcipher_ivsize(tfm);
+
+	memcpy(iv, aes_iv, ivsize);
+	/*
+	print_hex_dump(KERN_ERR, "enc  key: ", DUMP_PREFIX_NONE, 16, 1,
+		       key, key_len, 1);
+	print_hex_dump(KERN_ERR, "enc src1: ", DUMP_PREFIX_NONE, 16, 1,
+			src1, src1_len, 1);
+	print_hex_dump(KERN_ERR, "enc src2: ", DUMP_PREFIX_NONE, 16, 1,
+			src2, src2_len, 1);
+	print_hex_dump(KERN_ERR, "enc  pad: ", DUMP_PREFIX_NONE, 16, 1,
+			pad, zero_padding, 1);
+	*/
+	ret = crypto_blkcipher_encrypt(&desc, sg_out, sg_in,
+				     src1_len + src2_len + zero_padding);
+	crypto_free_blkcipher(tfm);
+	if (ret < 0)
+		pr_err("ceph_aes_crypt2 failed %d\n", ret);
+	/*
+	print_hex_dump(KERN_ERR, "enc  out: ", DUMP_PREFIX_NONE, 16, 1,
+		       dst, *dst_len, 1);
+	*/
+	return 0;
+}
+
+int ceph_aes_decrypt(const void *key, int key_len, void *dst, size_t *dst_len,
+		     const void *src, size_t src_len)
+{
+	struct scatterlist sg_in[1], sg_out[2];
+	struct crypto_blkcipher *tfm = ceph_crypto_alloc_cipher();
+	struct blkcipher_desc desc = { .tfm = tfm };
+	char pad[16];
+	void *iv;
+	int ivsize;
+	int ret;
+	int last_byte;
+
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	crypto_blkcipher_setkey((void *)tfm, key, key_len);
+	sg_init_table(sg_in, 1);
+	sg_init_table(sg_out, 2);
+	sg_set_buf(sg_in, src, src_len);
+	sg_set_buf(&sg_out[0], dst, *dst_len);
+	sg_set_buf(&sg_out[1], pad, sizeof(pad));
+
+	iv = crypto_blkcipher_crt(tfm)->iv;
+	ivsize = crypto_blkcipher_ivsize(tfm);
+
+	memcpy(iv, aes_iv, ivsize);
+
+	/*
+	print_hex_dump(KERN_ERR, "dec key: ", DUMP_PREFIX_NONE, 16, 1,
+		       key, key_len, 1);
+	print_hex_dump(KERN_ERR, "dec  in: ", DUMP_PREFIX_NONE, 16, 1,
+		       src, src_len, 1);
+	*/
+
+	ret = crypto_blkcipher_decrypt(&desc, sg_out, sg_in, src_len);
+	crypto_free_blkcipher(tfm);
+	if (ret < 0) {
+		pr_err("ceph_aes_decrypt failed %d\n", ret);
+		return ret;
+	}
+
+	if (src_len <= *dst_len)
+		last_byte = ((char *)dst)[src_len - 1];
+	else
+		last_byte = pad[src_len - *dst_len - 1];
+	if (last_byte <= 16 && src_len >= last_byte) {
+		*dst_len = src_len - last_byte;
+	} else {
+		pr_err("ceph_aes_decrypt got bad padding %d on src len %d\n",
+		       last_byte, (int)src_len);
+		return -EPERM;  /* bad padding */
+	}
+	/*
+	print_hex_dump(KERN_ERR, "dec out: ", DUMP_PREFIX_NONE, 16, 1,
+		       dst, *dst_len, 1);
+	*/
+	return 0;
+}
+
+int ceph_aes_decrypt2(const void *key, int key_len,
+		      void *dst1, size_t *dst1_len,
+		      void *dst2, size_t *dst2_len,
+		      const void *src, size_t src_len)
+{
+	struct scatterlist sg_in[1], sg_out[3];
+	struct crypto_blkcipher *tfm = ceph_crypto_alloc_cipher();
+	struct blkcipher_desc desc = { .tfm = tfm };
+	char pad[16];
+	void *iv;
+	int ivsize;
+	int ret;
+	int last_byte;
+
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	sg_init_table(sg_in, 1);
+	sg_set_buf(sg_in, src, src_len);
+	sg_init_table(sg_out, 3);
+	sg_set_buf(&sg_out[0], dst1, *dst1_len);
+	sg_set_buf(&sg_out[1], dst2, *dst2_len);
+	sg_set_buf(&sg_out[2], pad, sizeof(pad));
+
+	crypto_blkcipher_setkey((void *)tfm, key, key_len);
+	iv = crypto_blkcipher_crt(tfm)->iv;
+	ivsize = crypto_blkcipher_ivsize(tfm);
+
+	memcpy(iv, aes_iv, ivsize);
+
+	/*
+	print_hex_dump(KERN_ERR, "dec  key: ", DUMP_PREFIX_NONE, 16, 1,
+		       key, key_len, 1);
+	print_hex_dump(KERN_ERR, "dec   in: ", DUMP_PREFIX_NONE, 16, 1,
+		       src, src_len, 1);
+	*/
+
+	ret = crypto_blkcipher_decrypt(&desc, sg_out, sg_in, src_len);
+	crypto_free_blkcipher(tfm);
+	if (ret < 0) {
+		pr_err("ceph_aes_decrypt failed %d\n", ret);
+		return ret;
+	}
+
+	if (src_len <= *dst1_len)
+		last_byte = ((char *)dst1)[src_len - 1];
+	else if (src_len <= *dst1_len + *dst2_len)
+		last_byte = ((char *)dst2)[src_len - *dst1_len - 1];
+	else
+		last_byte = pad[src_len - *dst1_len - *dst2_len - 1];
+	if (last_byte <= 16 && src_len >= last_byte) {
+		src_len -= last_byte;
+	} else {
+		pr_err("ceph_aes_decrypt got bad padding %d on src len %d\n",
+		       last_byte, (int)src_len);
+		return -EPERM;  /* bad padding */
+	}
+
+	if (src_len < *dst1_len) {
+		*dst1_len = src_len;
+		*dst2_len = 0;
+	} else {
+		*dst2_len = src_len - *dst1_len;
+	}
+	/*
+	print_hex_dump(KERN_ERR, "dec  out1: ", DUMP_PREFIX_NONE, 16, 1,
+		       dst1, *dst1_len, 1);
+	print_hex_dump(KERN_ERR, "dec  out2: ", DUMP_PREFIX_NONE, 16, 1,
+		       dst2, *dst2_len, 1);
+	*/
+
+	return 0;
+}
+
+
+int ceph_decrypt(struct ceph_crypto_key *secret, void *dst, size_t *dst_len,
+		 const void *src, size_t src_len)
+{
+	switch (secret->type) {
+	case CEPH_CRYPTO_NONE:
+		if (*dst_len < src_len)
+			return -ERANGE;
+		memcpy(dst, src, src_len);
+		*dst_len = src_len;
+		return 0;
+
+	case CEPH_CRYPTO_AES:
+		return ceph_aes_decrypt(secret->key, secret->len, dst,
+					dst_len, src, src_len);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+int ceph_decrypt2(struct ceph_crypto_key *secret,
+			void *dst1, size_t *dst1_len,
+			void *dst2, size_t *dst2_len,
+			const void *src, size_t src_len)
+{
+	size_t t;
+
+	switch (secret->type) {
+	case CEPH_CRYPTO_NONE:
+		if (*dst1_len + *dst2_len < src_len)
+			return -ERANGE;
+		t = min(*dst1_len, src_len);
+		memcpy(dst1, src, t);
+		*dst1_len = t;
+		src += t;
+		src_len -= t;
+		if (src_len) {
+			t = min(*dst2_len, src_len);
+			memcpy(dst2, src, t);
+			*dst2_len = t;
+		}
+		return 0;
+
+	case CEPH_CRYPTO_AES:
+		return ceph_aes_decrypt2(secret->key, secret->len,
+					 dst1, dst1_len, dst2, dst2_len,
+					 src, src_len);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+int ceph_encrypt(struct ceph_crypto_key *secret, void *dst, size_t *dst_len,
+		 const void *src, size_t src_len)
+{
+	switch (secret->type) {
+	case CEPH_CRYPTO_NONE:
+		if (*dst_len < src_len)
+			return -ERANGE;
+		memcpy(dst, src, src_len);
+		*dst_len = src_len;
+		return 0;
+
+	case CEPH_CRYPTO_AES:
+		return ceph_aes_encrypt(secret->key, secret->len, dst,
+					dst_len, src, src_len);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+int ceph_encrypt2(struct ceph_crypto_key *secret, void *dst, size_t *dst_len,
+		  const void *src1, size_t src1_len,
+		  const void *src2, size_t src2_len)
+{
+	switch (secret->type) {
+	case CEPH_CRYPTO_NONE:
+		if (*dst_len < src1_len + src2_len)
+			return -ERANGE;
+		memcpy(dst, src1, src1_len);
+		memcpy(dst + src1_len, src2, src2_len);
+		*dst_len = src1_len + src2_len;
+		return 0;
+
+	case CEPH_CRYPTO_AES:
+		return ceph_aes_encrypt2(secret->key, secret->len, dst, dst_len,
+					 src1, src1_len, src2, src2_len);
+
+	default:
+		return -EINVAL;
+	}
+}
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
new file mode 100644
index 0000000..40b502e
--- /dev/null
+++ b/fs/ceph/crypto.h
@@ -0,0 +1,48 @@
+#ifndef _FS_CEPH_CRYPTO_H
+#define _FS_CEPH_CRYPTO_H
+
+#include "types.h"
+#include "buffer.h"
+
+/*
+ * cryptographic secret
+ */
+struct ceph_crypto_key {
+	int type;
+	struct ceph_timespec created;
+	int len;
+	void *key;
+};
+
+static inline void ceph_crypto_key_destroy(struct ceph_crypto_key *key)
+{
+	kfree(key->key);
+}
+
+extern int ceph_crypto_key_encode(struct ceph_crypto_key *key,
+				  void **p, void *end);
+extern int ceph_crypto_key_decode(struct ceph_crypto_key *key,
+				  void **p, void *end);
+extern int ceph_crypto_key_unarmor(struct ceph_crypto_key *key, const char *in);
+
+/* crypto.c */
+extern int ceph_decrypt(struct ceph_crypto_key *secret,
+			void *dst, size_t *dst_len,
+			const void *src, size_t src_len);
+extern int ceph_encrypt(struct ceph_crypto_key *secret,
+			void *dst, size_t *dst_len,
+			const void *src, size_t src_len);
+extern int ceph_decrypt2(struct ceph_crypto_key *secret,
+			void *dst1, size_t *dst1_len,
+			void *dst2, size_t *dst2_len,
+			const void *src, size_t src_len);
+extern int ceph_encrypt2(struct ceph_crypto_key *secret,
+			 void *dst, size_t *dst_len,
+			 const void *src1, size_t src1_len,
+			 const void *src2, size_t src2_len);
+
+/* armor.c */
+extern int ceph_armor(char *dst, const void *src, const void *end);
+extern int ceph_unarmor(void *dst, const char *src, const char *end);
+
+#endif
-- 
1.7.0

