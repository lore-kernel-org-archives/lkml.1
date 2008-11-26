Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYKZCFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYKZCFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYKZCFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:05:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbYKZCFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:05:09 -0500
Date: Wed, 26 Nov 2008 03:04:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/function-return-tracer: set a more human
	readable output
Message-ID: <20081126020459.GA16374@elte.hu>
References: <492C90E5.8070907@gmail.com> <20081126003936.GA26937@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126003936.GA26937@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Wow, very nice output! :-)
> 
> I've applied them, will comment and test on them as well.

I kept playing with this for almost an hour and kept looking at pages 
and pages of tracer output - it really shows the kernel's flow in a 
completely different dimension!

Talked to Steve about it and we have a few minor suggestions regarding 
the default output:

I think we should optimize the visual qualities of the output some 
more.

Instead of:

 pick_next_task() {   
   pick_next_task_fair() {   
     wakeup_preempt_entity() { 
     } 301
     set_next_entity() {    
       update_stats_wait_end() { 
       } 281
       __dequeue_entity() { 
       } 319
     } 1990
     hrtick_start_fair() { 
     } 276
   } 4524                                 
 } 5341                 

We should print such traces [mockup]:

   pick_next_task() {                     -
     pick_next_task_fair() {                -
       wakeup_preempt_entity();               + 0.301 us
       set_next_entity() {                    -
         update_stats_wait_end();               + 0.281 us
         __dequeue_entity();                    + 0.319 us
       }                                      + 1.990 us
       hrtick_start_fair();                   + 0.276 us
 +   }                                      + 10.524 us
 ! }                                      + 100.341 us
   switch_mm();                           + 0.494 us

The changes would be:

1) Compression of non-nested calls into a single line.

   Implementing this probably necessiates some trickery with the
   ring-buffer: we'd have to look at the next entry as well and see 
   whether it closes the function call.

2) Adding a closing ';' semicolon to single-line calls. It's the C 
   syntax and i'm missing it :-)

3) The first column: single-character visual shortcuts for "overhead". 
   This is a concept we used in the -rt tracer and it still lives in 
   the latency tracer bits of ftrace and is quite useful:

    '+' means "overhead spike": overhead is above 10 usecs.
    '!' means "large overhead": overhead is above 100 usecs.

   These give at-a-glance hotspot analysis - hotspots are easier to 
   miss as pure numbers.

4) Printing out in units of microseconds, with a decimal point and by
   explicitly mentioning the 'us' unit.

   All of these are important properties: microseconds is still the 
   most common 'overhead' unit in kernel circles. It also gives rather 
   human single-digit or two-digit results. Nanoseconds is three or- 
   four-digit - which is too much. Repeating 'us' so many times is not 
   a problem - these lines will be grepped, quoted, etc - constant 
   reminder about the unit is just fine.

5) Nesting the overhead numbers aligned to the right end of the graph. 
 
   This cleans up the view of the source code printout, but not 
   cluttering it with numbers. It also structures the numbers some 
   more. Visual cues are given via '-' and '+' signs, to follow 
   nesting. This nesting aligns up with the function nesting levels on 
   the left side - so it's easy to pair up number and function name. 
   It also separates the numbers from the symbol length effects in the 
   single-line case. (which is the most common trace line)

What do you think? It's lots of work (sorry! :-), but it would produce 
even more stunning graph-tracer output IMO.

	Ingo
