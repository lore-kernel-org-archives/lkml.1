Return-Path: <linux-kernel-owner+w=401wt.eu-S966731AbYD1WL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966731AbYD1WL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933408AbYD1WLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:11:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56049 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934010AbYD1WLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:11:47 -0400
Date: Tue, 29 Apr 2008 00:11:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] Immediate Values - jump patching update
Message-ID: <20080428221122.GC16153@elte.hu>
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48163B84.90605@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

>>> I still think this is the completely wrong approach.
>>
>> hm, can it result in a broken kernel? If yes, how? Or are your 
>> objections more higher level?
>
> My objections are higher level, I believe the current code is (a) 
> painfully complex, and I'd rather not see it in the kernel, and (b) 
> the wrong thing anyway.
>
> Put a 5-byte nop in as the marker, and patch it with a call 
> instruction, out of line, to a collector function.

the counter argument was that by specific sched.o analysis, this results 
in slower code. The reason is that the "function call parameter 
preparation" halo around that 5-byte patch site is larger than that 
single conditional branch operation to an offline place of the current 
function is.

i.e. the current optimized marker approach does roughly this:

  [ .... fastpath head ....       ]
  [ immediate value instruction   ]  --->
  [ branch instruction            ]  ---> these two get NOP-ed out
  [ .... fastpath tail ....       ]
  [ ............................. ]
  [ ... offline area ............ ]
  [ ... parameter preparation ... ]
  [ ... marker call ............. ]

your proposed 5-byte call NOP approach (which btw. was what i proposed 
multiple times in the past 2 years) would do this:

  [ .... fastpath head ......     ]
  [ ... parameter preparation ... ]
  [ ....   5-byte CALL .......... ]  ---> NOP-ed out
  [ .... fastpath tail .......... ]
  [ ............................. ]

in the first case we have little "marker parameter/value preparation" 
cost: it all happens in the 'offline area' _by GCC_. I.e. the fastpath 
is relatively undisturbed.

in the latter case, all the 'parameter preparation' phase has to happen 
at around the 5-byte CALL site, in the fastpath. This, in the specific, 
assembly level analysis of sched.o, was shown by Matthieu to be a 
pessimisation. We are better off by inserting that conditional and 
letting gcc generate the call, than by forcing it in the middle of the 
fastpath - even if we end up NOP-ing out the call.

wrt. complexity i agree with you - if the current optimization cannot be 
made correctly we have to fall back to a simpler variant, even if it's 
slower.

	Ingo
