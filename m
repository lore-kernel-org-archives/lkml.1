Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab0BLDpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 22:45:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab0BLDpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 22:45:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com,
       peter.lachner@intel.com
Subject: Re: [patch v3 1/2] x86, ptrace: regset extensions to support xstate
In-Reply-To: Suresh Siddha's message of  Thursday, 11 February 2010 11:50:59 -0800 <20100211195614.802495327@sbs-t61.sc.intel.com>
References: <20100211195058.071883111@sbs-t61.sc.intel.com>
	<20100211195614.802495327@sbs-t61.sc.intel.com>
X-Shopping-List: (1) Rancorous subservient detergents
   (2) Periodical devotions
   (3) Infectious friction
Message-Id: <20100212034520.0FABFC821@magilla.sf.frob.com>
Date: Thu, 11 Feb 2010 19:45:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * First copy the fxsave bytes 0..463.
> +	 */
> +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +				  &target->thread.xstate->xsave, 0,
> +				  offsetof(struct user_xstateregs,
> +					   i387.xstate_fx_sw));
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Copy the 48bytes defined by software.
> +	 */
> +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +				  xstate_fx_sw_bytes,
> +				  offsetof(struct user_xstateregs,
> +					   i387.xstate_fx_sw),
> +				  offsetof(struct user_xstateregs,
> +					   xsave_hdr));
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Copy the rest of xstate memory layout.
> +	 */
> +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +				  &target->thread.xstate->xsave.xsave_hdr,
> +				  offsetof(struct user_xstateregs,
> +					   xsave_hdr), -1);
> +	return ret;

I don't know why this didn't occur to me before.  Is there a reason not to
just copy xstate_fx_sw_bytes into the thread.xstate buffer?  You could just
do it right here, or in the places that really touch thread.xstate contents.

Then the trivial single user_regset_copyout() call would be all you need
here, and that seems simpler.  IMHO it's enough simpler that even if you
pay the 6-words memcpy every time here, it's worth it.

If you don't want to do that, that's fine too.  
The code looks correct as it is.

> --- tip.orig/arch/x86/include/asm/user.h
> +++ tip/arch/x86/include/asm/user.h

I don't have any special opinions about the placement, naming, etc. of
these asm/user.h bits (just that there be some symbolic form of the ABI
somewhere).  But perhaps folks want to think about it a bit more before we
bake it into the source API.

These definitions duplicate the asm/processor.h ones used inside the kernel.
IMHO these should be consolidated so asm/processor.h refers to the public types.

I'm not sure whether 'struct user_*' names make most sense for these or not.
They are processor-defined layouts.

> +struct user_ymmh_regs {
> +	/* 16 * 16 bytes for each YMMH-reg */
> +	__u32 ymmh_space[64];
> +};

This is the high half of %ymmN registers, where %xmmN is the low half.
Right?  Though of course documented in the chip manuals, it is rather
nonobvious that %ymmN are split this way in the storage, so I think it
merits a comment here saying so explicitly.


On these cosmetic issues I leave it up to you and the x86 maintainers.
I don't have strong opinions.  But I wanted to air what had occurred to me.

Modulo any cosmetic changes you want to make, this patch has my ACK
contingent on Oleg's ACK.


Thanks,
Roland
