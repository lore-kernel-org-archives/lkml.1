Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbZBWIC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbZBWIC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 03:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbZBWIB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 03:01:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:41079 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbZBWIB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:01:57 -0500
Message-ID: <49A257AB.4040200@kernel.org>
Date: Mon, 23 Feb 2009 00:00:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeffrey Trull <jetrull@sbcglobal.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: AGP aperture size detection 32b vs. 64b kernels
References: <622229.85336.qm@web82407.mail.mud.yahoo.com>
In-Reply-To: <622229.85336.qm@web82407.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeffrey Trull wrote:
> YingHai, thanks so much for your quick response.
> 
> You are correct, my solution is not a good one.  I am new to this code
> :)  Instead I should tell you what is happening and let you decide.
> 
> In fix_northbridge, "nb" is 0x1022:0x1103
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> Miscellaneous Control
> 
> and "agp" is 0x1106:0x0282
> 00:00.0 Host bridge: VIA Technologies, Inc. K8T800Pro Host Bridge
> 
> After this code is executed:
>     pci_read_config_dword(nb, AMD64_GARTAPERTURECTL, &nb_order);
>     nb_order = (nb_order >> 1) & 7;
> 
> nb_order is 0
> 
> Normally, fix_northbridge would exit at this point because the aperture
> is valid.  However, I comment out the "return 0" and we proceed.
> 
> After this code is executed:
> 
>     pci_read_config_word(agp, cap+0x14, &apsize);
> 
> apsize is 0xf20
> 
> and from there we calculate the correct value of 128MB.
> 
> Thanks so much for looking at my problem.  I hope maybe the solution
> will help others.
> 
> 
> --- On *Sun, 2/22/09, Yinghai Lu /<yinghai@kernel.org>/* wrote:
> 
>     From: Yinghai Lu <yinghai@kernel.org>
>     Subject: Re: AGP aperture size detection 32b vs. 64b kernels
>     To: "Jeffrey Trull" <jetrull@sbcglobal.net>
>     Date: Sunday, February 22, 2009, 7:29 PM
> 
>     On Sun, Feb 22, 2009 at 10:44 AM, Jeffrey Trull <jetrull@sbcglobal.net>
>     wrote:
>     > Hello YingHai,
>     >
>     > I'm sorry to write you out of the blue but when I was analyzing my
>     problem I
>     > found that you were very involved with the area of code.  So I hope you
>     will
>     > forgive this email.
>     >
>     > Although I have an Athlon64-based system, I normally use 32b kernels.
>     > AGP-based video has never worked for me.  Recently I discovered that if I
>     > use a 64b kernel AGP works OK and I can use the "dri" drivers. 
>     I built my
>     > own kernel and tracked it down to a difference between how 32b calculates
>     > AGP aperture (in amd64-agp.c) versus how 64b calculates aperture size (in
>     >
>      aperture_64.c).
>     >
>     > It seems that the code in aperture_64.c will always look at the
>     capabilities
>     > list to find the aperture size.  However, in amd64-agp.c, if the aperture
>     > size in the control register is valid, no capabilities will be searched. 
>     In
>     > my system this value is "0" -> 32MB, which is wrong.  If the
>     capabilities
>     > are searched, the correct value of 128MB is found.
>     >
>     > I find that if I change these lines in amd64-agp.c from the
>     fix_northbridge
>     > function:
>     >
>     > if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order)) {
>     >              return 0;
>     >        }
>     >
>     > to this:
>     >
>     > if (!cap && agp_aperture_valid(nb_aper,
>     (32*1024*1024)<<nb_order)) {
>     >              return 0;
>     >        }
> 
>     Not sure:
> 
>     static int __devinit agp_amd64_probe(struct pci_dev *pdev,
>                                      
>         const struct pci_device_id *ent)
>     {
>             struct agp_bridge_data *bridge;
>             u8 cap_ptr;
>             int err;
> 
>             cap_ptr = pci_find_capability(pdev, PCI_CAP_ID_AGP);
>             if (!cap_ptr)
>                     return -ENODEV;
> 
>     ==>
> 
>     cache_nbs(pdev, cap_ptr)
> 
>     ==>
>     fix_northbridge(dev, pdev, cap_ptr) < 0
> 
>     ==>
> 
>     static __devinit int fix_northbridge(struct pci_dev *nb, struct pci_dev *agp,
>                                                                      u16 cap)
>     {
>             u32 aper_low, aper_hi;
>             u64 aper, nb_aper;
>             int order = 0;
>             u32 nb_order, nb_base;
>             u16 apsize;
> 
>             pci_read_config_dword(nb, AMD64_GARTAPERTURECTL, &nb_order);
>             nb_order = (nb_order >> 1) & 7;
>             pci_read_config_dword(nb, AMD64_GARTAPERTUREBASE, &nb_base);
>             nb_aper = nb_base << 25;
>             if
>      (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order)) {
>                     return 0;
>             }
> 
>     so cap could not be 0 in any case...
> 
> 
>     it seems that your AGP need 128M, but NB only set that to 32M?
> 
> 
>     >
>     > then my capabilities are searched and the correct aperture is found.
>     >
>     > Thank you for considering my problem.
>     >
>     > Best Regards,
>     > Jeff Trull


please check

[PATCH] x86/agp: tight check to update amd nb aperture

Impact: fix bug to make agp working with dri

Jeffrey Reported that dri does work with 64bit, but doesn't work with 32bit
it turns out NB aperture is 32M, aperture on agp is 128M

64bit is using 64M for vaidation for 64 iommu/gart
32bit is only using 32M..., and will not update the nb aperture.

so try to compare nb apterture and agp apterture before leaving not touch nb
aperture.

Reported-by: Jeffrey Trull <jetrull@sbcglobal.net>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/char/agp/amd64-agp.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/char/agp/amd64-agp.c
===================================================================
--- linux-2.6.orig/drivers/char/agp/amd64-agp.c
+++ linux-2.6/drivers/char/agp/amd64-agp.c
@@ -271,15 +271,15 @@ static __devinit int fix_northbridge(str
 	nb_order = (nb_order >> 1) & 7;
 	pci_read_config_dword(nb, AMD64_GARTAPERTUREBASE, &nb_base);
 	nb_aper = nb_base << 25;
-	if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order)) {
-		return 0;
-	}
 
 	/* Northbridge seems to contain crap. Try the AGP bridge. */
 
 	pci_read_config_word(agp, cap+0x14, &apsize);
-	if (apsize == 0xffff)
+	if (apsize == 0xffff) {
+		if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order))
+			return 0;
 		return -1;
+	}
 
 	apsize &= 0xfff;
 	/* Some BIOS use weird encodings not in the AGPv3 table. */
@@ -301,6 +301,11 @@ static __devinit int fix_northbridge(str
 		order = nb_order;
 	}
 
+	if (nb_order >= order) {
+		if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order))
+			return 0;
+	}
+
 	dev_info(&agp->dev, "aperture from AGP @ %Lx size %u MB\n",
 		 aper, 32 << order);
 	if (order < 0 || !agp_aperture_valid(aper, (32*1024*1024)<<order))
