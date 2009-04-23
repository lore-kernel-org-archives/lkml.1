Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbZDWNWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbZDWNWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZDWNVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:21:53 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:37611 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZDWNVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:21:52 -0400
Date: Thu, 23 Apr 2009 17:22:02 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [RFC PATCH 1/2] pci: don't assume pref memio are 64bit -v3
Message-ID: <20090423132202.GB13984@jurassic.park.msu.ru>
References: <20090419090208.GA30211@elte.hu> <20090419090615.GA30631@elte.hu> <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org> <20090421105629.GB17904@jurassic.park.msu.ru> <49EF9C10.6090107@kernel.org> <20090422154900.08f8f366@hobbes> <49EFBB0E.3030401@kernel.org> <20090422180505.2518e837@hobbes> <49EFCE15.3030605@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EFCE15.3030605@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 07:10:29PM -0700, Yinghai Lu wrote:
> also on AMD system with two ht chain, or other system with pci=use_crs to get correct root default res,
> will get anonying
> 
> PCI: allocations above 4G disabled
> 
> even the system does support that.

Yep, but it's easy to fix (patch applies on the top of the previous one).

> also will have problem with some calling like request_resource(&iomem_resource, ....)

I don't think so. All critical resources are inserted much earlier than
mem64 one, and request_resource(&iomem_resource, ...) at later stages
would most likely fail regardless of mem64 thing.
Or am I missing something?

Ivan.

diff --git a/arch/x86/pci/dac_64bit.c b/arch/x86/pci/dac_64bit.c
index ee03c4a..35ffee3 100644
--- a/arch/x86/pci/dac_64bit.c
+++ b/arch/x86/pci/dac_64bit.c
@@ -33,12 +33,16 @@ void pcibios_pci64_setup(void)
 void pcibios_pci64_verify(void)
 {
 	struct pci_bus *b;
+	int disabled = 0;
 
 	if (mem64.flags & IORESOURCE_MEM64)
 		return;		/* presumably DAC works */
 	list_for_each_entry(b, &pci_root_buses, node) {
-		if (b->resource[2] == &mem64)
+		if (b->resource[2] == &mem64) {
 			b->resource[2] = NULL;
+			disabled = 1;
+		}
 	}
-	printk(KERN_INFO "PCI: allocations above 4G disabled\n");
+	if (disabled)
+		printk(KERN_INFO "PCI: allocations above 4G disabled\n");
 }
