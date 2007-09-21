Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbXIUOIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbXIUOIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759387AbXIUOIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:08:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758140AbXIUOIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:08:32 -0400
Message-ID: <46F3D049.4080006@redhat.com>
Date: Fri, 21 Sep 2007 16:08:09 +0200
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Frank Cusack <fcusack@fcusack.com>, Matt Domsch <Matt_Domsch@dell.com>,
       linux-ppp@vger.kernel.org
Subject: [PATCH] ppp_mppe: Don't put InterimKey on the stack
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The interrupt stack can be in the __START_KERNEL_map region in which
virt_to_page will not work. This caused ppp_mppe to crash on CentOS 5 on x86_64
(http://bugs.centos.org/view.php?id=2076).

The fix is to avoid copying the interim key. We can simply use it in its
original place, which is kmalloc'd.

Michal
---
 drivers/net/ppp_mppe.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ppp_mppe.c b/drivers/net/ppp_mppe.c
index f79cf87..c0b6d19 100644
--- a/drivers/net/ppp_mppe.c
+++ b/drivers/net/ppp_mppe.c
@@ -136,7 +136,7 @@ struct ppp_mppe_state {
  * Key Derivation, from RFC 3078, RFC 3079.
  * Equivalent to Get_Key() for MS-CHAP as described in RFC 3079.
  */
-static void get_new_key_from_sha(struct ppp_mppe_state * state, unsigned char *InterimKey)
+static void get_new_key_from_sha(struct ppp_mppe_state * state)
 {
 	struct hash_desc desc;
 	struct scatterlist sg[4];
@@ -153,8 +153,6 @@ static void get_new_key_from_sha(struct ppp_mppe_state * state, unsigned char *I
 	desc.flags = 0;
 
 	crypto_hash_digest(&desc, sg, nbytes, state->sha1_digest);
-
-	memcpy(InterimKey, state->sha1_digest, state->keylen);
 }
 
 /*
@@ -163,21 +161,21 @@ static void get_new_key_from_sha(struct ppp_mppe_state * state, unsigned char *I
  */
 static void mppe_rekey(struct ppp_mppe_state * state, int initial_key)
 {
-	unsigned char InterimKey[MPPE_MAX_KEY_LEN];
 	struct scatterlist sg_in[1], sg_out[1];
 	struct blkcipher_desc desc = { .tfm = state->arc4 };
 
-	get_new_key_from_sha(state, InterimKey);
+	get_new_key_from_sha(state);
 	if (!initial_key) {
-		crypto_blkcipher_setkey(state->arc4, InterimKey, state->keylen);
-		setup_sg(sg_in, InterimKey, state->keylen);
+		crypto_blkcipher_setkey(state->arc4, state->sha1_digest,
+					state->keylen);
+		setup_sg(sg_in, state->sha1_digest, state->keylen);
 		setup_sg(sg_out, state->session_key, state->keylen);
 		if (crypto_blkcipher_encrypt(&desc, sg_out, sg_in,
 					     state->keylen) != 0) {
     		    printk(KERN_WARNING "mppe_rekey: cipher_encrypt failed\n");
 		}
 	} else {
-		memcpy(state->session_key, InterimKey, state->keylen);
+		memcpy(state->session_key, state->sha1_digest, state->keylen);
 	}
 	if (state->keylen == 8) {
 		/* See RFC 3078 */

