Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855Ab0AUJDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0AUJDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 04:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237Ab0AUJDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 04:03:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab0AUJDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 04:03:09 -0500
Message-ID: <4B58181B.60405@redhat.com>
Date: Thu, 21 Jan 2010 11:02:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
References: <1262700774-1808-5-git-send-email-gleb@redhat.com> <1263490267.4244.340.camel@laptop> <20100117144411.GI31692@redhat.com> <4B541D08.9040802@zytor.com> <20100118085022.GA30698@redhat.com> <4B5510B1.9010202@zytor.com> <20100119065537.GF14345@redhat.com> <4B55E5D8.1070402@zytor.com> <20100119174438.GA19450@redhat.com> <4B5611A9.4050301@zytor.com> <20100120100254.GC5238@redhat.com> <4B5740CD.4020005@zytor.com>
In-Reply-To: <4B5740CD.4020005@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 07:43 PM, H. Peter Anvin wrote:
> On 01/20/2010 02:02 AM, Gleb Natapov wrote:
>>
>>> You can have the guest OS take an exception on a vector above 31 just
>>> fine; you just need it to tell the hypervisor which vector it, the OS,
>>> assigned for this purpose.
>>>
>> VMX doesn't allow to inject hardware exception with vector greater 
>> then 31.
>> SDM 3B section 23.2.1.3.
>>
>
> OK, you're right.  I had missed that... I presume it was done for 
> implementation reasons.

My expectation is that is was done for forward compatibility reasons.

>
>> I can inject the event as HW interrupt on vector greater then 32 but not
>> go through APIC so EOI will not be required. This sounds 
>> non-architectural
>> and I am not sure kernel has entry point code for this kind of event, it
>> has one for exception and one for interrupts that goes through 
>> __do_IRQ()
>> which assumes that interrupts should be ACKed.
>
> You can also just emulate the state transition -- since you know 
> you're dealing with a flat protected-mode or long-mode OS (and just 
> make that a condition of enabling the feature) you don't have to deal 
> with all the strange combinations of directions that an unrestricted 
> x86 event can take.  Since it's an exception, it is unconditional.

Do you mean create the stack frame manually?  I'd really like to avoid 
that for many reasons, one of which is performance (need to do all the 
virt-to-phys walks manually), the other is that we're certain to end up 
with something horribly underspecified.  I'd really like to keep as 
close as possible to the hardware.  For the alternative approach, see Xen.

-- 
error compiling committee.c: too many arguments to function

