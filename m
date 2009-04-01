Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbZDAJDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbZDAJDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZDAJDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:03:06 -0400
Received: from gw.goop.org ([64.81.55.164]:38411 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZDAJDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:03:04 -0400
Message-ID: <49D32DC2.9010003@goop.org>
Date: Wed, 01 Apr 2009 02:02:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Joe Perches <joe@perches.com>
Subject: Re: [PATCH] x86: percpu_to_op() misses memory and flags clobbers
References: <49D32212.80607@cosmosbay.com>
In-Reply-To: <49D32212.80607@cosmosbay.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> While playing with new percpu_{read|write|add|sub} stuff in network tree,
> I found x86 asm was a litle bit optimistic.
>
> We need to tell gcc that percpu_{write|add|sub|or|xor} are modyfing
> memory and possibly eflags. We could add another parameter to percpu_to_op()
> to separate the plain "mov" case (not changing eflags),
> but let keep it simple for the moment.
>   

Did you observe an actual failure that this patch fixed?

> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
>
> diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
> index aee103b..fd4f8ec 100644
> --- a/arch/x86/include/asm/percpu.h
> +++ b/arch/x86/include/asm/percpu.h
> @@ -82,22 +82,26 @@ do {							\
>  	case 1:						\
>  		asm(op "b %1,"__percpu_arg(0)		\
>  		    : "+m" (var)			\
> -		    : "ri" ((T__)val));			\
> +		    : "ri" ((T__)val)			\
> +		    : "memory", "cc");			\
>   

This shouldn't be necessary.   The "+m" already tells gcc that var is a 
memory input and output, and there are no other memory side-effects 
which it needs to be aware of; clobbering "memory" will force gcc to 
reload all register-cached memory, which is a pretty hard hit.  I think 
all asms implicitly clobber "cc", so that shouldn't have any effect, but 
it does no harm.

Now, its true that the asm isn't actually modifying var itself, but 
%gs:var, which is a different location.  But from gcc's perspective that 
shouldn't matter because var makes a perfectly good proxy for that 
location, and will make sure it correctly order all accesses to var.

I'd be surprised if this were broken, because we'd be seeing all sorts 
of strange crashes all over the place.  We've seen it before when the 
old x86-64 pda code didn't have proper constraints on its asm statements.

    J
