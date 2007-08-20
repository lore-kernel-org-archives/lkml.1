Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbXHTS4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbXHTS4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 14:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbXHTS4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 14:56:40 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:32828 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751105AbXHTS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 14:56:40 -0400
Date: Mon, 20 Aug 2007 20:56:37 +0200
From: Jan Hubicka <jh@suse.cz>
To: Roland Dreier <rdreier@cisco.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, jh@suse.cz
Subject: Re: [discuss] [PATCH] x86-64: memset optimization
Message-ID: <20070820185637.GL27714@kam.mff.cuni.cz>
References: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net> <200708182055.11277.ak@suse.de> <20070819010430.2c8c31fc@oldman.hemminger.net> <200708192024.24864.ak@suse.de> <20070820085253.5f589e58@freepuppy.rosehill.hemminger.net> <1187625068.2577.3.camel@laptopd505.fenrus.org> <adamywmw32l.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adamywmw32l.fsf@cisco.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  > > The problem is with the optimization flags: passing -Os causes the compiler
>  > > to be stupid and not inline any memset/memcpy functions.
>  > 
>  > you get what you ask for.. if you don't want that then don't ask for
>  > it ;)
> 
> Well, the compiler is really being dumb about -Os and in fact it's
> giving bigger code, so I'm not really getting what I ask for.  
> 
> With my gcc at least (x86_64, gcc (GCC) 4.1.3 20070812 (prerelease)
> (Ubuntu 4.1.2-15ubuntu2)) and Andi's example:
> 
> #include <string.h>
> 
> f(char x[6]) {
>         memset(x, 1, 6);
> }
> 
> compiling with -O2 gives
> 
> 0000000000000000 <f>:
>    0:	c7 07 01 01 01 01    	movl   $0x1010101,(%rdi)
>    6:	66 c7 47 04 01 01    	movw   $0x101,0x4(%rdi)
>    c:	c3                   	retq   

GCC mainline (ie future GCC4.3.0) now give:
0000000000000000 <f>:
   0:   b0 01                   mov    $0x1,%al
   2:   b9 06 00 00 00          mov    $0x6,%ecx
   7:   f3 aa                   rep stos %al,%es:(%rdi)
   9:   c3                      retq 
That is smallest, definitly not fastest.
GCC up to 4.3.0 won't be able to inline memset with non-0 operand...

Honza
> 
> and compiling with -Os gives
> 
> 0000000000000000 <f>:
>    0:	48 83 ec 08          	sub    $0x8,%rsp
>    4:	ba 06 00 00 00       	mov    $0x6,%edx
>    9:	be 01 00 00 00       	mov    $0x1,%esi
>    e:	e8 00 00 00 00       	callq  13 <f+0x13>
>   13:	5a                   	pop    %rdx
>   14:	c3                   	retq   
> 
> so the code gets bigger and worse in every way.
> 
>  - R.
