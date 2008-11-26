Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbYKZVO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbYKZVO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYKZVNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:13:07 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:18154 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbYKZVNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:13:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RGY/kxzGzUeIu07tgxizgHjYuysgJefkgIMn3avK1eKIyeyk0dl5J5QGPzy7BtyDuf
         dNIog1EwcRkaXSck8sKu9fb3x1W2IMGLQDr3pjNj1BamISwGhIhNBspqJX9n84hH6y6s
         j97A87EFo3wyxhRgNua6/xIcEGvepahubeEqA=
Subject: [PATCH-mm 7/8] bluetooth: remove private wrappers of endian helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 13:12:53 -0800
Message-Id: <1227733973.5511.129.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Depends on the byteorder consolidation in -mm.

 include/net/bluetooth/bluetooth.h |    6 ------
 net/bluetooth/l2cap.c             |   10 +++++-----
 net/bluetooth/rfcomm/core.c       |   12 ++++++------
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 996d12d..15e6a32 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -70,12 +70,6 @@ enum {
 	BT_CLOSED
 };
 
-/* Endianness conversions */
-#define htobs(a)	__cpu_to_le16(a)
-#define htobl(a)	__cpu_to_le32(a)
-#define btohs(a)	__le16_to_cpu(a)
-#define btohl(a)	__le32_to_cpu(a)
-
 /* BD Address */
 typedef struct {
 	__u8 b[6];
diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index 9610a9c..d7262dd 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -746,7 +746,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int addr_
 		goto done;
 	}
 
-	if (la->l2_psm && btohs(la->l2_psm) < 0x1001 &&
+	if (la->l2_psm && le16_to_cpu(la->l2_psm) < 0x1001 &&
 				!capable(CAP_NET_BIND_SERVICE)) {
 		err = -EACCES;
 		goto done;
@@ -917,9 +917,9 @@ static int l2cap_sock_listen(struct socket *sock, int backlog)
 		write_lock_bh(&l2cap_sk_list.lock);
 
 		for (psm = 0x1001; psm < 0x1100; psm += 2)
-			if (!__l2cap_get_sock_by_addr(htobs(psm), src)) {
-				l2cap_pi(sk)->psm   = htobs(psm);
-				l2cap_pi(sk)->sport = htobs(psm);
+			if (!__l2cap_get_sock_by_addr(cpu_to_le16(psm), src)) {
+				l2cap_pi(sk)->psm   = cpu_to_le16(psm);
+				l2cap_pi(sk)->sport = cpu_to_le16(psm);
 				err = 0;
 				break;
 			}
@@ -2431,7 +2431,7 @@ static ssize_t l2cap_sysfs_show(struct class *dev, char *buf)
 
 		str += sprintf(str, "%s %s %d %d 0x%4.4x 0x%4.4x %d %d 0x%x\n",
 				batostr(&bt_sk(sk)->src), batostr(&bt_sk(sk)->dst),
-				sk->sk_state, btohs(pi->psm), pi->scid, pi->dcid,
+				sk->sk_state, le16_to_cpu(pi->psm), pi->scid, pi->dcid,
 				pi->imtu, pi->omtu, pi->link_mode);
 	}
 
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index ba537fa..aadbd64 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -661,7 +661,7 @@ static struct rfcomm_session *rfcomm_session_create(bdaddr_t *src, bdaddr_t *dst
 
 	bacpy(&addr.l2_bdaddr, dst);
 	addr.l2_family = AF_BLUETOOTH;
-	addr.l2_psm    = htobs(RFCOMM_PSM);
+	addr.l2_psm    = cpu_to_le16(RFCOMM_PSM);
 	*err = kernel_connect(sock, (struct sockaddr *) &addr, sizeof(addr), O_NONBLOCK);
 	if (*err == 0 || *err == -EINPROGRESS)
 		return s;
@@ -833,9 +833,9 @@ static int rfcomm_send_pn(struct rfcomm_session *s, int cr, struct rfcomm_dlc *d
 	}
 
 	if (cr && channel_mtu >= 0)
-		pn->mtu = htobs(channel_mtu);
+		pn->mtu = cpu_to_le16(channel_mtu);
 	else
-		pn->mtu = htobs(d->mtu);
+		pn->mtu = cpu_to_le16(d->mtu);
 
 	*ptr = __fcs(buf); ptr++;
 
@@ -1037,7 +1037,7 @@ static void rfcomm_make_uih(struct sk_buff *skb, u8 addr)
 
 	if (len > 127) {
 		hdr = (void *) skb_push(skb, 4);
-		put_unaligned(htobs(__len16(len)), (__le16 *) &hdr->len);
+		store_le16_noalign(&hdr->len, __len16(len));
 	} else {
 		hdr = (void *) skb_push(skb, 3);
 		hdr->len = __len8(len);
@@ -1257,7 +1257,7 @@ static int rfcomm_apply_pn(struct rfcomm_dlc *d, int cr, struct rfcomm_pn *pn)
 
 	d->priority = pn->priority;
 
-	d->mtu = btohs(pn->mtu);
+	d->mtu = le16_to_cpu(pn->mtu);
 
 	if (cr && d->mtu > s->mtu)
 		d->mtu = s->mtu;
@@ -1882,7 +1882,7 @@ static int rfcomm_add_listener(bdaddr_t *ba)
 	/* Bind socket */
 	bacpy(&addr.l2_bdaddr, ba);
 	addr.l2_family = AF_BLUETOOTH;
-	addr.l2_psm    = htobs(RFCOMM_PSM);
+	addr.l2_psm    = cpu_to_le16(RFCOMM_PSM);
 	err = kernel_bind(sock, (struct sockaddr *) &addr, sizeof(addr));
 	if (err < 0) {
 		BT_ERR("Bind failed %d", err);
-- 
1.6.0.4.1044.g77718


