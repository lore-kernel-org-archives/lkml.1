Return-Path: <linux-kernel-owner+w=401wt.eu-S1761607AbXGJHjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607AbXGJHjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbXGJHje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:39:34 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:44037 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbXGJHjd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:39:33 -0400
Date: Tue, 10 Jul 2007 09:37:37 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86 setup 22/33] CPU features verification for the new x86
 setup code
Message-ID: <20070710093737.1f1afbf4@frecb000686.frec.bull.fr>
In-Reply-To: <11840382473923-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
	<11840363531039-git-send-email-hpa@zytor.com>
	<11840364593068-git-send-email-hpa@zytor.com>
	<1184036564610-git-send-email-hpa@zytor.com>
	<11840366692770-git-send-email-hpa@zytor.com>
	<11840367741994-git-send-email-hpa@zytor.com>
	<11840368791603-git-send-email-hpa@zytor.com>
	<11840369841576-git-send-email-hpa@zytor.com>
	<11840370903975-git-send-email-hpa@zytor.com>
	<11840371953778-git-send-email-hpa@zytor.com>
	<11840373002601-git-send-email-hpa@zytor.com>
	<11840374052662-git-send-email-hpa@zytor.com>
	<1184037510289-git-send-email-hpa@zytor.com>
	<11840376162370-git-send-email-hpa@zytor.com>
	<11840377211519-git-send-email-hpa@zytor.com>
	<11840378261081-git-send-email-hpa@zytor.com>
	<11840379311574-git-send-email-hpa@zytor.com>
	<11840380363720-git-send-email-hpa@zytor.com>
	<11840381413065-git-send-email-hpa@zytor.com>
	<11840382473923-git-send-email-hpa@zytor.com>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/07/2007 09:43:53,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/07/2007 09:43:54,
	Serialize complete at 10/07/2007 09:43:54
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Peter,

  Only two sub-minor nits:

On Mon, 9 Jul 2007 19:52:01 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> From: H. Peter Anvin <hpa@zytor.com>
> 
> Verify that the CPU has enough features to run the kernel.  This may
> entail enabling features on some CPUs.
> 
> By doing this in the setup code we can be guaranteed to still be able to
> write to the console through the BIOS.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/i386/boot/cpu.c      |   69 ++++++++++++
>  arch/i386/boot/cpucheck.c |  267 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 336 insertions(+), 0 deletions(-)
>  create mode 100644 arch/i386/boot/cpu.c
>  create mode 100644 arch/i386/boot/cpucheck.c
> 
> diff --git a/arch/i386/boot/cpu.c b/arch/i386/boot/cpu.c
> new file mode 100644
> index 0000000..042d894
> --- /dev/null
> +++ b/arch/i386/boot/cpu.c
> @@ -0,0 +1,69 @@
> +/* -*- linux-c -*- ------------------------------------------------------- *
> + *
> + *   Copyright (C) 1991, 1992 Linus Torvalds
> + *   Copyright 2007 rPath, Inc. - All Rights Reserved
> + *
> + *   This file is part of the Linux kernel, and is made available under
> + *   the terms of the GNU General Public License version 2.
> + *
> + * ----------------------------------------------------------------------- */
> +
> +/*
> + * arch/i386/boot/cpucheck.c

                    ^^^^^
                    cpu.c ?

> + *
> + * Check for obligatory CPU features and abort if the features are not
> + * present.
> + */
> +
> +#include "boot.h"
> +#include "bitops.h"
> +#include <asm/cpufeature.h>
> +
> +static char *cpu_name(int level)
> +{
> +	static char buf[6];
> +
> +	if (level == 64) {
> +		return "x86-64";
> +	} else {
> +		sprintf(buf, "i%d86", level);
> +		return buf;
> +	}
> +}
> +
> +int validate_cpu(void)
> +{
> +	u32 *err_flags;
> +	int cpu_level, req_level;
> +
> +	check_cpu(&cpu_level, &req_level, &err_flags);
> +
> +	if (cpu_level < req_level) {
> +		printf("This kernel requires an %s CPU, ",
> +		       cpu_name(req_level));
> +		printf("but only detected an %s CPU.\n",
> +		       cpu_name(cpu_level));
> +		return -1;
> +	}
> +
> +	if (err_flags) {
> +		int i, j;
> +		puts("This kernel requires the following features "
> +		     "not present on the CPU:\n");
> +
> +		for (i = 0; i < NCAPINTS; i++) {
> +			u32 e = err_flags[i];
> +
> +			for (j = 0; j < 32; j++) {
> +				if (e & 1)
> +					printf("%d:%d ", i, j);
> +
> +				e >>= 1;
> +			}
> +		}
> +		putchar('\n');
> +		return -1;
> +	} else {
> +		return 0;
> +	}
> +}
> diff --git a/arch/i386/boot/cpucheck.c b/arch/i386/boot/cpucheck.c
> new file mode 100644
> index 0000000..431bef8
> --- /dev/null
> +++ b/arch/i386/boot/cpucheck.c
> @@ -0,0 +1,267 @@
> +/* -*- linux-c -*- ------------------------------------------------------- *
> + *
> + *   Copyright (C) 1991, 1992 Linus Torvalds
> + *   Copyright 2007 rPath, Inc. - All Rights Reserved
> + *
> + *   This file is part of the Linux kernel, and is made available under
> + *   the terms of the GNU General Public License version 2.
> + *
> + * ----------------------------------------------------------------------- */
> +
> +/*
> + * arch/i386/boot/cpu.c

                    ^^^^^
                    cpucheck.c ?

> + *
> + * Check for obligatory CPU features and abort if the features are not
> + * present.  This code should be compilable as 16-, 32- or 64-bit
> + * code, so be very careful with types and inline assembly.
> + *
> + * This code should not contain any messages; that requires an
> + * additional wrapper.
> + *


  Sébastien.


