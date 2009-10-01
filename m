Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbZJAGTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbZJAGTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZJAGTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:19:23 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:39669 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZJAGTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:19:22 -0400
Message-ID: <4AC449BD.1060003@gmail.com>
Date: Thu, 01 Oct 2009 08:18:37 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
References: <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <4AC37FE5.7020200@gmail.com> <alpine.LFD.2.01.0909300909460.6996@localhost.localdomain> <20090930185315.GA9716@elte.hu> <20090930220342.GA2118@elte.hu> <alpine.LFD.2.01.0909301738220.6996@localhost.localdomain> <alpine.LFD.2.01.0909301743150.6996@localhost.localdomain> <4AC43E7E.1000600@gmail.com> <20091001061109.GA21488@elte.hu>
In-Reply-To: <20091001061109.GA21488@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 01 Oct 2009 08:18:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> 
> That's not enough - the inline assembly code in 
> arch/x86/include/asm/cmpxchg_32.h should also not reference 
> cmpxchg8b_emu in that case.
> 

I believe it is OK as is, since cmpxchg8b_emu is referenced only
once, in a section guarded by :
#ifndef CONFIG_X86_CMPXCHG64

(But I'll re-check in a couple of hours)

extract from arch/x86/include/asm/cmpxchg_32.h :


#ifndef CONFIG_X86_CMPXCHG64


#define cmpxchg64(ptr, o, n)                                    \
({                                                              \
        __typeof__(*(ptr)) __ret;                               \
        __typeof__(*(ptr)) __old = (o);                         \
        __typeof__(*(ptr)) __new = (n);                         \
        alternative_io("call cmpxchg8b_emu",                    \
                        "lock; cmpxchg8b (%%esi)" ,             \
                       X86_FEATURE_CX8,                         \
                       "=A" (__ret),                            \
                       "S" ((ptr)), "0" (__old),                \
                       "b" ((unsigned int)__new),               \
                       "c" ((unsigned int)(__new>>32))          \
                       : "memory");                             \
        __ret; })


