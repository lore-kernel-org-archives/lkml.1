Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbXEWSxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbXEWSxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXEWSxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:53:14 -0400
Received: from outbound-mail-14.bluehost.com ([69.89.18.114]:46987 "HELO
	outbound-mail-14.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755450AbXEWSxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:53:13 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 11:52:56 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <4635510D.4060103@shaw.ca> <200705221738.09571.jbarnes@virtuousgeek.org> <46539378.6000508@shaw.ca>
In-Reply-To: <46539378.6000508@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231152.57796.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 22, 2007 6:06 pm Robert Hancock wrote:
> There was a big discussion about this back in 2002, in which Linus
> wasn't overly enthused about disabling the decode during probing due
> to risk of causing problems with some devices:
>
> http://lkml.org/lkml/2002/12/19/145
>
> In this particular case (64-bit BAR) we might be able to avoid the
> problem by changing the order in which we probe the two halves of the
> address, i.e. change the top half to 0xffffffff before messing with
> the bottom half and then change it back last. That way, we end up
> mapping it way to the top of 64-bit address space, which hopefully is
> less likely to conflict..

Fixed it (finally).  I don't think moving the 64 bit probing around 
would make a difference, since we'd restore its original value anyway 
before moving on to the 32 bit probe which is where I think the problem 
is.

I think what's happening is the probe is writing 0xffffffff to the video 
device, which is in the GMCH, and without memory decoding disabled, 
it'll start claiming PCI config access cycles causing the problems I 
saw.  So my code to disable I/O and memory decode was actually working 
but I had a bug in the re-enable path so all my devices were staying 
disabled. :)

So here's the patch I used (along with your ACPI patch and my 965 MCFG 
enable patch of course).  The probing code could probably use a bit 
more cleanup, but this patch limits itself to implementing PCI_COMMAND 
based I/O and memory space decode disabling during size probing.  We 
might want to do this unconditionally if we're using mmconfig based 
configuration access, since I imagine other machines might end up 
having similar address space layouts that would cause problems.

Linus, since you were the one concerned about breaking working setups, 
what do you think?  Should we use this approach, or specifically quirk 
out cases where mmconfig space might conflict with BAR probing?

Thanks,
Jesse

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e48fcf0..69dfe0c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -170,6 +170,48 @@ static inline int is_64bit_memory(u32 mask)
 	return 0;
 }
 
+#define BAR_IS_MEMORY(bar) (((bar) & PCI_BASE_ADDRESS_SPACE) ==	\
+			    PCI_BASE_ADDRESS_SPACE_MEMORY)
+
+/**
+ * pci_bar_size - get raw PCI BAR size
+ * @dev: PCI device
+ * @reg: BAR to probe
+ *
+ * Use basic PCI probing:
+ *   - save original BAR value
+ *   - disable MEM or IO decode as appropriate in PCI_COMMAND reg
+ *   - write all 1s to the BAR
+ *   - read back value
+ *   - reenble MEM or IO decode as necessary
+ *   - write original value back
+ *
+ * Returns raw BAR size to caller.
+ */
+static u32 pci_bar_size(struct pci_dev *dev, unsigned int reg)
+{
+	u32 orig_reg, sz;
+	u16 orig_cmd;
+
+	pci_read_config_dword(dev, reg, &orig_reg);
+	pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
+
+	if (BAR_IS_MEMORY(orig_reg))
+		pci_write_config_word(dev, PCI_COMMAND,
+				      orig_cmd & ~PCI_COMMAND_MEMORY);
+	else
+		pci_write_config_word(dev, PCI_COMMAND, 
+				      orig_cmd & ~PCI_COMMAND_IO);
+
+	pci_write_config_dword(dev, reg, 0xffffffff);
+	pci_read_config_dword(dev, reg, &sz);
+	pci_write_config_dword(dev, reg, orig_reg);
+
+	pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
+
+	return sz;
+}
+
 static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, 
int rom)
 {
 	unsigned int pos, reg, next;
@@ -185,17 +227,15 @@ static void pci_read_bases(struct pci_dev *dev, 
unsigned int howmany, int rom)
 		res = &dev->resource[pos];
 		res->name = pci_name(dev);
 		reg = PCI_BASE_ADDRESS_0 + (pos << 2);
+
 		pci_read_config_dword(dev, reg, &l);
-		pci_write_config_dword(dev, reg, ~0);
-		pci_read_config_dword(dev, reg, &sz);
-		pci_write_config_dword(dev, reg, l);
+		sz = pci_bar_size(dev, reg);
 		if (!sz || sz == 0xffffffff)
 			continue;
 		if (l == 0xffffffff)
 			l = 0;
 		raw_sz = sz;
-		if ((l & PCI_BASE_ADDRESS_SPACE) ==
-				PCI_BASE_ADDRESS_SPACE_MEMORY) {
+		if (BAR_IS_MEMORY(l)) {
 			sz = pci_size(l, sz, (u32)PCI_BASE_ADDRESS_MEM_MASK);
 			/*
 			 * For 64bit prefetchable memory sz could be 0, if the
@@ -219,9 +259,7 @@ static void pci_read_bases(struct pci_dev *dev, 
unsigned int howmany, int rom)
 			u32 szhi, lhi;
 
 			pci_read_config_dword(dev, reg+4, &lhi);
-			pci_write_config_dword(dev, reg+4, ~0);
-			pci_read_config_dword(dev, reg+4, &szhi);
-			pci_write_config_dword(dev, reg+4, lhi);
+			szhi = pci_bar_size(dev, reg+4);
 			sz64 = ((u64)szhi << 32) | raw_sz;
 			l64 = ((u64)lhi << 32) | l;
 			sz64 = pci_size64(l64, sz64, PCI_BASE_ADDRESS_MEM_MASK);

