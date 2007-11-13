Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbXKMQOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbXKMQOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXKMQOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:14:01 -0500
Received: from il.qumranet.com ([82.166.9.18]:58686 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbXKMQOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:14:00 -0500
Message-ID: <4739CD03.90406@qumranet.com>
Date: Tue, 13 Nov 2007 18:12:51 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Dong, Eddie" <eddie.dong@intel.com>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, jeremy@goop.org, hollisb@us.ibm.com,
       kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 2/3] kvmclock - the host part.
References: <11945615632624-git-send-email-gcosta@redhat.com><11945615703593-git-send-email-gcosta@redhat.com> <11945615751747-git-send-email-gcosta@redhat.com> <10EA09EFD8728347A513008B6B0DA77A025DF8A2@pdsmsx411.ccr.corp.intel.com> <4739906B.2080103@redhat.com> <4739B916.4000405@qumranet.com> <10EA09EFD8728347A513008B6B0DA77A025DFB75@pdsmsx411.ccr.corp.intel.com>
In-Reply-To: <10EA09EFD8728347A513008B6B0DA77A025DFB75@pdsmsx411.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dong, Eddie wrote:
>>>
>>> After thinking for a little while, you are theoretically right.
>>> In the current state, we could even be preempted between all
>>> operations ;-) Maybe after avi's suggestion of moving the call to it
>>> it will end up in a preempt safe region, but anyway, it's safer to
>>> add the preempt markers here. I'll put it in next version, thanks
>>>
>>>
>>>       
>> Well, you can't kvm_write_guest() with preemption enabled.
>>
>> preempt notifiers to the rescue!  We have a callout during preemption,
>> so you can just zero out a flag there, and when we're scheduled again
>> retry the whole thing. 
>>
>>     
>
> The preemption issue is within following code which need to be done in a
> short enough period.
>
> +	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER,
> +			  &vcpu->hv_clock.last_tsc);
> +
> +	ktime_get_ts(&ts);
> +	vcpu->hv_clock.now_ns = ts.tv_nsec + (NSEC_PER_SEC *
> (u64)ts.tv_sec);
> +	vcpu->hv_clock.wc_sec = get_seconds();
>
> I am even thinking we have to disable interrupt between these lines,
> otherwise
> guest wall clock may see backward time source when calculating the
> delta TSC since last vcpu->hv_clock.now_ns update.
>   

That's true.  While we do need to handle vcpu migration and 
descheduling, the code sequence you note needs to be as atomic as possible.


-- 
error compiling committee.c: too many arguments to function

