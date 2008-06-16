Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbYFPGz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbYFPGz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYFPGzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:55:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:50475 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYFPGzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:55:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kU2lADZGT5WS2jyssR+/Fe9Jj4Gi8SGlpB+FYXC33JrkugkNSxGqC8Mem38hUYbPiN
         kc1EX8uG2k578ejTYUqj6yYnabwF8mms0Fm0nZLVWLfm6whCbGzF7T8E3Xoyw/WcGncX
         5+zlLhH6dS2nVUsPmXXhK/rj7rQYoHDQSy33I=
Message-ID: <19f34abd0806152355h65876c54r1ae0aa156e839db2@mail.gmail.com>
Date: Mon, 16 Jun 2008 08:55:48 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC][PATCH] kmemcheck: divide and conquer
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080616051504.GA3492@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080613140057.GA25833@damson.getinternet.no>
	 <20080614063114.GA24188@elte.hu>
	 <19f34abd0806140139i70a5056ehbd8a6f5df81549e4@mail.gmail.com>
	 <20080614090023.GA13798@elte.hu>
	 <19f34abd0806140217x1ea73a8k1cae18a12128a2b1@mail.gmail.com>
	 <20080616051504.GA3492@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 7:15 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> -tip testing found a build failure with kmemcheck:
>
> include/asm/string_32.h:320:1: warning: "memset" redefined
> include/asm/string_32.h:245:1: warning: this is the location of the previous definition
>
> arch/x86/mm/kmemcheck/smp.c: In function 'kmemcheck_pause_allbutself':
> arch/x86/mm/kmemcheck/smp.c:59: error: 'NMI_VECTOR' undeclared (first use in this function)
> arch/x86/mm/kmemcheck/smp.c:59: error: (Each undeclared identifier is reported only once
> arch/x86/mm/kmemcheck/smp.c:59: error: for each function it appears in.)
>
> with this config:
>
>  http://redhat.com/~mingo/misc/config-Mon_Jun_16_04_15_22_CEST_2008.bad
>
> the patch below fixes the build failure, but note that there are lots of
> those memset redefined warnings with that config as well.

Thanks. I get the error with that config as well.

> @@ -5,6 +5,7 @@
>  #include <mach_ipi.h>
>
>  #include "smp.h"
> +#include <asm/irq_vectors.h>
>
>  static spinlock_t nmi_spinlock;

However, the real error is that I'm including <mach_ipi.h> which for
the default config resolves to
include/asm-x86/mach-default/mach_ipi.h. All the mach-*/mach_ipi.h
files exist, but only one of them define NMI_VECTOR.

But your config has CONFIG_X86_BIGSMP=y.

For some reason, there is no <asm/irq_vectors.h> in my repository, so
I assume the change came from another branch. In fact, I should have
included <asm/hw_irq.h>, but that doesn't contain the right
definitions in the tip/auto-test branch.

Yep, seems to be

commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri May 2 20:10:09 2008 +0200

    x86: unify interrupt vector defines

I also can't seem to get the redefined warnings, so I assume that's
also just an indirect conflict with other -tip changes.

Right now, I am reluctant to apply your fix because it means that
kmemcheck tree won't build as it is. In general, what's the way to
resolve these things? Do you have another branch, *-fixes, where these
fixlets can go until either of the conflicting changesets are merged
upstream? If so, it seems that that would be the right place for this
patch. Do you agree or do you have another solution? :-)

Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
