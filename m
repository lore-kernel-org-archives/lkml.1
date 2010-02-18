Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab0BRE0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 23:26:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab0BRE0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 23:26:13 -0500
Message-ID: <4B7CC14F.7000802@redhat.com>
Date: Wed, 17 Feb 2010 18:25:51 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86 rwsem optimization extreme
References: <1266443901-3646-1-git-send-email-zamsden@redhat.com> <alpine.LFD.2.00.1002171403160.4141@localhost.localdomain> <4B7C7BE4.9050908@zytor.com> <alpine.LFD.2.00.1002171743200.4141@localhost.localdomain> <4B7C9F0A.1080708@zytor.com>
In-Reply-To: <4B7C9F0A.1080708@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On 02/17/2010 05:53 PM, Linus Torvalds wrote:
>    
>>   - but adc _throughput_ is also typically much higher, which indicates
>>     that even if you do flag renaming, the 'adc' quite likely only
>>     schedules in a single ALU unit.
>>
>> For example, on a Pentium, adc/sbb can only go in the U pipe, and I think
>> the same is true of 'stc'. Now, nobody likely cares about Pentiums any
>> more, but the point is, 'adc' does often have constraints that a regular
>> 'add' does not, and there's an example of a 'stc+adc' pair would at the
>> very least have to be scheduled with an instruction in between.
>>      
> No doubt.  I doubt it much matters in this context, but either way I
> think the patch is probably a bad idea... much for the same as my incl
> hack was - since the code isn't actually inline, saving a handful bytes
> is not the right tradeoff.
>
> 	-hpa
>
>    

Incidentally, the cost of putting all the rwsem code inline, using the 
straightforward approach, for git-tip, using defconfig on x86_64 is 3565 
bytes / 20971778 bytes total, or 0.0168%, using gcc 4.4.3.

That's small enough to actually consider it.

Even smaller if you leave trylock as a function... actually no, that 
didn't work, size increased.  I'm guessing many call sites also end up 
calling the explicit form as a fallback.

If you inline only read_lock functions and write release, nope, that 
didn't work either.

If you inline only read_lock functions, that still isn't it.  Many other 
permutations are possible, but I've wasted enough time.

Although, with a more clever inline implementation, if some of the 
constraints to %rdx go away...

Zach
