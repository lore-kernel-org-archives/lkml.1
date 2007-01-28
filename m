Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbXA1X20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbXA1X20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 18:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932975AbXA1X20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 18:28:26 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50958 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969AbXA1X2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 18:28:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jeff Garzik <jeff@garzik.org>, Greg Kroah-Hartman <greg@kroah.com>,
       Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
       linuxppc-dev@ozlabs.org, Brice Goglin <brice@myri.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/6] MSI portability cleanups
References: <1169714047.65693.647693675533.qpush@cradle>
	<m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	<1170015805.26655.15.camel@localhost.localdomain>
	<45BD0BDC.40205@garzik.org> <m1bqkiq25v.fsf@ebiederm.dsl.xmission.com>
	<1170022154.26655.63.camel@localhost.localdomain>
Date: Sun, 28 Jan 2007 16:26:44 -0700
In-Reply-To: <1170022154.26655.63.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Mon, 29 Jan 2007 09:09:14 +1100")
Message-ID: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

>  .../... (enable/disable bits)
>
>> Which are either talking directly to the hardware, or are talking
>> to the hypervisor, which is using hardware isolation so it is safe to
>> talk directly to the hardware but isn't leting us?  If we could use
>> things to work around errata in card implementation details it would
>> make some sense to me (although we don't seem to have any cards with
>> that got the MSI registers wrong at this point).  Regardless these
>> operations clearly have a different granularity than the other
>> operations, and should have a different lookup method.
>
> I'm not sure I undersdand the point of your rant here. The hypervisor
> case hooks at alloc/free and does everything from there. It doens't use
> an enable or a diable hook.
>
> The enable/disable ops are optional for that reason. When not present,
> it's assumed that alloc/free do it all.

Well my feeling is that in your weird HV case enable/disable should do
all of the work.  And alloc/free won't have to do anything because the
bus doesn't matter any more.

> When using a "direct" approach (what we call "raw"), we expect backends
> to just plug the provided helper functions in enable/disable. It's still
> a hook so that one can do additional platform specific bits if
> necessary, but in that specific case, I do agree we could just remove it
> and move the "raw" code back into the toplevel functions, with a way
> (via a special return code from alloc maybe ?) for the HV case to tell
> us not to go through there. That was one of our initial approaches when
> working with Michael on the design.
>
> However, that sort of hurts my sense of aestetics :-) I quite like the
> toplevel to be just a toplevel, and clearly separate the raw "helpers"
> and the backend. Provides more flexibility to handle all possible crazy
> cases in the future.

To be clear I see this as 2 distinct layers of code. enable/disable
that talks directly to the hardware, and the helpers of enable/disable
that allocate the irq.  I base this on the fact that I only need the
alloc/free when I am exclusively working with real hardware.

> You seem to absolutely want to get the HV case to go throuh the same
> code path as the "raw" case, and that will not happen.

Yes I do.  Because that is the only sane approach for a HV to use.
And yes we need an irq allocator to call the HV to setup the upstream
reception of the msi message.

However I don't think it will be to hard to support your HV once we get
the real hardware supported.  I just refuse to consider it before we have
figured out what makes sense in the context where we have to do everything.


>   .../... (irq operations)
>
>> These because they are per irq make sense as per bus operations unless
>> you have a good architecture definition like x86 has.  Roughly those
>> operations are what we currently have except the current operations
>> are a little simpler and easier to deal with for the architecture
>> code.
>
> Oh ? How so ? (easier/simpler ?)

I don't take a type parameter, and I don't take a vector.  All of
that work is done in the generic code.

>> And then there are the operations that are going in the wrong
>> direction.
>> +	/* setup_msi_msg - Setup an MSI message for the given device.
>> +	 *
>> +	 * @pdev:	PCI device structure.
>> +	 * @entry:	The MSI entry to create a msi_msg for.
>> +	 * @msg:	Written with the magic address and data.
>> +	 * @type:	The type, MSI or MSI-X.
>> +	 *
>> +	 * Returns the "magic address and data" used to trigger the msi.
>> +	 * If the setup is succesful this routine must return 0.
>> +	 *
>> +	 * This callback is optional.
>> +	 */
>> +	int (*setup_msi_msg) (struct pci_dev *pdev, struct msix_entry *entry,
>> +				struct msi_msg *msg, int type);
>> 
>> Much to much of the operations base approach as proposed looks like
>> when you have a hammer every problem looks like a nail, given how much
>> confusion about what was put into the operations structure.
>
> This is indeed a lower level hook to be used by "raw" enable/disable. An
> other approach would be to remove it, have each backend have it's own
> enable/disable that obtains the address/data and calls into a helper to
> program them. This would indeed be a little bit nicer in a layering
> perspective. But it adds a bit more code to each backend, so we kept
> things closer to the way they used to be. I don't have a firm reason not
> to change it however, I need talk to Michael in case he has more good
> reasons to keep it that way around. 

