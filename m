Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZFJDfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZFJDfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZFJDdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:33:35 -0400
Received: from kroah.org ([198.145.64.141]:56620 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbZFJDdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:33:35 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:41 2009
Message-Id: <20090610002341.473758727@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 08/60] sparc64: Fix crash with /proc/iomem
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=sparc64-fix-crash-with-proc-iomem.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>


[ Upstream commit 192d7a4667c6d11d1a174ec4cad9a3c5d5f9043c ]

When you compile kernel on Sparc64 with heap memory checking and type
"cat /proc/iomem", you get a crash, because pointers in struct
resource are uninitialized.

Most code fills struct resource with zeros, so I assume that it is
responsibility of the caller of request_resource to initialized it,
not the responsibility of request_resource functuion.

After 2.6.29 is out, there could be a check for uninitialized fields
added to request_resource to avoid crashes like this.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc64/kernel/pci_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc64/kernel/pci_common.c
+++ b/arch/sparc64/kernel/pci_common.c
@@ -368,7 +368,7 @@ static void pci_register_iommu_region(st
 	const u32 *vdma = of_get_property(pbm->prom_node, "virtual-dma", NULL);
 
 	if (vdma) {
-		struct resource *rp = kmalloc(sizeof(*rp), GFP_KERNEL);
+		struct resource *rp = kzalloc(sizeof(*rp), GFP_KERNEL);
 
 		if (!rp) {
 			prom_printf("Cannot allocate IOMMU resource.\n");


