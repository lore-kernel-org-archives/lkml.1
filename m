Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbZFRMVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbZFRMVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZFRMVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:21:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33796 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbZFRMVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:21:22 -0400
Message-ID: <4A3A315A.5090204@redhat.com>
Date: Thu, 18 Jun 2009 15:21:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v7 2/2] KVM: add iosignalfd support
References: <20090616133751.14362.12674.stgit@dev.haskins.net> <20090616134235.14362.64014.stgit@dev.haskins.net> <4A3A28DF.5090803@redhat.com> <4A3A2E90.6090900@novell.com>
In-Reply-To: <4A3A2E90.6090900@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2009 03:09 PM, Gregory Haskins wrote:
>>> +config KVM_MAX_IOSIGNALFD_ITEMS
>>> +    int "Maximum IOSIGNALFD items per address"
>>> +    depends on KVM
>>> +    default "32"
>>> +    ---help---
>>> +      This option influences the maximum number of fd's per PIO/MMIO
>>> +      address that are allowed to register
>>> +
>>>
>>>        
>> Is there a per-vm limit on iosignalfds?  if not, userspace can exhaust
>> kernel memory in that way.
>>      
>
> Yeah, its already naturally limited by the maximum number of MMIO/PIO
> devices we can register (today this is 6 per VM).  I should have
> documented that fact somewhere, tho.
>    

We need to raise this limit drastically and to expose it.  I suggest 
counting an all iosignalfd_items as part of the iodevice limit, so we 
don't have a bunch of little limits which no one understands.

>>> +struct _iosignalfd_item {
>>> +    struct list_head     list;
>>> +    struct file         *file;
>>> +    unsigned char       *match;
>>> +    struct rcu_head      rcu;
>>> +};
>>>
>>>        
>> Why not u64 match?
>>      
>
> Well, tbh it was primarily because it was starting to make my head hurt
> w.r.t. endianness ;).  For instance, if someone wanted a u16 match, I
> would presumably have to understand the relevant endianess of the u64 so
> I compare the appropriate bytes against the data-register coming in from
> the [MM|P]IO.  Using a pointer, I simply copy/memcmp the specified
> number of bytes and never have to worry about endianness.
>    

No, a u16 will naturally expand to a u64, and the emulator will generate 
the correct value.  As long as we don't allow mismatched access sizes, 
we should be fine.

> As a minor bonus, item->match == NULL tells me its a wildcard.  If I had
> item->match as a u64, I'd need a different state flag for "wildcard".
> NBD, but thought I would point it out.
>    

True, a pointer also supplies extra information.  But until we get 
garbage collection as part of the Java rewrite, resource management is a 
pain and I prefer as few pointers as possible.

>>> +static int
>>> +iosignalfd_is_match(struct _iosignalfd_group *group,
>>> +            struct _iosignalfd_item *item,
>>> +            const void *val,
>>> +            int len)
>>> +{
>>> +    if (!item->match)
>>> +        /* wildcard is a hit */
>>> +        return true;
>>> +
>>> +    if (len != group->length)
>>> +        /* mis-matched length is a miss */
>>> +        return false;
>>>
>>>        
>> Should check length before match (i.e. require correctly sized access).
>>      
>
> Perhaps, but my thinking is that group->length only matters for
> data-matching.  You could conceivably have a larger window registered if
> you are using all wildcards.  Not sure if this is really useful, but its
> the reason the code is that way today.
>    

My thinking is to have the code behave the same way.  If you require 
matching lengths on data match, require it on wildcard as well.

-- 
error compiling committee.c: too many arguments to function

