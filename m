Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbZJIPLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbZJIPLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbZJIPLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:11:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbZJIPLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:11:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1255093530.8802.64.camel@laptop>
References: <1255093530.8802.64.camel@laptop> <20091008232226.768382977@chello.nl>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/4] stack based kmap_atomic -v2
Date: Fri, 09 Oct 2009 16:10:24 +0100
Message-ID: <13895.1255101024@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

>  	type = kmap_atomic_idx_push();
> ...
> +	switch (type + 4) {

This bit is the bit I particularly dislike.  'type' is not fixed at compile
time, which means that the switch-statement cannot be optimised down.  With
your original patch, for example, the following code seems to simplify quite
nicely from:

	int test_kmap(struct page *page)
	{
		int *p, q;
		p = kmap_atomic(page, KM_USER0);
		q = *p;
		kunmap_atomic(page, KM_USER0);
		return q;
	}

to:

	int test_kmap(struct page *page)
	{
		int *p, q;
		p = kmap_atomic(page);
		q = *p;
		kunmap_atomic(page);
		return q;
	}

but, the assembly goes from:

	000002a0 <test_kmap>:
	 2a0:   82 40 1f f0     addi sp,-16,sp
	 2a4:   05 48 10 00     sti.p fp,@(sp,0)
	 2a8:   84 88 10 00     ori sp,0,fp
	 2ac:   88 0d 01 c5     movsg lr,gr5
	 2b0:   8b 48 20 08     sti gr5,@(fp,8)
	 2b4:   88 c8 f0 14     ldi @(gr15,20),gr4
	 2b8:   88 40 40 01     addi gr4,1,gr4
	 2bc:   89 48 f0 14     sti gr4,@(gr15,20)
	 2c0:   88 c9 00 00     ldi @(gr16,0),gr4
	 2c4:   10 00 81 04     sub.p gr8,gr4,gr8
	 2c8:   88 fc 0c 09     setlos 0xc09,gr4
	 2cc:   90 b0 80 05     srai gr8,5,gr8
	 2d0:   90 a0 80 0e     slli gr8,14,gr8
	 2d4:   90 04 80 84     or gr8,gr4,gr8
	 2d8:   ba 0c 91 88     movgs gr8,dampr9
	 2dc:   b8 0c 91 c4     movsg damlr9,gr4
	 2e0:   90 08 41 00     ld @(gr4,gr0),gr8
	 2e4:   ba 0c 91 80     movgs gr0,dampr9
	 2e8:   88 c8 f0 14     ldi @(gr15,20),gr4
	 2ec:   88 40 4f ff     addi gr4,-1,gr4
	 2f0:   89 48 f0 14     sti gr4,@(gr15,20)
	 2f4:   8a c8 20 08     ldi @(fp,8),gr5
	 2f8:   84 08 21 00     ld @(fp,gr0),fp
	 2fc:   00 30 50 00     jmpl.p @(gr5,gr0)
	 300:   82 40 10 10     addi sp,16,sp

to:

	000002a0 <test_kmap>:
	 2a0:	82 40 1f f0 	addi sp,-16,sp
	 2a4:	05 48 10 00 	sti.p fp,@(sp,0)
	 2a8:	84 88 10 00 	ori sp,0,fp
	 2ac:	88 0d 01 c5 	movsg lr,gr5
	 2b0:	0b 48 20 08 	sti.p gr5,@(fp,8)
	 2b4:	94 88 80 00 	ori gr8,0,gr10
	 2b8:	88 c8 f0 14 	ldi @(gr15,20),gr4
	 2bc:	88 40 40 01 	addi gr4,1,gr4
	 2c0:	89 48 f0 14 	sti gr4,@(gr15,20)
	 2c4:	08 c9 00 00 	ldi.p @(gr16,0),gr4
	 2c8:	96 f8 00 00 	sethi hi(0x0),gr11
	 2cc:	96 f4 00 00 	setlo lo(0x0),gr11
	 2d0:	92 08 b1 00 	ld @(gr11,gr0),gr9
	 2d4:	88 00 81 04 	sub gr8,gr4,gr4
	 2d8:	88 b0 40 05 	srai gr4,5,gr4
	 2dc:	0a 40 90 01 	addi.p gr9,1,gr5
	 2e0:	80 54 90 48 	subicc gr9,72,gr0,icc0
	 2e4:	0a 0c b0 80 	st.p gr5,@(gr11,gr0)
	 2e8:	8e a0 40 0e 	slli gr4,14,gr7
	 2ec:	e8 1a 00 06 	bhi icc0,0x2,304 <test_kmap+0x64>
	 2f0:	08 a0 90 02 	slli.p gr9,2,gr4
	 2f4:	8a f8 00 00 	sethi hi(0x0),gr5
	 2f8:	8a f4 00 00 	setlo lo(0x0),gr5
	 2fc:	8c 08 41 05 	ld @(gr4,gr5),gr6
	 300:	80 30 60 00 	jmpl @(gr6,gr0)
	 304:	10 f8 00 00 	sethi.p hi(0x0),gr8
	 308:	92 fc 00 8b 	setlos 0x8b,gr9
	 30c:	10 f4 00 00 	setlo.p lo(0x0),gr8
	 310:	80 3c 00 00 	call 310 <test_kmap+0x70>
	 314:	10 fc 00 06 	setlos.p 0x6,gr8
	 318:	80 3c 00 00 	call 318 <test_kmap+0x78>
	 31c:	80 88 00 00 	nop
	 320:	c0 1a ff fd 	bra 314 <test_kmap+0x74>
	 324:	08 a0 90 0e 	slli.p gr9,14,gr4
	 328:	8c f8 db fd 	sethi 0xdbfd,gr6
	 32c:	0a fc 0c 09 	setlos.p 0xc09,gr5
	 330:	8c f4 c0 00 	setlo 0xc000,gr6
	 334:	08 00 40 06 	add.p gr4,gr6,gr4
	 338:	8a 04 70 85 	or gr7,gr5,gr5
	 33c:	bc 0d 21 84 	movgs gr4,tplr
	 340:	bc 0d 31 85 	movgs gr5,tppr
	 344:	8a 0c 49 00 	tlbpr gr4,gr0,0x2,0x1
	 348:	8a 88 40 00 	ori gr4,0,gr5
	 34c:	88 08 b1 00 	ld @(gr11,gr0),gr4
	 350:	90 08 51 00 	ld @(gr5,gr0),gr8
	 354:	88 40 4f ff 	addi gr4,-1,gr4
	 358:	08 0c b0 80 	st.p gr4,@(gr11,gr0)
	 35c:	80 54 40 48 	subicc gr4,72,gr0,icc0
	 360:	e8 1a 00 27 	bhi icc0,0x2,3fc <test_kmap+0x15c>
	 364:	08 a0 40 02 	slli.p gr4,2,gr4
	 368:	8a f8 00 00 	sethi hi(0x0),gr5
	 36c:	8a f4 00 00 	setlo lo(0x0),gr5
	 370:	8c 08 41 05 	ld @(gr4,gr5),gr6
	 374:	80 30 60 00 	jmpl @(gr6,gr0)
	 378:	88 fc 0c 09 	setlos 0xc09,gr4
	 37c:	88 04 70 84 	or gr7,gr4,gr4
	 380:	b6 0c 21 84 	movgs gr4,iampr2
	 384:	ba 0c 21 84 	movgs gr4,dampr2
	 388:	b8 0c 21 c5 	movsg damlr2,gr5
	 38c:	c0 1a ff f0 	bra 34c <test_kmap+0xac>
	 390:	ba 0c 21 80 	movgs gr0,dampr2
	 394:	b6 0c 21 80 	movgs gr0,iampr2
	 398:	88 c8 f0 14 	ldi @(gr15,20),gr4
	 39c:	88 40 4f ff 	addi gr4,-1,gr4
	 3a0:	89 48 f0 14 	sti gr4,@(gr15,20)
	 3a4:	8a c8 20 08 	ldi @(fp,8),gr5
	 3a8:	84 08 21 00 	ld @(fp,gr0),fp
	 3ac:	00 30 50 00 	jmpl.p @(gr5,gr0)
	 3b0:	82 40 10 10 	addi sp,16,sp
	 3b4:	ba 0c 31 80 	movgs gr0,dampr3
	 3b8:	c0 1a ff f8 	bra 398 <test_kmap+0xf8>
	 3bc:	ba 0c 41 80 	movgs gr0,dampr4
	 3c0:	c0 1a ff f6 	bra 398 <test_kmap+0xf8>
	 3c4:	ba 0c 51 80 	movgs gr0,dampr5
	 3c8:	c0 1a ff f4 	bra 398 <test_kmap+0xf8>
	 3cc:	ba 0c 61 80 	movgs gr0,dampr6
	 3d0:	c0 1a ff f2 	bra 398 <test_kmap+0xf8>
	 3d4:	ba 0c 71 80 	movgs gr0,dampr7
	 3d8:	c0 1a ff f0 	bra 398 <test_kmap+0xf8>
	 3dc:	ba 0c 81 80 	movgs gr0,dampr8
	 3e0:	c0 1a ff ee 	bra 398 <test_kmap+0xf8>
	 3e4:	ba 0c 91 80 	movgs gr0,dampr9
	 3e8:	c0 1a ff ec 	bra 398 <test_kmap+0xf8>
	 3ec:	ba 0c a1 80 	movgs gr0,dampr10
	 3f0:	c0 1a ff ea 	bra 398 <test_kmap+0xf8>
	 3f4:	92 0c a9 00 	tlbpr gr10,gr0,0x4,0x1
	 3f8:	c0 1a ff e8 	bra 398 <test_kmap+0xf8>
	 3fc:	10 f8 00 00 	sethi.p hi(0x0),gr8
	 400:	92 fc 00 b0 	setlos 0xb0,gr9
	 404:	10 f4 00 00 	setlo.p lo(0x0),gr8
	 408:	80 3c 00 00 	call 408 <test_kmap+0x168>
	 40c:	10 fc 00 06 	setlos.p 0x6,gr8
	 410:	80 3c 00 00 	call 410 <test_kmap+0x170>
	 414:	80 88 00 00 	nop
	 418:	c0 1a ff fd 	bra 40c <test_kmap+0x16c>
	 41c:	88 fc 0c 09 	setlos 0xc09,gr4
	 420:	88 04 70 84 	or gr7,gr4,gr4
	 424:	ba 0c 31 84 	movgs gr4,dampr3
	 428:	b8 0c 31 c5 	movsg damlr3,gr5
	 42c:	c0 1a ff c8 	bra 34c <test_kmap+0xac>
	 430:	88 fc 0c 09 	setlos 0xc09,gr4
	 434:	88 04 70 84 	or gr7,gr4,gr4
	 438:	ba 0c 41 84 	movgs gr4,dampr4
	 43c:	b8 0c 41 c5 	movsg damlr4,gr5
	 440:	c0 1a ff c3 	bra 34c <test_kmap+0xac>
	 444:	88 fc 0c 09 	setlos 0xc09,gr4
	 448:	88 04 70 84 	or gr7,gr4,gr4
	 44c:	ba 0c 51 84 	movgs gr4,dampr5
	 450:	b8 0c 51 c5 	movsg damlr5,gr5
	 454:	c0 1a ff be 	bra 34c <test_kmap+0xac>
	 458:	88 fc 0c 09 	setlos 0xc09,gr4
	 45c:	88 04 70 84 	or gr7,gr4,gr4
	 460:	ba 0c 61 84 	movgs gr4,dampr6
	 464:	b8 0c 61 c5 	movsg damlr6,gr5
	 468:	c0 1a ff b9 	bra 34c <test_kmap+0xac>
	 46c:	88 fc 0c 09 	setlos 0xc09,gr4
	 470:	88 04 70 84 	or gr7,gr4,gr4
	 474:	ba 0c 71 84 	movgs gr4,dampr7
	 478:	b8 0c 71 c5 	movsg damlr7,gr5
	 47c:	c0 1a ff b4 	bra 34c <test_kmap+0xac>
	 480:	88 fc 0c 09 	setlos 0xc09,gr4
	 484:	88 04 70 84 	or gr7,gr4,gr4
	 488:	ba 0c 81 84 	movgs gr4,dampr8
	 48c:	b8 0c 81 c5 	movsg damlr8,gr5
	 490:	c0 1a ff af 	bra 34c <test_kmap+0xac>
	 494:	88 fc 0c 09 	setlos 0xc09,gr4
	 498:	88 04 70 84 	or gr7,gr4,gr4
	 49c:	ba 0c 91 84 	movgs gr4,dampr9
	 4a0:	b8 0c 91 c5 	movsg damlr9,gr5
	 4a4:	c0 1a ff aa 	bra 34c <test_kmap+0xac>
	 4a8:	88 fc 0c 09 	setlos 0xc09,gr4
	 4ac:	88 04 70 84 	or gr7,gr4,gr4
	 4b0:	ba 0c a1 84 	movgs gr4,dampr10
	 4b4:	b8 0c a1 c5 	movsg damlr10,gr5
	 4b8:	c0 1a ff a5 	bra 34c <test_kmap+0xac>

Your revised patch reduces the size of the overburden, but still has the
irritating jump table.

> You'd need to disallow nested hardirqs, but I'm not sure FRV suffers
> that particular issue?

It does permit such.

David
