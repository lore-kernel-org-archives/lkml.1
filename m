Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYK1RAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYK1RAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 12:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYK1RAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 12:00:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35927 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbYK1RAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 12:00:42 -0500
Date: Fri, 28 Nov 2008 18:00:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] warn: print the DMI board info name in a
	WARN/WARN_ON
Message-ID: <20081128170029.GD10487@elte.hu>
References: <20081128083525.092e9859@linux.intel.com> <20081128083609.2a254c06@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081128083609.2a254c06@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> From acdc8771dfaf6e8236b9122364301f65f46d4b59 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 28 Nov 2008 08:32:44 -0800
> Subject: [PATCH] warn: print the DMI board info name in a WARN/WARN_ON
> 
> it's very useful for many low level WARN_ON's to find out which
> motherboard has the broken BIOS etc... this patch adds a printk
> to the WARN_ON code for this.
> On architectures without DMI, gcc should optimize the code out.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  kernel/panic.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 2b913aa..9c1b7e0 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -21,6 +21,7 @@
>  #include <linux/debug_locks.h>
>  #include <linux/random.h>
>  #include <linux/kallsyms.h>
> +#include <linux/dmi.h>
>  
>  int panic_on_oops;
>  static unsigned long tainted_mask;
> @@ -328,12 +329,16 @@ void warn_slowpath(const char *file, int line, const char *fmt, ...)
>  {
>  	va_list args;
>  	char function[KSYM_SYMBOL_LEN];
> +	const char *board;
>  	unsigned long caller = (unsigned long)__builtin_return_address(0);
>  	sprint_symbol(function, caller);
>  
>  	printk(KERN_WARNING "------------[ cut here ]------------\n");
>  	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
>  		line, function);
> +	board = dmi_get_system_info(DMI_PRODUCT_NAME);
> +	if (board)
> +		printk(KERN_WARNING "Hardware name: %s\n", board);
>  
>  	if (fmt) {
>  		va_start(args, fmt);

nice idea - applied to tip/core/debug.

On architectures (or systems) where there's no DMI_PRODUCT_NAME string 
available, we'll print nothing. It's also a simple lockless call so can 
be called from any context.

Andrew, any objections?

	Ingo
