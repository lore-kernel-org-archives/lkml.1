Return-Path: <linux-kernel-owner+w=401wt.eu-S1761270AbXGNRQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270AbXGNRQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 13:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757653AbXGNRQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 13:16:47 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:57862 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757224AbXGNRQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 13:16:46 -0400
Date: Sat, 14 Jul 2007 13:16:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH -rt 4/5] use migrate_disable for __local_begin
Message-ID: <20070714171644.GC6975@Krystal>
References: <20070714175733.194012000@chello.nl> <20070714175840.153584000@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070714175840.153584000@chello.nl>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:14:09 up 7 days,  7:19,  2 users,  load average: 0.06, 0.17, 0.17
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/asm-i386/local.h   |    7 ++++---
>  include/asm-x86_64/local.h |    7 ++++---
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6/include/asm-i386/local.h
> ===================================================================
> --- linux-2.6.orig/include/asm-i386/local.h
> +++ linux-2.6/include/asm-i386/local.h
> @@ -197,11 +197,12 @@ static __inline__ long local_sub_return(
>  #define __local_begin(__flags)					\
>  {								\
>  	(__flags) = 0;						\
> -	preempt_disable();					\
> +	migrate_disable();					\

Brrrr. That's wrong. Your non atomic __local*() updates only makes sense
when preempt_disable/enable() protects them from concurrent threads on
the same CPU, which is not the case of migrate_disable/enable(). This is
why I suggest that you use local_begin/end() mapped to
migrate_disable/enable() for normal local variables, and, if you really
want a __local_begin/end(), then it should be mapped to
preempt_disable/enable() and should state that it provides no protection
against interrupts.

Mathieu

>  }
>  
> -static inline void __local_end(unsigned long flags) {
> -	preempt_enable();
> +static inline void __local_end(unsigned long flags)
> +{
> +	migrate_enable();
>  }
>  
>  /* On x86, these are no better than the atomic variants. */
> Index: linux-2.6/include/asm-x86_64/local.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86_64/local.h
> +++ linux-2.6/include/asm-x86_64/local.h
> @@ -186,11 +186,12 @@ static __inline__ long local_sub_return(
>  #define __local_begin(__flags)		\
>  {					\
>  	(__flags) = 0;			\
> -	preempt_disable();		\
> +	migrate_disable();		\
>  }
>  
> -static inline void __local_end(unsigned long flags) {
> -	preempt_enable();
> +static inline void __local_end(unsigned long flags)
> +{
> +	migrate_enable();
>  }
>  
>  #define __local_inc(l)		local_inc(l)
> 
> --
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
