Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbXFUSgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbXFUSgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbXFUSgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:36:24 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:38194 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756617AbXFUSgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:36:21 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Thu, 21 Jun 2007 20:36:15 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Ravikiran G Thirumalai" <kiran@scalex86.org>
cc: "Len Brown" <lenb@kernel.org>, "Steven Whitehouse" <swhiteho@redhat.com>,
       "Andi Kleen" <ak@suse.de>, "Shai Fultheim" <shai@scalex86.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/12] acpi: fix another compile warning
Message-ID: <20070621183615.GI5193@alberich.amd.com>
References: <20070619225035.GI5193@alberich.amd.com>
 <200706192338.02807.lenb@kernel.org>
 <20070620084911.GO5193@alberich.amd.com>
 <200706200936.31236.lenb@kernel.org> <20070620182548.GA561@localdomain>
MIME-Version: 1.0
In-Reply-To: <20070620182548.GA561@localdomain>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 21 Jun 2007 18:35:10.0524 (UTC)
 FILETIME=[E61AF7C0:01C7B432]
X-WSS-ID: 6A641A9C23K1051616-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 11:25:48AM -0700, Ravikiran G Thirumalai wrote:
> On Wed, Jun 20, 2007 at 09:36:30AM -0400, Len Brown wrote:
> > On Wednesday 20 June 2007 04:49, Andreas Herrmann wrote:
> > > On Tue, Jun 19, 2007 at 11:38:02PM -0400, Len Brown wrote:
> > > > On Tuesday 19 June 2007 18:50, Andreas Herrmann wrote:
> > 
> > I fear, however, that this patch defeats the purpose of 
> > b0bd35e622ffbda2c01dc67a0381c6a18817a29a -- which was to make selecting
> > NUMA more user-friendly.  So it might make more sense to simply revert that
> > patch entirely.
> > 
> > The underlying problem is that Kconfig doesn't support using select
> > on targets which themselves have dependencies.
> > 
> > Signed-off-by: Len Brown <len.brown@intel.com>
> > 
> > 
> > diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
> > index 5ce9443..e9d7767 100644
> > --- a/arch/x86_64/Kconfig
> > +++ b/arch/x86_64/Kconfig
> > @@ -364,9 +364,9 @@ config NODES_SHIFT
> >  config X86_64_ACPI_NUMA
> >         bool "ACPI NUMA detection"
> >         depends on NUMA
> > -       select ACPI 
> > +       depends on ACPI 
> >  	select PCI
> > -       select ACPI_NUMA
> > +       depends on ACPI_NUMA
> >         default y
> >         help
> >  	 Enable ACPI SRAT based node topology detection.
> > -
> 
> arch/x86_64/Kconfig:706:error: found recursive dependency: PCI -> ACPI ->
> X86_64_ACPI_NUMA -> PCI
>  -> USB_ARCH_HAS_OHCI -> USB_ARCH_HAS_HCD -> MOUSE_APPLETOUCH -> USB ->
> USB_SISUSBVGAmake[1]: *** [menuconfig] Error 1
> 
> I guess we have to change PCI to 'depends on' as well.
> Else, select PM?
> 
> I am OK with either approach.
> 
> Thanks,
> Kiran
> 
> Paper over 'select' inadequacies.  
> 
> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> 
> Index: linux-2.6.22-rc5/arch/x86_64/Kconfig
> ===================================================================
> --- linux-2.6.22-rc5.orig/arch/x86_64/Kconfig	2007-06-18 16:02:19.571323415 -0700
> +++ linux-2.6.22-rc5/arch/x86_64/Kconfig	2007-06-20 11:34:29.845354250 -0700
> @@ -366,6 +366,7 @@ config X86_64_ACPI_NUMA
>         depends on NUMA
>         select ACPI 
>  	select PCI
> +  	select PM
>         select ACPI_NUMA
>         default y
>         help

Yep, this one-liner solves all acpi related compile errors/warnings
that I've reported.

Additional it resolves anoter problem that results from
dependencies between CONFIG_PNP and CONFIG_ACPI.

One problem arises:
If PM is deselected, the PNP menu is empty on x86_64.
So I suggest to add the attached patch to hide the PNP-menu
if no PM (and thus ACPI) is selected.


Regards,

Andreas

--

Make CONFIG_PNP a menuconfig to hide the submenu if neither
ISA nor ACPI is selected.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

diff --git a/drivers/pnp/Kconfig b/drivers/pnp/Kconfig
index 1959cef..2291e7d 100644
--- a/drivers/pnp/Kconfig
+++ b/drivers/pnp/Kconfig
@@ -2,11 +2,9 @@
 # Plug and Play configuration
 #
 
-menu "Plug and Play support"
-	depends on HAS_IOMEM
-
-config PNP
+menuconfig PNP
 	bool "Plug and Play support"
+	depends on HAS_IOMEM
 	depends on ISA || ACPI
 	---help---
 	  Plug and Play (PnP) is a standard for peripherals which allows those
@@ -22,15 +20,15 @@ config PNP
 
 	  If unsure, say Y.
 
+if PNP
+
 config PNP_DEBUG
 	bool "PnP Debug Messages"
-	depends on PNP
 	help
 	  Say Y if you want the Plug and Play Layer to print debug messages.
 	  This is useful if you are developing a PnP driver or troubleshooting.
 
 comment "Protocols"
-	depends on PNP
 
 source "drivers/pnp/isapnp/Kconfig"
 
@@ -38,5 +36,4 @@ source "drivers/pnp/pnpbios/Kconfig"
 
 source "drivers/pnp/pnpacpi/Kconfig"
 
-endmenu
-
+endif



