Return-Path: <linux-kernel-owner+w=401wt.eu-S1764404AbYEOR7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764404AbYEOR7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758428AbYEOR6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:58:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763161AbYEOR6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:58:48 -0400
Date: Thu, 15 May 2008 10:58:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Andreas Schwab <schwab@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] init - fix building bug and potential buffer overflow
Message-Id: <20080515105803.7c9ab8c7.akpm@linux-foundation.org>
In-Reply-To: <20080514154402.GF6902@cvg>
References: <20080514154402.GF6902@cvg>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 19:44:02 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> This patch does fix build bug on m68k wich does not have strncat in straight way.
> 
> What is more important - my previous patch
> 
> commit e662e1cfd434aa234b72fbc781f1d70211cb785b
> Author: Cyrill Gorcunov <gorcunov@gmail.com>
> Date:   Mon May 12 14:02:22 2008 -0700
> 
>     init: don't lose initcall return values
> 
> has introduced potential buffer overflow by wrong calculation
> of string accumulator size.
> 
> Many thanks Andreas Schwab and Geert Uytterhoeven for helping
> to catch and fix the bug.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> Index: linux-2.6.git/init/main.c
> ===================================================================
> --- linux-2.6.git.orig/init/main.c	2008-05-14 17:55:10.000000000 +0400
> +++ linux-2.6.git/init/main.c	2008-05-14 19:11:18.000000000 +0400
> @@ -702,7 +702,7 @@ static void __init do_initcalls(void)
>  
>  	for (call = __initcall_start; call < __initcall_end; call++) {
>  		ktime_t t0, t1, delta;
> -		char msgbuf[40];
> +		char msgbuf[64];
>  		int result;
>  
>  		if (initcall_debug) {
> @@ -729,11 +729,11 @@ static void __init do_initcalls(void)
>  			sprintf(msgbuf, "error code %d ", result);
>  
>  		if (preempt_count() != count) {
> -			strncat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
> +			strcat(msgbuf, "preemption imbalance ");
>  			preempt_count() = count;
>  		}
>  		if (irqs_disabled()) {
> -			strncat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
> +			strcat(msgbuf, "disabled interrupts ");
>  			local_irq_enable();
>  		}
>  		if (msgbuf[0]) {

umm, why can't m68k call strncat() from init/main.c??
