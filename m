Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbYDYPzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbYDYPzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 11:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763279AbYDYPys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 11:54:48 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:55305 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763164AbYDYPyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 11:54:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYEACucEUhMROPA/2dsb2JhbACBUqpo
Date: Fri, 25 Apr 2008 11:54:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
       David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Message-ID: <20080425155444.GB9503@Krystal>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:49:30 up 56 days, 12:00,  7 users,  load average: 0.49, 0.39,
	0.37
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Fri, 25 Apr 2008, Ingo Molnar wrote:
> > 
> > something like the patch below? (untested)
> 
> No. That whole code sequence is total and utter crap. It needs to be 
> rewritten.
> 
> It first does a BUG_ON() if it's not naturally aligned (because that 
> wouldn't be atomic), and then it has code for page crossing! What a TOTAL 
> PIECE OF SH*T!
> 
> Hint:
>  - if it's naturally aligned, it couldn't be page crossing ANYWAY
>  - and if it was a page-crosser, it sure as hell couldn't be atomic!
> 
> The code is just crap, crap, crap. It needs to be rewritten from scratch. 
> I'll have a patch soonish.
> 
> 		Linus


Woooow, just a sec here. I removed the atomicity test _because_ there
happen to be a case where it's safe to do non-atomic instruction
modification. If we do :

1) replace the instruction first byte by a breakpoint, execute an
  instruction bypass (see the immediate values patches for detail)
2) modify the instruction non-atomically
3) put back the original instruction first byte.

That's why I removed the BUG_ONs at the beginning of the function.
That's also why it's required to deal with page crossing.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
