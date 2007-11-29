Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbXK2Rhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbXK2Rhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759703AbXK2Rhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:37:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53850 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174AbXK2Rhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:37:42 -0500
Date: Thu, 29 Nov 2007 17:37:34 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 08/11] x86 ia32 ptrace getreg/putreg merge
Message-ID: <20071129173734.GA556@infradead.org>
References: <20071129115711.9FC8526F8E7@magilla.localdomain> <20071129120031.F0F4F26F989@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129120031.F0F4F26F989@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 04:00:31AM -0800, Roland McGrath wrote:
> +#define R32(l,q)							\
> +	case offsetof(struct user32, regs.l):				\
> +		regs->q = value; break
> +
> +#define SEG32(rs)							\
> +	case offsetof(struct user32, regs.rs):				\
> +		return set_segment_reg(child,				\
> +				       offsetof(struct user_regs_struct, rs), \
> +				       value);				\
> +		break

The code would be a lot more readable if you just opencoded this in the
caller instead of these obsfucated macros.

> +
> +static int putreg32(struct task_struct *child, unsigned regno, u32 value)
> +{
> +	struct pt_regs *regs = task_pt_regs(child);
> +
> +	switch (regno) {
> +
> +	SEG32(cs);
> +	SEG32(ds);
> +	SEG32(es);
> +	SEG32(fs);
> +	SEG32(gs);
> +	SEG32(ss);
> +
> +	R32(ebx, bx);
> +	R32(ecx, cx);
> +	R32(edx, dx);
> +	R32(edi, di);
> +	R32(esi, si);
> +	R32(ebp, bp);
> +	R32(eax, ax);
> +	R32(orig_eax, orig_ax);
> +	R32(eip, ip);
> +	R32(esp, sp);
> +
> +	case offsetof(struct user32, regs.eflags):
> +		return set_flags(child, value);
> +
> +	case offsetof(struct user32, u_debugreg[0]) ...
> +		offsetof(struct user32, u_debugreg[7]):
> +		regno -= offsetof(struct user32, u_debugreg[0]);
> +		return ptrace_set_debugreg(child, regno / 4, value);
> +
> +	default:
> +		if (regno > sizeof(struct user32) || (regno & 3))
> +			return -EIO;
> +
> +		/*
> +		 * Other dummy fields in the virtual user structure
> +		 * are ignored
> +		 */
> +		break;
> +	}
> +	return 0;
> +}
> +
> +#undef R32
> +#undef SEG32
> +
> +#define R32(l,q)							\
> +	case offsetof(struct user32, regs.l):				\
> +		*val = regs->q; break
> +
> +#define SEG32(rs)							\
> +	case offsetof(struct user32, regs.rs):				\
> +		*val = get_segment_reg(child,				\
> +				       offsetof(struct user_regs_struct, rs)); \
> +		break
> +
> +static int getreg32(struct task_struct *child, unsigned regno, u32 *val)
> +{
> +	struct pt_regs *regs = task_pt_regs(child);
> +
> +	switch (regno) {
> +
> +	SEG32(ds);
> +	SEG32(es);
> +	SEG32(fs);
> +	SEG32(gs);
> +
> +	R32(cs, cs);
> +	R32(ss, ss);
> +	R32(ebx, bx);
> +	R32(ecx, cx);
> +	R32(edx, dx);
> +	R32(edi, di);
> +	R32(esi, si);
> +	R32(ebp, bp);
> +	R32(eax, ax);
> +	R32(orig_eax, orig_ax);
> +	R32(eip, ip);
> +	R32(esp, sp);
> +
> +	case offsetof(struct user32, regs.eflags):
> +		*val = get_flags(child);
> +		break;
> +
> +	case offsetof(struct user32, u_debugreg[0]) ...
> +		offsetof(struct user32, u_debugreg[7]):
> +		regno -= offsetof(struct user32, u_debugreg[0]);
> +		*val = ptrace_get_debugreg(child, regno / 4);
> +		break;
> +
> +	default:
> +		if (regno > sizeof(struct user32) || (regno & 3))
> +			return -EIO;
> +
> +		/*
> +		 * Other dummy fields in the virtual user structure
> +		 * are ignored
> +		 */
> +		*val = 0;
> +		break;
> +	}
> +	return 0;
> +}
> +
> +#undef R32
> +#undef SEG32
> +
> +#endif	/* CONFIG_IA32_EMULATION */
> +
>  #ifdef CONFIG_X86_32
>  
>  void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs, int error_code)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
