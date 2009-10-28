Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbZJ1N2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbZJ1N2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 09:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZJ1N2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 09:28:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbZJ1N2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 09:28:04 -0400
Message-ID: <4AE846D6.6020505@redhat.com>
Date: Wed, 28 Oct 2009 15:27:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Subject: Re: [Alacrityvm-devel] [KVM PATCH v2 1/2] KVM: export lockless GSI
 attribute
References: <20091023023512.3891.65889.stgit@dev.haskins.net>	<20091023023845.3891.36857.stgit@dev.haskins.net> <4AE460F4.2090905@redhat.com> <4AE5A336.4010801@gmail.com> <4AE5C26A.9000400@gmail.com> <4AE81710.1080103@redhat.com> <4AE844FA.4070408@gmail.com>
In-Reply-To: <4AE844FA.4070408@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2009 03:19 PM, Gregory Haskins wrote:
>> Yes, and it also contains the work_struct.
>>
>> What if we make the work_struct (and any additional state) part of the
>> set_atomic() argument list?  Does it simplify things?
>>      
> Hmmm, that might not, but we could do a kmalloc(GFP_ATOMIC) for such
> parameters.  Considering this is just a safety net, perhaps this would
> work fine.
>    

Can't you simply pass the same work_struct from irqfd as we use now?

>>> So while generalizing this perhaps makes sense at some point, especially
>>> if irqfd-like interfaces get added, it probably doesn't make a ton of
>>> sense to expend energy on it ATM.  It is basically a generalization of
>>> the irqfd deferrment code.  Lets just wait until we have a user beyond
>>> irqfd for now.  Sound acceptable?
>>>
>>>        
>> I'll look at v3, but would really like to disentangle this.
>>      
> Ok, I will see what I can do.  I need at least a v4 to get rid of the
> dependency on the now defunct v3:1/3 patch per yesterdays discussion.
>    

There's another alternative - make ioapic and pic irq-safe by switching 
irq locking to spinlocks and using spin_lock_irqsave().

I've long opposed this since the ioapic loops on all vcpus when 
injecting some irqs and this will increase irqoff times with large 
guests.  But we don't have large guests now, and we need irq-safe 
injection in three places now:

- irqfd
- pit - we now signal vcpu0 to handle the injection, but this has its 
problems
- device assignment

so it may be better to have irq-safe injection, and deal with the loop 
later (would be good to have an idea how exactly).

-- 
error compiling committee.c: too many arguments to function

