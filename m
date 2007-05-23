Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbXEWVUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbXEWVUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbXEWVUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:20:45 -0400
Received: from outbound-mail-54.bluehost.com ([69.89.20.34]:36477 "HELO
	outbound-mail-54.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754726AbXEWVUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:20:44 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 14:20:23 -0700
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>, Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705231349.56976.jbarnes@virtuousgeek.org> <alpine.LFD.0.98.0705231352450.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705231352450.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231420.26622.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 1:56 pm Linus Torvalds wrote:
> > Not for systems with PCIe...  and the platforms I've been having
> > trouble with have PCIe slots, so I'd really like mmconfig to be
> > used at least on machines with PCIe bridges.  For other machines,
> > it probably doesn't matter much.  I don't know of any regular PCI
> > devices offhand that really need extended config space.
>
> Ehh. Even for PCIe, why not use the normal accesses for the first 256
> bytes? Problem solved.

Ok, this patch also works.  We still need to enable mmconfig space for 
PCIe and extended config space, but we can continue to use type 1 
accesses for legacy PCI config space cycles to avoid decode trouble 
with mmconfig based BAR sizing.

Assuming Robert's and my patches to enable mmconfig space go in, we'd 
want a similar patch to the i386 mmconfig code.

Jesse

diff --git a/arch/x86_64/pci/mmconfig.c b/arch/x86_64/pci/mmconfig.c
index 65d8273..5052f80 100644
--- a/arch/x86_64/pci/mmconfig.c
+++ b/arch/x86_64/pci/mmconfig.c
@@ -61,7 +61,7 @@ static int pci_mmcfg_read(unsigned int seg, unsigned 
int bus,
 	}
 
 	addr = pci_dev_base(seg, bus, devfn);
-	if (!addr)
+	if (!addr || reg < 256) /* Use type 1 for non-extended access */
 		return pci_conf1_read(seg,bus,devfn,reg,len,value);
 
 	switch (len) {
@@ -89,7 +89,7 @@ static int pci_mmcfg_write(unsigned int seg, unsigned 
int bus,
 		return -EINVAL;
 
 	addr = pci_dev_base(seg, bus, devfn);
-	if (!addr)
+	if (!addr || reg < 256) /* Use type 1 for non-extended access */
 		return pci_conf1_write(seg,bus,devfn,reg,len,value);
 
 	switch (len) {
