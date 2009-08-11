Return-Path: <linux-kernel-owner+w=401wt.eu-S1751324AbZHKMOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbZHKMOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZHKMOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:14:34 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:53785 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZHKMOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:14:33 -0400
Message-ID: <4A812BCE.3010003@gefanuc.com>
Date: Tue, 11 Aug 2009 09:29:02 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org> <4A804283.5090009@gefanuc.com> <20090810193849.GA3055@braap.org>
In-Reply-To: <20090810193849.GA3055@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Martyn Welch wrote:
>   
>> That's one reason for the helper function. If VME bridges are added  
>> which sit of on other buses then vme_alloc_consistent can be extended to  
>> support this without requiring VME device drivers to be altered to  
>> reflect the fact that pci_alloc_consistent might not work for all VME  
>> bridges.
>>     
>
> But it corresponds to the bridge's code (not to the generic layer) to
> know whether the bridge sits on top of PCI or not; hence my comment.
>
>   
>> The DMA controller in the tsi-148 can do PCI to PCI; PCI to VME; VME to  
>> PCI; VME to VME; Patterns to  VME and Patterns to PCI transfers. How do  
>> you specify all those options without providing a structure where over  
>> 50% of the fields aren't used for any given transfer?
>>     
>
> I think a struct where not _every_ field is *always* used is fine.
> However requiring your drivers to know about what your bridge
> looks like is a mistake; just give them something thin that doesn't
> assume anything about what's behind it, and if it's not supported,
> return an appropriate error message.
>   

That's what the API does - how does it require the driver writer to know 
about what the bridge look like. All that it requires is the the 
hardware supports the transfer mode that the driver requests, however 
that's always going to be an issue with multiple devices with different 
properties.

>> Every bridge I have seen is capable of link-list execution. The API  
>> provides the ability to do scatter-gather style DMA transfers, this  
>> could be used as part of a "zero-copy" type driver for high speed VME  
>> capture devices. How would you support the link-list execution with a  
>> single call?
>>     
>
> Let me say it again: "Drivers should know *nothing* about the
> underlying bridge".
> They should work with *any* bridge; or do we care about the PCI
> bridge we're plug our PCI device on when writing a driver for it?
>
>   

Again: what part of the API I have defined forces the driver to know 
about the underlying bridge?

>> I was also looking at the ability to queue DMA transfers if the  
>> controller was currently busy - if the consensus is that this is  
>> overkill I will happily remove this.
>>     
>
> AFAICT the tsi148 has several DMA channels; in our driver we just
> try to find a free channel to proceed with the transfer; if there
> aren't any then we return EBUSY.
>   

Where as I request a DMA channel - a resource is returned, the driver 
does not need to know which one, he has the resource structure which 
refers to it. It treats the DMA engines as a resource, just as it treats 
the windows, both master and slave as resources.

> Drawing an analogy with current 'streaming DMA' transfers, we're
> told we should check whether they failed or not, so I think
> trying to be too clever here it's not worth it.
>
>   
Yes - my driver checks to see of the transfer has succeeded, I don't see 
quite what this has to do with the API. How's the API being clever?
>> I implemented it using param array, I agree that the arguments might get
>> quite long with 10 devices, especially if multiple parameters are
>> required, but I don't see why it shouldn't work.
>>     
>
> The fact that 'it works' doesn't make it less ugly or messy.
> When referring to code, these two words usually mean "there's
> a better way"; so let's just find it.
>
> E.
>   
If there's a better way to do this then fine - I'm happy to use it, 
however I'm not quite sure how this relates to the API, core VME code or 
low-level drivers. I think it's up to the authors of the VME device 
drivers themselves how they approach this. The API uses the standard 
bind-table approach as best as I could. If you can think of a better 
approach to this, patches will be welcome.

Martyn

-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
