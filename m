Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbXGITYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbXGITYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbXGITY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:24:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:21052 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbXGITY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:24:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PyioE3fbXIeM+/jyG0+5osywL/Qzu84QJJ9qUIa1v8b5kpLVfVMm1jAHTFiMxSo6uMrO1DxvHskOwGufL3axNhRbRMWgLF5DJFe5ov0GyjzOtciPGObmzPrMSuOjbzAYvW1rZDwMMQXEl/IbtMkRPBI8O+6+mXqkyrgRM2dkgAY=
Message-ID: <a781481a0707091224s3fb1a2acr6d3ccce091480f61@mail.gmail.com>
Date: Tue, 10 Jul 2007 00:54:26 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [PATCH 17/20] SMP: Implement on_cpu()
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       KVM <kvm-devel@lists.sourceforge.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <46921BE9.4040801@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11838956891287-git-send-email-avi@qumranet.com>
	 <11838956893094-git-send-email-avi@qumranet.com>
	 <p73lkdqzpdm.fsf@bingen.suse.de> <4691D9C1.4050309@qumranet.com>
	 <20070709071640.GB10864@one.firstfloor.org>
	 <46920270.3080309@qumranet.com> <46921BE9.4040801@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ISTR participating in a similar discussion some time back, but ...
anyway, I don't like the change in semantics of smp_call_function()
being proposed here *at* *all* ...

On 7/9/07, Avi Kivity <avi@qumranet.com> wrote:
> >> This defines on_cpu() which is similar to smp_call_function_single()
> >> except that it works if cpu happens to be the current cpu.  Can also be
> >> seen as a complement to on_each_cpu() (which also doesn't treat the
> >> current cpu specially).

I like the patch being originally proposed here. For the sake of
correctness, it is _compulsory_ to wrap a get_cpu() / put_cpu()
pair around calls to smp_call_function{_single} in any case,
so it makes sense to provide a function that does this wrapping
in itself, to reduce likelihood of bugs and also get rid of open-coding.

[ In fact I don't like the fact that for the UP case you're simply
executing the function locally without even checking that the
cpu argument passed is indeed == 0. We had discussed this
previously and you did mention that cpu == 0 for !SMP is
assumed to be true, but I don't see what we lose by asserting
that "trivial assumption" either. ]

On 7/9/07, Andi Kleen <andi@firstfloor.org> wrote:
> [...]
> on_each_cpu() was imho always a mistake. It would have been better
> to just fix smp_call_function() directly

I'm not sure what you mean by "fix" here, but if you're proposing
that we change smp_call_function() semantics to _include_ the
current CPU (and just run the given function locally also along
with the others -- and hence get rid of on_each_cpu) then I'm sorry
but I'll have to *violently* disagree with that. Please remember that
the current CPU _must_ be treated specially in a whole *lot* of
usage scenarios ...

Take smp_send_stop() for instance. We need to send a suicide
function:

for (;;)
        halt();

to all _other_ CPUs *only* -- it would be *insane* to include ourselves
(current CPU, current thread) and just execute this suicide function
_locally_ *in current thread* too.

OTOH, there are plenty of situations where we actually _want_ to
get some function executed on *each* CPU (_including_ the current
local CPU that is executing that thread) -- naturally on_each_cpu()
would make sense for those cases.

Both have their purposes -- both must co-exist.

On 7/9/07, Andi Kleen <andi@firstfloor.org> wrote:
> > I think it would be better to fix smp_call_function_single to just
> > handle this case transparently. There aren't that many callers yet
> > because it is
> > fairly new.

Take the same example here -- let's say we want to send a
"for (;;) ;" kind of function to a specified CPU. Now let's say
by the time we've called smp_call_function_single() on that
target CPU, we're preempted out and then get rescheduled
on the target CPU itself. There, we begin executing the
smp_call_function_single() (as modified by Avi here with your
proposed changed semantics) and notice that we've landed
on the target CPU itself, execute the suicidal function
_locally_ *in current thread* itself, and ... well, I hope you
get the picture.

So my opinion is to go with the get_cpu() / put_cpu() wrapper
Avi is proposing here and keep smp_call_function{_single}
semantics unchanged. [ Also please remember that for
*correctness*, preemption needs to be disabled by the
_caller_ of smp_call_function{_single} functions, doing so
inside them is insufficient. ]

Satyam
