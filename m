Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbXEROmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbXEROmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXEROmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:42:13 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46559 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbXEROmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:42:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, ak@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Zou, Nanhai" <nanhai.zou@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
Subject: Re: [patch] x86_64, irq: check remote IRR bit before migrating level triggered irq
References: <20070517230324.GB8089@linux-os.sc.intel.com>
	<m1ejlf0y96.fsf@ebiederm.dsl.xmission.com>
	<20070518010119.GB12088@linux-os.sc.intel.com>
Date: Fri, 18 May 2007 08:40:53 -0600
In-Reply-To: <20070518010119.GB12088@linux-os.sc.intel.com> (Suresh
	B. Siddha's message of "Thu, 17 May 2007 18:01:19 -0700")
Message-ID: <m1veeqjitm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Siddha, Suresh B" <suresh.b.siddha@intel.com> writes:

> On Thu, May 17, 2007 at 05:30:13PM -0700, Eric W. Biederman wrote:
>> So why does any of this matter?
>>
>> My memory says that the ioapic state for sending irqs gets reset when we
>> unmask the irq.
>
> No. Atleast not on the platform we have tested.

Ok.  It simply have the test for an external interrupt getting reset
not the delivery state machine.  Otherwise you would not have a
problem in the first place.

>> If not I expect we can use the mask and edge, unmask and level
>> work-around from arch/i386/ioapic.c.  That looks like it would
>> be less code, less error prone and easier to implement then the
>> current work around.
>
> hmm. We have to check and see if it can help. But ioapic spec doesn't
> say that the Remote IRR gets reset when the trigger mode changes. Not sure
> if we can apply the logic widely.

Worst case it is a noop, so wide deployment should be safe.

The original definition of the Remote IRR is:

> 14 Remote IRR--RO. This bit is used for level triggered
>    interrupts. Its meaning is undefined for edge triggered
>    interrupts. For level triggered interrupts, this bit is set to 1
>    when local APIC(s) accept the level interrupt sent by the
>    IOAPIC. The Remote IRR bit is set to 0 when an EOI message with a
>    matching interrupt vector is received from a local APIC.

We know it is not used to throttle edge triggered interrupts.

The question is how does the hardware implementation make that come
about?   By ignoring Remote IRR when transmitting edge triggered
interrupts?  By insisting Remote IRR is clear when doing a mode
transition?  By clearing Remote IRR when doing a mode transition?

At least historically there is some evidence that Intel's ioapics
did the latter.  I don't know if there is a defacto standard
for how ioapic mode transitions happen.

Still in any of those I don't see a problem with switching to edge
triggered mode and then back again.  Either Remote IRR will keep
it's current state or it will be cleared.   Remote IRR should not
get set (when it was clear) by such a procedure because that
would mess up the normal interrupt enable sequence that happens
on boot.  So I'm pretty certain toggling the edge bit is harmless
and it may actually clear Remote IRR for us.



This does seem to be a general applicable problem (at least in theory)
because we have no useful ordering rules we can take advantage of
so something that works across the board does make sense.

With a little care I think we can safely send an ack to the new
vector just in case this race triggers.  Before we send an
ipi to ourselves we need to ensure in the vector allocator that
the vector is either just for level or just for edge triggered
interrupts.  Then we can just send an ipi to our current cpu
ack it and we ensure the interrupt it acked.

"Siddha, Suresh B" <suresh.b.siddha@intel.com> writes:

> On Thu, May 17, 2007 at 04:58:02PM -0700, Eric W. Biederman wrote:
>> In essence this makes sense, and it may be the best work around for
>> buggy hardware available.   However I am not convinced that the remote
>> IRR on ioapics works reliably enough to be used for anything.   I
>> tested this earlier and I could not successfully poll the remote irr
>> bit to see if an ioapic had received an irq acknowledgement.  Instead
>> I locked up irq controllers.
>> 
>> If remote IRR worked reliably I could have pulled the irq migration
>> out of irq context.  So this fix looks dubious to me.
>
> We are just reading IOAPIC RTE's. So not sure why this can lead to lock
> up's. This patch is not reading any new HW registers. It just
> checks for certain bit values from the register that the code reads
> anyhow.
>
> Remote IRR should work reliably otherwise we will see lot more issues,
> I guess.

The test I performed was outside of interrupt context to mask an
interrupt, poll Remote IRR until it was clear, and them migrate
the interrupt.  That does not work correctly.  If that could
be made to work correctly we would not need to interrupt migration
in interrupt context.

So while that is not conclusive evidence that Remote IRR is not a
reliable indication of when it is safe to do things it is a strong
suggestion that it is not a good indicator.  Currently we don't
look at Remote IRR so we have no evidence that it is good for anything.

>> Why is the EOI delayed?  Can we work around that?
>
> Under some stress conditions, EOI can get retried because of which
> it is getting delayed.

Ok.  So that is why EOI is delayed.

>> It would be nice if ioapics and local apics actually obeyed the pci
>> ordering rules where a read would flush all traffic.  And we do have a
>> read in there.
>> 
>> I'm assuming the symptom you are seeing on current kernels is that
>> occasionally
>> the irq gets stuck and never fires again?
>
> yes.
>
>> I'm not certain I like the patch either, but I need to look more closely.
>> You are mixing changes to generic and arch specific code together.
>> 
>> I think pending_eoi should not try to reuse __DO_ACTION as that
>> helper bit of code does not seem appropriate.
>
> Wanted to minimize the code duplicacy and hence overloaded existing
> macros.

I think going more the way that this code has gone on arch/i386 with
real functions is preferable.

>> It would probably be best if the pending_eoi check was in
>> ack_apic_level with the rest of the weird logic we are working around.
>
> Just wanted to make sure that we give some time for the EOI to actually
> reach the IO-APIC.

If that is what we want an explicit delay is likely better then an
implicit wait induced by a function call.  A couple of extra
instructions isn't likely to make a really noticeable difference
to the slow interrupt controllers, and it makes the code much
less readable.

>> Could we please have more detail on this hardware behavior.  Why is
>> the EIO write write delayed?   Why can't we just issue reads in
>> appropriate places to flush the write?
>
> Because the EOI to IOAPIC gets generated as a side effect of processor
> EOI.

I agree with that.  But it would be useful if someone defined a
sequence such that we could read from the local apic and the from from
the ioapics to ensure we flush all traffic.  Not being able to
synchronize with an ioapic generates no end of challenges.

Eric
