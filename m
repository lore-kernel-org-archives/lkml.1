Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbYKQQMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbYKQQMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYKQQL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:11:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39281 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYKQQL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:11:58 -0500
Date: Mon, 17 Nov 2008 17:11:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       cl@linux-foundation.org, efault@gmx.de, a.p.zijlstra@chello.nl,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
Message-ID: <20081117161135.GE12081@elte.hu>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera> <20081117090648.GG28786@elte.hu> <20081117.011403.06989342.davem@davemloft.net> <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4921539B.2000002@cosmosbay.com>
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


* Eric Dumazet <dada1@cosmosbay.com> wrote:

>> It all looks like pure old-fashioned straight overhead in the 
>> networking layer to me. Do we still touch the same global cacheline 
>> for every localhost packet we process? Anything like that would 
>> show up big time.
>
> Yes we do, I find strange we dont see dst_release() in your NMI 
> profile
>
> I posted a patch ( commit 5635c10d976716ef47ae441998aeae144c7e7387 
> net: make sure struct dst_entry refcount is aligned on 64 bytes) (in 
> net-next-2.6 tree) to properly align struct dst_entry refcounter and 
> got 4% speedup on tbench on my machine.

Ouch, +4% from a oneliner networking change? That's a _huge_ speedup 
compared to the things we were after in scheduler land. A lot of 
scheduler folks worked hard to squeeze the last 1-2% out of the 
scheduler fastpath (which was not trivial at all). The _full_ 
scheduler accounts for only about 7% of the total system overhead here 
on a 16-way box...

So why should we be handling this anything but a plain networking 
performance regression/weakness? The localhost scalability bottleneck 
has been reported a _long_ time ago.

	Ingo
