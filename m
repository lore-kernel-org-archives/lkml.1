Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYLKTV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYLKTV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbYLKTSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:13 -0500
Received: from kroah.org ([198.145.64.141]:55860 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756611AbYLKTSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:04 -0500
Date: Thu, 11 Dec 2008 11:13:48 -0800
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
       alan@lxorguk.ukuu.org.uk, Max Dmitrichenko <dmitrmax@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 09/83] sparc64: Fix PCI resource mapping on sparc64
Message-ID: <20081211191348.GI5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0003-sparc64-Fix-PCI-resource-mapping-on-sparc64.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Max Dmitrichenko <dmitrmax@gmail.com>

[ Upstream commit 145e1c0023585e0e8f6df22316308ec61c5066b2 ]

There is a problem discovered in recent versions of ATI Mach64 driver
in X.org on sparc64 architecture. In short, the driver fails to mmap
MMIO aperture (PCI resource #2).

I've found that kernel's __pci_mmap_make_offset() returns EINVAL. It
checks whether user attempts to mmap more than the resource length,
which is 0x1000 bytes in our case. But PAGE_SIZE on SPARC64 is 0x2000
and this is what actually is being mmaped. So __pci_mmap_make_offset()
failed for this PCI resource.

Signed-off-by: Max Dmitrichenko <dmitrmax@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/pci.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/sparc64/kernel/pci.c
+++ b/arch/sparc64/kernel/pci.c
@@ -1017,6 +1017,7 @@ static int __pci_mmap_make_offset(struct
 
 	for (i = 0; i <= PCI_ROM_RESOURCE; i++) {
 		struct resource *rp = &pdev->resource[i];
+		resource_size_t aligned_end;
 
 		/* Active? */
 		if (!rp->flags)
@@ -1034,8 +1035,15 @@ static int __pci_mmap_make_offset(struct
 				continue;
 		}
 
+		/* Align the resource end to the next page address.
+		 * PAGE_SIZE intentionally added instead of (PAGE_SIZE - 1),
+		 * because actually we need the address of the next byte
+		 * after rp->end.
+		 */
+		aligned_end = (rp->end + PAGE_SIZE) & PAGE_MASK;
+
 		if ((rp->start <= user_paddr) &&
-		    (user_paddr + user_size) <= (rp->end + 1UL))
+		    (user_paddr + user_size) <= aligned_end)
 			break;
 	}
 

