Return-Path: <linux-kernel-owner+w=401wt.eu-S964923AbXBFQIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923AbXBFQIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964860AbXBFQIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:08:45 -0500
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:60900 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964845AbXBFQIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:08:41 -0500
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Tue, 6 Feb 2007 17:08:28 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: ebiederm@xmission.com
cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       discuss@x86-64.org, "Richard Gooch" <rgooch@safe-mbox.com>
Subject: Re: [patch] mtrr: fix issues with large addresses
Message-ID: <20070206160828.GH8665@alberich.amd.com>
References: <20070205171959.GF8665@alberich.amd.com>
 <m13b5kw2qj.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
In-Reply-To: <m13b5kw2qj.fsf@ebiederm.dsl.xmission.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 06 Feb 2007 16:08:30.0455 (UTC)
 FILETIME=[0B16C070:01C74A09]
X-WSS-ID: 69D677882MC7245509-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 05:26:12PM -0700, ebiederm@xmission.com wrote:
> "Andreas Herrmann" <andreas.herrmann3@amd.com> writes:
> > mtrr: fix issues with large addresses
> >
> > Fixes some issues with /proc/mtrr interface:
> > o If physical address size crosses the 44 bit boundary
> >   size_or_mask is evaluated wrong
> > o size_and_mask limits physical base
> >   address for an MTRR to be less than 44 bit
> > o added check to restrict base address to 36 bit on i386
> 
> The limit is per cpu not per architecture.  So if you run a
> cpu that can run in 64bit mode in 32bit mode the limit
> is not 36 bits.  Even PAE in 32bit mode doesn't have that limit.
> 

Good point.

I totally ignored that on 64 bit cpus in legacy mode
- PAE-paging means up to 52 physical address bits respectively
"physical address size of the underlying implementation"
- for non-PAE-paging with PSE enabled we have 40 bits for AMD and
with PSE36 36 bits for Intel

What a mess.
(Hope anyone knows for sure which paging methods are relevant for
Linux if compiled for i386 and w/o CONFIG_X86_64?)

(Seems that in my mind this legacy stuff is still tied to 36 and 32
bits :(

> > diff --git a/arch/i386/kernel/cpu/mtrr/generic.c
> > b/arch/i386/kernel/cpu/mtrr/generic.c
> > index f77fc53..aa21d15 100644
> > --- a/arch/i386/kernel/cpu/mtrr/generic.c
> > +++ b/arch/i386/kernel/cpu/mtrr/generic.c
> > @@ -172,7 +172,7 @@ int generic_get_free_region(unsigned long base, unsigned
> > long size, int replace_
> >  static void generic_get_mtrr(unsigned int reg, unsigned long *base,
> >  			     unsigned long *size, mtrr_type *type)
> >  {
> > -	unsigned int mask_lo, mask_hi, base_lo, base_hi;
> > +	unsigned long mask_lo, mask_hi, base_lo, base_hi;
> 
> Why?  Given the low and the high I am assuming these are all implicitly
> 32bit quantities.  unsigned int is fine.

It is not, please refer to the function body, e.g.

	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;

All leading 20 bits of "unsigned int" base_hi are snipped away. Thus
limiting base to use 44 bit instead of 52 bit in 64 bit mode. An
option would have been to use a type cast while shifting.

(Hmm, having your first remark in mind I have to admit that my fix is
mainly focused on 64 bit mode not on 64 bit cpu running in 32 bit ...)

> > diff --git a/arch/i386/kernel/cpu/mtrr/if.c b/arch/i386/kernel/cpu/mtrr/if.c
> > index 5ae1705..3abc3f1 100644
> > --- a/arch/i386/kernel/cpu/mtrr/if.c
> > +++ b/arch/i386/kernel/cpu/mtrr/if.c
> > @@ -137,6 +137,10 @@ mtrr_write(struct file *file, const char __user *buf,
> > size_t len, loff_t * ppos)
> >  	for (i = 0; i < MTRR_NUM_TYPES; ++i) {
> >  		if (strcmp(ptr, mtrr_strings[i]))
> >  			continue;
> > +#ifndef CONFIG_X86_64
> > +		if (base > 0xfffffffffULL)
> > +			return -EINVAL;
> > +#endif
> 
> That is just silly.  If the cpu is running in long mode or should
> not affect this capability.

Yes, that check is wrong -- due to my wrong assumption.
Base can use 52 bits not just 36 bits in 32 bit mode on 64 bit cpu.

My intention was to avoid the silent truncation of base address
in the following lines:

		base >>= PAGE_SHIFT;
		size >>= PAGE_SHIFT;
		err =
		    mtrr_add_page((unsigned long) base, ...

where base is cut at bit 44 due to the type cast.

The user doing
	#> echo 0x100000000000 size=0x0815000 type=uncachable >/proc/mtrr
will end up with a new MTRR pair having PhysBase==0x0. (At least this
will give him some time to get a coffee when his system reboots after
the crash.)

So it seems that some more stuff needs to be fixed in the mtrr code.
All unsigned long base addresses used in this code implicitly restrict
the address to 44 bit (taking the PAGE_SHIFT into account).

So I could do one of the following:
(1) prepare new patch omitting this silly hunk (-> old behaviour)
(2) check for 44 bit address size instead of 36 bit address size to
reflect the implicit truncation (-> avoid silent truncation)
(3) fix all mtrr code to be able to use up to 52 bit width physical
addresses instead of 44 bit ones if running in 32 bit mode on 64 bit
cpus.

I prefer to do (2).
(IMHO those who have the need for n>44 bit width base address in an MTRR
should stick to 64 bit mode.)

> > diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
> > index 16bb7ea..0acfb6a 100644
> > --- a/arch/i386/kernel/cpu/mtrr/main.c
> > +++ b/arch/i386/kernel/cpu/mtrr/main.c
> > @@ -50,7 +50,7 @@ u32 num_var_ranges = 0;
> >  unsigned int *usage_table;
> >  static DEFINE_MUTEX(mtrr_mutex);
> >  
> > -u32 size_or_mask, size_and_mask;
> > +u64 size_or_mask, size_and_mask;
> >  
> >  static struct mtrr_ops * mtrr_ops[X86_VENDOR_NUM] = {};
> >  
> > @@ -662,8 +662,8 @@ void __init mtrr_bp_init(void)
> >  			     boot_cpu_data.x86_mask == 0x4))
> >  				phys_addr = 36;
> >  
> > -			size_or_mask = ~((1 << (phys_addr - PAGE_SHIFT)) - 1);
> > -			size_and_mask = ~size_or_mask & 0xfff00000;
> > + size_or_mask = ~((1ULL << (phys_addr - PAGE_SHIFT)) - 1);
> > +			size_and_mask = ~size_or_mask & 0xfffff00000ULL;
> 
> Don't you want to make this hard coded mask 0xfffffffffff00000ULL?
> 

No.

(That mask is used for values already right shifted by PAGE_SHIFT. So
at least the upper three nibbles should be zero. And I recommend to
zero out also all bits betwenn 52 and 63.)

AFAIK size_and_mask is used to mask the address bits above 32 bits
in PhysBase and PhysMask.
0xfffff00000 << PAGE_SHIFT will mask the upper bits of PhysBase and
PhysMask up to the 52nd bit (counted from 1).

And 52 bit physical address size is exactly what both AMD and Intel
specify as the "architectural limit" in their programmer manuals for
64 bit mode.

> Eric
> 

Thanks for your comments.


Regards,

Andreas

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center



