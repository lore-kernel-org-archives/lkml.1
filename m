Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935393Ab0CMA6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:58:41 -0500
Received: from kroah.org ([198.145.64.141]:46786 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935325Ab0CMAbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:09 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:08 2010
Message-Id: <20100313002708.299410332@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [035/145] sparc32: Fix page_to_phys().
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 8654164f54bd02787ae91db8526dcae8e7e34eeb ]

It doesn't account for phys_base like it should, fix by using
page_to_pfn().

While we're here, make virt_to_page() use pfn_to_page() as well, so we
consistently use the asm/memory-model.h abstractions instead of
open-coding memory model assumptions.

Tested-by: Kristoffer Glembo <kristoffer@gaisler.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/include/asm/io_32.h   |    2 +-
 arch/sparc/include/asm/page_32.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/io_32.h
+++ b/arch/sparc/include/asm/io_32.h
@@ -8,7 +8,7 @@
 #include <asm/page.h>      /* IO address mapping routines need this */
 #include <asm/system.h>
 
-#define page_to_phys(page)	(((page) - mem_map) << PAGE_SHIFT)
+#define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 
 static inline u32 flip_dword (u32 l)
 {
--- a/arch/sparc/include/asm/page_32.h
+++ b/arch/sparc/include/asm/page_32.h
@@ -143,7 +143,7 @@ extern unsigned long pfn_base;
 #define phys_to_virt		__va
 
 #define ARCH_PFN_OFFSET		(pfn_base)
-#define virt_to_page(kaddr)	(mem_map + ((((unsigned long)(kaddr)-PAGE_OFFSET)>>PAGE_SHIFT)))
+#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 
 #define pfn_valid(pfn)		(((pfn) >= (pfn_base)) && (((pfn)-(pfn_base)) < max_mapnr))
 #define virt_addr_valid(kaddr)	((((unsigned long)(kaddr)-PAGE_OFFSET)>>PAGE_SHIFT) < max_mapnr)


