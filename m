Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbYAFLqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbYAFLqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 06:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYAFLqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 06:46:46 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:62512 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYAFLqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 06:46:45 -0500
Message-ID: <4780BF38.3010902@student.ltu.se>
Date: Sun, 06 Jan 2008 12:44:56 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, olof@lixom.net, mingo@elte.hu,
       mpm@selenic.com
Subject: Re: [patch 1/5] Introduce __WARN()
References: <20080105190713.73745ec6@laptopd505.fenrus.org> <20080105190840.48a8c2c5@laptopd505.fenrus.org>
In-Reply-To: <20080105190840.48a8c2c5@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> From: Olof Johansson <olof@lixom.net>
>
> Introduce __WARN() in the generic case, so the generic WARN_ON()
> can use arch-specific code for when the condition is true.
>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: <linux-arch@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/asm-generic/bug.h |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> Index: linux-2.6.24-rc6/include/asm-generic/bug.h
> ===================================================================
> --- linux-2.6.24-rc6.orig/include/asm-generic/bug.h
> +++ linux-2.6.24-rc6/include/asm-generic/bug.h
> @@ -31,14 +31,19 @@ struct bug_entry {
>  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
>  #endif
>  
> -#ifndef HAVE_ARCH_WARN_ON
> +#ifndef __WARN
> +#define __WARN() do {							\
> +	printk("WARNING: at %s:%d %s()\n", __FILE__,			\
> +		__LINE__, __FUNCTION__);				\
> +	dump_stack();							\
> +} while (0)
> +#endif
> +
> +#ifndef WARN_ON
>  #define WARN_ON(condition) ({						\
>  	int __ret_warn_on = !!(condition);				\
>   
What about using a boolean for __ret_warn_on, which then let us remove 
the '!!'?
(btw, wouldn't 'var != 0' actually be the proper semantic instead of 
playing with '!'s?)
> -	if (unlikely(__ret_warn_on)) {					\
> -		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
> -			__LINE__, __FUNCTION__);			\
> -		dump_stack();						\
> -	}								\
> +	if (unlikely(__ret_warn_on))					\
> +		__WARN();						\
>  	unlikely(__ret_warn_on);					\
>  })
>  #endif
>
>   

