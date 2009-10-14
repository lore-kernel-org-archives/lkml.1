Return-Path: <linux-kernel-owner+w=401wt.eu-S934405AbZJNOy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934405AbZJNOy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934353AbZJNOyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:54:25 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52441 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934299AbZJNOyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:54:22 -0400
Date: Wed, 14 Oct 2009 10:41:58 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mingo@redhat.com,
       tglx@linutronix.de, akpm@linux-foundation.org, rostedt@goodmis.org,
       hpa@zytor.com, cebbert@redhat.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 16/16] percpu: make accessors check for percpu pointer
 in sparse
In-Reply-To: <1255500125-3210-17-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.1.10.0910141039290.26476@gentwo.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-17-git-send-email-tj@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Tejun Heo wrote:

>  #ifndef SHIFT_PERCPU_PTR
>  /* Weird cast keeps both GCC and sparse happy. */
> -#define SHIFT_PERCPU_PTR(__p, __offset)				\
> -	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
> +#define SHIFT_PERCPU_PTR(__p, __offset)	({				\
> +	__verify_pcpu_ptr((__p));					\
> +	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset)); \
> +})

If you have the verification in SHIFT_PER_CPU_PTR then why do you need it
elsewhere?

>  #define __pcpu_size_call_return(stem, variable)				\
>  ({	typeof(variable) pscr_ret__;					\
> +	__verify_pcpu_ptr(&(variable));					\
>  	switch(sizeof(variable)) {					\
>  	case 1: pscr_ret__ = stem##1(variable);break;			\
>  	case 2: pscr_ret__ = stem##2(variable);break;			\
> @@ -250,6 +251,7 @@ extern void __bad_size_call_parameter(void);
>
>  #define __pcpu_size_call(stem, variable, ...)				\
>  do {									\
> +	__verify_pcpu_ptr(&(variable));					\
>  	switch(sizeof(variable)) {					\
>  		case 1: stem##1(variable, __VA_ARGS__);break;		\
>  		case 2: stem##2(variable, __VA_ARGS__);break;		\

Would it not be better to put the verification in the arch code? The
percpu_to/from_op may have multiple callsites (at least they have now). If
you put it in there then all other stuff is covered.


