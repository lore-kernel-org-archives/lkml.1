Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbZELIdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbZELIdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbZELIdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:33:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37408 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048AbZELIdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:33:21 -0400
Date: Tue, 12 May 2009 10:33:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] [GIT PULL] ring-buffer: optimize to 17%
	performance increase
Message-ID: <20090512083301.GA20435@elte.hu>
References: <20090512040832.681953177@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512040832.681953177@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> This patch series tunes the ring buffer to be a bit faster. I used 
> the ring-buffer-benmark test to help give a good idea on the 
> performance of the buffer. I ran it on an 2.8 GHz 4way box on an 
> idle system. I only wanted to test the write without the reader, 
> since the reader can produce some cacheline bouncing. To do this I 
> inserted the benchmark module with the "disable_reader=1" option.
> 
> Note, when I disable the ring buffer and run the test, I get an 
> average of 87 ns. Thus the overhead of the test is 87ns, and I 
> will show both the full time and the 87 subtracted from the time 
> (in parenthesis).
> 
> I'm also including the size of the ring_buffer.o object since some 
> changes helped in shrinking the text segments too.
> 
> Before the patch series:
> 
> benchmark:  307 ns (220 ns)
>    text    data     bss     dec     hex filename
>   16554      24      12   16590    40ce kernel/trace/ring_buffer.o
>           
>          
> commit 1cd8d7358948909ab80b254eb14bcebc555ad417
> ring-buffer: remove type parameter from rb_reserve_next_event
>              
> benchmark: 302 ns (215 ns)
>    text    data     bss     dec     hex filename
>   16538      24      12   16574    40be kernel/trace/ring_buffer.o
>     
> commit be957c447f7233a67904a1b11eb3ab61e702bf4d
> ring-buffer: move calculation of event length
> 
> benchmark: 293 ns (206 ns)
>    text    data     bss     dec     hex filename
>   16490      24      12   16526    408e kernel/trace/ring_buffer.o
>     
> commit 0f0c85fc80adbbd2265d89867d743f929d516805
> ring-buffer: small optimizations
> 
> benchmark: 285 ns (198 ns)
>    text    data     bss     dec     hex filename
>   16474      24      12   16510    407e kernel/trace/ring_buffer.o
> 
> commit 88eb0125362f2ab272cbaf84252cf101ddc2dec9
> ring-buffer: use internal time stamp function
> 
> benchmark: 282 ns (195 ns)
>    text    data     bss     dec     hex filename
>   16474      24      12   16510    407e kernel/trace/ring_buffer.o
> 
> 
> commit 168b6b1d0594c7866caa73b12f3b8d91075695f2
> ring-buffer: move code around to remove some branches
> 
> benchmark: 270 ns (183 ns)
>    text    data     bss     dec     hex filename
>   16490      24      12   16526    408e kernel/trace/ring_buffer.o
> 
> Thus we went from an average of 220 ns per recording, to 183 ns.
> Which is about a 17% performance gain.

Nice!

It's also interesting to see that text size went down when speed 
went up. I'm wondering how these compiler options:

  CONFIG_CC_OPTIMIZE_FOR_SIZE=y
  CONFIG_OPTIMIZE_INLINING=y

My guess is that the combo with the highest performance is:

  CONFIG_CC_OPTIMIZE_FOR_SIZE=y
  # CONFIG_OPTIMIZE_INLINING is not set

Especially if you run it on a fast box with a lot of caches and a 
modern x86 CPU.
 
> For your information:
> 
> Adding a reader that reads via pages (like splice), the time jumps to
> 326 ns.
> 
> Adding a reader that reades event by event it jumps to (with lots
> of overruns)
> 469 ns.
> 
> But disabling the ring buffer, the overhead for the test jumps from 87 ns
> to 113 ns, making the ring buffer cost with busy reader: 213 ns and 356 ns.
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (5):
>       ring-buffer: remove type parameter from rb_reserve_next_event
>       ring-buffer: move calculation of event length
>       ring-buffer: small optimizations
>       ring-buffer: use internal time stamp function
>       ring-buffer: move code around to remove some branches
> 
> ----
>  kernel/trace/ring_buffer.c |   63 +++++++++++++++++++++++++-------------------
>  1 files changed, 36 insertions(+), 27 deletions(-)

Pulled, thanks Steve!

	Ingo
