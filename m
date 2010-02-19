Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0BSOYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 09:24:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab0BSOYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 09:24:45 -0500
Message-ID: <4B7E9FB8.1020806@redhat.com>
Date: Fri, 19 Feb 2010 09:27:04 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: mingo@elte.hu, hpa@zytor.com, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] x86: add support for relative CALL and JMP in alternatives
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com> <1266406962-17463-3-git-send-email-luca@luca-barbieri.com>
In-Reply-To: <1266406962-17463-3-git-send-email-luca@luca-barbieri.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Barbieri wrote:
> Currently CALL and JMP cannot be used in alternatives because the
> relative offset would be wrong.
> 
> This patch uses the existing x86 instruction parser to parse the
> alternative sequence and fix up the displacements.
> 
> This allows to implement this feature with minimal code.
> 
> Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
> ---
>  arch/x86/kernel/alternative.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index de7353c..7464c7e 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -17,6 +17,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/io.h>
>  #include <asm/fixmap.h>
> +#include <asm/insn.h>
>  
>  #define MAX_PATCH_LEN (255-1)
>  
> @@ -195,6 +196,26 @@ extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
>  extern u8 *__smp_locks[], *__smp_locks_end[];
>  static void *text_poke_early(void *addr, const void *opcode, size_t len);
>  

Hmm, first of all, if those alternative codes are hand-written, I think
you don't need to use insn-decoder because you can expect what code
will be there. (or, as Peter said, it should be done in compile-time, because
the adjustment can be determined on each site...)
Anyway, I have some comments on it.

> +/* Fix call instruction displacements */
> +static void __init_or_module fixup_relative_addresses(char *buf, size_t size, size_t adj)
> +{
> +	struct insn insn;
> +	char *p = buf;
> +	char *end = p + size;
> +	while (p < end) {
> +		kernel_insn_init(&insn, p);
> +		insn_get_opcode(&insn);

Here, if you need to know the destination address encoded as an imm operand,
you can use insn_get_immediate() for that.

> +
> +		/* CALL or JMP near32 */
> +		if (insn.opcode.bytes[0] == 0xe8 || insn.opcode.bytes[0] == 0xe9) {
> +			size_t disp_off = insn.next_byte - insn.kaddr;
> +			*(unsigned *)(p + disp_off) += adj;

And also, you can use insn_offset_immediate() instead of disp_off, here.
Please see fix_riprel() in arch/x86/kernel/kprobes.c.

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

