Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab0BJBxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:53:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab0BJBx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:53:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 4/4] ptrace: Add support for generic PTRACE_GETREGSET/PTRACE_SETREGSET
In-Reply-To: Suresh Siddha's message of  Tuesday, 9 February 2010 12:13:13 -0800 <20100209202502.406177090@sbs-t61.sc.intel.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
	<20100209202502.406177090@sbs-t61.sc.intel.com>
X-Windows: power tools for power fools.
Message-Id: <20100210015257.942463E8@magilla.sf.frob.com>
Date: Tue,  9 Feb 2010 17:52:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 'addr' parameter for the ptrace system call encode the REGSET type and
> the buffer length. 'data' parameter points to the user buffer.
> 
> 	ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid,
> 	       (NT_TYPE << 20) | buf_length, buf);

IMHO this bit swizzling is a non-starter.  The NT_* codes can use a full 32
bits.  NT_PRXFPREG uses 31 bits.  The comments about ignoring the high bits
for this as a special case just seem insane to me.  Pass a full 32 bit word
for NT_* and a full word for the buffer size.  What's so terrible about
just having an obvious and comprehensible API?

IMHO if you insist on an insane bit swizzling approach, you should mix the
buffer size bits into the request code, leaving the "addr" argument free
for the unmolested NT_* code.  There is just no earthly reason that we
should suddenly impose a new and arcane constraint on what NT_* values can
be, even if there is no particular reason for future values not to be small.

> +int generic_ptrace_regset(struct task_struct *child, long request, long addr,
> +			  long data);

There is no need for a global function for this.  It should all be static
in kernel/ptrace.c, called only by ptrace_request()/compat_ptrace_request().

> +#ifdef PTRACE_EXPORT_REGSET
> +	case PTRACE_GETREGSET:
> +	case PTRACE_SETREGSET:
> +		return generic_ptrace_regset(child, request, addr, data);
> +#endif

Just use CONFIG_HAVE_ARCH_TRACEHOOK.  That means the arch supplies
task_user_regset_view().  Any additional per-arch conditionalization
defeats the essential purpose of having fully generic ptrace requests.

> +		if (NOTE_TO_REGSET_TYPE(regset->core_note_type) !=
> +		    PTRACE_REGSET_TYPE(addr))
> +			continue;

Here is where you should validate the buf_size value.  You must not pass a
size that is > regset.size * regset.n or has % regset.size != 0.  The arch
user_regset.get and .set functions are not required to check for bogus
offsets or sizes.

You could either just use:

	buf_size = MIN(buf_size, regset->n * regset->size);

or you could diagnose it with:

	if (buf_size > regset->n * regset->size)
		return -EINVAL;

Possibly we might want to allow a PTRACE_GETREGSET with a buffer that is
larger than necessary.  Then it would probably make sense to zero-fill the
rest of the buffer.  Or else, use an API that can pass back to userland how
much we're actually filling in.

> --- tip.orig/include/linux/elf.h
> +++ tip/include/linux/elf.h
> @@ -349,7 +349,29 @@ typedef struct elf64_shdr {
>  #define ELF_OSABI ELFOSABI_NONE
>  #endif
>  
> -/* Notes used in ET_CORE */
> +/*
> + * Notes used in ET_CORE. Architectures export some of the arch register sets
[...]

These comments don't really belong in linux/elf.h IMHO.  They don't add
anything, except documenting the insanity about truncating NT_* values.  I
don't think that nutty idea should survive.  But regardless, everything
about it belongs alongside the macros used to construct and deconstruct the
argument word.  No example should recommend using the bit-twiddling rather
than using some such macros that are made public in linux/ptrace.h.


Thanks,
Roland
