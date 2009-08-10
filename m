Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZHJPw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZHJPw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZHJPw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:52:57 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:54205 "EHLO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbZHJPw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:52:56 -0400
Message-ID: <4A804283.5090009@gefanuc.com>
Date: Mon, 10 Aug 2009 16:53:39 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org>
In-Reply-To: <20090810141442.GA18456@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Martyn Welch wrote:
>   
>> Emilio G. Cota wrote:
>>     
>>> - semaphores? isn't it screaming for mutexes?
>>>       
>> The semaphores are initialized in mutex mode.
>>     
>
> I know, but then please use mutexes.
>
>   
I'm clearly missing something here - can you provide me with an example?
>>> - some function signatures (get_whatever) pass too many
>>>   pointers; it's rather ugly. Passing a pointer to an
>>>   appropriate struct seems a better solution.
>>>   
>>>       
>> When implementing these functions it seemed like a simpler option to  
>> pass the parameters rather than defining yet another structure and using  
>> it for a single call. If the *_get functions are changed then the *_set  
>> functions should also be changed for consistency. I'm not overly  
>> bothered either way - if the consensus is that a structure would be  
>> better then we can go with a structure.
>>     
>
> Yeh, In my opinion a structure there would be prettier. However
> let's put this off a bit, I'm currently re-working this a bit.
>
>   
>>> - vme_alloc_consistent looks pretty fishy; why don't you pass
>>>   that responsibility to the specific master? There you obviously
>>>   know if you're bridging over PCI or whatever. Or even better;
>>>   why is this needed at all?
>>>   
>>>       
>> In the model I have chosen it is up to the VME device driver to create  
>> buffers rather than the VME bridge drivers. After all it is the device  
>> drivers for the specific hardware found on the VME bus that knows what  
>> it is going to do with these buffers. This method is provided as a  
>> helper. It ensures that a VME device driver (not to be confused with the  
>> VME bridge driver) is able to allocate a buffer suitable for utilizing  
>> the DMA engines found in the bridge or indeed to be mapped onto VME  
>> though a slave window without explicitly knowing which VME bridge is  
>> being used.
>>     
>
> hmm I see. The way you provide coherent DMA mappings for VME is through
> providing coherent (consistent) mappings for PCI, and then mapping the
> VME space onto those. I haven't tested if this works, but sounds
> reasonable.
>   
>> Master windows don't require a contiguous buffer, are you referring to  
>> something else when you say master?
>>     
> I was thinking of the hypothetical case where you'd have a bridge not
> over PCI; but anyway since quite a few things seem tied to PCI this
> is fine.
>   

That's one reason for the helper function. If VME bridges are added 
which sit of on other buses then vme_alloc_consistent can be extended to 
support this without requiring VME device drivers to be altered to 
reflect the fact that pci_alloc_consistent might not work for all VME 
bridges.

>>> - Please explain me what all the DMA functions do; are they
>>>   meant to be used by master or slaves?
>>>   
>>>       
>> The TODO file (drivers/staging/vme/TODO) contains a description of the  
>> current API including the DMA functions, does that provide enough of a  
>> description?
>>     
>
> I've had a closer look; it seems to me that most of it is unnecessary;
> there's no show those lists to a driver. I'd just provide a single
> 'do_dma(attributes)' call that sleeps until it's done (or similar).
>
>   
The DMA controller in the tsi-148 can do PCI to PCI; PCI to VME; VME to 
PCI; VME to VME; Patterns to  VME and Patterns to PCI transfers. How do 
you specify all those options without providing a structure where over 
50% of the fields aren't used for any given transfer?

Every bridge I have seen is capable of link-list execution. The API 
provides the ability to do scatter-gather style DMA transfers, this 
could be used as part of a "zero-copy" type driver for high speed VME 
capture devices. How would you support the link-list execution with a 
single call?

I was also looking at the ability to queue DMA transfers if the 
controller was currently busy - if the consensus is that this is 
overkill I will happily remove this.

