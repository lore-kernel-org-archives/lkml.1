Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbYDXSPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbYDXSPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYDXSPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:15:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49632 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYDXSPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:15:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Rene Herman <rene.herman@keyaccess.nl>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
References: <20080422221733.GA16260@havoc.gtf.org>
	<alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>
	<480E6DE5.6010103@garzik.org>
	<alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>
	<480E796E.4070001@garzik.org>
	<alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>
	<20080423000529.GG28933@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>
	<480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>
	<alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org>
	<m1od7zkd2s.fsf@frodo.ebiederm.org> <481066C1.1030805@garzik.org>
	<alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org>
	<4810A9E6.1080201@garzik.org>
	<alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org>
	<m1r6cvgpw2.fsf@frodo.ebiederm.org>
	<alpine.LFD.1.10.0804240951520.2779@woody.linux-foundation.org>
Date: Thu, 24 Apr 2008 11:15:28 -0700
In-Reply-To: <alpine.LFD.1.10.0804240951520.2779@woody.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 24 Apr 2008 09:58:52 -0700 (PDT)")
Message-ID: <m1d4of86gv.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [git patch] free_irq() fixes
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 24 Apr 2008, Eric W. Biederman wrote:
>> 
>> Right now the irq number is very much an array index and that
>> property is limiting.
>
> That's simply not true. 
>
> You are looking at some implementation detail, but other architectures 
> have used other notions.
>
> The number is just that: a number. Nothing else. If you think it's an 
> array index, you are looking at it in all the wrong ways.

*laughs*

I don't think it is fundamentally an array index.  I just think we
have assumptions in the implementation that are a bit hard to
get out keeping it an array index.  Some of that has to do
with the cookie we pass to drivers.  So I am concerned there.

My preference would be a cookie based on struct irq_desc * so we
could recover the pointer to the irq_desc with a constant time operation.
However I really don't care as long as the driver irq cookie doesn't
limit us.

> So you're now complaining about somethign totally different than the type, 
> you're talking about simple implementation issues.
>
> And the reason it's generally implemented as a vector is very simple: it's 
> basic to the whole notion that the hardware gives us some cookie (which 
> itself is _often_ a small number, but sometimes is something that we can 
> program), and we want to look up that cookie into our internal irq 
> handling data structures.

Yes.  

In some sense we have 3 cookies.  The hw cookie the driver cookie
and the human cookie (the irq number).

The hw cookie is so abstracted and hidden that most people don't
even realize we are doing really weird things there today.

The driver cookie is currently the same as the human cookie.  Not
really a problem, but it does sometimes mean drivers make assumptions
that are not future proof.

The human cookie the irq number is for sysadmins and other people
trying to understand the system.  So the human cookie should be
stable (the same from boot to boot) and have some meaning if
we can (The Nth vector IOAPIC vector, the ISA irq,
domain/bus/slot/msivec).  Of course humans also tend to deal with
small numbers better.  So we have an ugly trade off between stability
over time human readability with msi vectors.

> So even when we can program the hw cookie arbitrarily (eg MSI), we 
> actually tend to *want* to program it with something we can use as an 
> array index, simply because that's often the best way to then map the 
> hardware cookie into the internal "struct irq_desc" things.

Yes.  For the hw cookie it is important that we can look it up quickly
in a small array.  That is a purely architecture detail and drivers
and even the genirq layer don't see that as they don't see the hw
cookie.

Given that many (most?) architectures have their own hw cookie that
is completely different from the irq number, there is little need
for the struct irq_desc to be stored in an array.  The only
thing really driving that is inertia and the fact that the generic irq
layer uses a number to communicate with drivers.

I do agree that the number we communicate to drivers with can easily
be something else.

> The reason we use something that _looks_ like an array index is that we 
> ourself (and hardware) MADE IT SO.

The linux irq number has NOTHING implementation wise to do with the
hardware.  The connection with the hardware is not an implementation
detail but is a deliberate thing so HUMANS can understand the
connection with the hardware.

> It has absolutely nothing to do with the type of "irq". Even if "irq" was 
> a pointer to a struct, we'd *still* want to have that array-index-like 
> thing, and the only thing you could do would be to then use an extra level 
> of indirection to turn it into something else!

There are two possible benefits that I see from having the irq driver
cookie be separate from the human cookie.

- irq 0 can stop being special and non-magical drivers can use it.
  As we can separate the driver cookie and the human cookie.
  Making it so that "if (!irqcookie)" doesn't trigger for irq 0.
  Which has the potential to simplify things.

- We won't need an extra data structure eventually to map from the
  driver cookie to struct irq_desc.

  We could do something like:
struct irq_desc *irq_to_desc(struct irq *irq)
{
        struct irq_desc  *desc;
	unsigned long val;
        val = (unsigned long )irq;
        val = ~val;
        val = val - 3;
        desc = (struct irq_desc *)val;
        BUG_ON(desc->magic != IRQDESC_MAGIC)
        return desc;
}

Neither of which appears particularly persuasive to me in the short
term, because there will be a transition period where I will need some
intermediate data structure.  So we don't need a flag if we change
the type of the cookie.

> So "irq" looks like an array index because we _avoid_ the indirection 
> (except for the lookup of "irq_desc", which we absolutely do NOT want to 
> expose to drivers!)

I can see the point of not exposing irq_desc directly to drivers.
That seems to make it more future proof.  I'm still not quite
convinced that we might not want to have a:
struct irqdesc {
	struct irq generic_irq_info;
}

And pass that generic_irq_info to drivers, but I don't see any real
advantage in it either.

> Your argument is utter crap, in other words. It makes no sense.

Seems we are on different wave lengths then.

Eric
