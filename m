Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZKEIXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZKEIXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 03:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbZKEIW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 03:22:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbZKEIW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 03:22:58 -0500
Message-ID: <4AF28B49.7000509@redhat.com>
Date: Thu, 05 Nov 2009 10:22:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Gleb Natapov <gleb@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 02/11] Add "handle page fault" PV helper.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-3-git-send-email-gleb@redhat.com> <20091102092214.GB8933@elte.hu> <4AEF2D0A.4070807@redhat.com> <4AEF3419.1050200@redhat.com> <4AEF6CC3.4000508@redhat.com> <4AEFB823.4040607@redhat.com> <0A882F4D99BBF6449D58E61AAFD7EDD6339E7098@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <0A882F4D99BBF6449D58E61AAFD7EDD6339E7098@pdsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2009 08:44 AM, Tian, Kevin wrote:
>> From: Avi Kivity
>> Sent: 2009Äê11ÔÂ3ÈÕ 12:57
>>
>> On 11/03/2009 01:35 AM, Rik van Riel wrote:
>>     
>>>> We can't add an exception vector since all the existing 
>>>>         
>> ones are either
>>     
>>>> taken or reserved.
>>>>         
>>>
>>> I believe some are reserved for operating system use.
>>>       
>> Table 6-1 says:
>>
>>   9 |  | Coprocessor Segment Overrun (reserved)  |  Fault |  No  | 
>> Floating-point instruction.2
>>   15 |  ¡ª |  (Intel reserved. Do not use.) |   | No |
>>   20-31 |  ¡ª | Intel reserved. Do not use.  |
>>   32-255 |  ¡ª  | User Defined (Non-reserved) Interrupts |  Interrupt  
>> |   | External interrupt or INT n instruction.
>>
>> So we can only use 32-255, but these are not fault-like 
>> exceptions that 
>> can be delivered with interrupts disabled.
>>
>>     
> would you really want to inject a fault-like exception here? Fault
> is architurally synchronous event while here apf is more like an 
> asynchronous interrupt as it's not caused by guest itself. If 
> guest is with interrupt disabled, preemption won't happen and 
> apf path just ends up "wait for page" hypercall to waste cycles.
>   

An async page fault is, despite its name, synchronous, since it is
associated with an instruction. It must either be delivered immediately
or not at all.

It's true that in kernel mode you can't do much with an apf if
interrupts are disabled, but you still want to receive apfs for user
mode with interrupts disabled (for example due to interrupt shadow).

-- 
error compiling committee.c: too many arguments to function

