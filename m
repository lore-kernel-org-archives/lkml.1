Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYKQT67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYKQT67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYKQT6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:58:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45599 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYKQT6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:58:35 -0500
Date: Mon, 17 Nov 2008 20:57:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
Message-ID: <20081117195757.GA12020@elte.hu>
References: <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117184951.GA5585@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> [ I'll post per function analysis as i complete them, as a reply to
>   this mail. ]

[ i'll do a separate mail for every function analyzed, the discussion 
  spreads better that way. ]

> 100.000000 total
> ................
>   7.253355 copy_user_generic_string

This is the Well-known pattern of user-copy overhead, which centers 
around this single REP MOVS instruction:

                nr-of-hits
                 .........
ffffffff80341eea:       42 	83 e2 07    		and    $0x7,%edx
ffffffff80341eed:   677398 	f3 48 a5         	rep movsq %ds:(%rsi),%es:(%rdi)
ffffffff80341ef0:     3642 	89 d1                	mov    %edx,%ecx
ffffffff80341ef2:    16260 	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
ffffffff80341ef4:     6554 	31 c0                	xor    %eax,%eax
ffffffff80341ef6:     1958 	c3                   	retq   
ffffffff80341ef7:        0 	90                   	nop    
ffffffff80341ef8:        0 	90                   	nop    

That's to be expected - tbench shuffles 3.5 GB of effective data 
to/from sockets. That's 7.5 GB due to double-copy. So for every 64 
bytes of data transferred we spend 1.4 CPU cycles in this specific 
function - that is OK-ish.

	Ingo
