Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZHXJ2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZHXJ2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbZHXJ2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:28:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46085 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZHXJ2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:28:21 -0400
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090824092455.GA25267@elte.hu>
References: <4A9214E3.2070807@cn.fujitsu.com>
	 <1251093660.7538.119.camel@twins> <4A923197.4040708@cn.fujitsu.com>
	 <1251097012.7538.123.camel@twins>  <20090824092455.GA25267@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 11:27:38 +0200
Message-Id: <1251106058.7538.149.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 11:24 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2009-08-24 at 14:22 +0800, Li Zefan wrote:
> > > Peter Zijlstra wrote:
> > > > On Mon, 2009-08-24 at 12:19 +0800, Li Zefan wrote:
> > > >> If the correspoding module is unloaded before ftrace_profile_disable()
> > > >> is called, event->profile_disable() won't be called, which can
> > > >> cause oops:
> > > >>
> > > >>   # insmod trace-events-sample.ko
> > > >>   # perf record -f -a -e sample:foo_bar sleep 3 &
> > > >>   # sleep 1
> > > >>   # rmmod trace_events_sample
> > > >>   # insmod trace-events-sample.ko
> > > >>   OOPS!
> > > >>
> > > >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > > > 
> > > > 
> > > > Hrmm, feel fragile, why don't we check if all a modules tracepoints are
> > > > unused on unload?
> > > > 
> > > 
> > > I don't think it's fragile. We are profiling via a module's
> > > tracepoint, so we should pin the module, via module_get().
> > > If event->profile_enable() has been calld, we should make
> > > sure it's profile_disable() will be called.
> > 
> > What I call fragile is that everyone registering a tracepoint 
> > callback will now apparently need to worry about modules, _that_ 
> > is fragile.
> > 
> > Either make module unload look at tracepoint users, or place the 
> > try_get_module() in the registration hooks so that regular users 
> > don't need to worry about it.
> 
> The bug found by Li needs to be fixed obviously.
> 
> I tend to agree with you that this does not appear to be the best 
> place to do it: so you suggest to implicitly increase the module 
> refcount on callback registr instead? (and releasing it when 
> unregistering)
> 
> Same end result, slightly cleaner place to bump the refcount.

Yes, because the user of tracepoints should never need to care about
modules.


