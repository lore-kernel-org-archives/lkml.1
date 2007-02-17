Return-Path: <linux-kernel-owner+w=401wt.eu-S1422650AbXBQJfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422650AbXBQJfl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 04:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965102AbXBQJfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 04:35:41 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41250 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965099AbXBQJfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 04:35:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	<200702162045.58857.arnd@arndb.de>
	<20070216195256.GE2572@flint.arm.linux.org.uk>
Date: Sat, 17 Feb 2007 02:34:39 -0700
In-Reply-To: <20070216195256.GE2572@flint.arm.linux.org.uk> (Russell King's
	message of "Fri, 16 Feb 2007 19:52:56 +0000")
Message-ID: <m1k5yhb00g.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King <rmk+lkml@arm.linux.org.uk> writes:

> On Fri, Feb 16, 2007 at 08:45:58PM +0100, Arnd Bergmann wrote:
>> On Friday 16 February 2007 13:10, Eric W. Biederman wrote:
>> > To do this I believe will require a s/unsigned int irq/struct irq_desc *irq/
>> > throughout the entire kernel.  Getting the arch specific code and the
>> > generic kernel infrastructure fixed and ready for that change looks
>> > like a pain but pretty doable.
>> 
>> We did something like this a few years back on the s390 architecture, which
>> happens to be lucky enough not to share any interrupt based drivers with
>> any of the other architectures.
>
> What you're proposing is looking similar to a proposal I put forward some
> 4 years ago, but was rejected.  Maybe times have changed and there's a
> need for it now.
>
> Message attached.
>
> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
>
> From: 	Russell King <rmk@arm.linux.org.uk>
> Subject: [RFC] IRQ API
> To: 	linux-arch@vger.kernel.org
> Cc: 	Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Sat, 07 Jun 2003 17:05:19 -0700
>
> Hi,
>
> I've recently received an updated development system from ARM Ltd,
> which has caused me to become concerned about whether the existing
> IRQ infrastructure for the ARM architecture is really up to the job
> of handling the developments which will occur over the 2.6 lifetime.
> Essentially we're going to be seeing the emergence of vectored
> interrupt controllers, and knowing hardware designers, they'll
> continue the practice of chaining interrupt controllers (which is
> pretty common on ARM today.)  I have some hardware here today which
> has a vectored interrupt controller chained after two non-vectored
> controllers.  This vectored interrupt controller is on an add-on
> card, and so has no fixed address space and no fixed IRQ numbering.
>
> Rather than having the job of rewriting this code during 2.6, I'd much
> prefer to get something sorted, even if it is ARM only before 2.6.
>
> I believe that there are some common problems with the existing API
> which have been hinted at over the last few days, such as large
> NR_IRQS.  As such, I think it would be a good idea to try to thrash
> this issue out and get something which everyone is happy with.
>
> Additionally, I've added Alan's "reserve then hook" idea to the API;
> I seem to remember there is a case in IDE which needs something like
> this.
>
> Please note that what I am proposing is not to strip out the existing
> API between now and 2.7; what I am proposing is a structure for 2.7
> which can optionally be implemented by architectures and used in
> architecture specific drivers now if they feel they would benefit
> from it.
>
> Comments? (other than "wtf are you thinking about this so close to 2.6,
> are you mad" 8))
>
>
> 			Linux Interrupt API
> 			===================
>
> 		Russell King <rmk@arm.linux.org.uk>
>
> The Linux Interrupt API provides a flexible mechanism to handle and
> control interrupts within the kernel.  The design requirements for
> this API are:
>
> - must have as little overhead as possible for commodity hardware
> - must be easy and obvious to use
> - must allow complex multi-level interrupt implementations to exist
>   transparently to device drivers
> - must be compatible with the existing API
>
> Essentially, this means that implementation of the existing API must
> be simple.
>
> ------------------------------------------------------------------------------
>
> The API.
> ========
>
> struct irq {
> 	/* architecture defined information */
> 	/* must not be dereferenced by drivers */
> 	/* eg, x86's irq_desc_t or sparc64's struct ino_bucket */
> };
>
> #define NO_IRQ	<architecture-defined-int-constant>

When did you need a magic constant NO_IRQ in generic code.
One of the reasons I want to convert the drivers is so we can
kill the NO_IRQ nonsense.

As for struct irq.  Instead of struct irq_desc I really don't
care, although the C++ camp hasn't not yet weighed in and mentioned
how that creates a namespace conflict for them. 

> /**
>  *	irq_get - increment reference count on the IRQ descriptor
>  *	@irq: interrupt descriptor
>  *
>  *	IRQ descriptor reference counting is mandatory for
>  *	implementations which provide dynamically allocated IRQ
>  *	descriptors.  statically allocated IRQ descriptor
>  *	implementations may define these to be no-ops.
>  */
> struct irq *irq_get(struct irq *irq);

> /**
>  *	irq_put - decrement reference count on IRQ descriptor
>  *	@irq: interrupt descriptor
>  *
>  *	Decrement the reference counter in an IRQ descriptor.
>  *	If the reference counter drops to zero, the IRQ descriptor
>  *	will be freed.
>  *
>  *	IRQ descriptor reference counting is mandatory for
>  *	implementations which provide dynamically allocated IRQ
>  *	descriptors.  statically allocated IRQ descriptor
>  *	implementations may define these to be no-ops.
>  */
> void irq_put(struct irq *irq);

We might need this.  But I don't think we need reference counting in
the traditional sense.  For all practical purpose we already have
dynamic irq allocation and it hasn't proven necessary.  I would
prefer to go to lengths to avoid having to expose that kind of
an issue to driver code.


> Example backwards-compatible IRQ code.
> ======================================
>
> The following example code shows the expected back-compat code required
> for the x86 architecture.  Since x86 uses a fixed table of interrupts,
> this is relatively straight forward and simple.

Well I just find that comment cute, in the current context :)

I actually don't like the idea of having two version of the
infrastructure or for that matter any driver visible changes except
the type change at the same time.

That makes the conversion much harder because you have to think about
the change.  If I have to go in touch a huge percentage of the drivers
I don't want to have to think, I don't want something I have to code
review.  I want something that any first grader can do correct so when
I am fatigued after having converted 1000 drivers I can still get it
right, and so that there is a chance I don't have to convert drivers.

But otherwise I agree we seem to be largely on the same wavelength.

I also don't like infrastructure changes that never get finished,
which is the big danger with providing a backwards compatibility
API.  Some drivers just never adapt to what is new and better.

I think with a little care I can get 99% of the drivers compile
tested by enabling everything in the kernel (allyesconfig?)  

I guess when it comes to that I will have to see if I'm crazy or not.

Eric

