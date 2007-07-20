Return-Path: <linux-kernel-owner+w=401wt.eu-S937986AbXGTIa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937986AbXGTIa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936343AbXGTI1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:27:54 -0400
Received: from mail.suse.de ([195.135.220.2]:47340 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936240AbXGTI1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:27:50 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dmitry Torokhov <dtor@insightbb.com>
Subject: Re: [PATCH for review] [12/48] x86_64: use the global PIT lock
Date: Fri, 20 Jul 2007 10:25:12 +0200
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
References: <20070719348.540885000@suse.de> <200707192152.03321.ak@suse.de> <200707200024.21467.dtor@insightbb.com>
In-Reply-To: <200707200024.21467.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707201025.12915.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +static DEFINE_SPINLOCK(i8253_lock);
> +
>  static __init int add_pcspkr(void)
>  {
>         struct platform_device *pd;
> @@ -1501,9 +1503,14 @@ static __init int add_pcspkr(void)
>         if (!pd)
>                 return -ENOMEM;
>  
> +       pd->dev.platform_data = &i8253_lock;

That seems pretty ugly to pass spinlocks around in void * pointers. Also 
out of general memory bloat reasons i don't like allocating big data structures
just for this.

Wouldn't  it be better to just define i8253_lock weakly in the pcspkr code and let 
the architecture override it?

> Index: work/arch/x86_64/kernel/time.c
> ===================================================================
> --- work.orig/arch/x86_64/kernel/time.c
> +++ work/arch/x86_64/kernel/time.c
> @@ -23,6 +23,7 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/sysdev.h>
> +#include <linux/platform_device.h>
>  #include <linux/bcd.h>
>  #include <linux/notifier.h>
>  #include <linux/cpu.h>
> @@ -185,7 +186,7 @@ void main_timer_handler(void)
>                 set_rtc_mmss(xtime.tv_sec);
>                 rtc_update = xtime.tv_sec + 660;
>         }
> - 
> +
>         write_sequnlock(&xtime_lock);
>  }

No random white space changes in patches, multiple occurrences ?!?

-Andi

