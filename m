Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZJFQY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZJFQY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbZJFQY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:24:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756121AbZJFQY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:24:27 -0400
Message-ID: <4ACB6F0E.4000407@redhat.com>
Date: Tue, 06 Oct 2009 18:23:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: introduce "xinterface" API for external	interaction
 with guests
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <4AC8780D.1060800@redhat.com> <4ACA87D7.1080206@gmail.com> <4ACB0F3C.1000705@redhat.com> <4ACB46AD.8010405@gmail.com> <4ACB528D.6030408@gmail.com>
In-Reply-To: <4ACB528D.6030408@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2009 04:22 PM, Gregory Haskins wrote:
>>>>>> +
>>>>>> +static inline void
>>>>>> +_kvm_xinterface_release(struct kref *kref)
>>>>>> +{
>>>>>> +    struct kvm_xinterface *intf;
>>>>>> +    struct module *owner;
>>>>>> +
>>>>>> +    intf = container_of(kref, struct kvm_xinterface, kref);
>>>>>> +
>>>>>> +    owner = intf->owner;
>>>>>> +    rmb();
>>>>>>
>>>>>>
>>>>>>              
>>>>> Why rmb?
>>>>>
>>>>>            
>>>> the intf->ops->release() line may invalidate the intf pointer, so we
>>>> want to ensure that the read completes before the release() is called.
>>>>
>>>> TBH: I'm not 100% its needed, but I was being conservative.
>>>>
>>>>          
>>> rmb()s are only needed if an external agent can issue writes, otherwise
>>> you'd need one after every statement.
>>>        
>> I was following lessons learned here:
>>
>> http://lkml.org/lkml/2009/7/7/175
>>
>> Perhaps mb() or barrier() are more appropriate than rmb()?  I'm CC'ing
>> David Howells in case he has more insight.
>>      
> BTW: In case it is not clear, the rationale as I understand it is we
> worry about the case where one cpu reorders the read to be after the
> ->release(), and another cpu might grab the memory that was kfree()'d
> within the ->release() and scribble something else on it before the read
> completes.
>
> I know rmb() typically needs to be paired with wmb() to be correct, so
> you are probably right to say that the rmb() itself is not appropriate.
>   This problem in general makes my head hurt, which is why I said I am
> not 100% sure of what is required.  As David mentions, perhaps
> "smp_mb()" is more appropriate for this application.  I also speculate
> barrier() may be all that we need.
>    

barrier() is the operation for a compiler barrier.  But it's unneeded 
here - unless the compiler can prove that ->release(intf) will not 
modify intf->owner it is not allowed to move the access afterwards.  An 
indirect function call is generally a barrier() since the compiler can't 
assume memory has not been modified.

-- 
error compiling committee.c: too many arguments to function

