Return-Path: <linux-kernel-owner+w=401wt.eu-S1750940AbXDDUnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbXDDUnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXDDUnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:43:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55822 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbXDDUno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:43:44 -0400
Date: Wed, 4 Apr 2007 13:43:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>
Subject: Re: [PATCH -mm] fix jiffies clocksource inittime
Message-Id: <20070404134310.12ad3ab8.akpm@linux-foundation.org>
In-Reply-To: <1175716216.17711.59.camel@localhost>
References: <1175716216.17711.59.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 12:50:15 -0700
john stultz <johnstul@us.ibm.com> wrote:

> 	In debugging a problem w/ the -rt tree, I noticed that on systems that
> mark the tsc as unstable before it is registered, the TSC would still be
> selected and used for a short period of time. Digging in it looks to be
> a result of the mix of the clocksource list changes and my clocksource
> initialization changes.
> 
> With the -rt tree, using a bad TSC, even for a short period of time can
> results in a hang at boot. I was not able to reproduce this hang w/
> mainline, but I'm not completely certain that someone won't trip on it.
> 
> This patch resolves the issue by initializing the jiffies clocksource
> earlier so a bad TSC won't get selected just because nothing else is yet
> registered.
> 
> thanks
> -john
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
> index 3be8da8..4c256fd 100644
> --- a/kernel/time/jiffies.c
> +++ b/kernel/time/jiffies.c
> @@ -69,4 +69,4 @@ static int __init init_jiffies_clocksour
>  	return clocksource_register(&clocksource_jiffies);
>  }
>  
> -module_init(init_jiffies_clocksource);
> +core_initcall(init_jiffies_clocksource);

Do you think this is needed in 2.6.21?

If so: worrisome.  Startup ordering issues are fragile and tricky.  Time
management is fragile and tricky.  The combination of the two doesn't get
any better ;)

An option would be to test it in 2.6.22-rcX for a while, then backport to
2.6.21.x.


