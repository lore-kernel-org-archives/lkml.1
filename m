Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbYLUKBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbYLUKBP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 05:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYLUKA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 05:00:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbYLUKA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 05:00:58 -0500
Date: Sun, 21 Dec 2008 11:00:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer
	interrupt infinite loop
Message-ID: <20081221100047.GA31074@elte.hu>
References: <4949A2CC.6040209@gmail.com> <20081218103459.GD10513@elte.hu> <alpine.LFD.2.00.0812181136410.3492@localhost.localdomain> <20081218112216.GE14332@elte.hu> <c62985530812181307k4fc35770x3698101b3981879a@mail.gmail.com> <20081218211637.GF24271@elte.hu> <c62985530812181336m6ab39c8ah410dff763bd02d24@mail.gmail.com> <20081218214458.GA30834@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218214458.GA30834@elte.hu>
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


btw., a graph-tracer buglet i noticed:

  3)               |  perf_counter_task_tick() {
  3)               |    perf_counter_task_sched_out() {
  3)               |      /* c:ffff88049b184000, u:0: 0000000020ca1ab0 + 0000000000000000 = 0000000020ca1ab0
 */
  3)               |      /* sched-out counter ffff88049b184000, state: 0
 */
  3)   5.024 us    |    }
  3)               |    perf_counter_task_sched_in() {
  3)               |      /* c:ffff88049b184000, u:0: 0000000020ca1ab0 + 0000000000000000 = 0000000020ca1ab0
 */
  3)               |      /* sched-in counter ffff88049b184000, state: 1
 */
  3)   2.605 us    |    }
  3)   9.714 us    |  }
  3)               |  perf_counter_task_tick() {

the bug is that the '*/' comment closing text is printed in the next line 
- that's not a linewrap, it happened like this in the trace. 

The reason is that the ftrace_printk did:

	ftrace_printk("c:%p, u:%d: %016Lx + %016Lx = %016Lx\n",

the closing \n is pretty natural - especially for kernel hackers who might 
just turn printk()s into ftrace_printk(), to embedd printouts in function 
traces. So it would be nice if ftrace skipped over \n's when printing them 
out as embedded C comments.

	Ingo
