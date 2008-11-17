Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYKQVie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYKQVie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYKQVi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:38:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50966 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbYKQViZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:38:25 -0500
Date: Mon, 17 Nov 2008 22:38:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: skb_release_head_state(): Re: [Bug #11308] tbench regression
	on each kernel release from 2.6.22 -&gt; 2.6.28
Message-ID: <20081117213805.GA5600@elte.hu>
References: <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org> <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117205530.GE12020@elte.hu> <alpine.LFD.2.00.0811171325260.18283@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811171325260.18283@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 17 Nov 2008, Ingo Molnar wrote:
> > 
> > this function _really_ hurts from a 16-bit op:
> > 
> > ffffffff8048943e:     6503 	66 c7 83 a8 00 00 00 	movw   $0x0,0xa8(%rbx)
> > ffffffff80489445:        0 	00 00 
> > ffffffff80489447:   174101 	5b                   	pop    %rbx
> 
> I don't think that is it, actually. The 16-bit store just before it 
> had a zero count, even though anything that executes the second one 
> will always execute the first one too.

yeah - look at the followup bits that identify the likely real source 
of that overhead:

>> _But_, the real overhead probably comes from:
>> 
>>  ffffffff804b7210:    10867 	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
>> 
>> which is the next line, the ttl field:
>> 
>>  373             iph->ttl      = ip_select_ttl(inet, &rt->u.dst);
>> 
>> this shows that we are doing a hard cachemiss on the net-localhost 
>> route dst structure cacheline. We do a plain load instruction from 
>> it here and get a hefty cachemiss. (because 16 CPUs are banging on 
>> that single route)
>> 
>> And let make sure we see this in perspective as well: that single 
>> cachemiss is _1.0 percent_ of the total tbench cost. (!) We could 
>> make the scheduler 10% slower straight away and it would have less 
>> of a real-life effect than this single iph->ttl field setting.
