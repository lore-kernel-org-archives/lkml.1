Return-Path: <linux-kernel-owner+w=401wt.eu-S1763518AbYDNQkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763518AbYDNQkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763204AbYDNQj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:39:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:32974 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763172AbYDNQjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UfDHwoaO+HrXYIK4J31jg1qoBshO0DbuP4Z17+klDUbva3GWanKmEKCX7GZinGt+oVk2g49+gTunyha9tUWuOoFPla7j40EZVHMDRw9cDvhUINROMLb33veyLF74GVH2fbVrt95hF8SNqdfQ5kIQs7SAHhIwFEKtQmztbRyjGWI=
Subject: [PATCH 10/10] video: Use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 09:37:57 -0700
Message-Id: <1208191077.5721.33.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/video/matrox/matroxfb_misc.c |   28 ++++++++++++++--------------
 drivers/video/metronomefb.c          |    9 +++------
 2 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_misc.c b/drivers/video/matrox/matroxfb_misc.c
index ab7fb50..cfb5205 100644
--- a/drivers/video/matrox/matroxfb_misc.c
+++ b/drivers/video/matrox/matroxfb_misc.c
@@ -522,8 +522,6 @@ static void parse_bios(unsigned char __iomem* vbios, struct matrox_bios* bd) {
 #endif
 }
 
