Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbYAWS0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbYAWS0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYAWS0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:26:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32842 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbYAWS0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:26:07 -0500
Date: Wed, 23 Jan 2008 10:26:28 -0800
From: Greg KH <greg@kroah.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH]PCIE ASPM support - takes 3
Message-ID: <20080123182628.GB22362@kroah.com>
References: <1200621388.8965.3.camel@sli10-desk.sh.intel.com> <20080122225806.GC4742@kroah.com> <1201054854.24563.3.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201054854.24563.3.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 10:20:54AM +0800, Shaohua Li wrote:
> 
> On Tue, 2008-01-22 at 14:58 -0800, Greg KH wrote:
> > On Fri, Jan 18, 2008 at 09:56:28AM +0800, Shaohua Li wrote:
> > > v3->v2, fixed the issues Matthew Wilcox raised.
> > > 
> > > PCI Express ASPM defines a protocol for PCI Express components in the D0
> > > state to reduce Link power by placing their Links into a low power state
> > > and instructing the other end of the Link to do likewise. This
> > > capability allows hardware-autonomous, dynamic Link power reduction
> > > beyond what is achievable by software-only controlled power management.
> > > However, The device should be configured by software appropriately.
> > > Enabling ASPM will save power, but will introduce device latency.
> > > 
> > > This patch adds ASPM support in Linux. It introduces a global policy for
> > > ASPM, a sysfs file /sys/module/pcie_aspm/parameters/policy can control
> > > it. The interface can be used as a boot option too. Currently we have
> > > below setting:
> > >         -default, BIOS default setting
> > >         -powersave, highest power saving mode, enable all available ASPM
> > > state
> > > and clock power management
> > >         -performance, highest performance, disable ASPM and clock power
> > > management
> > > By default, the 'default' policy is used currently.
> > > 
> > > In my test, power difference between powersave mode and performance mode
> > > is about 1.3w in a system with 3 PCIE links.
> > > 
> > > please review, any comments will be appreciated.
> > 
> > Can you please fix up all of the warnings that checkpatch.pl and sparse
> > produce from this patch?
> > 
> > Also, one small thing:
> > 
> > > --- linux.orig/include/linux/pci.h	2008-01-16 15:59:42.000000000 +0800
> > > +++ linux/include/linux/pci.h	2008-01-18 09:41:20.000000000 +0800
> > > @@ -164,6 +164,10 @@ struct pci_dev {
> > >  					   this is D0-D3, D0 being fully functional,
> > >  					   and D3 being off. */
> > >  
> > > +#ifdef CONFIG_PCIEASPM
> > > +	void		*link_state;	/* ASPM link state. */
> > > +#endif
> > 
> > Can we make this a "real" pointer to a structure?  I note that you use
> > two different structures here in this pointer, should you really do
> > that?  It's good to get type-checks whereever possible.
> The structure is just for internal use of ASPM, just don't want make it
> global.

Yes, you don't need to expose the structure type, just name it, and then
define it in the code itself.

But using a void pointer as you have here, allows you to assign two
different types of structures to this pointer.  Are you sure that you
always get this right?  :)

Please, let's try to inforce type-saftey and set this to be a specific
type of pointer to a structure.  That will require you to possibly merge
the two structures, which will require some code changes.

thanks,

greg k-h
