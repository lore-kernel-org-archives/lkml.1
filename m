Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXBFRzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXBFRzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 12:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964784AbXBFRzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 12:55:43 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54925 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040AbXBFRzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 12:55:42 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       discuss@x86-64.org, "Richard Gooch" <rgooch@safe-mbox.com>
Subject: Re: [patch] mtrr: fix issues with large addresses
References: <20070205171959.GF8665@alberich.amd.com>
	<m13b5kw2qj.fsf@ebiederm.dsl.xmission.com>
	<20070206160828.GH8665@alberich.amd.com>
Date: Tue, 06 Feb 2007 10:54:23 -0700
In-Reply-To: <20070206160828.GH8665@alberich.amd.com> (Andreas Herrmann's
	message of "Tue, 6 Feb 2007 17:08:28 +0100")
Message-ID: <m1sldjtbn4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Andreas Herrmann" <andreas.herrmann3@amd.com> writes:

> On Mon, Feb 05, 2007 at 05:26:12PM -0700, ebiederm@xmission.com wrote:
>> "Andreas Herrmann" <andreas.herrmann3@amd.com> writes:
>> > mtrr: fix issues with large addresses
>> >
>> > Fixes some issues with /proc/mtrr interface:
>> > o If physical address size crosses the 44 bit boundary
>> >   size_or_mask is evaluated wrong
>> > o size_and_mask limits physical base
>> >   address for an MTRR to be less than 44 bit
>> > o added check to restrict base address to 36 bit on i386
>> 
>> The limit is per cpu not per architecture.  So if you run a
>> cpu that can run in 64bit mode in 32bit mode the limit
>> is not 36 bits.  Even PAE in 32bit mode doesn't have that limit.
>> 
>
> Good point.
>
> I totally ignored that on 64 bit cpus in legacy mode
> - PAE-paging means up to 52 physical address bits respectively
> "physical address size of the underlying implementation"
> - for non-PAE-paging with PSE enabled we have 40 bits for AMD and
> with PSE36 36 bits for Intel

For non PAE-paging you have 32bits.

The real question is how many physical bits does the cpu implemented
for bus transactions.  The latest Intel (non-ia64) cpus are at 40 bits
I believe, and the cutting edge AMD cpus are moving to 48bits.  The
Intel bus protocol supports 50 bits physical at least in it's ia64
incarnation so I believe some of the chipsets may actually support
that.

> What a mess.
> (Hope anyone knows for sure which paging methods are relevant for
> Linux if compiled for i386 and w/o CONFIG_X86_64?)

PAE does get used on i386, but except that it is a related phenomenon
it isn't relevant.

