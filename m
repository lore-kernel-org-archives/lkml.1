Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYLJIpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYLJIpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 03:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYLJIou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 03:44:50 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46917 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754803AbYLJIor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 03:44:47 -0500
Date: Wed, 10 Dec 2008 09:44:46 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Yuri Tikhonov <yur@emcraft.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Detlev Zundel <dzu@denx.de>, Wolfgang Denk <wd@denx.de>,
       Milton Miller <miltonm@bga.com>, Ilya Yanok <yanok@emcraft.com>
Subject: Re: [PATCH] fork_init: fix division by zero
In-Reply-To: <200812092044.40649.yur@emcraft.com>
Message-ID: <Pine.LNX.4.64.0812100944080.25126@vixen.sonytel.be>
References: <200812092044.40649.yur@emcraft.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008, Yuri Tikhonov wrote:
> The following patch fixes divide-by-zero error for the
> cases of really big PAGE_SIZEs (e.g. 256KB on ppc44x).
> Support for such big page sizes on 44x is not present in the
> current kernel yet, but coming soon.
> 
> Also this patch fixes the comment for the max_threads
> settings, as this didn't match the things actually done
> in the code.
> 
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
> Signed-off-by: Ilya Yanok <yanok@emcraft.com>
> ---
>  kernel/fork.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 2a372a0..b0ac2fb 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -181,10 +181,14 @@ void __init fork_init(unsigned long mempages)
>  
>  	/*
>  	 * The default maximum number of threads is set to a safe
> -	 * value: the thread structures can take up at most half
> -	 * of memory.
> +	 * value: the thread structures can take up at most
> +	 * (1/8) part of memory.
>  	 */
> +#if (8 * THREAD_SIZE) > PAGE_SIZE
>  	max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
> +#else
> +	max_threads = mempages * PAGE_SIZE / (8 * THREAD_SIZE);
                      ^^^^^^^^^^^^^^^^^^^^
> +#endif

Can't this overflow, e.g. on 32-bit machines with HIGHMEM?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
