Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbXIRRrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbXIRRrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761365AbXIRRrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:47:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:38035 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbXIRRrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=AvGDyG5Qo4Z/wd+rwfpPdHxLhgtiC4bq4pMyj3ffqXBkTJDYVGXO1ZNLixN4WlZR3gLoKTezlZb72TWgymirzhT2C9lOvDuTTwhwDR58ieVyo81D1aInGTvHF0+HHzOIcmyi/Dol2AAXEVa5llFIBdsFSovg3hxnSNKqw65o4OE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 1/7] Immediate Values - Architecture Independent Code
Date: Tue, 18 Sep 2007 18:47:22 +0100
User-Agent: KMail/1.9.1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070917184224.549435917@polymtl.ca> <20070917184319.658506512@polymtl.ca>
In-Reply-To: <20070917184319.658506512@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709181847.22905.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2007 19:42, Mathieu Desnoyers wrote:
> Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-09-17 13:25:06.000000000 -0400
> +++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-09-17 13:35:50.000000000 -0400
> @@ -122,6 +122,13 @@
>  		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
>  	}								\
>  									\
> +	/* Immediate values: pointers */				\
> +	__immediate : AT(ADDR(__immediate) - LOAD_OFFSET) {		\
> +		VMLINUX_SYMBOL(__start___immediate) = .;		\
> +		*(__immediate)						\
> +		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> +	}								\
> +									\

Why do you need an output section for that? IOW: will this work too?

.data : ... { 
...

		VMLINUX_SYMBOL(__start___immediate) = .;		\
		*(__immediate)						\
		VMLINUX_SYMBOL(__stop___immediate) = .;			\
...
}


> Index: linux-2.6-lttng/kernel/module.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/module.c	2007-09-17 13:25:06.000000000 -0400
> +++ linux-2.6-lttng/kernel/module.c	2007-09-17 13:35:51.000000000 -0400
> @@ -33,6 +33,7 @@
>  #include <linux/cpu.h>
>  #include <linux/moduleparam.h>
>  #include <linux/errno.h>
> +#include <linux/immediate.h>
>  #include <linux/err.h>
>  #include <linux/vermagic.h>
>  #include <linux/notifier.h>
> @@ -1717,6 +1718,7 @@ static struct module *load_module(void _
>  	unsigned int unusedcrcindex;
>  	unsigned int unusedgplindex;
>  	unsigned int unusedgplcrcindex;
> +	unsigned int immediateindex;
>  	struct module *mod;
>  	long err = 0;
>  	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
> @@ -1813,6 +1815,7 @@ static struct module *load_module(void _
>  #ifdef ARCH_UNWIND_SECTION_NAME
>  	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
>  #endif
> +	immediateindex = find_sec(hdr, sechdrs, secstrings, "__immediate");


Do you need to frame immediateindex by #ifdef CONFIG_IMMEDIATE / #endif?
--
vda
