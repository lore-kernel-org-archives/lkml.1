Return-Path: <linux-kernel-owner+w=401wt.eu-S933015AbZKFWit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbZKFWit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932986AbZKFWip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:38:45 -0500
Received: from kroah.org ([198.145.64.141]:56801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366AbZKFWWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:43 2009
Message-Id: <20091106221542.973446321@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>, Eric Sesterhenn <snakebyte@gmx.de>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [33/99] hfsplus: refuse to mount volumes larger than 2TB
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=hfsplus-refuse-to-mount-volumes-larger-than-2tb.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ben Hutchings <ben@decadent.org.uk>

commit 5c36fe3d87b3f0c85894a49193c66096a3d6b26f upstream.

As found in <http://bugs.debian.org/550010>, hfsplus is using type u32
rather than sector_t for some sector number calculations.

In particular, hfsplus_get_block() does:

        u32 ablock, dblock, mask;
...
        map_bh(bh_result, sb, (dblock << HFSPLUS_SB(sb).fs_shift) + HFSPLUS_SB(sb).blockoffset + (iblock & mask));

I am not confident that I can find and fix all cases where a sector number
may be truncated.  For now, avoid data loss by refusing to mount HFS+
volumes with more than 2^32 sectors (2TB).

[akpm@linux-foundation.org: fix 32 and 64-bit issues]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/hfsplus/wrapper.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -99,6 +99,10 @@ int hfsplus_read_wrapper(struct super_bl
 
 	if (hfsplus_get_last_session(sb, &part_start, &part_size))
 		return -EINVAL;
+	if ((u64)part_start + part_size > 0x100000000ULL) {
+		pr_err("hfs: volumes larger than 2TB are not supported yet\n");
+		return -EINVAL;
+	}
 	while (1) {
 		bh = sb_bread512(sb, part_start + HFSPLUS_VOLHEAD_SECTOR, vhdr);
 		if (!bh)


