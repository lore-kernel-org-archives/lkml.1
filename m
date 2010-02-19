Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab0BSRBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:01:17 -0500
Received: from kroah.org ([198.145.64.141]:57709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab0BSRA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:56 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:47 2010
Message-Id: <20100219163247.739059655@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Matt Fleming <matt@console-pimps.org>, Paul Mundt <lethal@linux-sh.org>
Subject: [62/93] sh: Couple kernel and user write page perm bits for CONFIG_X2TLB
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Fleming <matt@console-pimps.org>

commit fcb4ebd678858850e8b029909064175cb627868d upstream.

pte_write() should check whether the permissions include either the user
or kernel write permission bits. Likewise, pte_wrprotect() needs to
remove both the kernel and user write bits.

Without this patch handle_tlbmiss() doesn't handle faulting in pages
from the P3 area (our vmalloc space) because of a write. Mappings of the
P3 space have the _PAGE_EXT_KERN_WRITE bit but not _PAGE_EXT_USER_WRITE.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sh/include/asm/pgtable_32.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/sh/include/asm/pgtable_32.h
+++ b/arch/sh/include/asm/pgtable_32.h
@@ -344,7 +344,8 @@ static inline void set_pte(pte_t *ptep,
 #define pte_special(pte)	((pte).pte_low & _PAGE_SPECIAL)
 
 #ifdef CONFIG_X2TLB
-#define pte_write(pte)		((pte).pte_high & _PAGE_EXT_USER_WRITE)
+#define pte_write(pte) \
+	((pte).pte_high & (_PAGE_EXT_USER_WRITE | _PAGE_EXT_KERN_WRITE))
 #else
 #define pte_write(pte)		((pte).pte_low & _PAGE_RW)
 #endif
@@ -358,7 +359,7 @@ static inline pte_t pte_##fn(pte_t pte)
  * individually toggled (and user permissions are entirely decoupled from
  * kernel permissions), we attempt to couple them a bit more sanely here.
  */
-PTE_BIT_FUNC(high, wrprotect, &= ~_PAGE_EXT_USER_WRITE);
+PTE_BIT_FUNC(high, wrprotect, &= ~(_PAGE_EXT_USER_WRITE | _PAGE_EXT_KERN_WRITE));
 PTE_BIT_FUNC(high, mkwrite, |= _PAGE_EXT_USER_WRITE | _PAGE_EXT_KERN_WRITE);
 PTE_BIT_FUNC(high, mkhuge, |= _PAGE_SZHUGE);
 #else


