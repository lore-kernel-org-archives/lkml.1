Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbXEXAFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbXEXAFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbXEXAFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:05:45 -0400
Received: from outbound-mail-56.bluehost.com ([69.89.20.36]:40159 "HELO
	outbound-mail-56.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756343AbXEXAFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:05:45 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 17:02:30 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca>
In-Reply-To: <4635510D.4060103@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231702.30679.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 29, 2007 7:14 pm Robert Hancock wrote:
> This path adds validation of the MMCONFIG table against the ACPI
> reserved motherboard resources. If the MMCONFIG table is found to be
> reserved in ACPI, we don't bother checking the E820 table. The PCI
> Express firmware spec apparently tells BIOS developers that
> reservation in ACPI is required and E820 reservation is optional, so
> checking against ACPI first makes sense. Many BIOSes don't reserve
> the MMCONFIG region in E820 even though it is perfectly functional,
> the existing check needlessly disables MMCONFIG in these cases.
>
> In order to do this, MMCONFIG setup has been split into two phases.
> If PCI configuration type 1 is not available (like on EFI Macs) then
> MMCONFIG is enabled early as before. Otherwise, it is enabled later
> after the ACPI interpreter is enabled, since we need to be able to
> execute control methods in order to check the ACPI reserved
> resources. Presently this is just triggered off the end of ACPI
> interpreter initialization.
>
> There are a few other behavioral changes here:
>
> -Validate all MMCONFIG configurations provided, not just the first
> one.
>
> -Validate the entire required length of each configuration according
> to the provided ending bus number is reserved, not just the minimum
> required allocation.
>
> -Validate that the area is reserved even if we read it from the
> chipset directly and not from the MCFG table. This catches the case
> where the BIOS didn't set the location properly in the chipset and
> has mapped it over other things it shouldn't have. This might be
> overly pessimistic - we might be able to instead verify that no other
> reserved resources (like chipset registers) are inside this memory
> range.
>
> Some testing is needed to see if this rejects MMCONFIG on all systems
> where it is problematic. There were some patches floating around to
> read the table location out of the chipset for Intel 915 and 965, I
> think the author found the latter to be problematic since the chipset
> had the table mapped over top of motherboard resources. The extra
> checking here may catch that case if we add that chipset-specific
> support.
>
> Applies to 2.6.21.1.
>
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

Acked-by:  Jesse Barnes <jesse.barnes@intel.com>

As long as we get a fix for the mmconfig based probing issues in the 
other thread, I think this patch should go in.  Robert, maybe you could 
submit it along with this one (and an i386 equivalent)?  Type 1 config 
access is already a fallback for mmconfig for x86_64 at least, so it 
should be safe for non-extended access too, and it avoids problems with 
our lack of decode disable in the generic PCI probing code.

Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>

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