>>> Have a look at the interface for slaves we've got for our tsi148
>>> driver, available at:
>>> http://repo.or.cz/w/tsi148vmebridge.git
>>>
>>> /* API for new drivers */
>>> extern int vme_request_irq(unsigned int, int (*)(void *),
>>>                            void *, const char *);
>>>       
> [snip]
>   
>>> extern int vme_bus_error_check(int);
>>>
>>> That's pretty thin and it covers our slaves' needs. Do you see
>>> anything missing there?
>>>   
>>>       
>> This interface, especially struct vme_mapping seems to have been written  
>> solely for the tsi-148 bridge. The API I have defined aims to provide a  
>> consistent API across multiple VME bridges. Whilst this API clearly  
>> works for you with the tsi-148 I am unsure how suitable it will be for  
>> other bridge chips.
>>
>> The API I have proposed is designed to support more than just the tsi148  
>> chipset. Have you thought about how the above API will be supported on  
>> other VME bridges?
>>     
>
> We only have access to tsi148 chips. Since apparently there aren't
> many bridges around, I think is saner to just provide an interface
> that works well with the devices we have access to (i.e. tsi148 and
> Tundra Universe in your case), and when new chips come along, we simply
> modify the interface as needed. Of course this doesn't mean we shouldn't
> try to make it generic, but within reason.
>
>   
Agreed - which I believe is the approach I've taken.
>>> For masters there's no interface there because it was the
>>> master's driver who directly provided these calls to slaves.
>>> I had it in my to-do list to split that from the tsi148, in
>>> the same fashion as you've done with this work.
>>>
>>> - Note above the interrupt handler; simply needs the cookie. Also,
>>>   shouldn't your vme_request_irq() just require the IRQ vector?
>>>   
>>>       
>> No. I believe that you are using the term IRQ vector where we would use  
>> the term status ID, the value which is returned from an IACK cycle. Your  
>> interrupt handling code assigns a single interrupt handler to all  
>> interrupt levels, purely using the interrupt vector/status ID to  
>> determine which interrupt handler will be used. This adds an artificial  
>> limitation and would not work in some instances that we have seen. Our  
>> framework provides the ability to attach an interrupt handler to each  
>> combination of IRQ level and Status ID/vector.
>>     
> Fair enough. For sanity we tend not to share IRQ vectors among
> different modules, but yes, the interface should know about this.
>
>   
>>> - I'd like to see the whole picture, or 'vertical slice', i.e.
>>>   the bus interface + a master + a slave driver. How would
>>>   the slave's driver get the addresses and sizes of the mappings,
>>>   interrupt lines, etc. for each of the devices it controls?
>>>   For the time being we quickly hacked an xml-based scheme to get
>>>   this info upon installation, but it's clearly not suitable
>>>   for mainline.
>>>   
>>>       
>> I have written a test driver for a very old slave card we had lying  
>> around. In that case we used module parameters to determine the location  
>> of the device on the bus (it used a fixed VME address space). In this  
>> instance the interrupt level and ID could be configured in the registers  
>> available in the VME address space, hence I added module parameters to  
>> allow these to be configured. In this respect configuration of VME  
>> devices is very similar to ISA devices - neither of the buses has  
>> supported discovery mechanism from the outset and thus old cards. I  
>> therefore implemented a mechanism similar to how I believe ISA  
>> approaches this.
>>
>> The framework that I have proposed aims to provide a consistent API to  
>> manage allowing the resources provided by the VME bridges to be managed  
>> in as a consistent a manner as possible. I believe it is up to the  
>> device drivers for the devices found on the VME bus to determine the  
>> best way to configure this as it is not provided by the VME 
>> specifications.
>>     
>
> The problem is how to manage several (say 10) devices that have to be
> controlled with the same driver; passing parameters upon loading the
> driver's module doesn't seem to scale beyond one device..
I implemented it using param array, I agree that the arguments might get quite long with 10 devices, especially if multiple parameters are required, but I don't see why it shouldn't work.

> At the moment I see no clean way of doing this; right now we're doing
> it through an IOCTL, copying from user-space a tree that describes the
> devices to install, namely mappings and IRQs for each of them.
>
> Greg, any ideas on how to deal with this?
>
>   
>> For using the VME bus for communication between two SBCs, I think we  
>> could use the CRCSR space to provide some information about the  
>> resources used on each board for say, a virtual network driver like the  
>> rapidIO subsystem provides. Possibly using the "device tree" stuff used  
>> on PowerPC, Blackfin and Sparc archs (I believe) for passing device  
>> layout between the firmware and kernel at boot.
>>     
>
> hmm I don't see how we could implement this common consistent view of
> the bus in a way that could work with every bridge. For the time
> being I'd defer this and simply pass that responsibility to user-space.
>
>   
That's the conclusion I sort of came to. I guess how the VME address 
space(s) are used is a system integration issue.
>> Sure, np,
>>
>> Martyn
>>     
>
> Thanks,
> E.
>   


-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
