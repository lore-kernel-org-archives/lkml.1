Return-Path: <linux-kernel-owner+w=401wt.eu-S1765911AbXGTVan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765911AbXGTVan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbXGTVaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:30:18 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57229 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbXGTVaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:30:15 -0400
Date: Fri, 20 Jul 2007 23:31:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       sparc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7/7] sparc64: fix section mismatch warning in mdesc.c
Message-ID: <20070720213130.GF25064@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.text+0x35264): Section mismatch: reference to .init.text:__alloc_bootmem (between 'mdesc_bootmem_alloc' and 'mdesc_bootmem_free')

Rename mdesc_mem_ops to *_ops so modpost ignores __init references
and declare mdesc_bootmem_alloc __init since it is only used
during __init context.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sparc64/kernel/mdesc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc64/kernel/mdesc.c b/arch/sparc64/kernel/mdesc.c
index 13a79fe..cce4d0d 100644
--- a/arch/sparc64/kernel/mdesc.c
+++ b/arch/sparc64/kernel/mdesc.c
@@ -83,7 +83,7 @@ static void mdesc_handle_init(struct mdesc_handle *hp,
 	hp->handle_size = handle_size;
 }
 
-static struct mdesc_handle *mdesc_bootmem_alloc(unsigned int mdesc_size)
+static struct mdesc_handle * __init mdesc_bootmem_alloc(unsigned int mdesc_size)
 {
 	struct mdesc_handle *hp;
 	unsigned int handle_size, alloc_size;
@@ -123,7 +123,7 @@ static void mdesc_bootmem_free(struct mdesc_handle *hp)
 	}
 }
 
-static struct mdesc_mem_ops bootmem_mdesc_memops = {
+static struct mdesc_mem_ops bootmem_mdesc_ops = {
 	.alloc = mdesc_bootmem_alloc,
 	.free  = mdesc_bootmem_free,
 };
@@ -860,7 +860,7 @@ void __init sun4v_mdesc_init(void)
 
 	printk("MDESC: Size is %lu bytes.\n", len);
 
-	hp = mdesc_alloc(len, &bootmem_mdesc_memops);
+	hp = mdesc_alloc(len, &bootmem_mdesc_ops);
 	if (hp == NULL) {
 		prom_printf("MDESC: alloc of %lu bytes failed.\n", len);
 		prom_halt();
-- 
1.5.1.rc3.g84b7-dirty

