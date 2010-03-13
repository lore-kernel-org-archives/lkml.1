Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab0CMI0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 03:26:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758896Ab0CMI0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 03:26:32 -0500
Message-ID: <4B9B4C2D.90806@redhat.com>
Date: Sat, 13 Mar 2010 10:26:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Qing He <qing.he@intel.com>
CC: Sheng Yang <sheng@linux.intel.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/kvm: Show guest system/user cputime in cpustat
References: <1268292022-31352-1-git-send-email-sheng@linux.intel.com> <201003111546.44059.sheng@linux.intel.com> <4B98A0DE.1020006@redhat.com> <201003111717.26475.sheng@linux.intel.com> <20100312085321.GA9075@ub-qhe2>
In-Reply-To: <20100312085321.GA9075@ub-qhe2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 10:53 AM, Qing He wrote:
>
>> When Qing(CCed) was working on nested VMX in the past, he found PV
>> vmread/vmwrite indeed works well(it would write to the virtual vmcs so vmwrite
>> can also benefit). Though compared to old machine(one our internal patch shows
>> improve more than 5%), NHM get less benefit due to the reduced vmexit cost.
>>
>>      
> One of the hurdles to PVize vmread/vmwrite is the fact that the memory
> layout of physical vmcs remains unknown. Of course it can use the custom
> vmcs layout utilized by nested virtualization, but that looks a little weird,
> since different nested virtualization implementation may create different
> custom layout.
>    

Note we must use a custom layout and cannot depend on the physical 
layout, due to live migration.  The layout becomes an ABI.

> I once used another approach to partially accelerate the vmread/vmwrite
> in nested virtualization case, which also gives good performance gain (around
> 7% on pre-nehalem, based on this, PV vmread/vmwrite had another 7%). That
> is to make a shortcut to handle EXIT_REASON_VM{READ,WRITE}, without
> even turning on the IF.
>    

Interesting.  That means our exit path is inefficient; it seems to imply 
half the time is spent outside the hardware vmexit path.

A quick profile (on non-Nehalem) shows many atomics and calls into the 
lapic, as well as update_cr8_intercept which is sometimes unnecessary; 
these could easily be optimized.

Definitely optimizing the non-paravirt path is preferred to adding more 
paravirtualization.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

