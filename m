Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYGLWbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYGLWbK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 18:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYGLWa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 18:30:57 -0400
Received: from mercury.realtime.net ([205.238.132.86]:33387 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751759AbYGLWa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 18:30:57 -0400
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <7b8dd1f1421b1f52ebc76565986fd2a9@bga.com>
Content-Transfer-Encoding: 7bit
Cc: ppcdev <linuxppc-dev@ozlabs.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Milton Miller <miltonm@bga.com>
Subject: Re: linux-next: kbuild tree build failure
Date: Sat, 12 Jul 2008 17:32:28 -0500
To: Roman Zippel <zippel@linux-m68k.org>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In-Reply-To: <Pine.LNX.4.64.0807101654080.6791@localhost.localdomain>

On Fri Jul 11 00:59:25 EST 2008, Roman Zippel wrote:
> On Thu, 10 Jul 2008, Michael Ellerman wrote:
>
> > Well yes :)  But I think that's because you're thinking of
> > "end-users" and I'm thinking of "users" like myself - ie. _I_ use
> > Kconfig and I do expect myself to be able to type a 64-bit address.
>
> That doesn't really answer my question, why you need this.
>
> > > > --- .config.orig  2008-07-08 09:30:00.000000000 +1000
> > > > +++ .config       2008-07-08 09:30:43.000000000 +1000
> > > > @@ -370,9 +370,8 @@
> > > >  CONFIG_HOTPLUG_PCI_RPA=m
> > > >  CONFIG_HOTPLUG_PCI_RPA_DLPAR=m
> > > >  # CONFIG_HAS_RAPIDIO is not set
> > > > -CONFIG_PAGE_OFFSET=0xc000000000000000
> > > > -CONFIG_KERNEL_START=0xc000000002000000
> > > > -CONFIG_PHYSICAL_START=0x02000000
> > > > +CONFIG_PAGE_OFFSET=0xc0000000
> > > > +CONFIG_PHYSICAL_START=0x2000000
> > >
> > > Why is this worse? These are constants, you're not supposed to 
> change them
> > > anyway.
> > > The remaining values are generated in page.h and should be the 
> same as
> > > before. If that isn't the case and this patch produces a nonworking
> > > kernel, I'd like to hear about it.
> >
> > You're right the built kernel is fine. So it's not a bug,
>

But its horrible code.

> Good, could someone please ack whether the powerpc changes are 
> acceptable?
>

Well, since no one else has said it,
NAK

The primary reason I object is this:
>>>> Index: linux-2.6/include/asm-powerpc/page.h
>>>> ===================================================================
>>>> --- linux-2.6.orig/include/asm-powerpc/page.h
>>>> +++ linux-2.6/include/asm-powerpc/page.h
>>>> @@ -67,9 +67,15 @@
>>>>   * If you want to test if something's a kernel address, use 
>>>> is_kernel_addr().
>>>>   */
>>>>
>>>> -#define KERNELBASE      ASM_CONST(CONFIG_KERNEL_START)
>>>> +#ifdef CONFIG_PPC64
>>>> +#define PAGE_OFFSET    (ASM_CONST(CONFIG_PAGE_OFFSET) << 32)
>>>> +#define KERNELBASE     
>>>> (PAGE_OFFSET+ASM_CONST(CONFIG_PHYSICAL_START))
>>>> +#define LOAD_OFFSET    PAGE_OFFSET
>>>> +#else
>>>> +#define KERNELBASE     ASM_CONST(CONFIG_KERNEL_START)
>>>>  #define PAGE_OFFSET    ASM_CONST(CONFIG_PAGE_OFFSET)
>>>> -#define LOAD_OFFSET    
>>>> ASM_CONST((CONFIG_KERNEL_START-CONFIG_PHYSICAL_START))
>>>> +#define LOAD_OFFSET    
>>>> (ASM_CONST(CONFIG_KERNEL_START)-ASM_CONST(CONFIG_PHYSICAL_START))
>>>> +#endif
>>>>
>>>>  #if defined(CONFIG_RELOCATABLE) && defined(CONFIG_FLATMEM)
>>>>  #ifndef __ASSEMBLY__

(1) #define PAGE_OFFSET    (ASM_CONST(CONFIG_PAGE_OFFSET) << 32)