-#define get_u16(x) (le16_to_cpu(get_unaligned((__u16*)(x))))
-#define get_u32(x) (le32_to_cpu(get_unaligned((__u32*)(x))))
 static int parse_pins1(WPMINFO const struct matrox_bios* bd) {
 	unsigned int maxdac;
 
@@ -532,11 +530,12 @@ static int parse_pins1(WPMINFO const struct matrox_bios* bd) {
 		case 1:		maxdac = 220000; break;
 		default:	maxdac = 240000; break;
 	}
-	if (get_u16(bd->pins + 24)) {
-		maxdac = get_u16(bd->pins + 24) * 10;
+	if (get_unaligned_le16(bd->pins + 24)) {
+		maxdac = get_unaligned_le16(bd->pins + 24) * 10;
 	}
 	MINFO->limits.pixel.vcomax = maxdac;
-	MINFO->values.pll.system = get_u16(bd->pins + 28) ? get_u16(bd->pins + 28) * 10 : 50000;
+	MINFO->values.pll.system = get_unaligned_le16(bd->pins + 28) ?
+		get_unaligned_le16(bd->pins + 28) * 10 : 50000;
 	/* ignore 4MB, 8MB, module clocks */
 	MINFO->features.pll.ref_freq = 14318;
 	MINFO->values.reg.mctlwtst	= 0x00030101;
@@ -575,7 +574,8 @@ static void default_pins2(WPMINFO2) {
 static int parse_pins3(WPMINFO const struct matrox_bios* bd) {
 	MINFO->limits.pixel.vcomax	=
 	MINFO->limits.system.vcomax	= (bd->pins[36] == 0xFF) ? 230000			: ((bd->pins[36] + 100) * 1000);
-	MINFO->values.reg.mctlwtst	= get_u32(bd->pins + 48) == 0xFFFFFFFF ? 0x01250A21	: get_u32(bd->pins + 48);
+	MINFO->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 48) == 0xFFFFFFFF ?
+		0x01250A21 : get_unaligned_le32(bd->pins + 48);
 	/* memory config */
 	MINFO->values.reg.memrdbk	= ((bd->pins[57] << 21) & 0x1E000000) |
 					  ((bd->pins[57] << 22) & 0x00C00000) |
@@ -601,7 +601,7 @@ static void default_pins3(WPMINFO2) {
 static int parse_pins4(WPMINFO const struct matrox_bios* bd) {
 	MINFO->limits.pixel.vcomax	= (bd->pins[ 39] == 0xFF) ? 230000			: bd->pins[ 39] * 4000;
 	MINFO->limits.system.vcomax	= (bd->pins[ 38] == 0xFF) ? MINFO->limits.pixel.vcomax	: bd->pins[ 38] * 4000;
-	MINFO->values.reg.mctlwtst	= get_u32(bd->pins + 71);
+	MINFO->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 71);
 	MINFO->values.reg.memrdbk	= ((bd->pins[87] << 21) & 0x1E000000) |
 					  ((bd->pins[87] << 22) & 0x00C00000) |
 					  ((bd->pins[86] <<  1) & 0x000001E0) |
@@ -609,7 +609,7 @@ static int parse_pins4(WPMINFO const struct matrox_bios* bd) {
 	MINFO->values.reg.opt		= ((bd->pins[53] << 15) & 0x00400000) |
 					  ((bd->pins[53] << 22) & 0x10000000) |
 					  ((bd->pins[53] <<  7) & 0x00001C00);
-	MINFO->values.reg.opt3		= get_u32(bd->pins + 67);
+	MINFO->values.reg.opt3		= get_unaligned_le32(bd->pins + 67);
 	MINFO->values.pll.system	= (bd->pins[ 65] == 0xFF) ? 200000 			: bd->pins[ 65] * 4000;
 	MINFO->features.pll.ref_freq	= (bd->pins[ 92] & 0x01) ? 14318 : 27000;
 	return 0;
@@ -640,12 +640,12 @@ static int parse_pins5(WPMINFO const struct matrox_bios* bd) {
 	MINFO->limits.video.vcomin	= (bd->pins[122] == 0xFF) ? MINFO->limits.system.vcomin	: bd->pins[122] * mult;
 	MINFO->values.pll.system	=
 	MINFO->values.pll.video		= (bd->pins[ 92] == 0xFF) ? 284000			: bd->pins[ 92] * 4000;
-	MINFO->values.reg.opt		= get_u32(bd->pins+ 48);
-	MINFO->values.reg.opt2		= get_u32(bd->pins+ 52);
-	MINFO->values.reg.opt3		= get_u32(bd->pins+ 94);
-	MINFO->values.reg.mctlwtst	= get_u32(bd->pins+ 98);
-	MINFO->values.reg.memmisc	= get_u32(bd->pins+102);
-	MINFO->values.reg.memrdbk	= get_u32(bd->pins+106);
+	MINFO->values.reg.opt		= get_unaligned_le32(bd->pins + 48);
+	MINFO->values.reg.opt2		= get_unaligned_le32(bd->pins + 52);
+	MINFO->values.reg.opt3		= get_unaligned_le32(bd->pins + 94);
+	MINFO->values.reg.mctlwtst	= get_unaligned_le32(bd->pins + 98);
+	MINFO->values.reg.memmisc	= get_unaligned_le32(bd->pins + 102);
+	MINFO->values.reg.memrdbk	= get_unaligned_le32(bd->pins + 106);
 	MINFO->features.pll.ref_freq	= (bd->pins[110] & 0x01) ? 14318 : 27000;
 	MINFO->values.memory.ddr	= (bd->pins[114] & 0x60) == 0x20;
 	MINFO->values.memory.dll	= (bd->pins[115] & 0x02) != 0;
diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
index e9a89fd..7e7e977 100644
--- a/drivers/video/metronomefb.c
+++ b/drivers/video/metronomefb.c
@@ -236,8 +236,7 @@ static int load_waveform(u8 *mem, size_t size, u8 *metromem, int m, int t,
 	}
 
 	/* check waveform mode table address checksum */
-	wmta = le32_to_cpu(get_unaligned((__le32 *) wfm_hdr->wmta));
-	wmta &= 0x00FFFFFF;
+	wmta = get_unaligned_le32(wfm_hdr->wmta) & 0x00FFFFFF;
 	cksum_idx = wmta + m*4 + 3;
 	if (cksum_idx > size)
 		return -EINVAL;
@@ -249,8 +248,7 @@ static int load_waveform(u8 *mem, size_t size, u8 *metromem, int m, int t,
 	}
 
 	/* check waveform temperature table address checksum */
-	tta = le32_to_cpu(get_unaligned((int *) (mem + wmta + m*4)));
-	tta &= 0x00FFFFFF;
+	tta = get_unaligned_le32(mem + wmta + m * 4) & 0x00FFFFFF;
 	cksum_idx = tta + trn*4 + 3;
 	if (cksum_idx > size)
 		return -EINVAL;
@@ -263,8 +261,7 @@ static int load_waveform(u8 *mem, size_t size, u8 *metromem, int m, int t,
 
 	/* here we do the real work of putting the waveform into the
 	metromem buffer. this does runlength decoding of the waveform */
-	wfm_idx = le32_to_cpu(get_unaligned((__le32 *) (mem + tta + trn*4)));
-	wfm_idx &= 0x00FFFFFF;
+	wfm_idx = get_unaligned_le32(mem + tta + trn * 4) & 0x00FFFFFF;
 	owfm_idx = wfm_idx;
 	if (wfm_idx > size)
 		return -EINVAL;
-- 
1.5.5.144.g3e42

