Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYKZUZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYKZUZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 15:25:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYKZUZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 15:25:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:59760 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYKZUZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 15:25:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=hO6q0Zj0q2sKUUa9k7EwtQCH4Otl+RWCbRMWeJoikRr7CY+FvqqLnF1jSVhP66g/1p
         1HLpXMbUJhD8BDB4WWp4TOh/y5WBgpMZ76StTCNLLNWsSMF1kJU2lZaiocq4hiUqhGbm
         WKHqyAcwcVMlpky0UbKmOPRgrF30Gz9SfI43A=
Message-ID: <7c86c4470811261224k20ae2554m32af5504488664cf@mail.gmail.com>
Date: Wed, 26 Nov 2008 21:24:59 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [patch 23/24] perfmon: kernel documentation
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
In-Reply-To: <20081126193429.GC6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0c14.02225e0a.15ab.6f8e@mx.google.com>
	 <20081126122107.GV6703@one.firstfloor.org>
	 <7c86c4470811261021t5a7da650w95c30a71838172c4@mail.gmail.com>
	 <20081126193429.GC6703@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, Nov 26, 2008 at 8:34 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Wed, Nov 26, 2008 at 07:21:56PM +0100, stephane eranian wrote:
>> Andi,
>>
>> On Wed, Nov 26, 2008 at 1:21 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> > On Wed, Nov 26, 2008 at 12:43:00AM -0800, eranian@googlemail.com wrote:
>> >
>> > I assume you'll be also submitting manpages with the same information?
>> >
>> This is on my TODO list. Provide a man page for each new syscall.
>
> There should be a overview manpage as well.
>

Yes.

>> I have never played with that myself, even with regular file
>> descriptors. But I can only
>> assume passing a file descriptor increments its refcount. Thus you
>> simply get another
>> controlling process. There is enough context locking in place in the
>> kernel to make this
>> work.
>
> Ok as long as it isn't a root hole or similar.
>
I need to figure out how you actually pass a fd form one process to another.
I seem to remember you need a pipe or socket + some ioctl().

>> > ...
>> >
>> > Some simple syscall examples would be nice. e.g. how to set up a counter
>> > that it can be accessed using RDPMC on x86.
>>
>> I can add this. But why go straight to RDPMC. Most people would want to use
>> the syscall instead?
>
> On recent Intel x86 a common simple useful case is to just use RDPMC
> with one of the fixed counters, especially the unscaled cycle counter.
> The only change needed here is to set the CR bit.
>
Well, you also need to set the FIXED_CTRL + GLOBAL_ENABLE + CR4.pce.


But then, there is one issue with RDPMC which is not clearly stated in the SDM
if I recall. Take Core 2, counters are 40 bits, thus RDPMC returns 40-bit worth
of data. But wrmsrl() can only set the bottom 32 bits. Bits 32-39 are
sign extension
of bit 31. Thus, you may need some masking in case the counter is high.  On
Intel processors, perfmon considers that all counters are actually 31-bit wide
(bits 32 and up are always set) and they are all virtualized to 64-bit via the
overflow interrupt. The issue with RDPMC vs. wrmsrl() is important in per-thread
mode because on context switch we may have to restore the counter.




>> > to let a driver patch for that adjust it.
>> >
>> It depends on the number of registers available. It is expected that most tools
>> will want to use one call to program the config registers and one to program
>> the data registers. Pfmon is able to split vectors according to arg_mem_max.
>>
>> It is anticipated that newer processors will increase the number of available
>> PMU registers. That was the case with Barcelona with the addition of IBS.
>> On Intel X86, I am planning on exposing the LBR as part of the PMU registers.
>>
>>  On Itanium, you already have 35 data and 27 config registers.
>
> That is still far less than a 4K page. Also 4K worth of registers would
> be a lot. I doubt that will be hit anytime soon.
>
Well, that's because you are looking at the minimal pfarg_pmr_t structure.
But once we had sampling, a new structure is introduced and it contains a
couple of bitmasks and the size is fairly big, 208 bytes on X86, or 19
registers.

>> But I think your suggestion is interesting. When we "register" the new PMU
>> mapping table, we can provide a minimal size to fit all PMC or all PMD registers
>> in one call. That would remove a control point for the sysadmin, though.
>
> I don't think the sysadmin wants to really know about that.
>
If we all agree on this, I can have the kernel adjust the limit based
on the number
of registers. We would not necessarily need to expose that limit in
/sys, if we assume
that tools will never try to pass vector with more entries than there
are registers. And if
they do, the call will fail.
