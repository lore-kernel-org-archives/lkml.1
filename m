Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbYGBIqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbYGBIqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbYGBIqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:46:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbYGBIqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:46:05 -0400
Date: Wed, 2 Jul 2008 01:45:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: rtc-linux@googlegroups.com, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2.6.26-mmotm] rtc: BCD codeshrink
Message-Id: <20080702014502.c1052e84.akpm@linux-foundation.org>
In-Reply-To: <200807012341.01684.david-b@pacbell.net>
References: <200807012341.01684.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 23:41:01 -0700 David Brownell <david-b@pacbell.net> wrote:

> This updates <linux/bcd.h> to define the key routines as constant
> functions, which the macros will then call.  Newer code can now
> call bcd2bin() instead of SCREAMING BCD2BIN() TO THE FOUR WINDS.
> 
> This lets each driver shrink their codespace by using N function
> calls to a single (global) copy of those routines, instead of N
> inlined copies of these functions per driver.
> 
> These routines aren't used in speed-critical code.  Almost all
> callers are in the RTC framework.  Typical per-driver savings is
> near 300 bytes.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Acked-by:  Adrian Bunk <bunk@kernel.org>
> ---
>  include/linux/bcd.h |    9 +++++++--
>  lib/Makefile        |    2 +-
>  lib/bcd.c           |   14 ++++++++++++++
>  3 files changed, 22 insertions(+), 3 deletions(-)
> 
> --- a/include/linux/bcd.h	2008-06-30 16:44:26.000000000 -0700
> +++ b/include/linux/bcd.h	2008-06-30 21:38:24.000000000 -0700
> @@ -10,8 +10,13 @@
>  #ifndef _BCD_H
>  #define _BCD_H
>  
> -#define BCD2BIN(val)	(((val) & 0x0f) + ((val)>>4)*10)
> -#define BIN2BCD(val)	((((val)/10)<<4) + (val)%10)
> +#include <linux/compiler.h>
> +
> +unsigned bcd2bin(unsigned char val) __attribute_const__;
> +unsigned char bin2bcd(unsigned val) __attribute_const__;
> +
> +#define BCD2BIN(val)	bcd2bin(val)
> +#define BIN2BCD(val)	bin2bcd(val)

It'd be good to nuke these things now.

Unfortunately you didn't cc the list where nukers lurk.  Please do cc
linux-kernel on kernel-wide patches.

>  /* backwards compat */
>  #define BCD_TO_BIN(val) ((val)=BCD2BIN(val))
> --- a/lib/Makefile	2008-06-30 16:44:26.000000000 -0700
> +++ b/lib/Makefile	2008-06-30 21:38:24.000000000 -0700
> @@ -13,7 +13,7 @@ lib-$(CONFIG_SMP) += cpumask.o
>  
>  lib-y	+= kobject.o kref.o klist.o
>  
> -obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
> +obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
>  	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o
>  
>  ifeq ($(CONFIG_DEBUG_KOBJECT),y)
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ b/lib/bcd.c	2008-06-30 21:38:24.000000000 -0700
> @@ -0,0 +1,14 @@
> +#include <linux/bcd.h>
> +#include <linux/module.h>
> +
> +unsigned bcd2bin(unsigned char val)
> +{
> +	return (val & 0x0f) + (val >> 4) * 10;
> +}
> +EXPORT_SYMBOL(bcd2bin);
> +
> +unsigned char bin2bcd(unsigned val)
> +{
> +	return ((val / 10) << 4) + val % 10;
> +}
> +EXPORT_SYMBOL(bin2bcd);
