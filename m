Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbZHXJZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbZHXJZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZHXJZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:25:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZHXJZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:25:00 -0400
Date: Mon, 24 Aug 2009 11:24:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
Message-ID: <20090824092455.GA25267@elte.hu>
References: <4A9214E3.2070807@cn.fujitsu.com> <1251093660.7538.119.camel@twins> <4A923197.4040708@cn.fujitsu.com> <1251097012.7538.123.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251097012.7538.123.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2009-08-24 at 14:22 +0800, Li Zefan wrote:
> > Peter Zijlstra wrote:
> > > On Mon, 2009-08-24 at 12:19 +0800, Li Zefan wrote:
> > >> If the correspoding module is unloaded before ftrace_profile_disable()
> > >> is called, event->profile_disable() won't be called, which can
> > >> cause oops:
> > >>
> > >>   # insmod trace-events-sample.ko
> > >>   # perf record -f -a -e sample:foo_bar sleep 3 &
> > >>   # sleep 1
> > >>   # rmmod trace_events_sample
> > >>   # insmod trace-events-sample.ko
> > >>   OOPS!
> > >>
> > >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > > 
> > > 
> > > Hrmm, feel fragile, why don't we check if all a modules tracepoints are
> > > unused on unload?
> > > 
> > 
> > I don't think it's fragile. We are profiling via a module's
> > tracepoint, so we should pin the module, via module_get().
> > If event->profile_enable() has been calld, we should make
> > sure it's profile_disable() will be called.
> 
> What I call fragile is that everyone registering a tracepoint 
> callback will now apparently need to worry about modules, _that_ 
> is fragile.
> 
> Either make module unload look at tracepoint users, or place the 
> try_get_module() in the registration hooks so that regular users 
> don't need to worry about it.

The bug found by Li needs to be fixed obviously.

I tend to agree with you that this does not appear to be the best 
place to do it: so you suggest to implicitly increase the module 
refcount on callback registr instead? (and releasing it when 
unregistering)

Same end result, slightly cleaner place to bump the refcount.

	Ingo
