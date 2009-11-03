Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbZKCHkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbZKCHkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbZKCHkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:40:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbZKCHki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:40:38 -0500
Message-ID: <4AEFDE78.5030507@redhat.com>
Date: Tue, 03 Nov 2009 09:40:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] Add shared memory hypercall to PV Linux guest.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-2-git-send-email-gleb@redhat.com> <4AEECE2E.2050609@redhat.com> <20091102161809.GG27911@redhat.com> <4AEFBC5E.7020300@redhat.com> <20091103071638.GK27911@redhat.com>
In-Reply-To: <20091103071638.GK27911@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2009 09:16 AM, Gleb Natapov wrote:
>>>
>>> I have both! Do you want me to drop version?
>>>        
>> Yes.  Once a kernel is released you can't realistically change the version.
>>
>>      
> Why not? If version doesn't match apf will not be used.
>    

Then you cause a large performance regression (assuming apf is any 
good).  So there will be a lot of pressure to modify things 
incrementally via feature bits.

>    
>>>> Some documentation for this?
>>>>
>>>> Also, the name should reflect the pv pagefault use.  For other uses
>>>> we can register other areas.
>>>>
>>>>          
>>> I wanted it to be generic, but I am fine with making it apf specific.
>>> It will allow to make it smaller too.
>>>        
>> Maybe we can squeeze it into the page-fault error code?
>>
>>      
> apf has to pass two things into a guest kernel:
>   - event type (page not present/wake up)
>   - unique token
> Error code has 32 bits and at least 1 of them should indicate that this
> is apf another one should indicate event type so this leaves us 30 bits
> for a token. 12 bits of a token is used to store vcpu id this leaves 18
> bits for unique per vcpu id. Yes this may be enough. I don't think it is
> realistic to have more then 200000 outstanding apfs per vcpu. Alternately
> we can use CR2 to pass a token.
>    

Or a combination of pfec and cr2, yes.

>>>> would solve this.  I prefer using put_user() though than a permanent
>>>> get_user_pages().
>>>>
>>>>          
>>> I want to prevent it from been swapped out.
>>>        
>> Since you don't prevent the page fault handler or code from being
>> swapped out, you don't get anything out of it.
>>
>>      
> Performance. Currently it is accessed on each page fault and to access
> it gup+kmap should be done each and every time.
>    

put_user() is just as fast as a kmap, and don't prevent page migration 
or defragmentation.

Note we still have to mark_page_dirty() unless we want to chase live 
migration bugs.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

