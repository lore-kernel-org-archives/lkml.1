Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbYBTFxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbYBTFxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYBTFxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:53:08 -0500
Received: from mail.suse.de ([195.135.220.2]:35912 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbYBTFxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:53:05 -0500
Date: Tue, 19 Feb 2008 21:42:24 -0800
From: Greg KH <gregkh@suse.de>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       matthew@wil.cx, "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bootup crash, -git] Re: patch
	pci-pcie-aspm-support.patchadded to gregkh-2.6 tree
Message-ID: <20080220054224.GD31507@suse.de>
References: <12013009171835@kroah.org> <20080202105506.GA25160@elte.hu> <20080202185145.GA13005@kroah.com> <1203399945.12681.8.camel@sli10-desk.sh.intel.com> <20080219234529.GA12967@kroah.com> <1203471367.21958.3.camel@sli10-desk.sh.intel.com> <20080220041400.GA18771@suse.de> <1203482901.23071.5.camel@sli10-desk.sh.intel.com> <20080220050403.GA31314@suse.de> <1203485088.23071.10.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203485088.23071.10.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 01:24:48PM +0800, Shaohua Li wrote:
> 
> On Tue, 2008-02-19 at 21:04 -0800, Greg KH wrote:
> > On Wed, Feb 20, 2008 at 12:48:21PM +0800, Shaohua Li wrote:
> > > 
> > > On Tue, 2008-02-19 at 20:14 -0800, Greg KH wrote:
> > > > On Wed, Feb 20, 2008 at 09:36:07AM +0800, Shaohua Li wrote:
> > > > > --- linux.orig/include/linux/pci-acpi.h	2008-02-19 11:03:51.000000000 +0800
> > > > > +++ linux/include/linux/pci-acpi.h	2008-02-20 09:19:15.000000000 +0800
> > > > > @@ -47,6 +47,7 @@
> > > > >  				OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL)
> > > > >  
> > > > >  #ifdef CONFIG_ACPI
> > > > > +#include <acpi/acpi_bus.h>
> > > > >  extern acpi_status pci_osc_control_set(acpi_handle handle, u32 flags);
> > > > >  extern acpi_status __pci_osc_support_set(u32 flags, const char *hid);
> > > > >  static inline acpi_status pci_osc_support_set(u32 flags)
> > > > > @@ -59,13 +60,11 @@ static inline acpi_status pcie_osc_suppo
> > > > >  }
> > > > >  #else
> > > > >  #if !defined(AE_ERROR)
> > > > > -typedef u32 		acpi_status;
> > > > > -#define AE_ERROR      	(acpi_status) (0x0001)
> > > > > -#endif    
> > > > > -static inline acpi_status pci_osc_control_set(acpi_handle handle, u32 flags)
> > > > > -{return AE_ERROR;}
> > > > > -static inline acpi_status pci_osc_support_set(u32 flags) {return AE_ERROR;} 
> > > > > -static inline acpi_status pcie_osc_support_set(u32 flags) {return AE_ERROR;}
> > > > > +#define AE_ERROR      	(0x0001)
> > > > > +#endif
> > > > > +#define pci_osc_control_set(handle, flags) (AE_ERROR)
> > > > > +#define pci_osc_support_set(flags) (AE_ERROR)
> > > > > +#define pcie_osc_support_set(flags) (AE_ERROR)
> > > > 
> > > > No, please use inline functions, don't change these functions that
> > > > should be just fine.  Why are you needing to change them?
> > > some types aren't defined in non-ACPI, like acpi_handle, acpi_status.
> > 
> > Then why include a non-ACPI header file in non-ACPI .c files?
> aspm is generic, but in ACPI platform, it needs special handling. I can
> add 'ifdef CONFIG_ACPI' in aspm.c to avoid changing pci-acpi.h, but
> thought it's better pci-acpi.h is self-contained.

Ugh, "generic" stuff needing ACPI, that's an oxymoron...

Will this ever work on non-ACPI systems?  If so, then I expect to see
some #ifdefs in the .c file (or split it into two) to handle that.  If
not, why not only include it if ACPI is enabled, as that means it really
is a dependancy :(

thanks,

greg k-h
