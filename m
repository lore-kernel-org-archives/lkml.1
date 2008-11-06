Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYKFW7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYKFW7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYKFW67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:58:59 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48304 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYKFW66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:58:58 -0500
Date: Thu, 6 Nov 2008 15:58:54 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: "Fischer, Anna" <anna.fischer@hp.com>, Greg KH <greg@kroah.com>,
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
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Message-ID: <20081106225854.GA15439@parisc-linux.org>
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net> <20081106183630.GD11773@parisc-linux.org> <491371F0.7020805@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491371F0.7020805@codemonkey.ws>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 04:38:40PM -0600, Anthony Liguori wrote:
> >It's not clear thats the right solution.  If the VF devices are _only_
> >going to be used by the guest, then arguably, we don't want to create
> >pci_devs for them in the host.  (I think it _is_ the right answer, but I
> >want to make it clear there's multiple opinions on this).
> 
> The VFs shouldn't be limited to being used by the guest.
> 
> SR-IOV is actually an incredibly painful thing.  You need to have a VF 
> driver in the guest, do hardware pass through, have a PV driver stub in 
> the guest that's hypervisor specific (a VF is not usable on it's own), 
> have a device specific backend in the VMM, and if you want to do live 
> migration, have another PV driver in the guest that you can do teaming 
> with.  Just a mess.

Not to mention that you basically have to statically allocate them up
front.

> What we would rather do in KVM, is have the VFs appear in the host as 
> standard network devices.  We would then like to back our existing PV 
> driver to this VF directly bypassing the host networking stack.  A key 
> feature here is being able to fill the VF's receive queue with guest 
> memory instead of host kernel memory so that you can get zero-copy 
> receive traffic.  This will perform just as well as doing passthrough 
> (at least) and avoid all that ugliness of dealing with SR-IOV in the guest.

This argues for ignoring the SR-IOV mess completely.  Just have the
host driver expose multiple 'ethN' devices.

> This eliminates all of the mess of various drivers in the guest and all 
> the associated baggage of doing hardware passthrough.
> 
> So IMHO, having VFs be usable in the host is absolutely critical because 
> I think it's the only reasonable usage model.
> 
> Regards,
> 
> Anthony Liguori
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
