Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbYKXCfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbYKXCfm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 21:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYKXCfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 21:35:03 -0500
Received: from ozlabs.org ([203.10.76.45]:45015 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbYKXCfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 21:35:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18730.4326.745599.500581@drongo.ozlabs.ibm.com>
Date: Mon, 24 Nov 2008 13:26:46 +1100
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Milton Miller <miltonm@bga.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/5] powerpc/ppc64: ftrace, handle module trampolines for dyn ftrace
In-Reply-To: <20081120191149.759009300@goodmis.org>
References: <20081120190948.057007623@goodmis.org>
	<20081120191149.759009300@goodmis.org>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt writes:

> +#ifdef CONFIG_PPC64
> +static int
> +__ftrace_make_nop(struct module *mod,
> +		  struct dyn_ftrace *rec, unsigned long addr)
> +{
> +	unsigned char replaced[MCOUNT_INSN_SIZE * 2];
> +	unsigned int *op = (unsigned *)&replaced;

This makes me a little nervous, since it looks to me to be breaking
aliasing rules.  I know we use -fno-strict-aliasing, but still it
would be better to avoid doing these casts if possible - and we should
be able to avoid most of them by using unsigned int for instructions
consistently, instead of a mix of unsigned int and unsigned char.

> +	DEBUGP("ip:%lx jumps to %lx r2: %lx", ip, tramp, mod->arch.toc);
> +
> +	/* Find where the trampoline jumps to */
> +	if (probe_kernel_read(jmp, (void *)tramp, 8)) {
> +		printk(KERN_ERR "Failed to read %lx\n", tramp);
> +		return -EFAULT;
> +	}
> +
> +	DEBUGP(" %08x %08x",
> +	       (unsigned)(*ptr >> 32),
> +	       (unsigned)*ptr);
> +
> +	offset = (unsigned)jmp[2] << 24 |
> +		(unsigned)jmp[3] << 16 |
> +		(unsigned)jmp[6] << 8 |
> +		(unsigned)jmp[7];

We don't seem to be checking that these instructions look like the
start of a trampoline created by module_64.c, which makes me a little
nervous.

If the kernel text goes over 32MB, the linker will insert trampolines
automatically.  Those trampolines either look like a direct branch to
the target, or else they look like this:

	addis	r12,r2,xxxx
	ld	r11,yyyy(r12)
	mtctr	r11
	bctr

where xxxx/yyyy gives the offset from the kernel TOC to the procedure
descriptor for the target.

Now, a kernel with > 32MB of text probably won't work for other
reasons at the moment (like the linker putting trampolines before the
interrupt vectors), so in a sense it doesn't matter.  It also doesn't
matter since we only get here for calls in modules (something that
could stand to be mentioned in a comment at the top of the function).
Nevertheless, I think it would be worthwhile to check that the first
two instructions look like the addis and addi that we are expecting.

> +	if (probe_kernel_write((void *)ip, replaced, MCOUNT_INSN_SIZE))
> +		return -EPERM;
> +
> +	return 0;
> +}

We don't seem to do anything to ensure I-cache consistency.  I think
we probably need a flush_icache_range call here.  Similarly in
__ftrace_make_call.

Paul.