> (Seems that in my mind this legacy stuff is still tied to 36 and 32
> bits :(

Basically Intel had 36 bits implemented for so long it just got
stuck in everyones heads.  Forget that.  It is a question of
how many physical address bits the cpu uses when generating bus
cycles.  Nothing about the mode the cpu is running in matters.

>> > diff --git a/arch/i386/kernel/cpu/mtrr/generic.c
>> > b/arch/i386/kernel/cpu/mtrr/generic.c
>> > index f77fc53..aa21d15 100644
>> > --- a/arch/i386/kernel/cpu/mtrr/generic.c
>> > +++ b/arch/i386/kernel/cpu/mtrr/generic.c
>> > @@ -172,7 +172,7 @@ int generic_get_free_region(unsigned long base, unsigned
>> > long size, int replace_
>> >  static void generic_get_mtrr(unsigned int reg, unsigned long *base,
>> >  			     unsigned long *size, mtrr_type *type)
>> >  {
>> > -	unsigned int mask_lo, mask_hi, base_lo, base_hi;
>> > +	unsigned long mask_lo, mask_hi, base_lo, base_hi;
>> 
>> Why?  Given the low and the high I am assuming these are all implicitly
>> 32bit quantities.  unsigned int is fine.
>
> It is not, please refer to the function body, e.g.
>
> 	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
>
> All leading 20 bits of "unsigned int" base_hi are snipped away. Thus
> limiting base to use 44 bit instead of 52 bit in 64 bit mode. An
> option would have been to use a type cast while shifting.
>
> (Hmm, having your first remark in mind I have to admit that my fix is
> mainly focused on 64 bit mode not on 64 bit cpu running in 32 bit ...)

Yes.  So base needs to be come a u64. 

So base = ((base_hi << 32) | base_lo) >> PAGE_SHIFT.

I see where the 44bit limit comes in.  Do you actually have boxes
with > 16TB?

Regardless it looks like base and possibly size needs to become
a u64.  At which time the extra >> PAGE_SHIFT could be meaningless.
Either that or because base and size need to be sized in something like
megabytes.

I suspect making it a u64 sized in bytes will get the job done and
result in simpler code.


>> > diff --git a/arch/i386/kernel/cpu/mtrr/if.c b/arch/i386/kernel/cpu/mtrr/if.c
>> > index 5ae1705..3abc3f1 100644
>> > --- a/arch/i386/kernel/cpu/mtrr/if.c
>> > +++ b/arch/i386/kernel/cpu/mtrr/if.c
>> > @@ -137,6 +137,10 @@ mtrr_write(struct file *file, const char __user *buf,
>> > size_t len, loff_t * ppos)
>> >  	for (i = 0; i < MTRR_NUM_TYPES; ++i) {
>> >  		if (strcmp(ptr, mtrr_strings[i]))
>> >  			continue;
>> > +#ifndef CONFIG_X86_64
>> > +		if (base > 0xfffffffffULL)
>> > +			return -EINVAL;
>> > +#endif
>> 
>> That is just silly.  If the cpu is running in long mode or should
>> not affect this capability.
>
> Yes, that check is wrong -- due to my wrong assumption.
> Base can use 52 bits not just 36 bits in 32 bit mode on 64 bit cpu.
>
> My intention was to avoid the silent truncation of base address
> in the following lines:
>
> 		base >>= PAGE_SHIFT;
> 		size >>= PAGE_SHIFT;
> 		err =
> 		    mtrr_add_page((unsigned long) base, ...
>
> where base is cut at bit 44 due to the type cast.
>
> The user doing
> 	#> echo 0x100000000000 size=0x0815000 type=uncachable >/proc/mtrr
> will end up with a new MTRR pair having PhysBase==0x0. (At least this
> will give him some time to get a coffee when his system reboots after
> the crash.)
>
> So it seems that some more stuff needs to be fixed in the mtrr code.
> All unsigned long base addresses used in this code implicitly restrict
> the address to 44 bit (taking the PAGE_SHIFT into account).
>
> So I could do one of the following:
> (1) prepare new patch omitting this silly hunk (-> old behaviour)
> (2) check for 44 bit address size instead of 36 bit address size to
> reflect the implicit truncation (-> avoid silent truncation)
> (3) fix all mtrr code to be able to use up to 52 bit width physical
> addresses instead of 44 bit ones if running in 32 bit mode on 64 bit
> cpus.
>
> I prefer to do (2).
> (IMHO those who have the need for n>44 bit width base address in an MTRR
> should stick to 64 bit mode.)

I prefer (3).  Since the code is shared between 32 and 64bit mode it
should behave the same in both.  I know there are people who regularly
test 32bit kernels on boxes with 128 cpus and 128MB of ram.

People sometimes want crazy things and since it just a matter of changing
the type it should be no real work to get the code to work in 32bit mode.

>> > diff --git a/arch/i386/kernel/cpu/mtrr/main.c
> b/arch/i386/kernel/cpu/mtrr/main.c
>> > index 16bb7ea..0acfb6a 100644
>> > --- a/arch/i386/kernel/cpu/mtrr/main.c
>> > +++ b/arch/i386/kernel/cpu/mtrr/main.c
>> > @@ -50,7 +50,7 @@ u32 num_var_ranges = 0;
>> >  unsigned int *usage_table;
>> >  static DEFINE_MUTEX(mtrr_mutex);
>> >  
>> > -u32 size_or_mask, size_and_mask;
>> > +u64 size_or_mask, size_and_mask;
>> >  
>> >  static struct mtrr_ops * mtrr_ops[X86_VENDOR_NUM] = {};
>> >  
>> > @@ -662,8 +662,8 @@ void __init mtrr_bp_init(void)
>> >  			     boot_cpu_data.x86_mask == 0x4))
>> >  				phys_addr = 36;
>> >  
>> > -			size_or_mask = ~((1 << (phys_addr - PAGE_SHIFT)) - 1);
>> > -			size_and_mask = ~size_or_mask & 0xfff00000;
>> > + size_or_mask = ~((1ULL << (phys_addr - PAGE_SHIFT)) - 1);
>> > +			size_and_mask = ~size_or_mask & 0xfffff00000ULL;
>> 
>> Don't you want to make this hard coded mask 0xfffffffffff00000ULL?
>> 
>
> No.
>
> (That mask is used for values already right shifted by PAGE_SHIFT. So
> at least the upper three nibbles should be zero. And I recommend to
> zero out also all bits betwenn 52 and 63.)
>
> AFAIK size_and_mask is used to mask the address bits above 32 bits
> in PhysBase and PhysMask.
> 0xfffff00000 << PAGE_SHIFT will mask the upper bits of PhysBase and
> PhysMask up to the 52nd bit (counted from 1).
>
> And 52 bit physical address size is exactly what both AMD and Intel
> specify as the "architectural limit" in their programmer manuals for
> 64 bit mode.

Ok. I had earlier missed the PAGE_SHIFT shenanigans the code is playing.

Eric
