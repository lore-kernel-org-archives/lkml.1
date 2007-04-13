Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbXDMPNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbXDMPNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 11:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbXDMPNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 11:13:31 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36687 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbXDMPNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 11:13:30 -0400
Subject: [PATCH] cache_k8_northbridges() overflows beyond allocation (Was:
	2.6.21-rc5-mm4 (SLUB))
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>, ak@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com>
	 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com>
	 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com>
	 <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com>
	 <1175698437.6185.21.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704040946370.24640@schroedinger.engr.sgi.com>
	 <1175709755.6185.34.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 13 Apr 2007 08:13:42 -0700
Message-Id: <1176477222.8559.4.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 11:04 -0700, Christoph Lameter wrote:
> On Wed, 4 Apr 2007, Badari Pulavarty wrote:
...
> 
> > *** SLUB: Freepointer corrupt in kmalloc-16@0xffff810173f172a0 Slab
> > 0xffff81017f9f8b80
> >     offset=672 flags=0x2000000000000c7 inuse=42
> > freelist=0xffff810173f172a0
> >   Bytes b4 0xffff810173f17290:  a0 72 f1 73 00 00 00 00 00 00 00 00 00
> > 00 00 00 .r\uffffs............
> >     Object 0xffff810173f172a0:  00 00 00 00 01 81 ff ff 00 00 00 00 00
> > 00 00 00 ......\uffff\uffff........
> > FreePointer 0xffff810173f172a0 -> 0xffff810100000000
> 

Found it !! After a painful capture of all the kmalloc-16 slab
allocations (400+) so far and auditing some of them, found the
culprit - who writes beyond its allocation, causing the slab
corruption.

Thanks,
Badari

cache_k8_northbridges() is storing config values to incorrect locations
(in flush_words) and also its overflowing beyond the allocation, causing
slab verification failures.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
---
 arch/x86_64/kernel/k8.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc6/arch/x86_64/kernel/k8.c
===================================================================
--- linux-2.6.21-rc6.orig/arch/x86_64/kernel/k8.c	2007-04-05 19:36:56.000000000 -0700
+++ linux-2.6.21-rc6/arch/x86_64/kernel/k8.c	2007-04-13 07:51:57.000000000 -0700
@@ -61,8 +61,8 @@ int cache_k8_northbridges(void)
 	dev = NULL;
 	i = 0;
 	while ((dev = next_k8_northbridge(dev)) != NULL) {
-		k8_northbridges[i++] = dev;
-		pci_read_config_dword(dev, 0x9c, &flush_words[i]);
+		k8_northbridges[i] = dev;
+		pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
 	}
 	k8_northbridges[i] = NULL;
 	return 0;


