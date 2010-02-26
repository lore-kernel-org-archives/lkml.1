Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936095Ab0BZNI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 08:08:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936021Ab0BZNI2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 08:08:28 -0500
Subject: Re: [PATCH 2/5] KVM: SVM: Optimize nested svm msrpm merging
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20100226130401.GD12689@amd.com>
Date: Fri, 26 Feb 2010 14:08:25 +0100
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AEBFF8CD-15D2-4DEA-B441-94F10F6F2849@suse.de>
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com> <1267118149-15737-3-git-send-email-joerg.roedel@amd.com> <4B87A248.1050300@redhat.com> <20100226122502.GC12689@amd.com> <4E7D93ED-E5FC-4A64-B9B0-E2F644CD2B68@suse.de> <20100226130401.GD12689@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26.02.2010, at 14:04, Joerg Roedel wrote:

> On Fri, Feb 26, 2010 at 01:28:29PM +0100, Alexander Graf wrote:
>> 
>> On 26.02.2010, at 13:25, Joerg Roedel wrote:
>> 
>>> On Fri, Feb 26, 2010 at 12:28:24PM +0200, Avi Kivity wrote:
>>>>> +static void add_msr_offset(u32 offset)
>>>>> +{
>>>>> +	u32 old;
>>>>> +	int i;
>>>>> +
>>>>> +again:
>>>>> +	for (i = 0; i<  MSRPM_OFFSETS; ++i) {
>>>>> +		old = msrpm_offsets[i];
>>>>> +
>>>>> +		if (old == offset)
>>>>> +			return;
>>>>> +
>>>>> +		if (old != MSR_INVALID)
>>>>> +			continue;
>>>>> +
>>>>> +		if (cmpxchg(&msrpm_offsets[i], old, offset) != old)
>>>>> +			goto again;
>>>>> +
>>>>> +		return;
>>>>> +	}
>>>>> +
>>>>> +	/*
>>>>> +	 * If this BUG triggers the msrpm_offsets table has an overflow. Just
>>>>> +	 * increase MSRPM_OFFSETS in this case.
>>>>> +	 */
>>>>> +	BUG();
>>>>> +}
>>>> 
>>>> Why all this atomic cleverness?  The possible offsets are all
>>>> determined statically.  Even if you do them dynamically (makes sense
>>>> when considering pmu passthrough), it's per-vcpu and therefore
>>>> single threaded (just move msrpm_offsets into vcpu context).
>>> 
>>> The msr_offset table is the same for all guests. It doesn't make sense
>>> to keep it per vcpu because it will currently look the same for all
>>> vcpus. For standard guests this array contains 3 entrys. It is marked
>>> with __read_mostly for the same reason.
>> 
>> I'm still not convinced on this way of doing things. If it's static,
>> make it static. If it's dynamic, make it dynamic. Dynamically
>> generating a static list just sounds plain wrong to me.
> 
> Stop. I had a static list in the first version of the patch. This list
> was fine except the fact that a developer needs to remember to update
> this list if the list of non-intercepted msrs is expanded. The whole
> reason for a dynamically built list is to take the task of maintaining
> the list away from the developer and remove a possible source of hard to
> find bugs. This is what the current approach does.

I was more thinking of replacing the function calls with a list of MSRs. You can then take that list on module init, generate the MSR bitmap once and be good.

Later you can use the same list for the nested bitmap.

Alex