Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0CKHvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 02:51:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab0CKHvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 02:51:19 -0500
Message-ID: <4B98A0DE.1020006@redhat.com>
Date: Thu, 11 Mar 2010 09:50:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [PATCH] x86/kvm: Show guest system/user cputime in cpustat
References: <1268292022-31352-1-git-send-email-sheng@linux.intel.com> <4B989D61.70906@redhat.com> <201003111546.44059.sheng@linux.intel.com>
In-Reply-To: <201003111546.44059.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 09:46 AM, Sheng Yang wrote:
> On Thursday 11 March 2010 15:36:01 Avi Kivity wrote:
>    
>> On 03/11/2010 09:20 AM, Sheng Yang wrote:
>>      
>>> Currently we can only get the cpu_stat of whole guest as one. This patch
>>> enhanced cpu_stat with more detail, has guest_system and guest_user cpu
>>> time statistics with a little overhead.
>>>
>>> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
>>> ---
>>>
>>> This draft patch based on KVM upstream to show the idea. I would split it
>>> into more kernel friendly version later.
>>>
>>> The overhead is, the cost of get_cpl() after each exit from guest.
>>>        
>> This can be very expensive in the nested virtualization case, so I
>> wouldn't like this to be in normal paths.  I think detailed profiling
>> like that can be left to 'perf kvm', which only has overhead if enabled
>> at runtime.
>>      
> Yes, that's my concern too(though nested vmcs/vmcb read already too expensive,
> they should be optimized...).

Any ideas on how to do that?  Perhaps use paravirt_ops to covert the 
vmread into a memory read?  We store the vmwrites in the vmcs anyway.

> The other concern is, perf alike mechanism would
> bring a lot more overhead compared to this.
>    

Ordinarily users won't care if time is spent in guest kernel mode or 
guest user mode.  They want to see which guest is imposing a load on a 
system.  I consider a user profiling a guest from the host an advanced 
and rarer use case, so it's okay to require tools and additional 
overhead for this.

>> For example you can put the code to note the cpl in a tracepoint which
>> is enabled dynamically.
>>      
> Yanmin have already implement "perf kvm" to support this. We are just arguing
> if a normal top-alike mechanism is necessary.
>
> I am also considering to make it a feature that can be disabled. But seems it
> make things complicate and result in uncertain cpustat output.
>    

I'm not even sure that guest time was a good idea.

-- 
error compiling committee.c: too many arguments to function

