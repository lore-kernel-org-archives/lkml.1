Return-Path: <linux-kernel-owner+w=401wt.eu-S932918AbXA1WKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbXA1WKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932919AbXA1WKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:10:19 -0500
Received: from gate.crashing.org ([63.228.1.57]:35021 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932918AbXA1WKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:10:15 -0500
Subject: Re: [PATCH 0/6] MSI portability cleanups
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jeff Garzik <jeff@garzik.org>, Greg Kroah-Hartman <greg@kroah.com>,
       Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@parisc-linux.org>,
       linuxppc-dev@ozlabs.org, Brice Goglin <brice@myri.com>,
       shaohua.li@intel.com, linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <m1bqkiq25v.fsf@ebiederm.dsl.xmission.com>
References: <1169714047.65693.647693675533.qpush@cradle>
	 <m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	 <1170015805.26655.15.camel@localhost.localdomain>
	 <45BD0BDC.40205@garzik.org>  <m1bqkiq25v.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 09:09:14 +1100
Message-Id: <1170022154.26655.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 .../... (enable/disable bits)

> Which are either talking directly to the hardware, or are talking
> to the hypervisor, which is using hardware isolation so it is safe to
> talk directly to the hardware but isn't leting us?  If we could use
> things to work around errata in card implementation details it would
> make some sense to me (although we don't seem to have any cards with
> that got the MSI registers wrong at this point).  Regardless these
> operations clearly have a different granularity than the other
> operations, and should have a different lookup method.

I'm not sure I undersdand the point of your rant here. The hypervisor
case hooks at alloc/free and does everything from there. It doens't use
an enable or a diable hook.

The enable/disable ops are optional for that reason. When not present,
it's assumed that alloc/free do it all.

When using a "direct" approach (what we call "raw"), we expect backends
to just plug the provided helper functions in enable/disable. It's still
a hook so that one can do additional platform specific bits if
necessary, but in that specific case, I do agree we could just remove it
and move the "raw" code back into the toplevel functions, with a way
(via a special return code from alloc maybe ?) for the HV case to tell
us not to go through there. That was one of our initial approaches when
working with Michael on the design.

However, that sort of hurts my sense of aestetics :-) I quite like the
toplevel to be just a toplevel, and clearly separate the raw "helpers"
and the backend. Provides more flexibility to handle all possible crazy
cases in the future.

You seem to absolutely want to get the HV case to go throuh the same
code path as the "raw" case, and that will not happen.

  .../... (irq operations)

> These because they are per irq make sense as per bus operations unless
> you have a good architecture definition like x86 has.  Roughly those
> operations are what we currently have except the current operations
> are a little simpler and easier to deal with for the architecture
> code.

Oh ? How so ? (easier/simpler ?)

> And then there are the operations that are going in the wrong
> direction.
> +	/* setup_msi_msg - Setup an MSI message for the given device.
> +	 *
> +	 * @pdev:	PCI device structure.
> +	 * @entry:	The MSI entry to create a msi_msg for.
> +	 * @msg:	Written with the magic address and data.
> +	 * @type:	The type, MSI or MSI-X.
> +	 *
> +	 * Returns the "magic address and data" used to trigger the msi.
> +	 * If the setup is succesful this routine must return 0.
> +	 *
> +	 * This callback is optional.
> +	 */
> +	int (*setup_msi_msg) (struct pci_dev *pdev, struct msix_entry *entry,
> +				struct msi_msg *msg, int type);
> 
> Much to much of the operations base approach as proposed looks like
> when you have a hammer every problem looks like a nail, given how much
> confusion about what was put into the operations structure.

This is indeed a lower level hook to be used by "raw" enable/disable. An
other approach would be to remove it, have each backend have it's own
enable/disable that obtains the address/data and calls into a helper to
program them. This would indeed be a little bit nicer in a layering
perspective. But it adds a bit more code to each backend, so we kept
things closer to the way they used to be. I don't have a firm reason not
to change it however, I need talk to Michael in case he has more good
reasons to keep it that way around. 

> I don't mind taking a small step and making the alloc/free primitives
> per bus in a generic fashion. 
>
> I don't mind supporting poorly designed hypervisor interfaces, if it
> is easy.

And it it's not, we don't support them ? Ugh ? Well, it happens to be
fairly easy but still, I don't understand your approach there.

> I do strongly mind code that doesn't work, or we can't git-bisect
> through to find where bugs were introduced.

It doesn't work yet for you which is why it's not -replacing- your
current code. Again, this was intended as arch code in the first place,
until other archs and maintainers voiced their opinion that we should
move that to generic code. It may not be perfect, we may still want to
change things, maybe make some things closer to the direction you are
taking for the x86 code, but I don't understand the root of such a
strong opposition except mayeb that you've spent time trying to fix the
x86 junk and now are annoyed to see some of that work possibly
replaced ?

I agree with the problem if small changes & bisecting in the general
case. In fact, it would be nice if we could use your fixed code with
little change to "plug" it in as the x86 backend in many ways. Michael's
work isn't a re-implementation of everything, it's a re-structuring,
lots of bits of code that are missing can possibly be lifted from the
existing working implementation.

If we followed that "only do incrementental changes" rule all the time,
imagine in what state would be our USB stack today since we couldn't
have dropped in Linus replacement one ...

Ben.


