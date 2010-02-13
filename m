Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab0BMX1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 18:27:32 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47823 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0BMX1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 18:27:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FHTHa/CKHe7paxPOhBRHjNslTUgjLTV+PCHhzdYeHa0T8yYBNhSrklVU21u9VqsgDB
         +09Wjtjc1FS8RtV5/t+YysFFnY5r4wi/3Dn87y649ylpQowNM9AoEhoyNnfe7p5lQ1Y1
         aL2lG23CHzcdeYaiFnjaxl8Z/NH03P+jww6yQ=
Message-ID: <4B773560.2060800@arm.com>
Date: Sat, 13 Feb 2010 23:27:28 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 06/10] ARM: ftrace: add Thumb-2 support
References: <1266090518-31120-1-git-send-email-rabin@rab.in> <1266090518-31120-7-git-send-email-rabin@rab.in>
In-Reply-To: <1266090518-31120-7-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rabin Vincent wrote:
> Fix the mcount routines to build and run on a kernel built with the
> Thumb-2 instruction set.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  arch/arm/kernel/entry-common.S |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index 42eb166..cd2a574 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -156,7 +156,8 @@ ENTRY(__gnu_mcount_nc)
>  	stmdb	sp!, {r0-r3, lr}
>  	ldr	r0, =ftrace_trace_function
>  	ldr	r2, [r0]
> -	adr	r0, ftrace_stub
> + THUMB(	orr	r2, r2, #1		)
> +	adr	r0, BSYM(ftrace_stub)
>  	cmp	r0, r2

Does this code not give the correct result if not modified?

>  	bne	gnu_trace
>  	ldmia	sp!, {r0-r3, ip, lr}
> @@ -166,8 +167,9 @@ gnu_trace:
>  	ldr	r1, [sp, #20]			@ lr of instrumented routine
>  	mov	r0, lr
>  	sub	r0, r0, #MCOUNT_INSN_SIZE
> -	mov	lr, pc
> -	mov	pc, r2
> + ARM(	mov	lr, pc			)
> + ARM(	mov	pc, r2			)
> + THUMB(	blx	r2			)
>  	ldmia	sp!, {r0-r3, ip, lr}
>  	mov	pc, ip
>  ENDPROC(__gnu_mcount_nc)

As above, what does this need modifying? "mov pc, r2" wouldn't change 
the mode to ARM even if the value in r2 is even. It may need THUMB(nop) 
after this instruction.

I could of course miss something as I haven't actually tried this code.

-- 
Catalin
