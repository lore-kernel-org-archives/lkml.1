Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbXHHKD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbXHHKD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760926AbXHHKCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:02:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:48310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450AbXHHKCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:02:03 -0400
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in entry.S
Date: Wed, 8 Aug 2007 11:38:21 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <1186546820708-git-send-email-gcosta@redhat.com> <11865468243612-git-send-email-gcosta@redhat.com>
In-Reply-To: <11865468243612-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081138.23018.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +#define SYSRETQ						\
> +			movq	%gs:pda_oldrsp,%rsp;	\
> +			swapgs;				\
> +			sysretq;

When the macro does more than sysret it should have a different
name


>   */
>  	.globl int_ret_from_sys_call
>  int_ret_from_sys_call:
> -	cli
> +	DISABLE_INTERRUPTS(CLBR_ANY)

ANY? There are certainly some registers alive at this point like rax

>  retint_restore_args:
> -	cli
> +	DISABLE_INTERRUPTS(CLBR_ANY)

Similar.


>  	/*
>  	 * The iretq could re-enable interrupts:
>  	 */
> @@ -566,10 +587,14 @@ retint_restore_args:
>  restore_args:
>  	RESTORE_ARGS 0,8,0
>  iret_label:
> -	iretq
> +#ifdef CONFIG_PARAVIRT
> +	INTERRUPT_RETURN
> +ENTRY(native_iret)

ENTRY adds alignment. Why do you need that export anyways? 

> +#endif
> +1:	iretq
>
>  	.section __ex_table,"a"
> -	.quad iret_label,bad_iret
> +	.quad 1b, bad_iret

iret_label seems more expressive to me than 1

> +	ENABLE_INTERRUPTS(CLBR_NONE)

In many of the CLBR_NONEs there are actually some registers free;
but it might be safer to keep it this way. But if some client can get 
significantly better code with one or two free registers it might 
be worthwhile to investigate.

> -	swapgs
> +	SWAPGS_NOSTACK

There's still stack here

>  paranoid_restore\trace:
>  	RESTORE_ALL 8
> -	iretq
> +	INTERRUPT_RETURN

I suspect Xen will need much more changes anyways because of its
ring 3 guest. Are these changes sufficient for lguest?

-Andi

