Return-Path: <linux-kernel-owner+w=401wt.eu-S1765635AbZFQMIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765635AbZFQMIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759544AbZFQMIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:08:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47721 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300AbZFQMIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:08:36 -0400
Date: Wed, 17 Jun 2009 14:08:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: benh@kernel.crashing.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/6] perf_counter: tools: Makefile tweaks for 64-bit
	powerpc
Message-ID: <20090617120831.GB26454@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com> <19000.55666.866148.559620@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19000.55666.866148.559620@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> +++ b/tools/perf/Makefile
> @@ -157,9 +157,21 @@ uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
>  uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
>  uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
>  
> +# If we're on a 64-bit kernel, use -m64
> +ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
> +  M64 := -m64
> +endif

this is fine.

> +# Don't use -Werror on ppc64; we get warnings due to using
> +# %Lx formats on __u64, which is unsigned long.
> +Werror := -Werror
> +ifeq ($(uname_M),ppc64)
> +  Werror :=
> +endif

hm, i dont really like this one - it just adds a special case on an 
arch. Why is __u64 unsigned long on powerpc and not unsigned long 
long? I thought the whole mess with u64 was fixed there recently and 
powerpc too now uses include/asm-generic/int-ll64.h ?

ah, it does this:

/*
 * This is here because we used to use l64 for 64bit powerpc
 * and we don't want to impact user mode with our change to ll64
 * in the kernel.
 */
#if defined(__powerpc64__) && !defined(__KERNEL__)
# include <asm-generic/int-l64.h>
#else
# include <asm-generic/int-ll64.h>
#endif

That's crappy really.

	Ingo
