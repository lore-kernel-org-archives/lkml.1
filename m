Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYKZT5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYKZT5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbYKZT5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:57:09 -0500
Received: from kroah.org ([198.145.64.141]:38773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752301AbYKZT5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:57:08 -0500
Date: Wed, 26 Nov 2008 11:55:11 -0800
From: Greg KH <greg@kroah.com>
To: "Nakajima, Jun" <jun.nakajima@intel.com>
Cc: "Zhao, Yu" <yu.zhao@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [SR-IOV driver example 2/3] PF driver: integrate with SR-IOV
	core
Message-ID: <20081126195511.GA2386@kroah.com>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <20081126140303.GA13641@yzhao12-linux.sh.intel.com> <20081126142156.GB13668@yzhao12-linux.sh.intel.com> <20081126165859.GA28251@kroah.com> <0B53E02A2965CE4F9ADB38B34501A3A167E8BD7F@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0B53E02A2965CE4F9ADB38B34501A3A167E8BD7F@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 11:27:10AM -0800, Nakajima, Jun wrote:
> On 11/26/2008 8:58:59 AM, Greg KH wrote:
> > On Wed, Nov 26, 2008 at 10:21:56PM +0800, Yu Zhao wrote:
> > > This patch integrates the IGB driver with the SR-IOV core. It shows
> > > how the SR-IOV API is used to support the capability. Obviously
> > > people does not need to put much effort to integrate the PF driver
> > > with SR-IOV core. All SR-IOV standard stuff are handled by SR-IOV
> > > core and PF driver once it gets the necessary information (i.e.
> > > number of Virtual
> > > Functions) from the callback function.
> > >
> > > ---
> > >  drivers/net/igb/igb_main.c |   30 ++++++++++++++++++++++++++++++
> > >  1 files changed, 30 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
> > > index bc063d4..b8c7dc6 100644
> > > --- a/drivers/net/igb/igb_main.c
> > > +++ b/drivers/net/igb/igb_main.c
> > > @@ -139,6 +139,7 @@ void igb_set_mc_list_pools(struct igb_adapter *,
> > > struct e1000_hw *, int, u16);  static int igb_vmm_control(struct
> > > igb_adapter *, bool);  static int igb_set_vf_mac(struct net_device
> > > *, int, u8*);  static void igb_mbox_handler(struct igb_adapter *);
> > > +static int igb_virtual(struct pci_dev *, int);
> > >  #endif
> > >
> > >  static int igb_suspend(struct pci_dev *, pm_message_t); @@ -184,6
> > > +185,9 @@ static struct pci_driver igb_driver = {  #endif
> > >     .shutdown = igb_shutdown,
> > >     .err_handler = &igb_err_handler,
> > > +#ifdef CONFIG_PCI_IOV
> > > +   .virtual = igb_virtual
> > > +#endif
> >
> > #ifdef should not be needed, right?
> >
> 
> Good point. I think this is because the driver is expected to build on
> older kernels also,

That should not be an issue for patches that are being submitted, right?

And if this is the case, shouldn't it be called out in the changelog
entry?

> but the problem is that the driver (and probably others) is broken
> unless the kernel is built with CONFIG_PCI_IOV because of the
> following hunk, for example.
> 
> However, we don't want to use #ifdef for the (*virtual) field in the
> header. One option would be to define a constant like the following
> along with those changes.
> #define PCI_DEV_IOV
> 
> Any better idea?

Just always declare it in your driver, which will be added _after_ this
field gets added to the kernel tree as well.  It's not a big deal, just
an ordering of patches issue.

Because remember, don't add #ifdefs to drivers, they should not be
needed at all.

thanks,

greg k-h
