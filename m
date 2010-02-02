Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab0BBAxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 19:53:18 -0500
Received: from ozlabs.org ([203.10.76.45]:37316 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab0BBAxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 19:53:16 -0500
Date: Tue, 2 Feb 2010 11:50:02 +1100
From: Anton Blanchard <anton@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: Fix panic_timeout accuracy when running on a
 hypervisor
Message-ID: <20100202005002.GA2996@kryten>
References: <20100201041430.GQ2996@kryten>
 <20100201140245.faeec398.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201140245.faeec398.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

> > +static void panic_blink_one_second(void)
> > +{
> > +	static long i = 0, end;
> 
> I assumed the `static' was a brainfart and removed it?

...

> In fact we can simplify it a bit:
> 
> --- a/kernel/panic.c~panic-fix-panic_timeout-accuracy-when-running-on-a-hypervisor-fix
> +++ a/kernel/panic.c
> @@ -42,12 +42,10 @@ EXPORT_SYMBOL(panic_blink);
>  
>  static void panic_blink_one_second(void)
>  {
> -	static long i = 0, end;
> -
>  	if (panic_blink) {
> -		end = i + MSEC_PER_SEC;
> +		long i = 0;
>  
> -		while (i < end) {
> +		while (i < MSEC_PER_SEC) {
>  			i += panic_blink(i);
>  			mdelay(1);
>  			i++;

Unfortunately the panic_blink users seem to rely on count ever increasing:

static long i8042_panic_blink(long count)
{
...
        static long last_blink;
...
        if (count - last_blink < i8042_blink_frequency)
                return 0;

If we reset to 0 each second, this is going to always be true. Ugly interface.

Anton
