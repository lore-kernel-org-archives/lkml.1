Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYH3BOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYH3BOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 21:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYH3BOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 21:14:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:38411 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYH3BOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 21:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XVprnNkAkdLwDJK9Jj/bV1cgS7apz5o09guzHyAZtYQTlEmbzookgGAIn/bpXBiEPr
         htYbYJ0vIewMbCzGFloijN7Kt2mGVW9QK9Sr2h9jMf9xBNi1Ksx4AYfmd2abzbpX9khD
         cnl0eUWnK2G0XU7aoyorBd6//vEAzLWVYJYaQ=
Message-ID: <86802c440808291814v4037f83eu943b9ad23297309b@mail.gmail.com>
Date: Fri, 29 Aug 2008 18:14:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jordan Crouse" <jordan.crouse@amd.com>,
       "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808292157.24179.rjw@sisk.pl>
	 <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>
	 <200808300031.16708.rjw@sisk.pl>
	 <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
	 <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>
	 <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>
	 <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 5:45 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 29 Aug 2008, Yinghai Lu wrote:
>>
>> the BAR is from pci_read_bases..., so that chipset is broken...
>> they are even supposed to to hide that BAR to os.
>
> Ok, can we please
>
>  - *do* get a quirk for known-broken chipsets (at a *PCI* level, this is
>   not an x86 issue)

the quirk work at the first point for David' system.

[PATCH] x86: protect hpet in BAR for one ATI chipset v3

so avoid kernel don't allocate nre resource for it because it can not
allocate the old
address from BIOS.

the same way like some IO APIC address in BAR handling

v3: device id should be 0x4385

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/pci/quirks.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -1918,6 +1918,22 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_B
                         PCI_DEVICE_ID_NX2_5709S,
                         quirk_brcm_570x_limit_vpd);

+static void __init quirk_hpet_in_bar(struct pci_dev *pdev)
+{
+       int i;
+       u64 base, size;
+
+       /* the BAR1 is the location of the HPET...we must
+        * not touch this, so forcibly insert it into the resource tree */
+       base = pci_resource_start(pdev, 1);
+       size = pci_resource_len(pdev, 1);
+       if (base && size) {
+               insert_resource(&iomem_resource, &pdev->resource[1]);
+               dev_info(&pdev->dev, "HPET at %08llx-%08llx\n", base,
base + size - 1);
+       }
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 0x4385, quirk_hpet_in_bar);
+
 #ifdef CONFIG_PCI_MSI
 /* Some chipsets do not support MSI. We cannot easily rely on setting
  * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually


or waiting for another quirk from Jordan to set magic to hide the that BAR?


>
>  - *not* get any more random PCI work-arounds that go through the x86 tree
>   and aren't even looked at by the (very few) people who actually
>   understand the PCI resource handling?

stop working on following path?
[PATCH] x86: split e820 reserved entries record to late v4
[PATCH] x86: split e820 reserved entries record to late v4 - fix v2


>
> IOW, for the first issue, just teach pci_mmcfg_check_hostbridge() about
> this broken bridge, and have it fix things up (including hiding the thing,
> but also just verifying that the dang thing even -works- etc).

sound good, will look at after get lspci -tv and lspci -vvxxx from Rafael.

also quirk between probe::pci_read_bases and pci_resource_survey
could be used to make the BAR res ->end to be more reasonable.

>
> For the second issue - please do realize that we have had much over a
> _decade_ of work on the PCI resource handling, and it's fragile. The thing
> I reverted really isn't something that Ingo should ever have committed in
> the first place. It's not something an x86 maintainer can even make sane
> decisions on.
>
> Resource handling things _need_ to get ACK's from people like Ivan
> Kokshaysky or me. Or at least _several_ other people who actually really
> understand not just PCI resource handling, but have actually seen all the
> horrible crap it causes, and understand how fragile this stuff is. It's
> all different, and it's all about all the million of broken machines out
> there that screw things up.

YH
