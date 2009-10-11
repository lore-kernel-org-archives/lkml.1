Return-Path: <linux-kernel-owner+w=401wt.eu-S1760085AbZJKCMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085AbZJKCMN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 22:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbZJKCMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 22:12:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34782 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674AbZJKCML convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 22:12:11 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Eric Sesterhenn <snakebyte@gmx.de>, Roman Zippel <zippel@linux-m68k.org>,
       550010@bugs.debian.org
In-Reply-To: <1254883878.4246.191.camel@localhost>
References: <1254883878.4246.191.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 11 Oct 2009 03:11:27 +0100
Message-Id: <1255227087.25061.76.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] hfsplus: Refuse to mount volumes larger than 2TB
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As found in <http://bugs.debian.org/550010>, hfsplus is using type u32
rather than sector_t for some sector number calculations.

In particular, hfsplus_get_block() does:

        u32 ablock, dblock, mask;
...
        map_bh(bh_result, sb, (dblock << HFSPLUS_SB(sb).fs_shift) + HFSPLUS_SB(sb).blockoffset + (iblock & mask));

I am not confident that I can find and fix all cases where a sector
number may be truncated.  For now, avoid data loss by refusing to mount
HFS+ volumes with more than 2^32 sectors (2TB).

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@kernel.org
---
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -99,6 +99,10 @@
 
 	if (hfsplus_get_last_session(sb, &part_start, &part_size))
 		return -EINVAL;
+	if (part_start + part_size > 0x100000000) {
+		pr_err("hfs: volumes larger than 2TB are not supported yet\n");
+		return -EINVAL;
+	}
 	while (1) {
 		bh = sb_bread512(sb, part_start + HFSPLUS_VOLHEAD_SECTOR, vhdr);
 		if (!bh)

-- 
Ben Hutchings
Quantity is no substitute for quality, but it's the only one we've got.
