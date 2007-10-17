Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbXJQPKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbXJQPKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbXJQPKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:10:01 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57092 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbXJQPJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:09:59 -0400
Message-ID: <471625A0.4020201@bull.net>
Date: Wed, 17 Oct 2007 17:09:20 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Icedove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, borntraeger@de.ibm.com
Subject: Re: [PATCH] clear PF_VCPU in kvm_guest_exit()
References: <47135D1B.1060004@bull.net> <11926264852739-git-send-email-Laurent.Vivier@bull.net> <4716192E.7040402@qumranet.com>
In-Reply-To: <4716192E.7040402@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/10/2007 17:16:23,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 17/10/2007 17:16:25,
	Serialize complete at 17/10/2007 17:16:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Laurent Vivier wrote:
>> clear PF_VCPU in kvm_guest_exit() and move kvm_guest_exit() after 
>> local_irq_enable().
>>
>> According comments from Avi, we can clear PF_VCPU in kvm_guest_exit if we move 
>> it after local_irq_enable().
>>
>> http://lkml.org/lkml/2007/10/15/114
>>
>> To simplify s390 port, we don't clear it in account_system_time().
>>
>> http://lkml.org/lkml/2007/10/15/183
>>
>> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
>> ---
>>  drivers/kvm/kvm.h      |    1 +
>>  drivers/kvm/kvm_main.c |    3 ++-
>>  kernel/sched.c         |    1 -
>>  3 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
>> index e9dbf67..e8b4902 100644
>> --- a/drivers/kvm/kvm.h
>> +++ b/drivers/kvm/kvm.h
>> @@ -677,6 +677,7 @@ static inline void kvm_guest_enter(void)
>>  
>>  static inline void kvm_guest_exit(void)
>>  {
>> +	current->flags &= ~PF_VCPU;
>>  }
>>   
> 
> 
> Ingo already added this.
> 
>>  
>>  static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
>> diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
>> index 87275be..a9db477 100644
>> --- a/drivers/kvm/kvm_main.c
>> +++ b/drivers/kvm/kvm_main.c
>> @@ -2194,12 +2194,13 @@ again:
>>  
>>  	kvm_x86_ops->run(vcpu, kvm_run);
>>  
>> -	kvm_guest_exit();
>>  	vcpu->guest_mode = 0;
>>  	local_irq_enable();
>>  
>>  	++vcpu->stat.exits;
>>  
>>   
> 
> Need a barrier() here.  Otherwise the compiler may reorder
> "kvm_guest_exit();" and "++vcpu->stats.exits;", making kvm_guest_exit()
> right after local_irq_enable().  If it inlines kvm_guest_exit(), and
> further encodes it in one instruction (both likely) we get:
> 
>          sti
>          andl $something, (something_else)

For the moment it is:

    5676:       fb                      sti
    5677:       48 8b 85 f8 fe ff ff    mov    0xfffffffffffffef8(%rbp),%rax
    567e:       8b 80 10 0c 00 00       mov    0xc10(%rax),%eax
    5684:       8d 50 01                lea    0x1(%rax),%edx
    5687:       48 8b 85 f8 fe ff ff    mov    0xfffffffffffffef8(%rbp),%rax
    568e:       89 90 10 0c 00 00       mov    %edx,0xc10(%rax)
    5694:       65 48 8b 04 25 00 00    mov    %gs:0x0,%rax
    569b:       00 00
    569d:       48 89 45 a8             mov    %rax,0xffffffffffffffa8(%rbp)
    56a1:       48 8b 45 a8             mov    0xffffffffffffffa8(%rbp),%rax
    56a5:       48 89 45 b0             mov    %rax,0xffffffffffffffb0(%rbp)
    56a9:       48 8b 45 b0             mov    0xffffffffffffffb0(%rbp),%rax
    56ad:       48 89 c2                mov    %rax,%rdx
    56b0:       8b 42 14                mov    0x14(%rdx),%eax
    56b3:       83 e0 ef                and    $0xffffffffffffffef,%eax
    56b6:       89 42 14                mov    %eax,0x14(%rdx)

So I think it is out of the interrupt shadow... but you're right I will resend
the patch adding barrier() (because in futur gcc can behave differently),
removing the part already added by Ingo and copying kvm-devel.

> The andl executes in interrupt shadow (that is, interrupts are still
> disabled) and the timer tick won't see PF_VCPU.
> 
>> +	kvm_guest_exit();
>> +
>>  	preempt_enable();
>>  
>>  	/*
>>   
> 
> 
> Please copy kvm-devel on kvm patches.
> 

Laurent
-- 
---------------- Laurent.Vivier@bull.net  -----------------
"Given enough eyeballs, all bugs are shallow" E. S. Raymond
