Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbXH0RaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbXH0RaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760093AbXH0R3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:29:17 -0400
Received: from il.qumranet.com ([82.166.9.18]:55571 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539AbXH0R3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:29:15 -0400
Message-ID: <46D3095A.6020305@qumranet.com>
Date: Mon, 27 Aug 2007 20:26:50 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Implement emulator_write_phys()
References: <11882278064002-git-send-email-aliguori@us.ibm.com>	 <1188227808405-git-send-email-aliguori@us.ibm.com>	 <46D2F1B7.70604@qumranet.com> <1188235419.6364.2.camel@squirrel>
In-Reply-To: <1188235419.6364.2.camel@squirrel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> On Mon, 2007-08-27 at 18:45 +0300, Avi Kivity wrote:
>   
>> Anthony Liguori wrote:
>>     
>>> Since a hypercall may span two pages and is a gva, we need a function to write
>>> to a gva that may span multiple pages.  emulator_write_phys() seems like the
>>> logical choice for this.
>>>
>>> @@ -962,8 +962,35 @@ static int emulator_write_std(unsigned long addr,
>>>  			      unsigned int bytes,
>>>  			      struct kvm_vcpu *vcpu
>>>       
>> I think that emulator_write_emulated(), except for being awkwardly 
>> named, should do the job.  We have enough APIs.
>>
>> But!  We may not overwrite the hypercall instruction while a vcpu may be 
>> executing, since there's no atomicity guarantee for code fetch.  We have 
>> to to be out of guest mode while writing that insn.
>>     
>
>
> Hrm, good catch.
>
> How can we get out of guest mode given SMP guest support?
>
>   

kvm_flush_remote_tlbs() is something that can be generalized.  
Basically, you set a bit in each vcpu and send an IPI to take them out.

But that's deadlock prone and complex.  Maybe you can just take 
kvm->lock, zap the mmu and the flush tlbs, and patch the instruction at 
your leisure, as no vcpu will be able to map memory until the lock is 
released.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

