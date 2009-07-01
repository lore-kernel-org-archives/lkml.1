Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbZGATp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbZGATp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbZGATpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:45:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbZGATpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:45:51 -0400
Date: Wed, 1 Jul 2009 12:44:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       vapier.adi@gmail.com, lethal@linux-sh.org
Subject: Re: [RFC v2] kernel/printk.c - handling more than one CON_BOOT
Message-Id: <20090701124414.fe188893.akpm@linux-foundation.org>
In-Reply-To: <200906302251.52966.rgetz@blackfin.uclinux.org>
References: <200906290703.21539.rgetz@blackfin.uclinux.org>
	<200906302251.52966.rgetz@blackfin.uclinux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 22:51:52 -0400
Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> From: Robin Getz <rgetz@blackfin.uclinux.org>
> 
> Today, register_console() assumes the following usage:
>   - The first console to register with a flag set to CON_BOOT is the
>     one and only bootconsole.
>   - If another register_console() is called with an additional CON_BOOT,
>     it is silently rejected.
>   - As soon as a console without the CON_BOOT set calls registers
>     the bootconsole is automatically unregistered.
>   - Once there is a "real" console - register_console() will silently
>     reject any consoles with it's CON_BOOT flag set.

hm.  I never knew all that.  Thanks for taking the time to explain all
this - it helps.

I think it would be useful if we had a description of the new design,
similar to your description of the "Today" behaviour above.  Perhaps
as a comment over register_console()?

> In many systems (alpha, blackfin, microblaze, mips, powerpc, sh, & x86), there 
> are early_printk implementations, which use the CON_BOOT which come out 
> serial ports, vga, usb, & memory buffers. In many embedded systems, it would 
> be nice to have two - in case the primary fails, you always have access to a
> backup memory buffer - but this requires at least two CON_BOOT consoles.
> 
> This changeset allows multiple boot consoles, and changes the functionality
> to, be mostly the same as the above.
>  - Any number CON_BOOT consoles of can be registered
>  - A "real" console will unregister all the CON_BOOT consoles
>  - Once a "real" console is registered, no more CON_BOOT consoles 
>    can be added (still silently rejected)

Is the "silent" rejection desirable?  Perhaps that's a
programming/configuration error which the developer should be informed
of?


> diff -puN kernel/printk.c~kernel-printkc-handling-more-than-one-con_boot kernel/printk.c
> --- a/kernel/printk.c~kernel-printkc-handling-more-than-one-con_boot
> +++ a/kernel/printk.c
> @@ -37,6 +37,12 @@
>  #include <asm/uaccess.h>
>  
>  /*
> + * for_each_console() allows you to iterate on each console
> + */
> +#define for_each_console(con) \
> +	for (con = console_drivers; con != NULL; con = con->next)

hum.  Fair enough.


The patch looks good to me.
