Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0BJBav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:30:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab0BJBas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:30:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 2/4] x86, ptrace: regset extensions to support xstate
In-Reply-To: Suresh Siddha's message of  Tuesday, 9 February 2010 12:13:11 -0800 <20100209202502.216592031@sbs-t61.sc.intel.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
	<20100209202502.216592031@sbs-t61.sc.intel.com>
X-Shopping-List: (1) Grievous fruit beef
   (2) Mythical characteristic import rodents
   (3) Detrimental dandelion will-o'-the-wisps
   (4) Aquatic stone tables
   (5) Asymmetrical destroyer welts
Message-Id: <20100210013031.208FB73D8@magilla.sf.frob.com>
Date: Tue,  9 Feb 2010 17:30:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add the xstate regset support which helps extend the kernel ptrace and the
> core-dump interfaces to support AVX state etc.
> 
> This regset interface is designed to support all the future state that gets
> supported using xsave/xrstor infrastructure.

Looks good modulo cosmetic nits below.

> And hence the xsave memory layout available through this regset
> interface uses SW usable bytes [464..511] to convey what state is represented
> in the memory layout.
> 
> First 8 bytes of the sw_usable_bytes[464..467] will be set to OS enabled xstate
> mask(which is same as the 64bit mask returned by the xgetbv's xCR0).

I'd like to see some macros or struct or something in some user-visible
header (ptrace-abi.h I guess?) that instruct userland where to find this
software-defined word.  The rest of the layout and meaning is specified by
the chip manuals and it's only a question of convenience if we want to help
userland out with those bits.  But the use of the reserved-for-software
area to store a bitmask (or whatever else Linux might put there in the
future) is entirely a Linux invention that needs to be a clear and explicit
part of this userland ABI format.

> +/*
> + * The xfpregs_active() routine is same as the fpregs_active() routine,

s/xfpregs_active/xstateregs_active/
s/is same/is the same/

> @@ -204,8 +209,6 @@ int xfpregs_set(struct task_struct *targ
>  	if (ret)
>  		return ret;
>  
> -	set_stopped_child_used_math(target);
> -

You didn't mention this change in a comment or log entry.
It looks like it's superfluous after init_fpu.  So this change
is right, but AFAICT it belongs in an entirely separate patch
and has nothing to do with xsave support.

> +int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
> +		unsigned int pos, unsigned int count,
> +		void *kbuf, void __user *ubuf)
> +{
> +	int ret;
> +	int size = regset->n * regset->size;
[...]
> +		/*
> +		 * Copy the rest of xstate memory layout
> +		 */
> +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +					  xsave_hdr,
> +					  offsetof(struct xsave_struct,
> +						   xsave_hdr), size);

This calculation is unnecessary (though it doesn't hurt); you can just use
-1 here.  The arch user_regset.get and user_regset.set functions are not
required to worry about bogus arguments.  Their callers are required to
pass values that don't violate the .n, .size, and .align constraints in the
user_regset.

> +int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
> +		  unsigned int pos, unsigned int count,
> +		  const void *kbuf, const void __user *ubuf)
> +{
> +	int ret;
> +	int size = regset->n * regset->size;
[...]
> +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +				 &target->thread.xstate->xsave, 0, size);

Same here.

> +	[REGSET_XSTATE] = {
> +		.core_note_type = NT_X86_XSTATE,
> +		.size = sizeof(long), .align = sizeof(long),
[...]
> +	[REGSET_XSTATE] = {
> +		.core_note_type = NT_X86_XSTATE,
> +		.size = sizeof(u32), .align = sizeof(u32),

Isn't the xsave format is really the same for 32-bit and 64-bit?
All its components are naturally 64 bits or larger, right?

If that's correct, I think it would be better to make the 32 and 64 version
of the regset uniform with .size and .align being sizeof(u64).

> +u64 xstate_fx_sw_bytes[6];
> +void update_regset_xstate_info(unsigned int size, u64 xstate_mask)
> +{
> +#ifdef CONFIG_X86_64
> +	x86_64_regsets[REGSET_XSTATE].n = size / sizeof(long);
> +#endif
> +#if defined CONFIG_X86_32 || defined CONFIG_IA32_EMULATION
> +	x86_32_regsets[REGSET_XSTATE].n = size / sizeof(u32);
> +#endif

Just change these to / sizeof(u64) accordingly.


Thanks,
Roland
