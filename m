Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbZHRP72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbZHRP72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759316AbZHRP7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:59:25 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:47088 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020AbZHRP7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:59:23 -0400
Message-Id: <4A8AEBFD0200007800010580@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 18 Aug 2009 16:59:25 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix BUILD_BUG_ON() and a couple of bogus uses of it
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc permitting variable length arrays makes the current construct
used for BUILD_BUG_ON() useless, as that doesn't produce any diagnostic
if the controlling expression isn't really constant. Instead, this
patch makes it so that a bit field gets used here. Consequently, those
uses where the condition isn't really constant now also need fixing.

Note that in the gfp.h, kmemcheck.h, and virtio_config.h cases
MAYBE_BUILD_BUG_ON() really just serves documentation purposes - even
if the expression is compile time constant (__builtin_constant_p()
yields true), the array is still deemed of variable length by gcc, and
hence the whole expression doesn't have the intended effect.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/char/tpm/tpm.c        |    2 --
 drivers/net/niu.c             |    2 +-
 include/linux/gfp.h           |    2 +-
 include/linux/kernel.h        |    8 ++++++--
 include/linux/kmemcheck.h     |    2 +-
 include/linux/virtio_config.h |    3 +--
 6 files changed, 10 insertions(+), 9 deletions(-)

--- linux-2.6.31-rc6/drivers/char/tpm/tpm.c	2009-08-18 15:31:17.000000000 +0200
+++ 2.6.31-rc6-build-bug-on/drivers/char/tpm/tpm.c	2009-08-17 15:21:11.000000000 +0200
@@ -696,7 +696,6 @@ int __tpm_pcr_read(struct tpm_chip *chip
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	BUILD_BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
 	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
 			  "attempting to read a pcr value");
 
@@ -760,7 +759,6 @@ int tpm_pcr_extend(u32 chip_num, int pcr
 		return -ENODEV;
 
 	cmd.header.in = pcrextend_header;
-	BUILD_BUG_ON(be32_to_cpu(cmd.header.in.length) > EXTEND_PCR_SIZE);
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
 	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
--- linux-2.6.31-rc6/drivers/net/niu.c	2009-08-18 15:31:34.000000000 +0200
+++ 2.6.31-rc6-build-bug-on/drivers/net/niu.c	2009-08-17 15:21:11.000000000 +0200
@@ -5615,7 +5615,7 @@ static void niu_init_tx_mac(struct niu *
 	/* The XMAC_MIN register only accepts values for TX min which
 	 * have the low 3 bits cleared.
 	 */
-	BUILD_BUG_ON(min & 0x7);
+	BUG_ON(min & 0x7);
 
 	if (np->flags & NIU_FLAGS_XMAC)
 		niu_init_tx_xmac(np, min, max);
--- linux-2.6.31-rc6/include/linux/gfp.h	2009-08-18 15:31:54.000000000 +0200
+++ 2.6.31-rc6-build-bug-on/include/linux/gfp.h	2009-08-17 15:21:11.000000000 +0200
@@ -220,7 +220,7 @@ static inline enum zone_type gfp_zone(gf
 					 ((1 << ZONES_SHIFT) - 1);
 
 	if (__builtin_constant_p(bit))
-		BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
+		MAYBE_BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 	else {
 #ifdef CONFIG_DEBUG_VM
 		BUG_ON((GFP_ZONE_BAD >> bit) & 1);
--- linux-2.6.31-rc6/include/linux/kernel.h	2009-08-18 15:31:55.000000000 +0200
+++ 2.6.31-rc6-build-bug-on/include/linux/kernel.h	2009-08-17 15:21:11.000000000 +0200
@@ -675,13 +675,17 @@ struct sysinfo {
 };
 
 /* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
+
+/* Force a compilation error if condition is constant and true */
+#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
 
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
    e.g. in a structure initializer (or where-ever else comma expressions
    aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
 
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
--- linux-2.6.31-rc6/include/linux/kmemcheck.h	2009-08-18 15:31:55.000000000 +0200
+++ 2.6.31-rc6-build-bug-on/include/linux/kmemcheck.h	2009-08-17 15:21:11.000000000 +0200
@@ -140,7 +140,7 @@ static inline void kmemcheck_mark_initia
 	do if (ptr) {							\
 		int _n = (long) &((ptr)->name##_end)			\
 			- (long) &((ptr)->name##_begin);		\
-		BUILD_BUG_ON(_n < 0);					\
+		MAYBE_BUILD_BUG_ON(_n < 0);				\
 									\
 		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
 	} while (0)
--- linux-2.6.31-rc6/include/linux/virtio_config.h	2009-08-18 15:31:55.000000000 +0200
+++ 2.6.31-rc6-build-bug-on/include/linux/virtio_config.h	2009-08-17 15:21:11.000000000 +0200
@@ -109,8 +109,7 @@ static inline bool virtio_has_feature(co
 				      unsigned int fbit)
 {
 	/* Did you forget to fix assumptions on max features? */
-	if (__builtin_constant_p(fbit))
-		BUILD_BUG_ON(fbit >= 32);
+	MAYBE_BUILD_BUG_ON(fbit >= 32);
 
 	if (fbit < VIRTIO_TRANSPORT_F_START)
 		virtio_check_driver_offered_feature(vdev, fbit);


