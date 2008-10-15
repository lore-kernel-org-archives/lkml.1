Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYJOA5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYJOA5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbYJOA43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:56:29 -0400
Received: from gw.goop.org ([64.81.55.164]:36860 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbYJOA42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:56:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 5] xen: portability clean up and some
	minor clean up for xencomm.c
X-Mercurial-Node: 818765124affc177ec6781c61636db8cf4db1942
Message-Id: <818765124affc177ec67.1224031841@abulafia.goop.org>
In-Reply-To: <patchbomb.1224031839@abulafia.goop.org>
Date: Tue, 14 Oct 2008 17:50:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

clean up of xencomm.c. is_phys_contiguous() is arch dependent
function that depends on how virtual memory are laid out.
So split out the function into arch specific code.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
---
 drivers/xen/xencomm.c |   25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/xen/xencomm.c b/drivers/xen/xencomm.c
--- a/drivers/xen/xencomm.c
+++ b/drivers/xen/xencomm.c
@@ -23,13 +23,7 @@
 #include <asm/page.h>
 #include <xen/xencomm.h>
 #include <xen/interface/xen.h>
-#ifdef __ia64__
-#include <asm/xen/xencomm.h>	/* for is_kern_addr() */
-#endif
-
-#ifdef HAVE_XEN_PLATFORM_COMPAT_H
-#include <xen/platform-compat.h>
-#endif
+#include <asm/xen/xencomm.h>	/* for xencomm_is_phys_contiguous() */
 
 static int xencomm_init(struct xencomm_desc *desc,
 			void *buffer, unsigned long bytes)
@@ -157,20 +151,11 @@
 	return 0;
 }
 
-/* check if memory address is within VMALLOC region  */
-static int is_phys_contiguous(unsigned long addr)
-{
-	if (!is_kernel_addr(addr))
-		return 0;
-
-	return (addr < VMALLOC_START) || (addr >= VMALLOC_END);
-}
-
 static struct xencomm_handle *xencomm_create_inline(void *ptr)
 {
 	unsigned long paddr;
 
-	BUG_ON(!is_phys_contiguous((unsigned long)ptr));
+	BUG_ON(!xencomm_is_phys_contiguous((unsigned long)ptr));
 
 	paddr = (unsigned long)xencomm_pa(ptr);
 	BUG_ON(paddr & XENCOMM_INLINE_FLAG);
@@ -202,7 +187,7 @@
 	int rc;
 	struct xencomm_desc *desc;
 
-	if (is_phys_contiguous((unsigned long)ptr))
+	if (xencomm_is_phys_contiguous((unsigned long)ptr))
 		return xencomm_create_inline(ptr);
 
 	rc = xencomm_create(ptr, bytes, &desc, GFP_KERNEL);
@@ -219,7 +204,7 @@
 	int rc;
 	struct xencomm_desc *desc = NULL;
 
-	if (is_phys_contiguous((unsigned long)ptr))
+	if (xencomm_is_phys_contiguous((unsigned long)ptr))
 		return xencomm_create_inline(ptr);
 
 	rc = xencomm_create_mini(ptr, bytes, xc_desc,


