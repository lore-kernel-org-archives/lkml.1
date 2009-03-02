Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbZCBTxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbZCBTxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 14:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbZCBTw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 14:52:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50414 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbZCBTw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 14:52:58 -0500
Date: Mon, 2 Mar 2009 20:52:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Cc: x86@kernel.org, Bill Metzenthen <billm@suburbia.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, math-emu: fix init_fpu for task != current
Message-ID: <20090302195230.GA12252@elte.hu>
References: <E1Le9vp-00020J-AA@mailer.emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1Le9vp-00020J-AA@mailer.emlix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Glöckner <dg@emlix.com> wrote:

> init_fpu calls finit to initialize a task's xstate, while finit always
> works on the current task. If we use PTRACE_GETFPREGS on another
> process and both processes did not already use floating point, we get
> a null pointer exception in finit.
> 
> This patch creates a new function finit_task that takes a task_struct
> parameter. finit becomes a wrapper that simply calls finit_task with
> current. On the plus side this avoids many calls to get_current which
> would each resolve to an inline assembler mov instruction.
> 
> Signed-off-by: Daniel Glöckner <dg@emlix.com>
> ---
>  arch/x86/include/asm/i387.h |    1 +
>  arch/x86/kernel/i387.c      |    2 +-
>  arch/x86/math-emu/fpu_aux.c |   31 ++++++++++++++++++++-----------
>  3 files changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
> index 48f0004..10f349b 100644
> --- a/arch/x86/include/asm/i387.h
> +++ b/arch/x86/include/asm/i387.h
> @@ -172,6 +172,7 @@ static inline void __save_init_fpu(struct task_struct *tsk)
> 
>  #else  /* CONFIG_X86_32 */
> 
> +extern void finit_task(struct task_struct *tsk);
>  extern void finit(void);
> 
>  static inline void tolerant_fwait(void)
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index b0f61f0..f2f8540 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -136,7 +136,7 @@ int init_fpu(struct task_struct *tsk)
>  #ifdef CONFIG_X86_32
>  	if (!HAVE_HWFP) {
>  		memset(tsk->thread.xstate, 0, xstate_size);
> -		finit();
> +		finit_task(tsk);
>  		set_stopped_child_used_math(tsk);
>  		return 0;
>  	}
> diff --git a/arch/x86/math-emu/fpu_aux.c b/arch/x86/math-emu/fpu_aux.c
> index 491e737..aa09870 100644
> --- a/arch/x86/math-emu/fpu_aux.c
> +++ b/arch/x86/math-emu/fpu_aux.c
> @@ -30,20 +30,29 @@ static void fclex(void)
>  }
> 
>  /* Needs to be externally visible */
> -void finit(void)
> +void finit_task(struct task_struct *tsk)

ok, the fix looks good - but we sure want to define this 
function in the "# CONFIG_MATH_EMU is not set" case too, agreed?

	Ingo