The current code in the kernel already is structured that way because
we have to reprogram the msi message on each irq migration.  Not using
a helper to write the message would be a noticeable change and require
a fair amount of code rewriting on the currently supported
architectures.

>> I don't mind taking a small step and making the alloc/free primitives
>> per bus in a generic fashion. 
>>
>> I don't mind supporting poorly designed hypervisor interfaces, if it
>> is easy.
>
> And it it's not, we don't support them ? Ugh ? Well, it happens to be
> fairly easy but still, I don't understand your approach there.

Yes.  In general the mainline linux kernel does not support certain
classes of stupidity.  TCP offload engines, firmware drivers for
hardware we care about, a fixed ABI to binary only modules, etc.
It is the responsibility of the OS to setup MSI so we do it, not
the firmware so we do it.

Not supporting stupid things that are hard to support encourages other
people not to be so silly, especially when linux still works on the
hardware when that silly feature isn't supported.

For similar reasons we don't support more than 1 irq with a plain MSI
capability.  It is hard, we can't do it on most hardware, and anyone
who wants more than 1 irq should just implement MSI-X and everyone
will be able to use it, on any hardware.

Part of the reason to not support a messed up HV interface if it hard
is that a HV is just software.  Which means the incremental cost to
fix it is roughly the same as fixing the linux kernel, and it puts
the burden on the people doing stupid things not on the rest of us
forever more.

>> I do strongly mind code that doesn't work, or we can't git-bisect
>> through to find where bugs were introduced.
>
> It doesn't work yet for you which is why it's not -replacing- your
> current code. Again, this was intended as arch code in the first place,
> until other archs and maintainers voiced their opinion that we should
> move that to generic code. It may not be perfect, we may still want to
> change things, maybe make some things closer to the direction you are
> taking for the x86 code, but I don't understand the root of such a
> strong opposition except mayeb that you've spent time trying to fix the
> x86 junk and now are annoyed to see some of that work possibly
> replaced ?

No.  I have spent time fixing what is there, and made it work.  I see
implementations proposed that don't handle cases I have fixed, and I
don't see anything that resembles a simple migration path for i386,
x86_64 and ia64.  Which is part of what annoys me when I am told
the ops work for everything.

As for the code not working important parts of the code (like MSI-X)
don't even work on ppc.  The strength of my opposition is largely
shaped by the number of people wearing rose colored glasses and
ignoring the problems, and missing huge details.

Given that we have been talking about things since before OLS I would
have expected the ppc code to be a little farther along.

> I agree with the problem if small changes & bisecting in the general
> case. In fact, it would be nice if we could use your fixed code with
> little change to "plug" it in as the x86 backend in many ways. Michael's
> work isn't a re-implementation of everything, it's a re-structuring,
> lots of bits of code that are missing can possibly be lifted from the
> existing working implementation.

Not the x86 backend but the raw backend.  You might not need all of
the features because you are always going through another interrupt
controller but that doesn't mean they shouldn't be there.

Michael has at least agreed to look in that direction so I'm hoping
my changes remove some of the difficulty for him.

> If we followed that "only do incrementental changes" rule all the time,
> imagine in what state would be our USB stack today since we couldn't
> have dropped in Linus replacement one ...

Well even that was a partial following of that rule because you didn't
rewrite the rest of the kernel at the same time, to better support
usb.  I do agree that there are instances where a complete rewrite is
the best path.  In this case I don't see a reasonable case for not
reusing what is there.

Nor do I see the level of care being put into the problem that would
cause me to trust a rewrite.  I have a huge number of little technical
problems with the proposed code, and see absolutely no overriding
virtue in it.  Especially when the worst of the problems with msi.c
can be easily fixed, as demonstrated by my patchset.

Eric
