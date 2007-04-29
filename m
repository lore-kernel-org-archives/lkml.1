Return-Path: <linux-kernel-owner+w=401wt.eu-S1161614AbXD2Xqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161614AbXD2Xqn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161618AbXD2Xqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:46:42 -0400
Received: from ns2.suse.de ([195.135.220.15]:38501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161614AbXD2Xqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:37 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: James Puthukattukaran <James.Puthukattukaran@sun.com>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [25/26] x86_64: x86-64 system crashes when no memory populating Node 0
Message-Id: <20070429234635.62EDA150F2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: James Puthukattukaran <James.Puthukattukaran@sun.com>

I have a 4 socket AMD Operton system. The 2.6.18 kernel I have crashes
when there is no memory in node0.

AK: changed call to _nopanic

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/aperture.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux/arch/x86_64/kernel/aperture.c
===================================================================
--- linux.orig/arch/x86_64/kernel/aperture.c
+++ linux/arch/x86_64/kernel/aperture.c
@@ -51,7 +51,6 @@ static void __init insert_aperture_resou
 
 static u32 __init allocate_aperture(void) 
 {
-	pg_data_t *nd0 = NODE_DATA(0);
 	u32 aper_size;
 	void *p; 
 
@@ -65,12 +64,12 @@ static u32 __init allocate_aperture(void
 	 * Unfortunately we cannot move it up because that would make the
 	 * IOMMU useless.
 	 */
-	p = __alloc_bootmem_node(nd0, aper_size, aper_size, 0); 
+	p = __alloc_bootmem_nopanic(aper_size, aper_size, 0);
 	if (!p || __pa(p)+aper_size > 0xffffffff) {
 		printk("Cannot allocate aperture memory hole (%p,%uK)\n",
 		       p, aper_size>>10);
 		if (p)
-			free_bootmem_node(nd0, __pa(p), aper_size); 
+			free_bootmem(__pa(p), aper_size);
 		return 0;
 	}
 	printk("Mapping aperture over %d KB of RAM @ %lx\n",
