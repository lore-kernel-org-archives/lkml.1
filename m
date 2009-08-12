Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZHLIQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZHLIQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbZHLIQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:16:45 -0400
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:44654 "EHLO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbZHLIQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:16:43 -0400
Message-ID: <4A827A84.3060906@gefanuc.com>
Date: Wed, 12 Aug 2009 09:17:08 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 2/5] Staging: vme: add VME userspace driver
References: <20090803210116.GC28430@kroah.com> <20090808232259.GA29303@braap.org> <20090809121715.GA3884@braap.org> <4A801D04.6050102@gefanuc.com> <20090810152606.GA23319@braap.org> <4A804B0B.5020809@gefanuc.com> <20090810203637.GD3055@braap.org> <4A8133ED.6070304@gefanuc.com> <20090811094025.GC3251@braap.org> <4A81683D.2030408@gefanuc.com> <20090811210146.GB9910@braap.org>
In-Reply-To: <20090811210146.GB9910@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Martyn Welch wrote:
>   
>> I disagree. The bridge drivers should register their resources with the  
>> core. The core, or a layer above it, can control how those resources are  
>> used. This moves the complexity you want for managing the windows to a  
>> level that will work on all underlying drivers rather than having to be  
>> written explicitly for each one. The mechanism I have provided does this  
>> discovery.
>>     
>
> nah, it would be foolish to think we can write an upper layer
> that covers every corner case for every bridge we're gonna
> encounter. 
So it's foolish to have a generic USB layer, or a generic PCI layer or 
generic "name you bus here" layer?

Unless you provide a consistent API, such as one supporting the features 
documented in the VME specifications, how are you planning to write 
drivers that could potentially work on more than one specific bridge?

> For instance, imagine a bridge that has 10 windows,
> with the annoying feature that window#10 *only* accepts CS/CSR
> mappings. How stupid is that? Very stupid. But what would be
> more stupid is to write allegedly 'generic' interfaces that
> break every time a bridge comes up with a stupid feature.
>   

Actually, the VME core as it exists would support such a situation. The 
10th window would only register as being capable of supporting that 
address space. What about a driver only needed to access CR/CSR space 
(to see what was available on other hosts for example), then utilized a 
DMA controller to transfer data over the VME bus  (thereby not requiring 
a master or slave window). It could request a window that fitted it's 
needs ("vme_address_t aspace = VMECRCST;") and the core would be able to 
hand it that resource. Should the underlying bridge not have such a 
limited window, it can had it one with a larger feature set, ensuring 
that it meets the requirements as requested by the driver.

> So that doesn't belong to a generic interface. Now, to avoid
> code duplication between two (or more) _very_ similar bridges,
> we just share the 'resource management' code among those,
> privately. And that's pretty much it.
>   

Or it could be layered on top, utilising the the resource management 
that I have proposed and the two can sit together happily side-by-side. 
If you are right and that method of access works best, then drivers will 
use that rather than requesting resources. If not then the two can 
continue to sit side-by-side. Why make the bridge drivers more complex 
than they need to be?

Also, it seems that your API doesn't currently support Location 
Monitors. These are specified in the VME spec, I'd be interested in how 
you plan to support this feature in a consistent manner with your 
current API. These can only be used in a single location at a time and 
cover a fixed number of addresses from the initial offset. The location 
monitors are treated as a resource in my VME core which is consistent 
with the windows being treated as resources.

Come to think of it, I can't see any code managing slave windows either 
- how is your API going to consistently manage these?

Martyn

> Regards,
> E.
>   


-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
