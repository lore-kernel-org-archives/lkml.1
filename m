Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbXDMUK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbXDMUK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbXDMUK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:10:27 -0400
Received: from gw.goop.org ([64.81.55.164]:38835 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964862AbXDMUK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:10:27 -0400
Message-ID: <461FE38C.2060501@goop.org>
Date: Fri, 13 Apr 2007 13:09:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] i386: map enough initial memory to create lowmem mappings
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

head.S creates the very initial pagetable for the kernel.  It maps
maps enough space for the kernel itself, and an allocation bitmap.
The amount of mapped memory is rounded up to 4Mbytes, and so this
typically ends up mapping 8Mbytes of memory.

When booting, pagetable_init() needs to create mappings for all
lowmem, and the pagetables for these mappings are allocated from the
free pages around the kernel in low memory.  If the number of
pagetable pages + kernel size exceeds head.S's initial mapping, it
will end up faulting on an unmapped page.  This will only happen with
specific combinations of kernel size and memory size.

This patch makes sure that head.S also maps enough space to fit the
kernel pagetables as well as the kernel itself.  It ends up using an
additional two pages of unreclaimable memory.

[ What am I missing here?  Why doesn't this cause crashes all over the place? ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Chris Wright <chrisw@sous-sol.org>

---
 arch/i386/kernel/head.S |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

===================================================================
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -34,16 +34,19 @@
 
 /*
  * This is how much memory *in addition to the memory covered up to
- * and including _end* we need mapped initially.  We need one bit for
- * each possible page, but only in low memory, which means
- * 2^32/4096/8 = 128K worst case (4G/4G split.)
+ * and including _end* we need mapped initially.
+ * We need:
+ *  - one bit for each possible page, but only in low memory, which means
+ *     2^32/4096/8 = 128K worst case (4G/4G split.)
+ *  - enough space to map all low memory, which means
+ *     (2^32/4096) / 512 + 4 pages (worst case for PAE)
  *
  * Modulo rounding, each megabyte assigned here requires a kilobyte of
  * memory, which is currently unreclaimed.
  *
  * This should be a multiple of a page.
  */
-#define INIT_MAP_BEYOND_END	(128*1024)
+#define INIT_MAP_BEYOND_END	(128*1024 + (2048 + 4)*4096)
 
 
 /*


