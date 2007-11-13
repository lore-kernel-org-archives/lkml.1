Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbXKMOtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbXKMOtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbXKMOsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:48:55 -0500
Received: from il.qumranet.com ([82.166.9.18]:53564 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbXKMOsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:48:55 -0500
Message-ID: <4739B916.4000405@qumranet.com>
Date: Tue, 13 Nov 2007 16:47:50 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: "Dong, Eddie" <eddie.dong@intel.com>, linux-kernel@vger.kernel.org,
       jeremy@goop.org, hollisb@us.ibm.com, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 2/3] kvmclock - the host part.
References: <11945615632624-git-send-email-gcosta@redhat.com><11945615703593-git-send-email-gcosta@redhat.com> <11945615751747-git-send-email-gcosta@redhat.com> <10EA09EFD8728347A513008B6B0DA77A025DF8A2@pdsmsx411.ccr.corp.intel.com> <4739906B.2080103@redhat.com>
In-Reply-To: <4739906B.2080103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Dong, Eddie escreveu:
>   
>>> +static void kvm_write_guest_time(struct kvm_vcpu *vcpu) +{
>>> +	struct timespec ts;
>>> +	int r;
>>> +
>>> +	if (!vcpu->clock_gpa)
>>> +		return;
>>> +
>>> +	/* Updates version to the next odd number, indicating
>>> we're writing */
>>> +	vcpu->hv_clock.version++;
>>> +	kvm_write_guest(vcpu->kvm, vcpu->clock_gpa,
>>> &vcpu->hv_clock, PAGE_SIZE);
>>> +
>>> +	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER,
>>> +			  &vcpu->hv_clock.last_tsc);
>>> +
>>> +	ktime_get_ts(&ts);
>>>       
>> Do we need to disable preemption here?
>>     
> After thinking for a little while, you are theoretically right.
> In the current state, we could even be preempted between all operations
> ;-) Maybe after avi's suggestion of moving the call to it it will end up
> in a preempt safe region, but anyway, it's safer to add the preempt
> markers here.
> I'll put it in next version, thanks
>
>   

Well, you can't kvm_write_guest() with preemption enabled.

preempt notifiers to the rescue!  We have a callout during preemption, 
so you can just zero out a flag there, and when we're scheduled again 
retry the whole thing.

-- 
error compiling committee.c: too many arguments to function

