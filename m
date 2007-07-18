Return-Path: <linux-kernel-owner+w=401wt.eu-S934508AbXGRQbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508AbXGRQbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933139AbXGRQaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:30:55 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:42942 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761000AbXGRQay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:30:54 -0400
Message-ID: <469E3DA1.3010600@vmware.com>
Date: Wed, 18 Jul 2007 09:19:45 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] i386: use x86_64's desc_def.h
References: <1184743355.10380.112.camel@localhost.localdomain> <1184743422.10380.114.camel@localhost.localdomain>
In-Reply-To: <1184743422.10380.114.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> The main effect is to change the definition of "struct desc_struct" to
> a union of more complex types.
>   

Yay!  Someone finally killed it.  Every time I tried to kill it, I ended 
up off in the weeds chasing some bug.

>  
> diff -r 656f3ff2c9ce arch/i386/kernel/process.c
> @@ -880,21 +880,8 @@ asmlinkage int sys_set_thread_area(struc
>   * Get the current Thread-Local Storage area:
>   */
>  
> -#define GET_BASE(desc) ( \
> -	(((desc)->a >> 16) & 0x0000ffff) | \
> -	(((desc)->b << 16) & 0x00ff0000) | \
> -	( (desc)->b        & 0xff000000)   )
> -
> -#define GET_LIMIT(desc) ( \
> -	((desc)->a & 0x0ffff) | \
> -	 ((desc)->b & 0xf0000) )
> -	
> -#define GET_32BIT(desc)		(((desc)->b >> 22) & 1)
> -#define GET_CONTENTS(desc)	(((desc)->b >> 10) & 3)
> -#define GET_WRITABLE(desc)	(((desc)->b >>  9) & 1)
> -#define GET_LIMIT_PAGES(desc)	(((desc)->b >> 23) & 1)
> -#define GET_PRESENT(desc)	(((desc)->b >> 15) & 1)
> -#define GET_USEABLE(desc)	(((desc)->b >> 20) & 1)
> +#define GET_CONTENTS(desc)	(((desc)->raw32.b >> 10) & 3)
> +#define GET_WRITABLE(desc)	(((desc)->raw32.b >>  9) & 1)
>  
> diff -r 656f3ff2c9ce arch/i386/kernel/ptrace.c
> --- a/arch/i386/kernel/ptrace.c	Wed Jul 18 16:21:04 2007 +1000
> +++ b/arch/i386/kernel/ptrace.c	Wed Jul 18 16:21:06 2007 +1000
> @@ -283,22 +283,8 @@ ptrace_get_thread_area(struct task_struc
>  /*
>   * Get the current Thread-Local Storage area:
>   */
> -
> -#define GET_BASE(desc) ( \
> -	(((desc)->a >> 16) & 0x0000ffff) | \
> -	(((desc)->b << 16) & 0x00ff0000) | \
> -	( (desc)->b        & 0xff000000)   )
> -
> -#define GET_LIMIT(desc) ( \
> -	((desc)->a & 0x0ffff) | \
> -	 ((desc)->b & 0xf0000) )
> -
> -#define GET_32BIT(desc)		(((desc)->b >> 22) & 1)
> -#define GET_CONTENTS(desc)	(((desc)->b >> 10) & 3)
> -#define GET_WRITABLE(desc)	(((desc)->b >>  9) & 1)
> -#define GET_LIMIT_PAGES(desc)	(((desc)->b >> 23) & 1)
> -#define GET_PRESENT(desc)	(((desc)->b >> 15) & 1)
> -#define GET_USEABLE(desc)	(((desc)->b >> 20) & 1)
> +#define GET_CONTENTS(desc)	(((desc)->raw32.b >> 10) & 3)
> +#define GET_WRITABLE(desc)	(((desc)->raw32.b >>  9) & 1)
>   

You got rid of the duplicate definitions here, but then added new 
duplicates (GET_CONTENTS / WRITABLE).  Can you stick them in desc.h?

Zach
