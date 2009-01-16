Return-Path: <linux-kernel-owner+w=401wt.eu-S937780AbZAPW0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937780AbZAPW0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761975AbZAPW0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:26:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761959AbZAPW0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:26:12 -0500
Date: Fri, 16 Jan 2009 23:26:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Mason <chris.mason@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
Message-ID: <20090116222600.GA3899@elte.hu>
References: <20090116004050.273665842@goodmis.org> <1232142467.5090.19.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232142467.5090.19.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0848]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Mason <chris.mason@oracle.com> wrote:

> On Thu, 2009-01-15 at 19:40 -0500, Steven Rostedt wrote:
> > Ingo,
> > 
> > The first patch is critical, and needs to stay with trace_output.c
> > Not that critical since trace_output.c is not in mainline yet.
> > 
> > The second patch gives the ability to stack trace functions.
> > I've been leery about adding this and still keep it a separate
> > option from the "stacktrace" that already exists. This is because
> > when enabled with no filtering, the lag between typing and seeing
> > what is typed can be up to 10 seconds or more.
> > 
> 
> I mostly asked for this because I often try to find the most common
> reason a given function is called, and oprofile isn't always a great way
> to catch it.  systemtap can do it too if you can get systemtap to work
> against your current devel kernel, but there are limits on how much
> memory it'll use.
> 
> I've attached some simple python code that parses the output of the
> function stack tracer, it makes some dumb assumptions about the format
> but isn't a bad proof of concept.  The first such assumption is that
> you're only filtering on a single function.
> 
> Here is some example output, trying to find the most common causes of
> native_smp_send_reschedule() during a btrfs dbench run.
> 
> It relates to the Oracle OLTP thread because oracle heavily uses IPC
> semaphores to trigger wakeups of processes as various events finish.
> I'd bet that try_to_wakeup is the most common cause of the reschedule
> calls there as well.
> 
> For btrfs, the btree lock mutexes come back into the profile yet again.
> It would be interesting to change the spinning mutex code to look for
> spinners and skip the wakeup on unlock, but that's a different thread
> entirely.
> 
> The short version is: thanks Steve, this is really cool!
> 
> 12058 hits: 
>  <= check_preempt_wakeup
>  <= try_to_wake_up
>  <= wake_up_process
>  <= __mutex_unlock_slowpath
>  <= mutex_unlock
>  <= btrfs_tree_unlock
>  <= unlock_up
>  ===========

Cool! We've got scripts/tracing/ [with one Python script in it already] - 
so if this is tidied up to be generally useful we could put it there.

The other thing is that there's the statistics framework of ftrace, being 
worked on by Frederic and Steve. That tries to handle and provide 
higher-order summaries/"views" of plain traces, like histograms and counts 
- provided by the kernel.

Maybe the above type of multi-dimensional-stack-trace based histogram 
could fit into the statistics framework too?

	Ingo
