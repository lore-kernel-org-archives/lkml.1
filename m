Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0BRCAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:00:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53054 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab0BRCA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:00:29 -0500
Message-ID: <4B7C9F0A.1080708@zytor.com>
Date: Wed, 17 Feb 2010 17:59:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Zachary Amsden <zamsden@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86 rwsem optimization extreme
References: <1266443901-3646-1-git-send-email-zamsden@redhat.com> <alpine.LFD.2.00.1002171403160.4141@localhost.localdomain> <4B7C7BE4.9050908@zytor.com> <alpine.LFD.2.00.1002171743200.4141@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002171743200.4141@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 05:53 PM, Linus Torvalds wrote:
>>
>> FWIW, I don't know of any microarchitecture where adc is slower than
>> add, *as long as* the setup time for the CF flag is already used up.
> 
> Oh, I think there are lots.
> 
> Look at just about any x86 latency/throughput table, and you'll see:
> 
>  - adc latencies are typically much higher than a single cycle
> 
>    But you are right that this is likel not an issue on any out-of-order 
>    chip, since the 'stc' will schedule perfectly.
> 

STC actually tends to schedule poorly, since it has a partial register
stall.  In-order or out-of-order doesn't really matter, though; what
matters is that the scoreboarding used for the flags has to settle, or
you will take a huge hit.

>  - but adc _throughput_ is also typically much higher, which indicates 
>    that even if you do flag renaming, the 'adc' quite likely only 
>    schedules in a single ALU unit.
> 
> For example, on a Pentium, adc/sbb can only go in the U pipe, and I think 
> the same is true of 'stc'. Now, nobody likely cares about Pentiums any 
> more, but the point is, 'adc' does often have constraints that a regular 
> 'add' does not, and there's an example of a 'stc+adc' pair would at the 
> very least have to be scheduled with an instruction in between.

No doubt.  I doubt it much matters in this context, but either way I
think the patch is probably a bad idea... much for the same as my incl
hack was - since the code isn't actually inline, saving a handful bytes
is not the right tradeoff.

	-hpa