It creates unreadable code, where two defines with almost the same name 
(the only difference being
the CONFIG_ prefix, which is often ignored when scanning) contains 
radically different values.

(2)  #define PAGE_OFFSET    ASM_CONST(CONFIG_PAGE_OFFSET)

It creates config variables that mean different things depending on 
other config variables
The 32 and 64 bit powerpc kernel share a common source, a config 
variable should be used for
only one purpose.



> > but I think it is nicer to have the real values in the .config.
>
> Why?

Mostly consistency between the different portions of the archticture.

As I remember, this code was adjusted and some of the defines moved 
from page.h
as part of the 32 bit relocatable kernel for 85xx booke ASMP support.

The 32 bit kernel has advanced options to change the VMA split, which 
enable
direct user input when explicitly defined.  That allows us to not need 
patches
for the embedded boards who need some other split than 3G/1G.  So there
is the reason that we have this directly specified in Kconfig at all.

While the 64 bit kernel doesn't need to actually change the page 
offset, as we
don't support the full 64 bits of the real address anyways (in fact, the
archtiecture prevents us from doing so) and therefore don't need to 
adjust
the effective address spilt between user and kernel.

But introducing config variables that mean different things is 
UNMAINTAINABLE.

Also, I remember, CONFIG_PAGE_OFFSET is used by the linker script and 
previously
page.h was conditionally included.   Does it always include page.h now?



On a seperate note,
>>>>  config PINT3_ASSIGN
>>>>         hex "PINT3_ASSIGN"
>>>>         depends on PINTx_REASSIGN
>>>> -       default 0x02020303
>>>> +       default 0x2020303

is harder to read.   The value is a list of 4 1 byte values, but you 
have hidden the first nibble making parsing the rest of the value hard.

>>>>
>>>>  config IRAM_SIZE
>>>>         hex "Internal memory size (hex)"
>>>>         depends on (CHIP_M32700 || CHIP_M32102 || CHIP_VDEC2 || 
>>>> CHIP_OPSP || CHIP_M32104) && DISCONTIGMEM
>>>> -       default "00080000" if CHIP_M32700
>>>> -       default "00010000" if CHIP_M32102 || CHIP_OPSP || 
>>>> CHIP_M32104
>>>> -       default "00008000" if CHIP_VDEC2
>>>> +       default "0x80000" if CHIP_M32700
>>>> +       default "0x10000" if CHIP_M32102 || CHIP_OPSP || CHIP_M32104
>>>> +       default "0x8000" if CHIP_VDEC2

Likewize, I find it easier to mentally check the order of magnitude and 
compare sizes when they have
leading zeros and are right aligned.


Going to another email in the thread,

On Fri Jul 11 00:52:25 EST 2008, Roman Zippel wrpte:
> On Tue, 8 Jul 2008, Sam Ravnborg wrote:
> > We use Kconfig for a mixture of user editable values and fixed
> > configuration values.
> > And I agree that asking the user to input a 64 bit number is not 
> usefull.
> >
> > But keeping support for 64 bit values is what I would consider
> > expected functionality.
...
> > > This would also ease on any portability issues
> > > (kconfig is compiled with the host compiler not the target 
> compiler).
> >
> > We use strtol() in a few places in symbol.c already where we do an
> > implicit conversion to int. Why did this not cause us problems 
> before?
> >
> > Is it because these code paths are only triggered when we deal with 
> ranges?
> > If so we could 'fix' strdup_type() to not use strto{,u}l() so it
> > is 64 bit clean and we are back to old behaviour.
>
> Ranges are the primary reason I made it consistent with this.
> If we really wanted to support 64bit numbers, it would create only more
> problems. First you have to make sure that on every build host (i.e 
> also
> non-Linux) strtoll() is available. Then how it should these numbers be
> represented? On 32bit these may need a 'll' postfix, but the powerpc
> example already shows, that there are different requirements, so they 
> use
> ASM_CONST for that. How should this postprecessing be integrated into
> kconfig?

I think the architectures will already do something like ASM_CONST in
their C code when its needed.  This should not be the responsibility of
kbuild.

If you are worried about users tring to set values that are too high,
then make the types be hex8, hex16, hex32, and hex64.

milton

