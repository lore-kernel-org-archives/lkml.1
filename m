Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbXKMOp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbXKMOp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbXKMOpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:45:51 -0500
Received: from il.qumranet.com ([82.166.9.18]:39489 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbXKMOpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:45:50 -0500
Message-ID: <4739B85B.2080102@qumranet.com>
Date: Tue, 13 Nov 2007 16:44:43 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, jeremy@goop.org, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com
Subject: Re: [PATCH 2/3] kvmclock - the host part.
References: <11945615632624-git-send-email-gcosta@redhat.com> <11945615703593-git-send-email-gcosta@redhat.com> <11945615751747-git-send-email-gcosta@redhat.com> <4736D6C0.8040408@qumranet.com> <47398A68.8080009@redhat.com>
In-Reply-To: <47398A68.8080009@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Avi Kivity escreveu:
>   
>> Glauber de Oliveira Costa wrote:
>>     
>>> This is the host part of kvm clocksource implementation. As it does
>>> not include clockevents, it is a fairly simple implementation. We
>>> only have to register a per-vcpu area, and start writting to it
>>> periodically.
>>>
>>>   
>>>       
>> Missing live migration support  (a way for userspace to read and write
>> the guest clock address).  Should probably be in a separate patch.
>>     
>
> I think it's a matter of issuing a hypercall for reading the clock
> address. It's fair simple, and can be done in a later version of this patch.
> As for writting, the register hypercall itself can be used. It has no
> special side-effects we should care about.
>   

kvm live migration is done (at least thus far) without guest 
involvement.  So you need the host to be able to transfer this state.


>   
>>> @@ -1924,6 +1955,7 @@ out:
>>>          goto preempted;
>>>      }
>>>  
>>> +    kvm_write_guest_time(vcpu);
>>>      post_kvm_run_save(vcpu, kvm_run);
>>>   
>>>       
>> Why here?  Seems like we're leaving the guest for a while at this place.
>>
>> Suggest putting it on top of __vcpu_run(), guarded by a flag, and
>> setting the flag every time we put the vcpu.
>>     
>
> No special preference. It just sounded exity enough to me. I can move to
> where you suggest.
>
>   

It's more than a place, it's a set of rules:

- if the vcpu is migrated, we need a new timebase
- ditto if we're descheduled (well that's the same thing)
- if "some time passes"


-- 
error compiling committee.c: too many arguments to function

