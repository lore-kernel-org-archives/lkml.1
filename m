Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYKGQJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYKGQJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYKGQJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:09:32 -0500
Received: from outbound-mail-109.bluehost.com ([69.89.22.9]:53048 "HELO
	outbound-mail-109.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752479AbYKGQJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:09:31 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2008 11:09:31 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=uniscape.net;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=N5hPpgBx9guEVwodHXVJ/JLmnUd/9JCfj4BuZhdp+qjghiIPun7Lfk1YYrNev/MztX5BFSY6+FDphsh75Vsbn9GJUOLW+zoPazAVehmsWbUIxbmMUK8QtB5Fd52NdG64;
Message-ID: <49146667.6060901@uniscape.net>
Date: Sat, 08 Nov 2008 00:01:43 +0800
From: Yu Zhao <yu.zhao@uniscape.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Matthew Wilcox <matthew@wil.cx>, "Fischer, Anna" <anna.fischer@hp.com>,
       Greg KH <greg@kroah.com>, H L <swdevyid@yahoo.com>,
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
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net> <20081106183630.GD11773@parisc-linux.org> <491371F0.7020805@codemonkey.ws>
In-Reply-To: <491371F0.7020805@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2990:host272.hostmonster.com:uniscape:uniscape.net} {sentby:smtp auth 124.76.3.39 authed with yu.zhao@uniscape.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Matthew Wilcox wrote:
>> [Anna, can you fix your word-wrapping please?  Your lines appear to be
>> infinitely long which is most unpleasant to reply to]
>>
>> On Thu, Nov 06, 2008 at 05:38:16PM +0000, Fischer, Anna wrote:
>>  
>>>> Where would the VF drivers have to be associated?  On the "pci_dev"
>>>> level or on a higher one?
>>>>       
>>> A VF appears to the Linux OS as a standard (full, additional) PCI
>>> device. The driver is associated in the same way as for a normal PCI
>>> device. Ideally, you would use SR-IOV devices on a virtualized system,
>>> for example, using Xen. A VF can then be assigned to a guest domain as
>>> a full PCI device.
>>>     
>>
>> It's not clear thats the right solution.  If the VF devices are _only_
>> going to be used by the guest, then arguably, we don't want to create
>> pci_devs for them in the host.  (I think it _is_ the right answer, but I
>> want to make it clear there's multiple opinions on this).
>>   
> 
> The VFs shouldn't be limited to being used by the guest.

Yes, VF driver running in the host is supported :-)

> 
> SR-IOV is actually an incredibly painful thing.  You need to have a VF 
> driver in the guest, do hardware pass through, have a PV driver stub in 
> the guest that's hypervisor specific (a VF is not usable on it's own), 
> have a device specific backend in the VMM, and if you want to do live 
> migration, have another PV driver in the guest that you can do teaming 
> with.  Just a mess.

Actually not so mess. VF driver can be a plain PCI device driver and 
doesn't require any backend in the VMM, or hypervisor specific 
knowledge, if the hardware is properly designed. In this case PF driver 
controls hardware resource allocation for VFs and VF driver can work 
without any communication to PF driver or VMM.

> 
> What we would rather do in KVM, is have the VFs appear in the host as 
> standard network devices.  We would then like to back our existing PV 
> driver to this VF directly bypassing the host networking stack.  A key 
> feature here is being able to fill the VF's receive queue with guest 
> memory instead of host kernel memory so that you can get zero-copy 
> receive traffic.  This will perform just as well as doing passthrough 
> (at least) and avoid all that ugliness of dealing with SR-IOV in the guest.

If the hardware supports both SR-IOV and IOMMU, I wouldn't suggest 
people to do so, because they will get better performance by directly 
assigning VF to the guest.

However, lots of low-end machines don't have SR-IOV and IOMMU support. 
They may have multi queue NIC, which uses built-in L2 switch to dispense 
packets to different DMA queue according to MAC address. They definitely 
can benefit a lot if there is software support for the DMA queue hooking 
virtio-net backend as you suggested.

> 
> This eliminates all of the mess of various drivers in the guest and all 
> the associated baggage of doing hardware passthrough.
> 
> So IMHO, having VFs be usable in the host is absolutely critical because 
> I think it's the only reasonable usage model.

Please don't worry, we have take this usage model as well as container 
model into account when designing SR-IOV framework for the kernel.

> 
> Regards,
> 
> Anthony Liguori
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

