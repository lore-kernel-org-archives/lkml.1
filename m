Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbYKWRcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbYKWRcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 12:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYKWRcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 12:32:12 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:18579 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbYKWRcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 12:32:11 -0500
Date: Sun, 23 Nov 2008 18:30:59 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: jia zhang <jia.zhang2008@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH] x86: remove the confusing entry in call trace
Message-ID: <20081123173058.GA32147@mailshack.com>
References: <49296CEE.2070905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49296CEE.2070905@gmail.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Sun, 23 Nov 2008 18:31:56 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.35; VDF: 7.1.0.122; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 10:47:10PM +0800, jia zhang wrote:
> 
> avoid the confusion in call trace because of the lack of padding at the tail of
> function.
> 
> Signed-off-by: jia zhang <jia.zhang2008@gmail.com> --- When do_exit get call,
> the return address behind call instruction is pushed into stack. If something
> get wrong in do_exit, for x86_64, the entry "kernel_execve +0x00/0xXX" rather
> than "child_rip +0xYY/0xZZ" is remained in call trace. It looks confused.

It's valuable to know from where do_exit is called, so that's the
only reason why using "call" is important. Otherwise it could just
be changed to a jmp as do_exit does not return. It's maybe a bit
ugly to add the padding, but it does give better traces. Maybe
a 'ret', 'int3', or 'ud2' would be slightly less offensive?

Anyhow, I don't have a problem with the added padding, so:

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>


>  b/arch/x86/kernel/entry_32.S |    1 +
>  b/arch/x86/kernel/entry_64.S |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index 28b597e..3290819 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1051,6 +1051,7 @@ ENTRY(kernel_thread_helper)
>  	push %eax
>  	CFI_ADJUST_CFA_OFFSET 4
>  	call do_exit
> +	nop			# padding for call trace
>  	CFI_ENDPROC
>  ENDPROC(kernel_thread_helper)
>  
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index b86f332..6f677a6 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -1170,6 +1170,7 @@ child_rip:
>  	# exit
>  	mov %eax, %edi
>  	call do_exit
> +	nop			# padding for call trace
>  	CFI_ENDPROC
>  ENDPROC(child_rip)
