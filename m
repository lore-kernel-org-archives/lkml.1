Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbXISLAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbXISLAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbXISK74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 06:59:56 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:32823 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755902AbXISK7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 06:59:55 -0400
Date: Wed, 19 Sep 2007 06:59:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Message-ID: <20070919105951.GA15500@Krystal>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46F04856.3010808@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 06:48:35 up 51 days, 11:07,  3 users,  load average: 1.25, 0.66, 0.47
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
> 
> > +#define immediate_read(name)						\
> > +	({								\
> > +		__typeof__(name##__immediate) value;			\
> > +		switch (sizeof(value)) {				\
> > +		case 1:							\
> > +			asm (	".section __immediate, \"a\", @progbits;\n\t" \
> > +					".long %1, (0f)+1, 1;\n\t"	\
> > +					".previous;\n\t"		\
> > +					"0:\n\t"			\
> > +					"mov %2,%0;\n\t"		\
> 
> Given that you're relying on the exact instruction that this mov
> generates, it might be better to explicitly put the opcodes in with
> .byte.  That way you're protected from the assembler deciding to
> generate some other form of the instruction (for whatever reason).  I
> guess substituting in different registers would be a pain.
> 

Good point. I thought it might come up, especially for 16 bits mov that
can be expressed under different forms, one of which has a prefix. I
would like to go for Peter's suggestion: putting the label _after_ the
instruction, since we know that we will be right after the immediate
value, but it has a drawback: we cannot insure correct alignment of the
immediate value in that case. But that would help not having to force
the register.

> Aside from that,  is there any reason not to just put $0 in there rather
> than use %2?
> 

Actually, no, since the initial value is written to the immediate value
references at early boot and at module load time. I originally thought
passing the referenced variable to it, but, as I recall, it brought
linker issues when the symbol was defined in another module. So yes,
just $0 is ok, I'll change that.

> 
> > +					".long %1, (0f)+1, 4;\n\t"	\
> > +					".previous;\n\t"		\
> > +					"1:\n\t"			\
> > +					".org (1b)+(3-((1b)%%4)), 0x90;\n\t" \
> >   
> Seems a little complex, but I couldn't come up with anything much better:
> 
> 	.org . + 3 - (. & 3), 0x90
> 
> You can use . rather than needing to define 1:, it doesn't need quite so
> many parens, and using &3 avoids the %% wart. 
> 

Yes, this one is tricky.. trying to align efficiently something on a 4
bytes address - 1 is not what gas is used to help doing.

> It's a pity that gas seems to generate plain 0x90 nops rather than
> long-nop forms here.  I thought it could do that.
> 

At least we will have at most 3 nops there.

Mathieu

>     J

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
