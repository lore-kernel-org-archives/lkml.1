Return-Path: <linux-kernel-owner+w=401wt.eu-S1752283AbXBFSm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbXBFSm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXBFSm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:42:27 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:12445 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbXBFSm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:42:26 -0500
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Tue, 6 Feb 2007 19:42:13 +0100
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: ebiederm@xmission.com
cc: discuss@x86-64.org, "Richard Gooch" <rgooch@safe-mbox.com>,
       "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [discuss] [patch] mtrr: fix issues with large addresses
Message-ID: <20070206184213.GA4628@alberich.amd.com>
References: <20070205171959.GF8665@alberich.amd.com>
 <m13b5kw2qj.fsf@ebiederm.dsl.xmission.com>
 <20070206160828.GH8665@alberich.amd.com>
 <m1sldjtbn4.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
In-Reply-To: <m1sldjtbn4.fsf@ebiederm.dsl.xmission.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 06 Feb 2007 18:42:15.0576 (UTC)
 FILETIME=[85B08180:01C74A1E]
X-WSS-ID: 69D613802KW7181974-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 10:54:23AM -0700, ebiederm@xmission.com wrote:
> "Andreas Herrmann" <andreas.herrmann3@amd.com> writes:
> > On Mon, Feb 05, 2007 at 05:26:12PM -0700, ebiederm@xmission.com wrote:
> >> "Andreas Herrmann" <andreas.herrmann3@amd.com> writes:
> >> >
> >> The limit is per cpu not per architecture.  So if you run a
> >> cpu that can run in 64bit mode in 32bit mode the limit
> >> is not 36 bits.  Even PAE in 32bit mode doesn't have that limit.
> >> 
> > Good point.
> >
> > I totally ignored that on 64 bit cpus in legacy mode
> > - PAE-paging means up to 52 physical address bits respectively
> > "physical address size of the underlying implementation"
> > - for non-PAE-paging with PSE enabled we have 40 bits for AMD and
> > with PSE36 36 bits for Intel
> 
> For non PAE-paging you have 32bits.

You are referring to current Linux implementation?
The AMD64 architecture increased physical address size in PSE mode to
40 bits. So at least it would be possible to use more than 32 bits.

> >> > diff --git a/arch/i386/kernel/cpu/mtrr/generic.c
> >> > b/arch/i386/kernel/cpu/mtrr/generic.c
> >> > index f77fc53..aa21d15 100644
> >> > --- a/arch/i386/kernel/cpu/mtrr/generic.c
> >> > +++ b/arch/i386/kernel/cpu/mtrr/generic.c
> >> > @@ -172,7 +172,7 @@ int generic_get_free_region(unsigned long base, unsigned
> >> > long size, int replace_
> >> >  static void generic_get_mtrr(unsigned int reg, unsigned long *base,
> >> >  			     unsigned long *size, mtrr_type *type)
> >> >  {
> >> > -	unsigned int mask_lo, mask_hi, base_lo, base_hi;
> >> > +	unsigned long mask_lo, mask_hi, base_lo, base_hi;
> >> 
> >> Why?  Given the low and the high I am assuming these are all implicitly
> >> 32bit quantities.  unsigned int is fine.
> >
> > It is not, please refer to the function body, e.g.
> >
> > 	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
> >
> > All leading 20 bits of "unsigned int" base_hi are snipped away. Thus
> > limiting base to use 44 bit instead of 52 bit in 64 bit mode. An
> > option would have been to use a type cast while shifting.
> >
> > (Hmm, having your first remark in mind I have to admit that my fix is
> > mainly focused on 64 bit mode not on 64 bit cpu running in 32 bit ...)
> 
> Yes.  So base needs to be come a u64. 

I was afraid you'ld say that.

> So base = ((base_hi << 32) | base_lo) >> PAGE_SHIFT.
> 
> I see where the 44bit limit comes in.  Do you actually have boxes
> with > 16TB?

No, I don't have access to such a box. Would be nice though.

> 
> Regardless it looks like base and possibly size needs to become
> a u64.  At which time the extra >> PAGE_SHIFT could be meaningless.
> Either that or because base and size need to be sized in something like
> megabytes.
> 
> I suspect making it a u64 sized in bytes will get the job done and
> result in simpler code.

Right you are!

> >> > diff --git a/arch/i386/kernel/cpu/mtrr/if.c b/arch/i386/kernel/cpu/mtrr/if.c
> >> > index 5ae1705..3abc3f1 100644
> >> > --- a/arch/i386/kernel/cpu/mtrr/if.c
> >> > +++ b/arch/i386/kernel/cpu/mtrr/if.c
> >> > @@ -137,6 +137,10 @@ mtrr_write(struct file *file, const char __user *buf,
> >> > size_t len, loff_t * ppos)
> >> >  	for (i = 0; i < MTRR_NUM_TYPES; ++i) {
> >> >  		if (strcmp(ptr, mtrr_strings[i]))
> >> >  			continue;
> >> > +#ifndef CONFIG_X86_64
> >> > +		if (base > 0xfffffffffULL)
> >> > +			return -EINVAL;
> >> > +#endif
> >> 
> >> That is just silly.  If the cpu is running in long mode or should
> >> not affect this capability.

	<snip>

> > So I could do one of the following:
> > (1) prepare new patch omitting this silly hunk (-> old behaviour)
> > (2) check for 44 bit address size instead of 36 bit address size to
> > reflect the implicit truncation (-> avoid silent truncation)
> > (3) fix all mtrr code to be able to use up to 52 bit width physical
> > addresses instead of 44 bit ones if running in 32 bit mode on 64 bit
> > cpus.
> >
> > I prefer to do (2).
> > (IMHO those who have the need for n>44 bit width base address in an MTRR
> > should stick to 64 bit mode.)
> 
> I prefer (3).  Since the code is shared between 32 and 64bit mode it
> should behave the same in both.  I know there are people who regularly
> test 32bit kernels on boxes with 128 cpus and 128MB of ram.
> 
> People sometimes want crazy things and since it just a matter of changing
> the type it should be no real work to get the code to work in 32bit mode.

Ok, it is best to do (3).
I will come up with another patch asap.


> Eric


Regards,

Andreas

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center



