Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbYIBIX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbYIBIX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 04:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYIBIXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 04:23:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:35756 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYIBIXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 04:23:16 -0400
Subject: Re: Misc fixes for 2.6.27
From: David Woodhouse <dwmw2@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080902061920.GK18288@one.firstfloor.org>
References: <1220300084.2982.139.camel@pmac.infradead.org>
	 <87wshvwl8v.fsf@basil.nowhere.org> <20080901153517.2f8b1ef8@infradead.org>
	 <87sksjwjwg.fsf@basil.nowhere.org> <20080901161639.5215db63@infradead.org>
	 <20080902061920.GK18288@one.firstfloor.org>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 09:23:10 +0100
Message-Id: <1220343790.2982.165.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 08:19 +0200, Andi Kleen wrote:
> On Mon, Sep 01, 2008 at 04:16:39PM -0700, Arjan van de Ven wrote:
> > On Tue, 02 Sep 2008 01:01:19 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > Arjan van de Ven <arjan@infradead.org> writes:
> > > 
> > > > On Tue, 02 Sep 2008 00:32:16 +0200
> > > > Andi Kleen <andi@firstfloor.org> wrote:
> > > >
> > > >> David Woodhouse <dwmw2@infradead.org> writes:
> > > >> > +
> > > >> > +static struct dmi_system_id __initdata intel_iommu_dmi_table[]
> > > >> > = {
> > > >> > +	{	/* Some DG33BU BIOS revisions advertised
> > > >> > non-existent VT-d */
> > > >> 
> > > >> Are you sure it's non existent? A G33 chipset should have it in
> > > >> hardware I thought.
> > > >
> > > > nope they don't/
> > > > later ones and some other models do though, but not the G33
> > > 
> > > I see. But presumably that chipset will be in other motherboards
> > > too and that BIOS bug might be also wider spread. So it would be
> > > still better to key off an PCI-ID or similar.

It's certainly possible that the same BIOS bug could show up elsewhere.
I was expecting that we could add new motherboards to the DMI table if
that happens.

> > it would be nice, no doubt, unfortunately this code runs (and needs to
> > run) before the PCI subsystem is initialized...
> 
> early quirks handles these cases. Check out early-quirks.c

That might work, I suppose -- although the iommu probe happens early, it
looks like the early-quirks are handled even earlier. Unfortunately the
last attempt at flashing a BIOS on my DG33BU has turned it into a brick
and even the recovery procedure doesn't work, so I can't test any more
-- I'm more inclined to stick with what I'd tested, but if you feel
strongly and someone can test this version, then perhaps we could go
with that instead...

I made it check for this:
00:00.0 Host bridge [0600]: Intel Corporation 82G33/G31/P35/P31 Express DRAM Controller [8086:29c0] (rev 02)

Are we sure that device never going to appear on a board which really
_does_ have an IOMMU? And we should probably get it into pci_ids.h too.


diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 4353cf5..f51f61b 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -95,6 +95,20 @@ static void __init nvidia_bugs(int num, int slot, int func)
 
 }
 
+#ifdef CONFIG_DMAR
+static void __init intel_g33_dmar(int num, int slot, int func)
+{
+	struct acpi_table_header *dmar_tbl;
+	acpi_status = status;
+
+	status = acpi_get_table(ACPI_SIG_DMAR, 0, &dmar_tbl);
+	if (ACPI_SUCCESS(status)) {
+		printk(KERN_INFO "BIOS BUG: DMAR advertised on Intel G31/G33 chipset -- ignoring\n");
+		dmar_disabled = 1;
+	}
+}
+#endif
+
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -114,6 +128,10 @@ static struct chipset early_qrk[] __initdata = {
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
+#ifdef CONFIG_DMAR
+	{ PCI_VENDOR_ID_INTEL, 0x29c0,
+	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, intel_g33_dmar },
+#endif
 	{}
 };
 


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



