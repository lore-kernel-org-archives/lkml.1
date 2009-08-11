Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbZHKMq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbZHKMq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZHKMqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:46:14 -0400
Received: from exprod5og110.obsmtp.com ([64.18.0.20]:45202 "EHLO
	exprod5og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZHKMqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:46:12 -0400
Message-ID: <4A81683D.2030408@gefanuc.com>
Date: Tue, 11 Aug 2009 13:46:53 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
References: <20090803205657.964064732@mini.kroah.org> <20090803210116.GC28430@kroah.com> <20090808232259.GA29303@braap.org> <20090809121715.GA3884@braap.org> <4A801D04.6050102@gefanuc.com> <20090810152606.GA23319@braap.org> <4A804B0B.5020809@gefanuc.com> <20090810203637.GD3055@braap.org> <4A8133ED.6070304@gefanuc.com> <20090811094025.GC3251@braap.org>
In-Reply-To: <20090811094025.GC3251@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Martyn Welch wrote:
>   
>> suggest if you want something more complex that allows the user to just  
>> pick a location/size and not worry about windows at all
>>     
>
> That's exactly the whole point. I think each bridge should manage
> its resources; putting this on the upper layer would mean the
> layer should have a mechanism of 'discovering' what the bridge
> can/can't do. Anyway this could be revisited later.
> I'm preparing a patch for this.
>   

I disagree. The bridge drivers should register their resources with the 
core. The core, or a layer above it, can control how those resources are 
used. This moves the complexity you want for managing the windows to a 
level that will work on all underlying drivers rather than having to be 
written explicitly for each one. The mechanism I have provided does this 
discovery.
>   
>>> - Most accesses are 32-bit accesses. Treating all of them
>>>   as 64-bit accesses would decrease performance for most of
>>>   them--which happen to be 32-bit.
>>>       
>> I'm not - I'm storing them as 64-bit values, which they are, in the  
>> structures used in *software*. These are then split *when* a write to  
>> the hardware registers is required. Similarly, when the registers are  
>> occasionally read they are combined and stored as a 64-bit value. This  
>> simplifies all *software* checking and manipulation. By storing these as  
>> 2 32-bit values every driver that uses the VME core will need to convert  
>> pci addresses, vme addresses and counts to 2 32-bit values. That is 
>> madness.
>>     
>
> I agree with you on that's painful for doing 64-bit accesses.
> However I'm still not convinced on the performance side (I mean
> software), since most of the time the upper 32bits will be empty.
> Will have a look though.
>
>   
Regardless of the contents of the upper 32 bits, they will need to be 
checked. For example when ensuring a window offset and size fit within a 
given address space. To do this the bound needs to be  calculated.

To do this with 2 32-bit values. add the lower window offset and size, 
which could lead to an over-flow of the lower 32-bit value, which needs 
to be added to the upper 32-bit value, which is the sum of the upper 
window offset and size. Then potentially check both the upper and lower 
values (thinking of 16-bit address range here) to ensure they are below 
the maximum address for the address range.

Compared to an addition of the window offset and size and a comparison 
to the maximum address for the address range when using one 64-bit value.

Clearly neither of the above basic outlines check that the combination 
has wrapped over 64 bits, but this would affect both equally.

So, which is more complex?

Martyn
> Cheers,
> E.
>   


-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
