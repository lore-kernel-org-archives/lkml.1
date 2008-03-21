Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbYCUJMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbYCUJMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 05:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYCUJML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 05:12:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38164 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbYCUJMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 05:12:10 -0400
Date: Fri, 21 Mar 2008 10:11:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       shai@scalex86.org
Subject: Re: [patch 1/4] x86: vSMP: Fix is_vsmp_box()
Message-ID: <20080321091139.GD20420@elte.hu>
References: <20080320073740.GA9414@localdomain> <20080320073902.GB9414@localdomain> <86802c440803200044g54617517k4530db76ebe2cabb@mail.gmail.com> <20080320184045.GA6085@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320184045.GA6085@localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> >>         /* Check if we are running on a ScaleMP vSMP box */
> >>  -       if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
> >>  -            (PCI_VENDOR_ID_SCALEMP || (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
> >>  +       if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) ==
> >>  +            PCI_VENDOR_ID_SCALEMP) &&
> >>  +           (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) ==
> >>  +           PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
> >>                 vsmp = 1;
> >>
> >>         return vsmp;
> >
> >why read two times
> >
> 
> Well, the pci cfg space read happens just _once_ during the boot, as 
> the result is cached in a static flag. The above code is better 
> readable. So readability is better than micro-optimization here.

i think the patch below results in even more readable and a bit smaller 
code - because it's such a simple check?

OTOH, you are right in general, for example in mmconf-fam10h_64.c's 
get_fam10h_pci_mmconf_base() function, we do this:

                id = read_pci_config(bus, slot, 0, PCI_VENDOR_ID);

                vendor = id & 0xffff;
                device = (id>>16) & 0xffff;
                if (pci_probes[i].vendor == vendor &&
                    pci_probes[i].device == device) {

here it would indeed be cleaner to simply do:

                vendor = read_pci_config_16(bus, slot, 0, PCI_VENDOR_ID);
                device = read_pci_config_16(bus, slot, 0, PCI_DEVICE_ID);

instead of open-coding the 16-bit splitting.

	Ingo

------------>
Subject: x86: vsmp fix x86 vsmp fix is vsmp box cleanup
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Mar 21 09:55:06 CET 2008

code got a bit smaller:

arch/x86/kernel/vsmp_64.o:

   text	   data	    bss	    dec	    hex	filename
    205	      4	      0	    209	     d1	vsmp_64.o.before
    181	      4	      0	    185	     b9	vsmp_64.o.after

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vsmp_64.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-x86.q/arch/x86/kernel/vsmp_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/vsmp_64.c
+++ linux-x86.q/arch/x86/kernel/vsmp_64.c
@@ -120,10 +120,8 @@ int is_vsmp_box(void)
 		return vsmp;
 
 	/* Check if we are running on a ScaleMP vSMP box */
-	if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) ==
-	     PCI_VENDOR_ID_SCALEMP) &&
-	    (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) ==
-	    PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
+	if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
+	     (PCI_VENDOR_ID_SCALEMP | (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
 		vsmp = 1;
 
 	return vsmp;
