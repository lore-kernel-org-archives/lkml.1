Return-Path: <linux-kernel-owner+w=401wt.eu-S1765403AbYCTBXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765403AbYCTBXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYCTBXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:23:20 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:30933 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYCTBXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:23:18 -0400
Message-ID: <5a4c581d0803181502h1fc050fbwf98e1bc4602e4d46@mail.gmail.com>
Date: Tue, 18 Mar 2008 23:02:16 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: ehci-hcd affects hda speed
Cc: "David Brownell" <david-b@pacbell.net>,
       "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <47DF19AD.405@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr>
	 <200803171400.40045.david-b@pacbell.net>
	 <47DEFD85.1050706@keyaccess.nl>
	 <200803171700.26274.david-b@pacbell.net> <47DF19AD.405@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2008 at 2:23 AM, Rene Herman <rene.herman@keyaccess.nl> wrote:
> On 18-03-08 01:00, David Brownell wrote:
>
>  > On Monday 17 March 2008, Rene Herman wrote:
>  >> +       case PCI_VENDOR_ID_VIA:
>  >> +               if (pdev->device == 0x3104 && pdev->revision >= 0x60) {
>  >
>  > Unless you have specific docs from VIA saying that this register
>  > isn't revision-specific (at least in the sense that all revisions
>  > after 0x60 define that bit in that way), this should probably be a
>  > switch on pdev->revision and just include the known-safe revisions.
>
>  I'm looking at a VIA datasheet which says the revision ID for the "VT6212 /
>  VT6212L PCI USB2.0 Controller" is simply 0x60. The VT61212L I myself owned
>  advertised a revision ID of 0x63 and Lev's VT6212L advertises 0x65.
>
>  The thing is -- you don't necesarily immediately notice this problem. I
>  noticed it earlier on an old system, as did Lev, but even if on a modern
>  system you may not immediately see an IDE throughput drop, you may still
>  have a sucky system.
>
>  With 0x60 documented and 0x63 and 0x65 confirmed as VT6212L, I'd personally
>  still go with >= 0x60 and assume either backwards-compatibility or a "don't
>  care" definition if some later revision were to not define this hack.
>
>
>  > At one point I had a table mapping those revision codes to
>  > specific VIA chips.  Too bad I didn't keep it.  ISTR that the
>  > VT6212 has a newer revision code than the vt8235 southbridge,
>  > and probably not as new as the vt8237 one...
>
>  Some googling seems to indicate that:
>
>  VT6202 = 0x5x (0x50, 0x51 at least)
>  VT6212 = 0x6x (0x60, 0x61, 0x63, 0x65 at least)
>  VT8235 = 0x82
>  VT8237 = 0x86
>  VT*800 = 0x90 (KM800Pro, VN800, K8N800, ...)
>
>  Do you want one with 0x6x? I feel it's very likely that everyone on anything
>  later will then still have a sucky system. Tons of people with VT8235/VT8237
>  around (although not me). Any quick test available for them?
>
>
>  > But otherwise, yes -- that's the kind of patch I'd sign off on
>  > after making this comment a bit more informative about how
>  > that 1 usec sleep time creates an amount of PCI bus hogging.
>
>  Version with 0x6x and the somewhat more expansive comment. I'd like to be
>  able to test VT8235/VT8237 first though...
>
>  Still totally untested ofcourse.
>
>  Rene
>
> commit fd96c2b26339f21a66504cb3f36579bb312a8f3b
>  Author: Rene Herman <rene.herman@gmail.com>
>  Date:   Tue Mar 18 00:02:16 2008 +0100
>
>     USB: VIA VT6212(L) 10us EHCI sleep time select.
>
>     The VIA VT6212(L) uses a 1us EHCI sleep time by default which hogs
>     the bus bad. Use the 10us EHCI spec value instead as suggested by
>     Lev A. Melnikovsky.
>
>     CC: Lev A. Melnikovsky <melnikovsky@mail.ru>
>     Signed-off-by: Rene Herman <rene.herman@gmail.com>
>
>  diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
>  index 3ba0166..bdc8af9 100644
>  --- a/drivers/usb/host/ehci-pci.c
>  +++ b/drivers/usb/host/ehci-pci.c
>  @@ -152,6 +152,20 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
>                         break;
>                 }
>                 break;
>  +       case PCI_VENDOR_ID_VIA:
>  +               if (pdev->device == 0x3104 && (pdev->revision & 0xf0) == 0x60) {
>  +                       u8 tmp;
>  +                       /*
>  +                        * The VT6212 defaults to a 1us EHCI sleep time which
>  +                        * hogs the bus badly. Setting bit 5 of 0x4B sets the
>  +                        * sleep time to the EHCI standard 10us.
>  +                        */
>  +                       pci_read_config_byte(pdev, 0x4b, &tmp);
>  +                       if (tmp & 0x20)
>  +                               break;
>  +                       pci_write_config_byte(pdev, 0x4b, tmp | 0x20);
>  +               }
>  +               break;
>         }
>
>         ehci_reset(ehci);

Works for me on top of 2.6.25-rc6-git2 :) Thanks folks !

Tested-by: Alessandro Suardi <alessandro.suardi@gmail.com>

(going to mention the patch in my Fedora bugzilla entry)

--alessandro

 "We act as though comfort and luxury were the chief requirements
 of life, when all that we need to make us really happy is
 something to be enthusiastic about."

 (Charles Kingsley)
