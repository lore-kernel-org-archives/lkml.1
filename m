Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbXJHSVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbXJHSVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbXJHSVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:21:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50065 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbXJHSVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:21:45 -0400
Date: Mon, 8 Oct 2007 11:06:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Michal Schmidt <mschmidt@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 06/12] Fix ppp_mppe kernel stack usage.
Message-ID: <20071008180622.GG7627@kroah.com>
References: <20071008180406.052382073@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ppp_mppe-kernel-stack-usage.patch"
In-Reply-To: <20071008180551.GA7627@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Schmidt <mschmidt@redhat.com>

commit 45dfd5b5dd20f17fe23dafc5cfe921474d27f849 from upstream

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ppp_mppe.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

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
@@ -153,8 +153,6 @@ static void get_new_key_from_sha(struct 
 	desc.flags = 0;
 
 	crypto_hash_digest(&desc, sg, nbytes, state->sha1_digest);
-
-	memcpy(InterimKey, state->sha1_digest, state->keylen);
 }
 
 /*
@@ -163,21 +161,21 @@ static void get_new_key_from_sha(struct 
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

-- 
