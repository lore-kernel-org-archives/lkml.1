Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZFUNyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZFUNyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 09:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZFUNyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 09:54:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40874 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZFUNyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 09:54:37 -0400
Message-ID: <4A3E3BC7.8040707@redhat.com>
Date: Sun, 21 Jun 2009 16:55:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v7 2/2] KVM: add iosignalfd support
References: <20090616133751.14362.12674.stgit@dev.haskins.net> <20090616134235.14362.64014.stgit@dev.haskins.net> <4A3A28DF.5090803@redhat.com> <4A3A2E90.6090900@novell.com> <4A3A315A.5090204@redhat.com> <4A3A4A7D.8050406@novell.com>
In-Reply-To: <4A3A4A7D.8050406@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2009 05:09 PM, Gregory Haskins wrote:
> Avi Kivity wrote:
>    
>> On 06/18/2009 03:09 PM, Gregory Haskins wrote:
>>      
>>>>> +config KVM_MAX_IOSIGNALFD_ITEMS
>>>>> +    int "Maximum IOSIGNALFD items per address"
>>>>> +    depends on KVM
>>>>> +    default "32"
>>>>> +    ---help---
>>>>> +      This option influences the maximum number of fd's per PIO/MMIO
>>>>> +      address that are allowed to register
>>>>> +
>>>>>
>>>>>
>>>>>            
>>>> Is there a per-vm limit on iosignalfds?  if not, userspace can exhaust
>>>> kernel memory in that way.
>>>>
>>>>          
>>> Yeah, its already naturally limited by the maximum number of MMIO/PIO
>>> devices we can register (today this is 6 per VM).  I should have
>>> documented that fact somewhere, tho.
>>>
>>>        
>> We need to raise this limit drastically and to expose it.
>>      
>
> Any suggestions on a target #?  512?
>    

Let's say 20 devices with 16 queues each.  That gives 320 fds.  So 512 
seems like a good choice for now.

But don't make it Kconfigurable, there's no way the user will know what 
to put there.
>> No, a u16 will naturally expand to a u64, and the emulator will
>> generate the correct value.
>>      
>
> Right, I understand that part.  What I mean specifically is at run-time
> when the IO comes in.  I was thinking I would need to do a memcmp
> against the u64 and the data-register and it was hurting my head trying
> to figure out what pointer to pass to memcmp.
>
> <lightbulb turns on>
>
> Duh, I can just load the data-register into a u64 and check equality.
> Nevermind, I am a dumbass ;)
>    

I see on your v8 what the load means.  It's not so pretty.  But we can 
have generic code do the load and pass a u64 instead of a pointer.

But please, only after this goes in.

-- 
error compiling committee.c: too many arguments to function

