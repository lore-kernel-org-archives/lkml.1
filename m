Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbZI3QOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbZI3QOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZI3QOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:14:49 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:38034 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZI3QOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:14:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z6c6HP+uM9PPITcwwTlP9ccsPy7qaN6hiIERsgXpnT1QM/HIjiFr/JMKt8tKknhEJZ
         Q2igQ7jmh7iKpkkoM0aXkll7joR4Cx0lgXSA581buPmNlpkzpqg9EWnpG9LSo9KaYKq7
         FxMS8JAfR+gb46xBpt/78i2I4X30JyY1uLJg8=
Date: Wed, 30 Sep 2009 20:14:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32-rc1
Message-ID: <20090930161447.GC5235@lenovo>
References: <4AC060AE.1090401@gmail.com> <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain> <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com> <4AC2712C.4080901@gmail.com> <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain> <20090929232248.735bf4df@infradead.org> <alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org> <4AC37FE5.7020200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC37FE5.7020200@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Eric Dumazet - Wed, Sep 30, 2009 at 05:57:25PM +0200]
...
| 
| > +#define cmpxchg64(ptr, o, n)					\
| > +({								\
| > +	__typeof__(*(ptr)) __ret;				\
| > +	__typeof__(*(ptr)) __old = (o);				\
| > +	__typeof__(*(ptr)) __new = (n);				\
| > +	alternative_io("call cmpxchg8b_emu",			\
| > +			"lock; cmpxchg8b (%%esi)" ,		\
| > +		       X86_FEATURE_CX8,				\
| > +		       "=A" (__ret),				\
| > +		       "S" ((ptr)), "0" (__old),		\
| > +		       "b" ((unsigned int)__new),		\
| > +		       "c" ((unsigned int)(__new>>32)));	\
| 
| 
| Note:
| 
| lock; cmpxchg8b (%%esi)
| 
| gives 4 bytes opcode : f0 0f c7 0e
| Because alternative (call cmpxchg8b_emu) uses 5 bytes, a nop will be added.
| 
| Choosing ".byte 0xf0, 0x0f, 0xc7, 0x4e, 0x00"  aka "lock cmpxchg8b 0x0(%esi)" is a litle bit better ?
| 

Just curious why not "nop; lock; cmpxchg8b (%esi)"? lock itself is destructive
instruction with causes write buffers to flush data back and NOP itself will
be discarded by cpu internals so I suppose this form should be better. Though
I could miss something, and OTOH it's not a big deal. But still curious :)

	-- Cyrill
