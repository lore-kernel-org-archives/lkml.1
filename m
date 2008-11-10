Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbYKJWA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbYKJWA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYKJWAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:00:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbYKJWAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:00:48 -0500
Date: Mon, 10 Nov 2008 13:58:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Pitre <nico@cam.org>
Cc: mathieu.desnoyers@polymtl.ca, torvalds@linux-foundation.org,
       rmk+lkml@arm.linux.org.uk, dhowells@redhat.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] clarify usage expectations for cnt32_to_63()
Message-Id: <20081110135850.0d620f3c.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811101627510.13034@xanadu.home>
References: <9405.1226101315@redhat.com>
	<20081108001555.GE18378@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.0811080939180.13034@xanadu.home>
	<alpine.LFD.2.00.0811081746060.13034@xanadu.home>
	<20081109022549.GA18508@Krystal>
	<alpine.LFD.2.00.0811082143320.13034@xanadu.home>
	<alpine.LFD.2.00.0811082356090.13034@xanadu.home>
	<alpine.LFD.2.00.0811090015570.13034@xanadu.home>
	<20081109064855.GA23782@Krystal>
	<alpine.LFD.2.00.0811090827160.13034@xanadu.home>
	<20081109162250.GB10181@Krystal>
	<alpine.LFD.2.00.0811092304300.13034@xanadu.home>
	<20081109204256.89ab7925.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0811101627510.13034@xanadu.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 16:34:54 -0500 (EST)
Nicolas Pitre <nico@cam.org> wrote:

> > It is far better to make the management of the state explicit and at
> > the control of the caller.  Get the caller to allocate the state and
> > pass its address into this function.  Simple, clear, explicit and
> > robust.
> 
> Sigh...  What about this compromize then?
> 
> diff --git a/include/linux/cnt32_to_63.h b/include/linux/cnt32_to_63.h
> index 7605fdd..74ce767 100644
> --- a/include/linux/cnt32_to_63.h
> +++ b/include/linux/cnt32_to_63.h
> @@ -32,8 +32,9 @@ union cnt32_to_63 {
>  
>  
>  /**
> - * cnt32_to_63 - Expand a 32-bit counter to a 63-bit counter
> + * __cnt32_to_63 - Expand a 32-bit counter to a 63-bit counter
>   * @cnt_lo: The low part of the counter
> + * @cnt_hi_p: Pointer to storage for the extended part of the counter
>   *
>   * Many hardware clock counters are only 32 bits wide and therefore have
>   * a relatively short period making wrap-arounds rather frequent.  This
> @@ -75,16 +76,31 @@ union cnt32_to_63 {
>   * clear-bit instruction. Otherwise caller must remember to clear the top
>   * bit explicitly.
>   */
> -#define cnt32_to_63(cnt_lo) \
> +#define __cnt32_to_63(cnt_lo, cnt_hi_p) \
>  ({ \
> -	static u32 __m_cnt_hi; \
>  	union cnt32_to_63 __x; \
> -	__x.hi = __m_cnt_hi; \
> +	__x.hi = *(cnt_hi_p); \
>   	smp_rmb(); \
>  	__x.lo = (cnt_lo); \
>  	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
> -		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
> +		*(cnt_hi_p) = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
>  	__x.val; \
>  })

This references its second argument twice, which can cause correctness
or efficiency problems.

There is no reason that this had to be implemented in cpp. 
Implementing it in C will fix the above problem.



To the reader of the code, a call to cnt32_to_63() looks exactly like a
plain old function call.  Hiding the instantiation of the state storage
inside this macro misleads the reader and hence is bad practice.  This
is one of the reasons why the management of that state should be
performed by the caller and made explicit.

I cannot think of any other cases in the kernel where this trick of
instantiating static storage at a macro expansion site is performed. 
It is unusual.  It will surprise readers.  Surprising readers is
undesirable.

