Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbYGAVxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbYGAVxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbYGAVwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:52:49 -0400
Received: from gw.goop.org ([64.81.55.164]:51634 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbYGAVws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:52:48 -0400
Message-ID: <486AA72B.6010401@goop.org>
Date: Tue, 01 Jul 2008 14:52:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org>	<485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org>	<485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>
In-Reply-To: <m1skutffn4.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nope.  It achieves that affect with a magic set of relocations instead
> of linker magic.
>   

Well, the code gcc generates for -fstack-protector emits a literal 
"%gs:40", so there's no relocations at all.

>> At present, the x86-64 only uses %gs-relative addressing to reach the pda, which
>> are always small positive offsets.  It always accesses per-cpu data in a
>> two-step process of getting the base of per-cpu data, then offsetting to find
>> the particular variable.
>>
>> x86-32 has no pda, and arranges %fs so that %fs:variable gets the percpu variant
>> of variable.  The offsets are always quite large.
>>     
>
> As a practical matter I like that approach (except for extra code size
> of the offsets).
>   

Yes, and there's no reason we couldn't do the same on 64-bit, aside from 
the stack-protector's use of %gs:40.  There's no code-size cost in large 
offsets, since they're always 32-bits anyway (there's no short absolute 
addressing mode).

>> The powerpc guys tried using gcc-level thread-local storage, but it doesn't work
>> well.  per-cpu data and per-thread data have different constraints, and its hard
>> to tell gcc about them.  For example, if you have a section of preemptable code
>> in your function, it's hard to tell gcc not to cache a "thread-local" variable
>> across it, even though we could have switched CPUs in the meantime.
>>     
>
> Yes, I completely agree with that.  It doesn't mean however that we
> can't keep gcc ignorant and generate the same code manually.
>   

Yes, I see.  I haven't looked at that specifically, but I think both 
Rusty and Andi have, and it gets tricky with modules and -ve kernel 
addresses, or something.

> Well I was thinking threads switching on a cpu having the kinds of problems you
> described when it was tried on ppc.

Uh, I think we're having a nomenclature imprecision here.  Strictly 
speaking, the kernel doesn't have threads, only tasks and CPUs.  We only 
care about per-cpu data, not per-task data, so the concern is not 
"threads switching on a CPU" but "CPUs switching on (under) a task".  
But I think we understand each other regardless ;)

If we manually generate %gs-relative references to percpu data, then 
it's no different to what we do with 32-bit, whether it be a specific 
symbol address or using the TLS relocations.

    J
