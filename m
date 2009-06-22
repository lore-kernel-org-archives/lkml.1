Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbZFVMZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbZFVMZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZFVMZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:25:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:8000 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZFVMZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:25:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=rHC7FxX/EUkBQs1+Njk1QanZO1eZrWCnSCJwS8LeGAlg5pQUyev9qit/6mQJs42AWF
         n1LIsxhvz8lrmfaR7Z1Tk6gwMRN7w+sBzkhvAclhw9emBMyhptSh+fNaCg+y63ioDq8R
         HtfEL0I2mX7k7Q2OiOY1hcAg7352LtVM6ZgPc=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090622115239.GF24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622115239.GF24366@elte.hu>
Date: Mon, 22 Jun 2009 14:25:28 +0200
Message-ID: <7c86c4470906220525x409bedadj29be01236e42ea1@mail.gmail.com>
Subject: Re: I.5 - Mmaped count
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 1:52 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> 5/ Mmaped count
>>
>> It is possible to read counts directly from user space for
>> self-monitoring threads. This leverages a HW capability present on
>> some processors. On X86, this is possible via RDPMC.
>>
>> The full 64-bit count is constructed by combining the hardware
>> value extracted with an assembly instruction and a base value made
>> available thru the mmap. There is an atomic generation count
>> available to deal with the race condition.
>>
>> I believe there is a problem with this approach given that the PMU
>> is shared and that events can be multiplexed. That means that even
>> though you are self-monitoring, events get replaced on the PMU.
>> The assembly instruction is unaware of that, it reads a register
>> not an event.
>>
>> On x86, assume event A is hosted in counter 0, thus you need
>> RDPMC(0) to extract the count. But then, the event is replaced by
>> another one which reuses counter 0. At the user level, you will
>> still use RDPMC(0) but it will read the HW value from a different
>> event and combine it with a base count from another one.
>>
>> To avoid this, you need to pin the event so it stays in the PMU at
>> all times. Now, here is something unclear to me. Pinning does not
>> mean stay in the SAME register, it means the event stays on the
>> PMU but it can possibly change register. To prevent that, I
>> believe you need to also set exclusive so that no other group can
>> be scheduled, and thus possibly use the same counter.
>>
>> Looks like this is the only way you can make this actually work.
>> Not setting pinned+exclusive, is another pitfall in which many
>> people will fall into.
>
>   do {
>     seq = pc->lock;
>
>     barrier()
>     if (pc->index) {
>       count = pmc_read(pc->index - 1);
>       count += pc->offset;
>     } else
>       goto regular_read;
>
>     barrier();
>   } while (pc->lock != seq);
>
> We don't see the hole you are referring to. The sequence lock
> ensures you get a consistent view.
>
Let's take an example, with two groups, one event in each group.
Both events scheduled on counter0, i.e,, rdpmc(0). The 2 groups
are multiplexed, one each tick. The user gets 2 file descriptors
and thus two mmap'ed pages.

Suppose the user wants to read, using the above loop, the value of the
event in the first group BUT it's the 2nd group  that is currently active
and loaded on counter0, i.e., rdpmc(0) returns the value of the 2nd event.

Unless you tell me that pc->index is marked invalid (0) when the
event is not scheduled. I don't see how you can avoid reading
the wrong value. I am assuming that is the event is not scheduled
lock remains constant.

Assuming the event is active when you enter the loop and you
read a value. How to get the timing information to scale the
count?
