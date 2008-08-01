Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbYHAFsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbYHAFsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 01:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYHAFs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 01:48:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:54259 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbYHAFsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 01:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=H0De5rvIg5Iwx1hddjqtgbyNoVMdaxOCc/TSD59D2W8Jz5LHAzV4eWpEkDfjK6F9aS
         bVV0sHKXOfsZJQbCbBQULEsKwsxe+xJKA9sMG2ycceYHUxs3p6H/r+RgEeEauKgycFgl
         We9o7EdQXcr+7uYbVgrkEkDOv86WeBjg39gTU=
Date: Fri, 1 Aug 2008 07:48:32 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] ide-generic: skip automatic probing of legacy iobases
	(was: Re: [PATCH] ide-floppy fix)
Message-ID: <20080801054831.GA14636@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200807222149.19939.bzolnier@gmail.com> <20080723063224.GB17724@gollum.tnic> <200807232051.12226.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807232051.12226.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ removed stable@kernel.org from the CC-list ]

On Wed, Jul 23, 2008 at 08:51:11PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 23 July 2008, Borislav Petkov wrote:
> 
> [...]
> 
> > > Now it should be finally fixed.
> > 
> > True story. Works here too.
> 
> Thanks for verifying it.
> 
> > Hm, let's see whether there's time during the weekend. I already have something
> > stolen from pata_legacy but I'll do some more testing first. By the way, what
> > are the chances of exporting those pieces of code from drivers/ata/pata_legacy.c
> > and adding the function def into some header instead of duplicating the code into
> > ide_generic.c?
> 
> Good idea (<linux/ata.h> sounds like a perfect spot).

Hi Bart,

i finally found some time to work on the iobase-exclusion. Actually, i dropped
the original idea of reusing pata_legacy code without duplicating it since this
got the whole SATA pulled in in Kconfig, which, imo, outweighs the savings from
not duplicating one function. I ended up refitting the pata_legacy iobase checks
into ide-generic.

As a result, i have now a new bool-Kconfig option BLK_DEV_GENERIC_ONLY which
gets reverse-selected only when no pci ide controller which is using the generic
ide_host_register() from within ide_pci_init_one() is selected in Kconfig. This
is tested both with and without a pci ide driver selected in addition to
ide-generic.

---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Fri, 1 Aug 2008 07:33:13 +0200
Subject: [PATCH] ide-generic: skip automatic probing of legacy iobases

A number of pci ide controllers use legacy IO bases for their primary
and secondary ports. Skip probing those when both a specific host
driver _and_ ide-generic are enabled. The checking code originates from
drivers/ata/pata_legacy.c and is only reorganized into ide-generic.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/Kconfig       |    4 +++
 drivers/ide/ide-generic.c |   49 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 611319b..f103f5f 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -386,10 +386,14 @@ config BLK_DEV_OFFBOARD
 config BLK_DEV_GENERIC
 	tristate "Generic PCI IDE Chipset Support"
 	select BLK_DEV_IDEPCI
+	select BLK_DEV_GENERIC_ONLY if !(BLK_DEV_AEC62XX || BLK_DEV_ALI15X3 || BLK_DEV_AMD74XX || BLK_DEV_ATIIXP || BLK_DEV_CMD64X || BLK_DEV_CS5530 || BLK_DEV_CS5535 || BLK_DEV_HPT34X || BLK_DEV_HPT366 || BLK_DEV_IT821X || BLK_DEV_IT8213 || BLK_DEV_JMICRON || BLK_DEV_NS87415 || BLK_DEV_OPTI621 || BLK_DEV_PDC202XX_OLD || BLK_DEV_PDC202XX_NEW || BLK_DEV_PIIX || BLK_DEV_RZ1000 || BLK_DEV_SC1200 || BLK_DEV_SVWKS || BLK_DEV_SIIMAGE || BLK_DEV_SIS5513 || BLK_DEV_SL82C105 || BLK_DEV_SLC90E66 || BLK_DEV_TC86C001 || BLK_DEV_TRIFLEX || BLK_DEV_TRM290 || BLK_DEV_VIA82CXXX)
         help
           This option provides generic support for various PCI IDE Chipsets
           which otherwise might not be supported.
 
+config BLK_DEV_GENERIC_ONLY
+	bool
+
 config BLK_DEV_OPTI621
 	tristate "OPTi 82C621 chipset enhanced support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 8fe8b5b..3ce78f9 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -100,12 +100,55 @@ static const u16 legacy_bases[] = { 0x1f0, 0x170, 0x1e8, 0x168, 0x1e0, 0x160 };
 static const int legacy_irqs[]  = { 14, 15, 11, 10, 8, 12 };
 #endif
 
+static void ide_generic_check_pci_uses_legacy_iobases(int *primary,
+						      int *secondary)
+{
+
+#if !defined(CONFIG_BLK_DEV_GENERIC_ONLY)
+	struct pci_dev *p = NULL;
+	u16 val;
+
+	for_each_pci_dev(p) {
+		int r;
+
+		for (r = 0; r < 6; r++) {
+			if (pci_resource_start(p, r) == 0x1f0)
+				*primary = 1;
+			if (pci_resource_start(p, r) == 0x170)
+				*secondary = 1;
+		}
+
+		/* Cyrix CS5510 pre SFF MWDMA ATA on the bridge */
+		if (p->vendor == 0x1078 && p->device == 0x0000)
+			*primary = *secondary = 1;
+
+		/* Cyrix CS5520 pre SFF MWDMA ATA on the bridge */
+		if (p->vendor == 0x1078 && p->device == 0x0002)
+			*primary = *secondary = 1;
+
+		/* Intel MPIIX - PIO ATA on non PCI side of bridge */
+		if (p->vendor == 0x8086 && p->device == 0x1234) {
+
+			pci_read_config_word(p, 0x6C, &val);
+			if (val & 0x8000) {
+				/* ATA port enabled */
+				if (val & 0x4000)
+					*secondary = 1;
+				else
+					*primary = 1;
+			}
+		}
+	}
+#endif
+
+}
+
 static int __init ide_generic_init(void)
 {
 	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
 	struct ide_host *host;
 	unsigned long io_addr;
-	int i, rc;
+	int i, rc, primary = 0, secondary = 0;
 
 #ifdef CONFIG_MIPS
 	if (!ide_probe_legacy())
@@ -116,7 +159,9 @@ static int __init ide_generic_init(void)
 
 	memset(hws, 0, sizeof(hw_regs_t *) * MAX_HWIFS);
 
-	for (i = 0; i < ARRAY_SIZE(legacy_bases); i++) {
+	ide_generic_check_pci_uses_legacy_iobases(&primary, &secondary);
+
+	for (i = primary + secondary; i < ARRAY_SIZE(legacy_bases); i++) {
 		io_addr = legacy_bases[i];
 
 		hws[i] = NULL;
-- 
1.5.5.4


-- 
Regards/Gruss,
    Boris.
