Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbZEKRza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbZEKRza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZEKRzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:55:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52006 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbZEKRzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:55:12 -0400
Message-ID: <4A08661C.1000208@redhat.com>
Date: Mon, 11 May 2009 20:53:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Hollis Blanchard <hollisb@us.ibm.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Gregory Haskins <ghaskins@novell.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net>	 <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com>	 <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com>	 <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com>	 <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com>	 <4A02D40D.7060307@redhat.com> <4A0448DF.90705@codemonkey.ws>	 <4A0570B1.30401@novell.com> <4A071F1A.1090702@codemonkey.ws>	 <4A0824C2.4000109@gmail.com> <1242059712.29194.12.camel@slate.austin.ibm.com> <4A085B06.4080803@redhat.com> <4A086065.2090600@gmail.com>
In-Reply-To: <4A086065.2090600@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Avi Kivity wrote:
>   
>> Hollis Blanchard wrote:
>>     
>>> I haven't been following this conversation at all. With that in mind...
>>>
>>> AFAICS, a hypercall is clearly the higher-performing option, since you
>>> don't need the additional memory load (which could even cause a page
>>> fault in some circumstances) and instruction decode. That said, I'm
>>> willing to agree that this overhead is probably negligible compared to
>>> the IOp itself... Ahmdal's Law again.
>>>   
>>>       
>> It's a question of cost vs. benefit.  It's clear the benefit is low
>> (but that doesn't mean it's not worth having).  The cost initially
>> appeared to be very low, until the nested virtualization wrench was
>> thrown into the works.  Not that nested virtualization is a reality --
>> even on svm where it is implemented it is not yet production quality
>> and is disabled by default.
>>
>> Now nested virtualization is beginning to look interesting, with
>> Windows 7's XP mode requiring virtualization extensions.  Desktop
>> virtualization is also something likely to use device assignment
>> (though you probably won't assign a virtio device to the XP instance
>> inside Windows 7).
>>
>> Maybe we should revisit the mmio hypercall idea again, it might be
>> workable if we find a way to let the guest know if it should use the
>> hypercall or not for a given memory range.
>>
>> mmio hypercall is nice because
>> - it falls back nicely to pure mmio
>> - it optimizes an existing slow path, not just new device models
>> - it has preexisting semantics, so we have less ABI to screw up
>> - for nested virtualization + device assignment, we can drop it and
>> get a nice speed win (or rather, less speed loss)
>>
>>     
> Yeah, I agree with all this.  I am still wrestling with how to deal with
> the device-assignment problem w.r.t. shunting io requests into a
> hypercall vs letting them PF.  Are you saying we could simply ignore
> this case by disabling "MMIOoHC" when assignment is enabled?  That would
> certainly make the problem much easier to solve.
>   

No, we need to deal with hotplug.  Something like IO_COND that Chris 
mentioned, but how to avoid turning this into a doctoral thesis.

(On the other hand, device assignment requires the iommu, and I think 
you have to specify that up front?)

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

