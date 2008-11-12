Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbYKLAdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbYKLAdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYKLA00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:26 -0500
Received: from kroah.org ([198.145.64.141]:42266 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753491AbYKLA0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:22 -0500
Date: Tue, 11 Nov 2008 16:23:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [patch 18/49] MTD: Fix cfi_send_gen_cmd handling of x16 devices in
	x8 mode (v4)
Message-ID: <20081112002331.GS10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mtd-fix-cfi_send_gen_cmd-handling-of-x16-devices-in-x8-mode.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

commit 467622ef2acb01986eab37ef96c3632b3ea35999 upstream

For "unlock" cycles to 16bit devices in 8bit compatibility mode we need
to use the byte addresses 0xaaa and 0x555. These effectively match
the word address 0x555 and 0x2aa, except the latter has its low bit set.

Most chips don't care about the value of the 'A-1' pin in x8 mode,
but some -- like the ST M29W320D -- do. So we need to be careful to
set it where appropriate.

cfi_send_gen_cmd is only ever passed addresses where the low byte
is 0x00, 0x55 or 0xaa. Of those, only addresses ending 0xaa are
affected by this patch, by masking in the extra low bit when the device
is known to be in compatibility mode.

[dwmw2: Do it only when (cmd_ofs & 0xff) == 0xaa]
v4: Fix  stupid typo in cfi_build_cmd_addr that failed to compile
    I'm writing this patch way to late at night.
v3: Bring all of the work back into cfi_build_cmd_addr
    including calling of map_bankwidth(map) and cfi_interleave(cfi)
    So every caller doesn't need to.
v2: Only modified the address if we our device_type is larger than our
    bus width.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/chips/cfi_cmdset_0002.c |   13 -------------
 drivers/mtd/chips/jedec_probe.c     |   10 ++++------
 include/linux/mtd/cfi.h             |   22 +++++++++++++++++++---
 3 files changed, 23 insertions(+), 22 deletions(-)

--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -362,19 +362,6 @@ struct mtd_info *cfi_cmdset_0002(struct 
 		/* Set the default CFI lock/unlock addresses */
 		cfi->addr_unlock1 = 0x555;
 		cfi->addr_unlock2 = 0x2aa;
-		/* Modify the unlock address if we are in compatibility mode */
-		if (	/* x16 in x8 mode */
-			((cfi->device_type == CFI_DEVICETYPE_X8) &&
-				(cfi->cfiq->InterfaceDesc ==
-					CFI_INTERFACE_X8_BY_X16_ASYNC)) ||
-			/* x32 in x16 mode */
-			((cfi->device_type == CFI_DEVICETYPE_X16) &&
-				(cfi->cfiq->InterfaceDesc ==
-					CFI_INTERFACE_X16_BY_X32_ASYNC)))
-		{
-			cfi->addr_unlock1 = 0xaaa;
-			cfi->addr_unlock2 = 0x555;
-		}
 
 	} /* CFI mode */
 	else if (cfi->cfi_mode == CFI_MODE_JEDEC) {
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1808,9 +1808,7 @@ static inline u32 jedec_read_mfr(struct 
 	 * several first banks can contain 0x7f instead of actual ID
 	 */
 	do {
-		uint32_t ofs = cfi_build_cmd_addr(0 + (bank << 8),
-						  cfi_interleave(cfi),
-						  cfi->device_type);
+		uint32_t ofs = cfi_build_cmd_addr(0 + (bank << 8), map, cfi);
 		mask = (1 << (cfi->device_type * 8)) - 1;
 		result = map_read(map, base + ofs);
 		bank++;
@@ -1824,7 +1822,7 @@ static inline u32 jedec_read_id(struct m
 {
 	map_word result;
 	unsigned long mask;
-	u32 ofs = cfi_build_cmd_addr(1, cfi_interleave(cfi), cfi->device_type);
+	u32 ofs = cfi_build_cmd_addr(1, map, cfi);
 	mask = (1 << (cfi->device_type * 8)) -1;
 	result = map_read(map, base + ofs);
 	return result.x[0] & mask;
@@ -2067,8 +2065,8 @@ static int jedec_probe_chip(struct map_i
 
 	}
 	/* Ensure the unlock addresses we try stay inside the map */
-	probe_offset1 = cfi_build_cmd_addr(cfi->addr_unlock1, cfi_interleave(cfi), cfi->device_type);
-	probe_offset2 = cfi_build_cmd_addr(cfi->addr_unlock2, cfi_interleave(cfi), cfi->device_type);
+	probe_offset1 = cfi_build_cmd_addr(cfi->addr_unlock1, map, cfi);
+	probe_offset2 = cfi_build_cmd_addr(cfi->addr_unlock2, map, cfi);
 	if (	((base + probe_offset1 + map_bankwidth(map)) >= map->size) ||
 		((base + probe_offset2 + map_bankwidth(map)) >= map->size))
 		goto retry;
--- a/include/linux/mtd/cfi.h
+++ b/include/linux/mtd/cfi.h
@@ -281,9 +281,25 @@ struct cfi_private {
 /*
  * Returns the command address according to the given geometry.
  */
-static inline uint32_t cfi_build_cmd_addr(uint32_t cmd_ofs, int interleave, int type)
+static inline uint32_t cfi_build_cmd_addr(uint32_t cmd_ofs,
+				struct map_info *map, struct cfi_private *cfi)
 {
-	return (cmd_ofs * type) * interleave;
+	unsigned bankwidth = map_bankwidth(map);
+	unsigned interleave = cfi_interleave(cfi);
+	unsigned type = cfi->device_type;
+	uint32_t addr;
+
+	addr = (cmd_ofs * type) * interleave;
+
+	/* Modify the unlock address if we are in compatiblity mode.
+	 * For 16bit devices on 8 bit busses
+	 * and 32bit devices on 16 bit busses
+	 * set the low bit of the alternating bit sequence of the address.
+	 */
+	if (((type * interleave) > bankwidth) && ((uint8_t)cmd_ofs == 0xaa))
+		addr |= (type >> 1)*interleave;
+
+	return  addr;
 }
 
 /*
@@ -429,7 +445,7 @@ static inline uint32_t cfi_send_gen_cmd(
 				int type, map_word *prev_val)
 {
 	map_word val;
-	uint32_t addr = base + cfi_build_cmd_addr(cmd_addr, cfi_interleave(cfi), type);
+	uint32_t addr = base + cfi_build_cmd_addr(cmd_addr, map, cfi);
 
 	val = cfi_build_cmd(cmd, map, cfi);
 

-- 
