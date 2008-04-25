Return-Path: <linux-kernel-owner+w=401wt.eu-S1766014AbYDYUaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766014AbYDYUaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765176AbYDYU35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:29:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765167AbYDYU34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:29:56 -0400
Message-ID: <48123C9B.9020306@zytor.com>
Date: Fri, 25 Apr 2008 13:18:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
References: <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal>
In-Reply-To: <20080425183748.GB16180@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> This epilogue should then be used on both branches of the condition,
> like this :
> 
> if (unlikely(imv_cond(var))) {
>   imv_cond_end();
>   ...
> } else {
>   imv_cond_end();
>    ...
> }
> 
> Where imv_cond_end() would look like this :
> 
> +/*
> + * Puts a test and branch make sure the %al register and ZF are not live
> + * anymore.
> + * All asm statements clobbers the flags, but add "cc" clobber just to be sure.
> + * Clobbers %al.
> + */
> +#define imv_cond_end()                                                 \
> +       do {                                                            \
> +               asm (".section __imv_cond_end,\"a\",@progbits\n\t"      \
> +                               _ASM_PTR "1f\n\t"                       \
> +                               ".previous\n\t"                         \
> +                               "1:\n\t"                                \
> +                               : : : "a", "cc");                       \
> +       } while (0)
> +
> 

As far as this is concerned, all you accomplish here is that gcc, if it 
wants to re-use the %al value, will copy it into another register before 
doing your imv_conv_end().

	-hpa
