Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbXHUKQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbXHUKQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbXHUKQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:16:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:10742 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbXHUKQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=njq6vQuD6m2rbhYUamALYq4xdxSiiN9oQ076oUNRanQcM4GrBMX5jtFF9zecQj8hGv6t7H1+cr9jyyMmpksp4oJ1Y5D0Nfx81IpqxVAZ62+oLXqzPX24mjMxuQgjUyAy0BfPIH2V8Far7V+9a6p/20/LQ+mweJH5hg+SbvMdNVU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jan Hubicka <jh@suse.cz>
Subject: Re: [discuss] [PATCH] x86-64: memset optimization
Date: Tue, 21 Aug 2007 11:16:10 +0100
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>, Arjan van de Ven <arjan@infradead.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net> <adamywmw32l.fsf@cisco.com> <20070820185637.GL27714@kam.mff.cuni.cz>
In-Reply-To: <20070820185637.GL27714@kam.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211116.11035.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2007 19:56, Jan Hubicka wrote:
> >  > > The problem is with the optimization flags: passing -Os causes the
> >  > > compiler to be stupid and not inline any memset/memcpy functions.
> >  >
> >  > you get what you ask for.. if you don't want that then don't ask for
> >  > it ;)
> >
> > Well, the compiler is really being dumb about -Os and in fact it's
> > giving bigger code, so I'm not really getting what I ask for.
> >
> > With my gcc at least (x86_64, gcc (GCC) 4.1.3 20070812 (prerelease)
> > (Ubuntu 4.1.2-15ubuntu2)) and Andi's example:
> >
> > #include <string.h>
> >
> > f(char x[6]) {
> >         memset(x, 1, 6);
> > }
> >
> > compiling with -O2 gives
> >
> > 0000000000000000 <f>:
> >    0:	c7 07 01 01 01 01    	movl   $0x1010101,(%rdi)
> >    6:	66 c7 47 04 01 01    	movw   $0x101,0x4(%rdi)
> >    c:	c3                   	retq
>
> GCC mainline (ie future GCC4.3.0) now give:
> 0000000000000000 <f>:
>    0:   b0 01                   mov    $0x1,%al
>    2:   b9 06 00 00 00          mov    $0x6,%ecx
>    7:   f3 aa                   rep stos %al,%es:(%rdi)
>    9:   c3                      retq
> That is smallest, definitly not fastest.
> GCC up to 4.3.0 won't be able to inline memset with non-0 operand...

No, it's not smallest. This one is smaller by 1 byte, maybe faster
(rep ... prefix is microcoded -> slower) and frees %ecx for other uses:

        mov    $0x01010101,%eax  # 5 bytes
        stosl                    # 1 byte
        stosw                    # 2 bytes
        retq
--
vda
