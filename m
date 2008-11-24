Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYKXQ1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYKXQ1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYKXQ10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:27:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46760 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbYKXQ1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:27:25 -0500
Date: Mon, 24 Nov 2008 17:27:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Human readable output for function return tracer
Message-ID: <20081124162719.GA11532@elte.hu>
References: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811240639w574659c0nd0a54e6c1fb1197a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> Hi,
> 
> I'm planning to apply an idea proposed by Ingo to make the output on
> the function return tracer
> more "eyes-parsable".
> The idea consists on a trace which has flow similar to C code:
> 
> func1() {
>     func2() {
>         func3() {
>         }
>     }
>     func4() {
>     }
> }
> 
> (With time of execution added on closing braces).
> 
> The problem is that the traces arrive in the reverse order, according
> to the fact that functions
> are traced on return.
> The order corresponding to the above example would be as the following:
> 
> func3, func2, func4, func1
> 
> Oh and we have the parent in a return trace, so we would actually have:
> 
> func2->func3

[ Note: here we'd also have: ]

  func1->func2

> func1->func4
> ....    ->func1

it's basicaly a representation of the callgraph in polish notation.

> This trace flow doesn't make the things easy to produce our C like 
> code.
> 
> So I found only one solution which have both pros and cons. I could 
> send a "pre-trace" to the ring-buffer to signal that function x with 
> depth y is beeing called (when we enter the function).

that's OK i think. It will double the number of events, but will 
simplify everything immensely - especially if we have small 
imperfections in the callgraph arising out of IRQ entries.

Note that we _could_ render it all from the return events alone, 
because we have the full callgraph available. But it would be either 
very memory-intense or very CPU-intense: we'd either have to buffer up 
all the return events in a reverse-stack sort of construct (which 
could grow much larger than the return stack itself), or we'd have to 
reconstruct it on the fly by constantly scanning forwards to discover 
the context of the printout. Both can have pretty ugly worst-case 
behavior with certain call graph layouts.

So i think you made a good call - lets keep it simple for now.

Also, do you have any thoughts about how to extend the return-tracer 
to 64-bit x86? It should work pretty well i think - the return value 
has to be extended to 64 bits but that's pretty much all.

	Ingo
