Return-Path: <linux-kernel-owner+w=401wt.eu-S1765453AbXHXXY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765453AbXHXXY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 19:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbXHXXYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 19:24:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbXHXXYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 19:24:18 -0400
Date: Fri, 24 Aug 2007 16:23:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH -mm 2/2] Hibernation: Arbitrary boot kernel support on
 x86_64
Message-Id: <20070824162346.ec57f508.akpm@linux-foundation.org>
In-Reply-To: <200708241211.55319.rjw@sisk.pl>
References: <200708241206.57178.rjw@sisk.pl>
	<200708241211.55319.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 12:11:54 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Index: linux-2.6.23-rc3/include/asm-x86_64/suspend.h
> ===================================================================
> --- linux-2.6.23-rc3.orig/include/asm-x86_64/suspend.h	2007-08-21 20:36:49.000000000 +0200
> +++ linux-2.6.23-rc3/include/asm-x86_64/suspend.h	2007-08-21 20:37:47.000000000 +0200
> @@ -43,4 +43,10 @@ extern void fix_processor_context(void);
>  /* routines for saving/restoring kernel state */
>  extern int acpi_save_state_mem(void);
>  
> +#define ARCH_HAS_HIBERNATION_HEADER

The preferred way of doing this is via Kconfig, please.  ie: add a
CONFIG_HIBERNATION_HEADER to arch/x86_64/Kconfig.

> +
> +/* arch/x86_64/kernel/suspend.c */
> +extern int arch_hibernation_header_save(void *addr, unsigned int max_size);
> +extern int arch_hibernation_header_restore(void *addr);

Given that these are called from non-arch-specific code, they must have the
same signature across all architectures.  So there's no point in putting
the prototypes into an arch-specific header file.

It would be better to do something like this in (say) suspend.h:

#ifdef CONFIG_HIBERNATION_HEADER
extern int arch_hibernation_header_save(void *addr, unsigned int max_size);
extern int arch_hibernation_header_restore(void *addr);
#else
static inline int arch_hibernation_header_save(void *addr,
						unsigned int max_size)
{
	return 0;
}

static inline int arch_hibernation_header_restore(void *addr)
{
	return 0;
}
#endif

then go nuke some ifdefs from the .c files.
