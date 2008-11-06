Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYKFWjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYKFWjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYKFWis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:38:48 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:12230 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYKFWir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:38:47 -0500
Message-ID: <491371F0.7020805@codemonkey.ws>
Date: Thu, 06 Nov 2008 16:38:40 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
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
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net> <20081106183630.GD11773@parisc-linux.org>
In-Reply-To: <20081106183630.GD11773@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> [Anna, can you fix your word-wrapping please?  Your lines appear to be
> infinitely long which is most unpleasant to reply to]
>
> On Thu, Nov 06, 2008 at 05:38:16PM +0000, Fischer, Anna wrote:
>   
>>> Where would the VF drivers have to be associated?  On the "pci_dev"
>>> level or on a higher one?
>>>       
>> A VF appears to the Linux OS as a standard (full, additional) PCI
>> device. The driver is associated in the same way as for a normal PCI
>> device. Ideally, you would use SR-IOV devices on a virtualized system,
>> for example, using Xen. A VF can then be assigned to a guest domain as
>> a full PCI device.
>>     
>
> It's not clear thats the right solution.  If the VF devices are _only_
> going to be used by the guest, then arguably, we don't want to create
> pci_devs for them in the host.  (I think it _is_ the right answer, but I
> want to make it clear there's multiple opinions on this).
>   

The VFs shouldn't be limited to being used by the guest.

SR-IOV is actually an incredibly painful thing.  You need to have a VF 
driver in the guest, do hardware pass through, have a PV driver stub in 
the guest that's hypervisor specific (a VF is not usable on it's own), 
have a device specific backend in the VMM, and if you want to do live 
migration, have another PV driver in the guest that you can do teaming 
with.  Just a mess.

What we would rather do in KVM, is have the VFs appear in the host as 
standard network devices.  We would then like to back our existing PV 
driver to this VF directly bypassing the host networking stack.  A key 
feature here is being able to fill the VF's receive queue with guest 
memory instead of host kernel memory so that you can get zero-copy 
receive traffic.  This will perform just as well as doing passthrough 
(at least) and avoid all that ugliness of dealing with SR-IOV in the guest.

This eliminates all of the mess of various drivers in the guest and all 
the associated baggage of doing hardware passthrough.

So IMHO, having VFs be usable in the host is absolutely critical because 
I think it's the only reasonable usage model.

Regards,

Anthony Liguori
