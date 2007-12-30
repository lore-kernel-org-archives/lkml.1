Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbXL3Gkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbXL3Gkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 01:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbXL3Gks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 01:40:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbXL3Gkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 01:40:47 -0500
Message-ID: <47773CAD.7050907@redhat.com>
Date: Sun, 30 Dec 2007 01:37:33 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: kprobes remove fix_riprel #ifdef
References: <1198466917.6323.15.camel@brick>
In-Reply-To: <1198466917.6323.15.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Harvey,

A similar idea was already nack-ed by Ananth.
http://sources.redhat.com/ml/systemtap/2007-q4/msg00468.html
And I agree his thought.

Especially, "riprel" does not exist on x86_32, so fix_riprel()
is meaningless on it.
Thus, I think it would better be ifdef'd in call-site.

Harvey Harrison wrote:
> Move #ifdef around function definiton into the function and
> unconditionally return on X86_32.  Saves an ifdef from the
> one callsite.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Ingo, Masami, final leftovers from some unsent kprobes unification work.
> 
> Net reduction of one #ifdef section.
> 
>  arch/x86/kernel/kprobes.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index b1804e4..1ac532e 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -263,15 +263,16 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_X86_64
>  /*
>   * Adjust the displacement if the instruction uses the %rip-relative
>   * addressing mode.
>   * If it does, Return the address of the 32-bit displacement word.
>   * If not, return null.
> + * Only applicable to X86_64
>   */
>  static void __kprobes fix_riprel(struct kprobe *p)
>  {
> +#ifdef CONFIG_X86_64
>  	u8 *insn = p->ainsn.insn;
>  	s64 disp;
>  	int need_modrm;
> @@ -335,15 +336,17 @@ static void __kprobes fix_riprel(struct kprobe *p)
>  			*(s32 *)insn = (s32) disp;
>  		}
>  	}
> -}
> +#else
> +	return;
>  #endif
> +}
>  
>  static void __kprobes arch_copy_kprobe(struct kprobe *p)
>  {
>  	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
> -#ifdef CONFIG_X86_64
> +
>  	fix_riprel(p);
> -#endif
> +
>  	if (can_boost(p->addr))
>  		p->ainsn.boostable = 0;
>  	else

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

