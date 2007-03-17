Return-Path: <linux-kernel-owner+w=401wt.eu-S965997AbXCQAkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965997AbXCQAkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 20:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992470AbXCQAkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 20:40:31 -0400
Received: from gw.goop.org ([64.81.55.164]:33008 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966006AbXCQAka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 20:40:30 -0400
Message-ID: <45FB38F7.5010306@goop.org>
Date: Fri, 16 Mar 2007 17:40:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
References: <20070301232443.195603797@goop.org> <20070301232527.956565107@goop.org> <20070316092445.GM23174@elte.hu> <45FAD592.9010105@goop.org> <45FB283F.6080000@vmware.com>
In-Reply-To: <45FB283F.6080000@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> I like this code very much; although it is unavoidably ugly, it is a
> nice general mechanism for doing code rewriting.  Much more
> elaboration on this below.
>

Thanks.

> static inline void local_irq_restore(const unsigned long flags)
> {
>        vmi_wrap_call(
>                SetInterruptMask, "pushl %0; popfl",
>                VMI_NO_OUTPUT,
>                1, VMI_IREG1 (flags),
>                XCONC("cc", "memory"));
> }
>
> So the constraints are obvious and tied to the inline assembly.  But
> Jeremy seems to have done even better with the vcall stuff.  Prettier:
>
> +    PVOP_VCALL0(setup_boot_clock);

Yeah, it doesn't try as hard as your example, so its all based around
the function call ABI.  If you want to inline something, you need to do
that elsewhere, which I guess is OK because that's not the
common case (only very simple cases can be replaced by inlines, and only
a few of those are worth doing).

> We went through this design exercise, and thought it was pretty
> promising.  Basically, you would reserve a set of "local" relocation
> types that should never be emitted by the toolchain.  Then you can
> have complex relocations, such as "replace pushf; popf %0 with
> arbitrary code."  You can even leave the arguments unfixed and grant
> the compiler register allocation, as long as you took care to encode
> the input / output registers somewhere (in a .reloc section of some
> sort, or encoded in the relocation type itself).

I'm pretty sure that's not what he means.  The big objection to the
PVOP_* stuff is the fact that there are these massive macros full of
inline asm to wrap the calls, which have to be invoked in a fragile
type-unsafe way.  Adding custom relocs would suffer the same problem,
since you'd need inline asm to deal with them, and I'm deathly
frightened of whatever binutils would do if you mean real relocs.

I think the suggestion is much simpler.  If you convince gcc/binutils to
leave the .reloc section in vmlinux, and make that available to the
kernel itself, then you can scan all the kernel's relocs to find ones
which refer to paravirt_ops, and use those to determine which are
callsites that can be patched.

The main upside is that all the callsites are just normal C calls;
there's no special syntax or strange macros, and we get the full benefit
of typechecking, etc.

But I can see a few downsides compared the current scheme:

   1. Identifying the callsites is a somewhat hackish process of looking
      at a reloc and doing a bit of dissassembly to see what is using
      the reloc, to identify calls and jumps
   2. There's nothing explicit to tell us how much space there is to
      patch into; we just have to assume sizeof(indirect call/jmp)
   3. There's no information about the register environment at the
      callsite, so we just have to adopt normal C ABI rules.  For the
      patch sites in hand-written asm, this could be tricky.
   4. gcc could do strange things which prevent detection of patch
      sites.  For example, it might CSE the value of, say,
      paravirt_ops.irq_enable, which would be a reasonable optimisation,
      but prevent any of the resulting indirect calls from being
      patched.  In general it relies on gcc to generate identifiable
      callsites, which is a bit unpredictable.
   5. There's still a moderate amount of binutils hackery to get the
      relocs into the right form, and there's plenty of scope for it to
      screw up.


> [ Roswell technology deleted ]

    J
