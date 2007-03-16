Return-Path: <linux-kernel-owner+w=401wt.eu-S1030234AbXCPX3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234AbXCPX3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030308AbXCPX3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:29:06 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49465 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030234AbXCPX3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:29:04 -0400
Message-ID: <45FB283F.6080000@vmware.com>
Date: Fri, 16 Mar 2007 15:29:03 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <20070301232443.195603797@goop.org> <20070301232527.956565107@goop.org> <20070316092445.GM23174@elte.hu> <45FAD592.9010105@goop.org>
In-Reply-To: <45FAD592.9010105@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Well, one thing to make clear is this is absolutely not a Xen-specific
> patch or piece of code.  This is part of the paravirt_ops infrastructure
> designed to remove the overhead of all the indirect calls which are
> scattered all over the place.  (Perhaps I should post the general
> paravirt and Xen specific patches in separate patch series to make this
> clear...).
>
> The idea is to wrap the callsite itself with in the same manner as the
> other altinstructions so that the general patcher can, at the very
> least, convert the indirect call to a direct one, or nop it out if its
> an indirect call.  This means that a pv_ops implementation can get about
> 90% of the benefit of patching without any extra effort.
>   

I like this code very much; although it is unavoidably ugly, it is a 
nice general mechanism for doing code rewriting.  Much more elaboration 
on this below.

> So, I disagree with your characterisation that its "limited"; this is a
> pretty general mechanism.  The fragile part is in using the PVOP_*
> macros properly to match the ABI's calling convention, particularly with
> tricky cases like passed and returned structures and 64-bit args.  But
> that just needs to be done once in one place, and is otherwise
> self-contained.
>   

You could just use the VMI ABI, then patch everything at runtime to call 
into the Xen paravirt-ops backend ;)

> I would love a better mechanism.  I played with using things like gcc's
> builtin_apply stuff, and so on, but I could find no way to get gcc to
> set up the args and then be able to just emit the call itself under asm
> control.
>   

I fought tooth and nail to get something cleaner than this for VMI back 
when it was a subarch.  In the end, the best I could do was wrap the 
constraints into prettier macros so the asm volatile stuff wasn't 
sticking out everywhere.  It was pretty, but the macros were so 
grotesque that I was exiled from my home planet.

static inline void local_irq_restore(const unsigned long flags)
{
        vmi_wrap_call(
                SetInterruptMask, "pushl %0; popfl",
                VMI_NO_OUTPUT,
                1, VMI_IREG1 (flags),
                XCONC("cc", "memory"));
}

So the constraints are obvious and tied to the inline assembly.  But 
Jeremy seems to have done even better with the vcall stuff.  Prettier:

+	PVOP_VCALL0(setup_boot_clock);



>
> I haven't looked at Dave's reply in detail, but I saw some mention of
> using relocs.  The idea is intriguing , but I don't quite see how it
> would all fit together.
>   

We went through this design exercise, and thought it was pretty 
promising.  Basically, you would reserve a set of "local" relocation 
types that should never be emitted by the toolchain.  Then you can have 
complex relocations, such as "replace pushf; popf %0 with arbitrary 
code."  You can even leave the arguments unfixed and grant the compiler 
register allocation, as long as you took care to encode the input / 
output registers somewhere (in a .reloc section of some sort, or encoded 
in the relocation type itself).

Now you can make complex decisions at runtime, and apply choice 
functions to these relocations that can cope with a variety of different 
circumstances - you could encode not just paravirt-ops as relocations, 
but all of the alternative instructions, and smp alternatives, and even 
higher level constructs, such as choices made by the user with the 
kernel command line - some potential examples:

acpi=noirq
idle=halt

With proper synchronization, using something like stop_machine_run, you 
can even make these choices dynamically, and then relink the kernel in 
place to take faster paths.  And the technique is universal, so you 
could use it cross architecture, which would be really helpful for 
architectures that say, have really slow indirect branches.

Once the technique gains wide acceptance, you could use it for all 
kernel interfaces which have static function pointers for the post-init 
lifetime of the kernel.  Which might contribute to a global performance 
improvement of perhaps a couple percent.  But the cost is clearly the 
complexity.

I just had a slightly interesting idea - you could even catch bugs where 
dynamic assignments to function pointers fail to update the appropriate 
patch sites by checking for non .init code sections which write through 
accelerated_fn_ptr_t's using static checking from sparse.

Is that sort of what you were thinking of Dave?

Zach
