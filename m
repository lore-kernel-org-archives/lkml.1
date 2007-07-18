Return-Path: <linux-kernel-owner+w=401wt.eu-S932187AbXGRWRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbXGRWRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbXGRWRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:17:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754798AbXGRWRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:17:24 -0400
Date: Wed, 18 Jul 2007 15:16:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: early_printk accessing __log_buf
Message-Id: <20070718151617.fe6a2943.akpm@linux-foundation.org>
In-Reply-To: <200707181756.44074.rgetz@blackfin.uclinux.org>
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 17:56:43 -0400
Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> Quick question:
> 
> I am currently setting up an early_printk for the Blackfin - & I'm populating
> an early fault interrupt handler at the same time. This allows things like
> catching interrupts, or faults before the kernel has had a chance to
> enable it's standard interrupt/fault handlers which happen midway 
> through the boot process.
> 
> I would like to be able to print out the standard __log_buf from my early
> fault handler - so everyone can see where things are when they died. In
> most situations - printk has dumped some info to the log_buf, and it is
> normally handy to see figure out what is going on.
> 
> However - __log_buf & associated pointers are declared as static in
> kernel/printk.c - so they can't be accessed by external files.
> 
> I would normally use do_syslog([23],...) to read from the buffer - 
> but these crashes happens before the kernel is fully initialized,
> so spin_lock_irq, cond_resched, or wait_event_interruptible
> will cause problems...
> 
> Although there are other solutions - I would prefer to just don't declare them
> as static when EARLY_PRINTK is defined. This way if something bad happens - 
> everyone can dump out the standard buffers to assist in debugging...

Being able to get at the log buffer from external debug-style code is a
fairly common requirement.

> ===================================================================
> --- linux-2.6.x/kernel/printk.c (revision 3400)
> +++ linux-2.6.x/kernel/printk.c (working copy)
> @@ -117,7 +117,12 @@
> 
>  #ifdef CONFIG_PRINTK
> 
> +#ifdef CONFIG_EARLY_PRINTK
> +char __log_buf[__LOG_BUF_LEN];
> +#else
>  static char __log_buf[__LOG_BUF_LEN];
> +#endif
> +
>  static char *log_buf = __log_buf;
>  static int log_buf_len = __LOG_BUF_LEN;
>  static unsigned long logged_chars; /* Number of chars produced since last read+clear operation */
> 

erk.  There isn't much point in making something externally accessible
without also declaring it in a header file.  And callers will need to be
able to get at log_buf_len too, I guess.

I'd suggest that any interface into here should be via function calls, not
via direct access to printk internals: think up some nice
copy_me_some_of_the_log_buffer() interface.
