Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbYLBVY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbYLBVY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbYLBVYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:24:44 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:14519 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYLBVYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:24:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SaMtRF7I1e3ExSfjgcj/Y6weDp+v0m3b78SAK45edVK4tjIzf7Qbmt6bzayMrY8na/
         zfdmEA4tuLPW4ezWTl92EQ4ffhndGvNC9LIxznpE4GDSUTdJIZxOyFwsnwvSaXBzyN0e
         bVXoVoMCNj2ldNxHgXbTOTka968t2sD4Xs9cI=
Message-ID: <c62985530812021324m45a26782kd52beca1b6437747@mail.gmail.com>
Date: Tue, 2 Dec 2008 22:24:42 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 4/5] ftrace: clean up function graph asm
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <20081202203425.258501817@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081202203404.496794864@goodmis.org>
	 <20081202203425.258501817@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/2 Steven Rostedt <rostedt@goodmis.org>:
> From: Steven Rostedt <srostedt@redhat.com>
>
> Impact: clean up
>
> There exists macros for x86 asm to handle x86_64 and i386.
> This patch updates function graph asm to use them.
>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/x86/kernel/ftrace.c |   20 ++++----------------
>  1 files changed, 4 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 5883247..1a5b8f8 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -467,28 +467,16 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>         * ignore such a protection.
>         */
>        asm volatile(
> -#ifdef CONFIG_X86_64
> -               "1: movq (%[parent_old]), %[old]\n"
> -               "2: movq %[return_hooker], (%[parent_replaced])\n"
> -#else
> -               "1: movl (%[parent_old]), %[old]\n"
> -               "2: movl %[return_hooker], (%[parent_replaced])\n"
> -#endif
> +               "1: " _ASM_MOV " (%[parent_old]), %[old]\n"
> +               "2: " _ASM_MOV " %[return_hooker], (%[parent_replaced])\n"
>                "   movl $0, %[faulted]\n"
>
>                ".section .fixup, \"ax\"\n"
>                "3: movl $1, %[faulted]\n"
>                ".previous\n"
>
> -               ".section __ex_table, \"a\"\n"
> -#ifdef CONFIG_X86_64
> -               "   .quad 1b, 3b\n"
> -               "   .quad 2b, 3b\n"
> -#else
> -               "   .long 1b, 3b\n"
> -               "   .long 2b, 3b\n"
> -#endif
> -               ".previous\n"
> +               _ASM_EXTABLE(1b, 3b)
> +               _ASM_EXTABLE(2b, 3b)
>
>                : [parent_replaced] "=r" (parent), [old] "=r" (old),
>                  [faulted] "=r" (faulted)
> --

Thanks Steven. I wasn't aware of _ASM_MOV.
