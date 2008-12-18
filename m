Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753447AbYLRCOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYLRCOU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYLRCOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:14:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:21187 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYLRCOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:14:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,240,1228118400"; 
   d="scan'208";a="650718122"
Message-ID: <4949B1E6.7030309@intel.com>
Date: Thu, 18 Dec 2008 10:13:58 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "Fischer, Anna" <anna.fischer@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Chiang, Alexander" <achiang@hp.com>,
        "Helgaas, Bjorn" <bjorn.helgaas@hp.com>,
        "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
        "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "matthew@wil.cx" <matthew@wil.cx>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "rdreier@cisco.com" <rdreier@cisco.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <200812161523.55238.jbarnes@virtuousgeek.org> <0199E0D51A61344794750DC57738F58E5E29B33E3C@GVW1118EXC.americas.hpqcorp.net>
In-Reply-To: <0199E0D51A61344794750DC57738F58E5E29B33E3C@GVW1118EXC.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fischer, Anna wrote:
> I have two minor comments on this topic.
> 
> 1) Currently the PF driver is called before the kernel initializes VFs and
> their resources, and the current API does not allow the PF driver to
> detect that easily if the allocation of the VFs and their resources
> has succeeded or not. It would be quite useful if the PF driver gets
> notified when the VFs have been created successfully as it might have
> to do further device-specific work *after* IOV has been enabled.

If the VF allocation fails in the PCI layer, then the SR-IOV core will 
invokes the callback again to notify the PF driver with zero VF count. 
The PF driver does not have to concern about this even the PCI layer 
code fails (and actually it's very rare).

And I'm not sure why the PF driver wants to do further work *after* the 
VF is allocated. Does this mean PF driver have to set up some internal 
resources related to SR-IOV/VF? If yes, I suggest the PF driver do it 
before VF allocation. The design philosophy of SR-IOV/VF is that VF is 
treated as hot-plug device, which means it should be immediately usable 
by VF driver (e.g. VF driver is pre-loaded) after it appears in the PCI 
subsystem. If that is not the purpose, then PF driver should handle it 
not depending on the SR-IOV, right?

If you could elaborate your SR-IOV PF/VF h/w specific requirement, it 
would be help for me to answer this question :-)

> 2) Configuration of SR-IOV: the current API allows to enable/disable
> VFs from userspace via SYSFS. At the moment I am not quite clear what
> exactly is supposed to control these capabilities. This could be
> Linux tools or, on a virtualized system, hypervisor control tools.

This depends on user application, you know, which depends on the usage 
environment (i.e. native, KVM or Xen).

> One thing I am missing though is an in-kernel API for this which I
> think might be useful. After all the PF driver controls the device,
> and, for example, when a device error occurs (e.g. a hardware failure
> which only the PF driver will be able to detect, not Linux), then the
> PF driver might have to de-allocate all resources, shut down VFs and
> reset the device, or something like that. In that case the PF driver
> needs to have a way to notify the Linux SR-IOV code about this and
> initiate cleaning up of VFs and their resources. At the moment, this
> would have to go through userspace, I believe, and I think that is not
> an optimal solution. Yu, do you have an opinion on how this would be
> realized?

Yes, the PF driver can use pci_iov_unregister to disable SR-IOV in case 
the fatal error occurs. This function also sends notification to user 
level through 'uevent' so user application can aware the change.

Thanks,
Yu
