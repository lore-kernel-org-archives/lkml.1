Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYKGCIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYKGCIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYKGCIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:08:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:42584 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYKGCIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:08:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,560,1220252400"; 
   d="scan'208";a="460256936"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: Anthony Liguori <anthony@codemonkey.ws>, Matthew Wilcox <matthew@wil.cx>
CC: "Fischer, Anna" <anna.fischer@hp.com>, Greg KH <greg@kroah.com>,
       H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Date: Thu, 6 Nov 2008 18:08:31 -0800
Subject: RE: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Thread-Topic: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Thread-Index: AclAYHg8a9aqa1drRG2g5MMX8EwwRgAEon0A
Message-ID: <0B53E02A2965CE4F9ADB38B34501A3A1678F60DA@orsmsx505.amr.corp.intel.com>
References: <20081106154351.GA30459@kroah.com>
 <894107.30288.qm@web45108.mail.sp1.yahoo.com>
 <20081106164919.GA4099@kroah.com>
 <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net>
 <20081106183630.GD11773@parisc-linux.org> <491371F0.7020805@codemonkey.ws>
In-Reply-To: <491371F0.7020805@codemonkey.ws>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/2008 2:38:40 PM, Anthony Liguori wrote:
> Matthew Wilcox wrote:
> > [Anna, can you fix your word-wrapping please?  Your lines appear to
> > be infinitely long which is most unpleasant to reply to]
> >
> > On Thu, Nov 06, 2008 at 05:38:16PM +0000, Fischer, Anna wrote:
> >
> > > > Where would the VF drivers have to be associated?  On the "pci_dev"
> > > > level or on a higher one?
> > > >
> > > A VF appears to the Linux OS as a standard (full, additional) PCI
> > > device. The driver is associated in the same way as for a normal
> > > PCI device. Ideally, you would use SR-IOV devices on a virtualized
> > > system, for example, using Xen. A VF can then be assigned to a
> > > guest domain as a full PCI device.
> > >
> >
> > It's not clear thats the right solution.  If the VF devices are
> > _only_ going to be used by the guest, then arguably, we don't want
> > to create pci_devs for them in the host.  (I think it _is_ the right
> > answer, but I want to make it clear there's multiple opinions on this).
> >
>
> The VFs shouldn't be limited to being used by the guest.
>
> SR-IOV is actually an incredibly painful thing.  You need to have a VF
> driver in the guest, do hardware pass through, have a PV driver stub
> in the guest that's hypervisor specific (a VF is not usable on it's
> own), have a device specific backend in the VMM, and if you want to do
> live migration, have another PV driver in the guest that you can do
> teaming with.  Just a mess.

Actually "a PV driver stub in the guest" _was_ correct; I admit that I stated so at a virt mini summit more than a half year ago ;-). But the things have changed, and such a stub is no longer required (at least in our implementation). The major benefit of VF drivers now is that they are VMM-agnostic.

>
> What we would rather do in KVM, is have the VFs appear in the host as
> standard network devices.  We would then like to back our existing PV
> driver to this VF directly bypassing the host networking stack.  A key
> feature here is being able to fill the VF's receive queue with guest
> memory instead of host kernel memory so that you can get zero-copy
> receive traffic.  This will perform just as well as doing passthrough
> (at
> least) and avoid all that ugliness of dealing with SR-IOV in the guest.
>
> This eliminates all of the mess of various drivers in the guest and
> all the associated baggage of doing hardware passthrough.
>
> So IMHO, having VFs be usable in the host is absolutely critical
> because I think it's the only reasonable usage model.

As Eddie said, VMDq is better for this model, and the feature is already available today. It is much simpler because it was designed for such purposes. It does not require hardware pass-through (e.g. VT-d) or VFs as a PCI device, either.

>
> Regards,
>
> Anthony Liguori
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
             .
Jun Nakajima | Intel Open Source Technology Center
