Return-Path: <linux-kernel-owner+w=401wt.eu-S1762784AbYFNAZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762784AbYFNAZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761305AbYFNAPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:15:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:34576 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760986AbYFNAPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:15:13 -0400
Date: Fri, 13 Jun 2008 17:12:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       alan@lxorguk.ukuu.org.uk,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 40/47] m68k: Add ext2_find_{first,next}_bit() for ext4
Message-ID: <20080614001207.GN24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="m68k-add-ext2_find_-first-next-_bit-for-ext4.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit 69c5ddf58a03da3686691ad2f293bc79fd977c10 upstream

Add ext2_find_{first,next}_bit(), which are needed for ext4.
They're derived out of the ext2_find_next_zero_bit found in the same file.
Compile tested with crosstools

[Reworked to preserve all symmetry with ext2_find_{first,next}_zero_bit()]

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=10393

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-m68k/bitops.h |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

--- a/include/asm-m68k/bitops.h
+++ b/include/asm-m68k/bitops.h
@@ -410,8 +410,50 @@ static inline int ext2_find_next_zero_bi
 	res = ext2_find_first_zero_bit (p, size - 32 * (p - addr));
 	return (p - addr) * 32 + res;
 }
-#define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
+
+static inline int ext2_find_first_bit(const void *vaddr, unsigned size)
+{
+	const unsigned long *p = vaddr, *addr = vaddr;
+	int res;
+
+	if (!size)
+		return 0;
+
+	size = (size >> 5) + ((size & 31) > 0);
+	while (*p++ == 0UL)
+	{
+		if (--size == 0)
+			return (p - addr) << 5;
+	}
+
+	--p;
+	for (res = 0; res < 32; res++)
+		if (ext2_test_bit(res, p))
+			break;
+	return (p - addr) * 32 + res;
+}
+
+static inline int ext2_find_next_bit(const void *vaddr, unsigned size,
+				     unsigned offset)
+{
+	const unsigned long *addr = vaddr;
+	const unsigned long *p = addr + (offset >> 5);
+	int bit = offset & 31UL, res;
+
+	if (offset >= size)
+		return size;
+
+	if (bit) {
+		/* Look for one in first longword */
+		for (res = bit; res < 32; res++)
+			if (ext2_test_bit(res, p))
+				return (p - addr) * 32 + res;
+		p++;
+	}
+	/* No set bit yet, search remaining full bytes for a set bit */
+	res = ext2_find_first_bit(p, size - 32 * (p - addr));
+	return (p - addr) * 32 + res;
+}
 
 #endif /* __KERNEL__ */
 

-- 
