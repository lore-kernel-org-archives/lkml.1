Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936128Ab0BZMmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:42:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935302Ab0BZMmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:42:43 -0500
Message-ID: <4B87C1BC.6070502@redhat.com>
Date: Fri, 26 Feb 2010 14:42:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: SVM: Optimize nested svm msrpm merging
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com> <1267118149-15737-3-git-send-email-joerg.roedel@amd.com> <4B87A248.1050300@redhat.com> <20100226122502.GC12689@amd.com>
In-Reply-To: <20100226122502.GC12689@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2010 02:25 PM, Joerg Roedel wrote:
> On Fri, Feb 26, 2010 at 12:28:24PM +0200, Avi Kivity wrote:
>    
>>> +static void add_msr_offset(u32 offset)
>>> +{
>>> +	u32 old;
>>> +	int i;
>>> +
>>> +again:
>>> +	for (i = 0; i<   MSRPM_OFFSETS; ++i) {
>>> +		old = msrpm_offsets[i];
>>> +
>>> +		if (old == offset)
>>> +			return;
>>> +
>>> +		if (old != MSR_INVALID)
>>> +			continue;
>>> +
>>> +		if (cmpxchg(&msrpm_offsets[i], old, offset) != old)
>>> +			goto again;
>>> +
>>> +		return;
>>> +	}
>>> +
>>> +	/*
>>> +	 * If this BUG triggers the msrpm_offsets table has an overflow. Just
>>> +	 * increase MSRPM_OFFSETS in this case.
>>> +	 */
>>> +	BUG();
>>> +}
>>>        
>> Why all this atomic cleverness?  The possible offsets are all
>> determined statically.  Even if you do them dynamically (makes sense
>> when considering pmu passthrough), it's per-vcpu and therefore
>> single threaded (just move msrpm_offsets into vcpu context).
>>      
> The msr_offset table is the same for all guests. It doesn't make sense
> to keep it per vcpu because it will currently look the same for all
> vcpus. For standard guests this array contains 3 entrys. It is marked
> with __read_mostly for the same reason.
>    

In that case, you can calculate it during module initialization.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

