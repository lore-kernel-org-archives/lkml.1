Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZGAVKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZGAVKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZGAVKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:10:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44444 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbZGAVKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:10:36 -0400
Date: Wed, 1 Jul 2009 23:10:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, paulus@samba.org,
       arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] FRV: Add basic performance counter support
Message-ID: <20090701211017.GB631@elte.hu>
References: <20090701144913.GA28172@elte.hu> <20090701164705.29780.60902.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701164705.29780.60902.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> Add basic performance counter support to the FRV arch.
> 

that was fast :)

Looks good. There's two areas where we can improve the core 
perfcounters code:

> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  arch/frv/Kconfig                    |    1 +
>  arch/frv/include/asm/perf_counter.h |   17 +++++++++++++++++
>  arch/frv/lib/Makefile               |    2 +-
>  arch/frv/lib/perf_counter.c         |   19 +++++++++++++++++++
>  4 files changed, 38 insertions(+), 1 deletions(-)
>  create mode 100644 arch/frv/include/asm/perf_counter.h
>  create mode 100644 arch/frv/lib/perf_counter.c
> 
> 
> diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
> index 8a5bd7a..b86e19c 100644
> --- a/arch/frv/Kconfig
> +++ b/arch/frv/Kconfig
> @@ -7,6 +7,7 @@ config FRV
>  	default y
>  	select HAVE_IDE
>  	select HAVE_ARCH_TRACEHOOK
> +	select HAVE_PERF_COUNTERS
>  
>  config ZONE_DMA
>  	bool
> diff --git a/arch/frv/include/asm/perf_counter.h b/arch/frv/include/asm/perf_counter.h
> new file mode 100644
> index 0000000..ccf726e
> --- /dev/null
> +++ b/arch/frv/include/asm/perf_counter.h
> @@ -0,0 +1,17 @@
> +/* FRV performance counter support
> + *
> + * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#ifndef _ASM_PERF_COUNTER_H
> +#define _ASM_PERF_COUNTER_H
> +
> +#define PERF_COUNTER_INDEX_OFFSET	0

We shouldnt require this of architectures that dont offer hw 
perfcounters yet.


> +
> +#endif /* _ASM_PERF_COUNTER_H */
> diff --git a/arch/frv/lib/Makefile b/arch/frv/lib/Makefile
> index 4ff2fb1..0a37721 100644
> --- a/arch/frv/lib/Makefile
> +++ b/arch/frv/lib/Makefile
> @@ -5,4 +5,4 @@
>  lib-y := \
>  	__ashldi3.o __lshrdi3.o __muldi3.o __ashrdi3.o __negdi2.o __ucmpdi2.o \
>  	checksum.o memcpy.o memset.o atomic-ops.o atomic64-ops.o \
> -	outsl_ns.o outsl_sw.o insl_ns.o insl_sw.o cache.o
> +	outsl_ns.o outsl_sw.o insl_ns.o insl_sw.o cache.o perf_counter.o
> diff --git a/arch/frv/lib/perf_counter.c b/arch/frv/lib/perf_counter.c
> new file mode 100644
> index 0000000..2000fee
> --- /dev/null
> +++ b/arch/frv/lib/perf_counter.c
> @@ -0,0 +1,19 @@
> +/* Performance counter handling
> + *
> + * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#include <linux/perf_counter.h>
> +
> +/*
> + * mark the performance counter as pending
> + */
> +void set_perf_counter_pending(void)
> +{
> +}

This could be avoided as well via a generic weak alias.

	Ingo
