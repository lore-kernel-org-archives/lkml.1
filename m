Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbYILRoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbYILRoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbYILRoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:44:11 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:8928 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYILRoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:44:09 -0400
X-BigFish: VPS-35(z21eW34a4lz1432R98dR936eQ4015M1805M936fQzz10d3izzz32i6bh87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K73FX3-02-831-01
Date: Fri, 12 Sep 2008 11:45:22 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Rufus & Azrael <rufus-azrael@numericable.fr>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user
	with the same regression
Message-ID: <20080912174522.GB8042@cosmic.amd.com>
References: <48B067B3.6020008@numericable.fr> <86802c440808231310hdafc30aw6931b77ea926338e@mail.gmail.com> <48B06FF9.1030404@numericable.fr> <86802c440808231328w5c6a3fa3s9be9d90ec1f30aa1@mail.gmail.com> <48B07409.60905@numericable.fr> <86802c440808231335n9214e38q5141a3560c698f76@mail.gmail.com> <48B074E1.9020106@numericable.fr> <86802c440808231345u7c4f7710k5878928239507b10@mail.gmail.com> <86802c440808231405u42fa8024r89eccc907f36d99e@mail.gmail.com> <20080912173933.GF6743@alberich.amd.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20080912173933.GF6743@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 12 Sep 2008 17:44:01.0172 (UTC) FILETIME=[241AC540:01C914FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On 12/09/08 19:39 +0200, Andreas Herrmann wrote:
> On Sat, Aug 23, 2008 at 02:05:19PM -0700, Yinghai Lu wrote:
> > Jordan, or others for AMD could access SB600
> > can you check ATI SB600 doc to produce one quirks patch to set the
> > magic bit to hide 00:14.0 BAR1 to OS ?
> 
> I know this is a very late reply, but
> is there still a quirk desired to hide BAR1 of SB600 SMBus device?
> 
> If yes, I'll provide a patch asap.

I sent one up last week, but it was overshadowed by the much
more serious R790 problem that Linus and Rafael was looking
at.  I have re-attached the patch for posterity.

Thanks,
Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

--W/nzBZO5zC0uMSeA
Content-Type: text/x-diff; charset="us-ascii"
Content-Disposition: inline; filename="remove-hpet-bar.patch"

[PATCH]: SB600 - remove HPET resources from PCI device

From: Jordan Crouse <jordan.crouse@amd.com>

Prevent the HPET resources from appearing in PCI device 14.0 which
confuses the PCI resource engine.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
---

 arch/x86/pci/fixup.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 4bdaa59..d313ba8 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -511,3 +511,30 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1201, fam10h_pci_cfg_space_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1202, fam10h_pci_cfg_space_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1203, fam10h_pci_cfg_space_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, 0x1204, fam10h_pci_cfg_space_size);
+
+/* SB600: Disable BAR1 on device 14.0 to avoid HPET resources from
+ * confusing the PCI engine */
+
+static void sb600_disable_hpet_bar(struct pci_dev *dev)
+{
+	u8 val;
+
+	/* The SB600 and SB700 both share the same device
+	 * ID, but the PM register 0x55 does something different
+	 * for the SB700, so make sure we are dealing with the
+	 * SB600 before touching the bit.
+	 */
+
+	pci_read_config_byte(dev, 0x08, &val);
+
+	if (val < 0x2F) {
+		outb(0x55, 0xCD6);
+		val = inb(0xCD7);
+
+		/* Set bit 7 in PM register 0x55 */
+		outb(0x55, 0xCD6);
+		outb(val | 0x80, 0xCD7);
+	}
+}
+
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, 0x4385, sb600_disable_hpet_bar);

--W/nzBZO5zC0uMSeA--
