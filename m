Return-Path: <linux-kernel-owner+w=401wt.eu-S1762225AbYDNQVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762225AbYDNQVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYDNQVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:21:24 -0400
Received: from gw.goop.org ([64.81.55.164]:34515 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787AbYDNQVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:21:24 -0400
Message-ID: <48038482.90500@goop.org>
Date: Mon, 14 Apr 2008 09:21:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080407)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [RFC] x86: bitops asm constraint fixes
References: <480378CC.76E4.0078.0@novell.com>
In-Reply-To: <480378CC.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>  
> +struct __bits { int _[1UL << (32 - 3 - sizeof(int))]; };
>   

I don't understand what you're doing here.  The array can be 1<<(32 - 1) 
bytes (assuming we never allow a 64-bit bit offset).  The int array 
makes that 1<<(32 - 1 - log2(sizeof(int))) ints.  But I don't see what 
the sizeof(int) is doing in there.

> +
>  #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
>  /* Technically wrong, but this avoids compilation errors on some gcc
>     versions. */
> -#define ADDR "=m" (*(volatile long *)addr)
> -#define BIT_ADDR "=m" (((volatile int *)addr)[nr >> 5])
> +#define ADDR "=m" (*(volatile long *) addr)
> +#define BIT_ADDR "=m" (((volatile int *) addr)[nr >> 5])
> +#define FULL_ADDR "=m" (*(volatile struct __bits *) addr)
>  #else
>  #define ADDR "+m" (*(volatile long *) addr)
> -#define BIT_ADDR "+m" (((volatile int *)addr)[nr >> 5])
> +#define BIT_ADDR "+m" (((volatile int *) addr)[nr >> 5])
> +#define FULL_ADDR "+m" (*(volatile struct __bits *) addr)
>  #endif
> -#define BASE_ADDR "m" (*(volatile int *)addr)
> +#define BASE_ADDR "m" (*(volatile int *) addr)
>   

Shouldn't BASE_ADDR also use __bits?  Otherwise it won't get write-read 
dependencies right (a read could move before a write).

    J
