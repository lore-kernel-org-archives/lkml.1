Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZDDGu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZDDGu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 02:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZDDGuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 02:50:10 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:54290 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbZDDGuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 02:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lJH9f3ClDcCy7GBwklpxr0E7I/t5J3fWEB8Y0p4lPmOrYJhXFv8r0usG36DcO5La8s
         obaZ5rgCFyOU2xJ8pI5LzX/tEAUeq7WtKo9UL1SmS7XL0xrwuk3y5T9t7F37v2O+Kqup
         UHhoPslOZKABkm2qaudhXcUpQDBnhlXymxKJo=
Subject: Re: [PATCH 0/4] [GIT PULL] for tip/tracing/filters
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0904031035060.965@gandalf.stny.rr.com>
References: <20090402052721.013878388@goodmis.org>
	 <20090403121434.GJ31399@elte.hu>
	 <alpine.DEB.2.00.0904031035060.965@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 01:50:03 -0500
Message-Id: <1238827803.22495.16.camel@bookworm>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 10:36 -0400, Steven Rostedt wrote:
> On Fri, 3 Apr 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > 
> > > Ingo,
> > > 
> > > Please pull the latest tip/tracing/filters tree, which can be found at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > > tip/tracing/filters
> > > 
> > > 
> > > Steven Rostedt (2):
> > >       ring-buffer: add ring_buffer_discard_commit
> > >       tracing/filters: use ring_buffer_discard_commit for discarded events
> > > 
> > > Tom Zanussi (2):
> > >       tracing/filters: add run-time field descriptions to TRACE_EVENT_FORMAT events
> > >       tracing/filters: add TRACE_EVENT_FORMAT_NOFILTER event macro
> > 
> > I've cherry-picked them into tip/tracing/filters, and there are some 
> > new build failures:
> > 
> > (.text+0x40795): undefined reference to `event_context_switch'
> > kernel/built-in.o: In function `probe_power_mark':
> > trace_power.c:(.text+0x44fd7): undefined reference to `event_power'
> > trace_power.c:(.text+0x44fe1): undefined reference to `event_power'
> > trace_power.c:(.text+0x44fe6): undefined reference to 
> > `filter_match_preds'
> > kernel/built-in.o: In function `probe_power_end':
> > trace_power.c:(.text+0x45064): undefined reference to `event_power'
> > trace_power.c:(.text+0x4506e): undefined reference to `event_power'
> > trace_power.c:(.text+0x45073): undefined reference to 
> > `filter_match_preds'
> > kernel/built-in.o: In function `kmemtrace_free':
> > 
> > so i've excluded it from tip/master for now.
> 
> I figured that is due to the missing pieces from the ftrace merge I did. 
> But I guess we want to tone down on the inter merging of branches.
> 
> Tom, could you check out the tracing/filters branch from tip and get that 
> branch working.
> 

I'm guessing the problem is that CONFIG_EVENT_TRACER wasn't selected but
should have been, because those tracers all now export events
(trace_event_types.h, included by trace_export.c).  I'm not sure this is
the right way to do it, but the patch below selects EVENT_TRACER if
TRACING is selected (a couple of the exported events belong to bprint
and print, which don't have a config option other than TRACING, so it
seems to belong there).

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8a41360..a061746 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -56,6 +56,7 @@ config TRACING
 	select TRACEPOINTS
 	select NOP_TRACER
 	select BINARY_PRINTF
+	select EVENT_TRACER
 
 #
 # Minimum requirements an architecture has to meet for us to
@@ -177,7 +178,7 @@ config CONTEXT_SWITCH_TRACER
 
 config EVENT_TRACER
 	bool "Trace various events in the kernel"
-	select TRACING
+	depends on TRACING
 	help
 	  This tracer hooks to various trace points in the kernel
 	  allowing the user to pick and choose which trace point they
-- 
1.5.6.3



