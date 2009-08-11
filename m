Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZHKMtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZHKMtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbZHKMtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:49:05 -0400
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:36797 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbZHKMs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:48:59 -0400
Message-ID: <4A8133ED.6070304@gefanuc.com>
Date: Tue, 11 Aug 2009 10:03:41 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
References: <20090803205657.964064732@mini.kroah.org> <20090803210116.GC28430@kroah.com> <20090808232259.GA29303@braap.org> <20090809121715.GA3884@braap.org> <4A801D04.6050102@gefanuc.com> <20090810152606.GA23319@braap.org> <4A804B0B.5020809@gefanuc.com> <20090810203637.GD3055@braap.org>
In-Reply-To: <20090810203637.GD3055@braap.org>
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
>>> Martyn Welch wrote:
>>> The point here is that the driver should know *nothing* about
>>> windows, etc. What it should just know is:
>>> - I want a mapping of a certain size to VME address X
>>>   
>>>       
>> I'm not convinced. Given that each bridge provides a limited number of  
>> windows (some more than others), we are limited to how large a window we  
>> can produce (we need to map them somewhere) and the potential  
>> combinations are so great (independant 16, 32, 40, 64 and CR/CSR address  
>> spaces, not to mention access modes) it is important to assign the  
>> windows to a driver, so that it may move them as it sees fit. For  
>> example, supporting 10 devices (as you have mentioned earier) with a  
>> single driver could potentially require a single window that it knows it  
>> has exclusive use of to position over each devices register as required  
>> without either having to provide a large window (unfeasibly large on  
>> most/all platforms if they are scattered across the 64-bit address  
>> space) or needing more windows than are available on any of the bridges  
>> I have seen (8 being the maximum).
>>     
>
> No, it corresponds to the bridge to manage *its* resources. Drivers
> would have a very hard time, because they'd need to know their
> own resources but _also_ the use other drivers are making of the
> bridge. And that's madness at its best.
>   

I think you've missed how the current API works - drivers request a 
resource, not a specific window, specifying the attributes they wish the 
window to support, such as "A32 address space", "2eSST transfer mode". 
The VME core looks at the resources it has available and returns a 
resource structure that identifies the underlying resource. The driver 
has no need to know which one it is. If a suitable resource is not 
available, no resource is returned, the underlying hardware is therefore 
incapable of providing the required attributes or all the resources are 
in use.

In terms of knowing "the use other drivers are making of the bridge", if 
to drivers try to create a slave window using the same address space and 
location there is no way, beyond basic checks that windows don't overlap 
and rejecting the second attempt, that anything can be done. The bus 
simply can't support this.

The API I have defined provides basic resource management - may I 
suggest if you want something more complex that allows the user to just 
pick a location/size and not worry about windows at all that you provide 
a patch for this that layers above the basic resource management? This 
would then be of use to anyone that wanted to use it for any underlying 
VME bridge.
>   
>>> The struct provides exactly this.
>>>   
>>>       
>> Ah - vme_dma does to some degree. I was talking about vme_mapping for  
>> configuring vme windows, from your vmebus.h:
>>
>>     
>
> [ was it just me or some lines + links got copied? I've removed them
> anyway ]
>
>   
>> * This data structure is used for describing both a hardware window
>> * and a logical mapping on top of a hardware window. Therefore some of
>> * the fields are only relevant to one of those two entities.
>> */
>> struct vme_mapping {
>>        int     window_num;
>>
>>     
>
> [ snip ]
>   
>>        enum vme_read_prefetch_size     read_prefetch_size;
>> Tsi-148 specific.
>>     
>
> If others don't implement it, it's ok; however you need to
> cover all the cases, so it's needed here.
>
> [ snip ]
>   
>>        int                             bcast_select;
>>        unsigned int                    pci_addru;
>>        unsigned int                    pci_addrl;
>>
>> Why are these split, why not a single unsigned long long?
>>        unsigned int                    sizeu;
>>        unsigned int                    sizel;
>> Ditto.
>>        unsigned int                    vme_addru;
>>        unsigned int                    vme_addrl;
>> Ditto.
>>     
>
> - Most accesses are 32-bit accesses. Treating all of them
>   as 64-bit accesses would decrease performance for most of
>   them--which happen to be 32-bit.
>
>   
I'm not - I'm storing them as 64-bit values, which they are, in the 
structures used in *software*. These are then split *when* a write to 
the hardware registers is required. Similarly, when the registers are 
occasionally read they are combined and stored as a 64-bit value. This 
simplifies all *software* checking and manipulation. By storing these as 
2 32-bit values every driver that uses the VME core will need to convert 
pci addresses, vme addresses and counts to 2 32-bit values. That is madness.
>> In addition your enum vme_address_modifier would need extending when  
>> specifying slave windows, the tsi-148 can support windows with USER and  
>> SUP access, as well as DATA and PRG. Why throw access privileges and  
>> address spaces together like that? The VME spec also specifies 4 User  
>> definable  address spaces...
>>     
>
> Well Sebastien worked on this for less than two months, and to be
> honest with you the result is much better than the original code
> we had from Motorola--which is the one you based your work on,
> I think.
>   
So that's where the 2 32-bit values come from. That was an artifact of 
the Motorola driver mapping the structure over the registers. I'm 
surprised you kept that, it was practically the first thing I corrected.
> So yes, the whole spec is not there, but
> - If no one uses something, there's no point in implementing it--
>   irrespective of being written on a spec or not.
> - Sebastien did a bloody good job, but obviously he focused on
>   our urgent matters, i.e. with the Motorola driver we couldn't
>   go on production with our machines.
>
>   
Right - but I've taken a higher level view of what a VME API should 
provide, with the aim of providing an API that will support the features 
described in the VME specifications for more than one chip set, rather 
than targeting just those features that I need right now. I have 
provided a VME core to enable common checking routines and functionality 
to be provided to all VME bridge drivers without duplication. I too feel 
that I have done a good job and, whilst I am not going to make claims 
about it's readiness for production machines at this stage, feel that 
the tsi-148 driver that I have adapted/written is quite robust.
>> I'm still not convinced by all these structures - you've defined tonnes  
>> of them, I don't feel that it aids readability and maintainability at 
>> all.
>>     
> Tons of them? Seriously?
>
> t61$ /data/src/linux-next/include/linux ->cat pci*.h | egrep '^struct' | wc -l
> 41
> t61$ /data/src/linux-next/include/linux ->cat vme*.h | egrep '^struct' | wc -l
> 6
>
> I would call that pretty sane as a starting point.
>
> [ NB. this is my current dev tree, vme.h is just 'our' vmebus.h
>   Lynx's compatility crap removed ]
>
>   
>> It's all over the web :-) We've had it for years and I'm not sure under  
>> what terms we originally got it, so I'm afraid I've got to assume we're  
>> still bound under some NDA, sorry. Searching google for "Universe II  
>> Manual" much get you what you want though...
>>     
>
> o rite, no probs.
>
> Thanks,
> E.
>   


-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
