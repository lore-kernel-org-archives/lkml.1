Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbZEFN4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbZEFN4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbZEFN4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:56:43 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:3915 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbZEFN4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:56:42 -0400
Message-ID: <4A019717.7070806@codemonkey.ws>
Date: Wed, 06 May 2009 08:56:39 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com>
In-Reply-To: <4A010927.6020207@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Chris Wright wrote:
>   
>> * Gregory Haskins (gregory.haskins@gmail.com) wrote:
>>   
>>     
>>> So you would never have someone making a generic
>>> hypercall(KVM_HC_MMU_OP).  I agree.
>>>     
>>>       
>> Which is why I think the interface proposal you've made is wrong.
>>     
>
> I respectfully disagree.  Its only wrong in that the name chosen for the
> interface was perhaps too broad/vague.  I still believe the concept is
> sound, and the general layering is appropriate. 
>
>   
>>   There's
>> already hypercall interfaces w/ specific ABI and semantic meaning (which
>> are typically called directly/indirectly from an existing pv op hook).
>>   
>>     
>
> Yes, these are different, thus the new interface.
>
>   
>> But a free-form hypercall(unsigned long nr, unsigned long *args, size_t count)
>> means hypercall number and arg list must be the same in order for code
>> to call hypercall() in a hypervisor agnostic way.
>>   
>>     
>
> Yes, and that is exactly the intention.  I think its perhaps the point
> you are missing.
>
> I am well aware that historically the things we do over a hypercall
> interface would inherently have meaning only to a specific hypervisor
> (e.g. KVM_HC_MMU_OPS (vector 2) via kvm_hypercall()).  However, this
> doesn't in any way infer that it is the only use for the general
> concept.  Its just the only way they have been exploited to date.
>
> While I acknowledge that the hypervisor certainly must be coordinated
> with their use, in their essence hypercalls are just another form of IO
> joining the ranks of things like MMIO and PIO.  This is an attempt to
> bring them out of the bowels of CONFIG_PARAVIRT to make them a first
> class citizen. 
>
> The thing I am building here is really not a general hypercall in the
> broad sense.  Rather, its a subset of the hypercall vector namespace. 
> It is designed specifically for dynamic binding a synchronous call()
> interface to things like virtual devices, and it is therefore these
> virtual device models that define the particular ABI within that
> namespace.  Thus the ABI in question is explicitly independent of the
> underlying hypervisor.  I therefore stand by the proposed design to have
> this interface described above the hypervisor support layer (i.e.
> pv_ops) (albeit with perhaps a better name like "dynamic hypercall" as
> per my later discussion with Avi).
>
> Consider PIO: The hypervisor (or hardware) and OS negotiate a port
> address, but the two end-points are the driver and the device-model (or
> real device).  The driver doesnt have to say:
>
> if (kvm)
>    kvm_iowrite32(addr, ..);
> else if (lguest)
>    lguest_iowrite32(addr, ...);
> else
>    native_iowrite32(addr, ...);
>
> Instead, it just says "iowrite32(addr, ...);" and the address is used to
> route the message appropriately by the platform.  The ABI of that
> message, however, is specific to the driver/device and is not
> interpreted by kvm/lguest/native-hw infrastructure on the way.
>
> Today, there is no equivelent of a platform agnostic "iowrite32()" for
> hypercalls so the driver would look like the pseudocode above except
> substitute with kvm_hypercall(), lguest_hypercall(), etc.  The proposal
> is to allow the hypervisor to assign a dynamic vector to resources in
> the backend and convey this vector to the guest (such as in PCI
> config-space as mentioned in my example use-case).  The provides the
> "address negotiation" function that would normally be done for something
> like a pio port-address.   The hypervisor agnostic driver can then use
> this globally recognized address-token coupled with other device-private
> ABI parameters to communicate with the device.  This can all occur
> without the core hypervisor needing to understand the details beyond the
> addressing.
>   

PCI already provide a hypervisor agnostic interface (via IO regions).  
You have a mechanism for devices to discover which regions they have 
allocated and to request remappings.  It's supported by Linux and 
Windows.  It works on the vast majority of architectures out there today.

Why reinvent the wheel?

Regards,

Anthony Liguori
