Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZLUPt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZLUPt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbZLUPtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:49:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58692 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZLUPtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:49:55 -0500
X-Authority-Analysis: v=1.0 c=1 a=3VcTWO7RLfwA:10 a=7U3hwN5JcxgA:10 a=omOdbC7AAAAA:8 a=USB8USR6KlpO5Z8YTZ0A:9 a=Fp4XEPq5HBqb4AvktZd_7JU0gXsA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: Fix lockdep warning in global_clock()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091221064356.GA2378@elte.hu>
References: <4B2F1543.8020300@cn.fujitsu.com>
	 <20091221064356.GA2378@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 21 Dec 2009 10:49:51 -0500
Message-ID: <1261410591.25193.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-21 at 07:43 +0100, Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> >  # echo 1 > events/enable
> >  # echo global > trace_clock
> > 
> > ------------[ cut here ]------------
> > WARNING: at kernel/lockdep.c:3162 check_flags+0xb2/0x190()
> > ...
> > ---[ end trace 3f86734a89416623 ]---
> > possible reason: unannotated irqs-on.
> > ...
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  kernel/trace/trace_clock.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
> > index 84a3a7b..11563c9 100644
> > --- a/kernel/trace/trace_clock.c
> > +++ b/kernel/trace/trace_clock.c
> > @@ -83,7 +83,7 @@ u64 notrace trace_clock_global(void)
> >  	int this_cpu;
> >  	u64 now;
> >  
> > -	raw_local_irq_save(flags);
> > +	local_irq_save(flags);
> 
> Hm, wont this cause problems when we trace inside lockdep? Have you tried the 
> lockdep events - do they still work?


Doesn't the lockdep code protect against this type of recursion.

Working with interrupts and spin locks in the latency code, I found that
I had to remove all the raw_local_irq_save for the normal
local_irq_save. Because if you disable interrupts with raw_* and then
anything that is called must also disable with raw_*, if they don't then
lockdep will blow up.

-- Steve


