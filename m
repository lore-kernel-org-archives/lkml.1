Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbYHGEi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbYHGEi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 00:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbYHGEgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 00:36:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:49889 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbYHGEgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 00:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=vA2fgknTr1FIMsuoLRD/HeQGwLXrn0Z0iLkt2OUGkBGCXKB2NaXsUqCIUkCIFLPUjE
         yRMsyG1QfU4kR8IQjmrcVii1BQZoaXepQ+cP1W3MCdUZmuk+YEamftWOoX35hMvseBBZ
         ViNrtKxmVuoDjhLaramuTRSSRUrM5bkW5vqkQ=
Date: Thu, 7 Aug 2008 06:36:22 +0200
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: [PATCH] ide-generic: handle probing of legacy io-ports v5 (was:
	Re: [PATCH 1/2] pata_legacy: export functionality to ide)
Message-ID: <20080807043621.GA3771@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Sergei Shtylyov <sshtylyov@ru.mvista.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org
References: <20080803165135.GA31977@gollum.tnic> <4898630C.7090403@ru.mvista.com> <9ea470500808050732s7be29360ge358790e955be06a@mail.gmail.com> <58cb370e0808050741v7ff3f20awb3d91a84486f8547@mail.gmail.com> <20080806061023.GA23773@gollum.tnic> <48998C58.20703@ru.mvista.com> <9ea470500808060703p4a94c868i25106e081aad75c4@mail.gmail.com> <4899C9F4.9040002@ru.mvista.com> <20080806194754.GC31312@gollum.tnic> <489A03C3.5070607@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489A03C3.5070607@ru.mvista.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 12:04:19AM +0400, Sergei Shtylyov wrote:

[.. ]

>>>>> Would have been probably enough to test only BAR0/2, don't you think?
>
>>>> I assume you're referring to the legacy ioports fixup in
>>>> drivers/pci/probe.c:pci_setup_device().
>
>>>   And to the fact that the value 0x1f0 should only be ever seen in 
>>> BAR0 and 0x170 in BAR2 even if they would have been read off the 
>>> chips (some chips have these values reading back even in legacy mode, 
>>> and even could malfunction if other values are written there), not 
>>> fixed up there, and certainly not in BAR1 or BAR3, so it's quite 
>>> pointless to look in these BARs too.
>
>> So the comment in there saying that in some cases BAR0-3 could contain junk is a
>> bogus?
>
>    Don't know. The PCI IDE spec. said that those should be 0 in 
> compatibility mode but I know that some controllers require the standard 
> values of 0x1[f7]0 to be in BAR0/2 in compatibility mode. If my memory 
> serves, NatSemi PC8741x were ones of those...
>
>> In other words, can we assume that one will always read 0x1f0 from BAR0
>> and 0x170 from BAR2 in compatibility mode.
>
>    Certainly not. We can only rely on the workaround putting 0x1[f7]0 in 
> the resources 0/2.
>
>> If so, the check is even simpler:
>
>> 	if (pci_resource_start(p, 0) == 0x1f0)
>> 		*primary = 1;
>> 	if (pci_resource_start(p, 2) == 0x170)
>> 		*secondary = 1;
>
>    Yes, I think that should be enough...

Here's v5:

---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sun, 3 Aug 2008 18:46:35 +0200
Subject: [PATCH] ide-generic: handle probing of legacy io-ports v5

Avoid probing the io-ports in case an IDE PCI controller is present and it
uses the legacy iobases. If we still want to enforce the probing, we do

ide_generic.probe_mask=0x3f

on the kernel command line. The iobase checking code is
adapted from drivers/ata/pata_legacy.c after converting hex
pci ids into their corresponding macros in <linux/pci_ids.h>.

Also, check only BAR0/2 resources since those are guaranteed
by the workaround in drivers/pci/probe.c:pci_setup_device().

CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-generic.c |   56 +++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 8fe8b5b..608f353 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/ide.h>
+#include <linux/pci_ids.h>
 
 /* FIXME: convert m32r to use ide_platform host driver */
 #ifdef CONFIG_M32R
@@ -27,7 +28,7 @@
 
 #define DRV_NAME	"ide_generic"
 
-static int probe_mask = 0x03;
+static int probe_mask;
 module_param(probe_mask, int, 0);
 MODULE_PARM_DESC(probe_mask, "probe mask for legacy ISA IDE ports");
 
@@ -100,19 +101,66 @@ static const u16 legacy_bases[] = { 0x1f0, 0x170, 0x1e8, 0x168, 0x1e0, 0x160 };
 static const int legacy_irqs[]  = { 14, 15, 11, 10, 8, 12 };
 #endif
 
+static void ide_generic_check_pci_legacy_iobases(int *primary, int *secondary)
+{
+	struct pci_dev *p = NULL;
+	u16 val;
+
+	for_each_pci_dev(p) {
+
+		if (pci_resource_start(p, 0) == 0x1f0)
+			*primary = 1;
+		if (pci_resource_start(p, 2) == 0x170)
+			*secondary = 1;
+
+		/* Cyrix CS55{1,2}0 pre SFF MWDMA ATA on the bridge */
+		if (p->vendor == PCI_VENDOR_ID_CYRIX &&
+		    (p->device == PCI_DEVICE_ID_CYRIX_5510 ||
+		     p->device == PCI_DEVICE_ID_CYRIX_5520))
+			*primary = *secondary = 1;
+
+		/* Intel MPIIX - PIO ATA on non PCI side of bridge */
+		if (p->vendor == PCI_VENDOR_ID_INTEL &&
+		    p->device == PCI_DEVICE_ID_INTEL_82371MX) {
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
 		return -ENODEV;
 #endif
-	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
-			 "parameter for probing all legacy ISA IDE ports\n");
+	ide_generic_check_pci_legacy_iobases(&primary, &secondary);
+
+	if (!probe_mask) {
+		printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" "
+		     "module parameter for probing all legacy ISA IDE ports\n");
+
+		if (primary == 0)
+			probe_mask |= 0x1;
+
+		if (secondary == 0)
+			probe_mask |= 0x2;
+	} else {
+		printk(KERN_WARNING "%s: enforcing probing of io ports upon "
+			"user request.\n", DRV_NAME);
+	}
 
 	memset(hws, 0, sizeof(hw_regs_t *) * MAX_HWIFS);
 
-- 
1.5.5.4

-- 
Regards/Gruss,
    Boris.
