Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbZBJOtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbZBJOtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZBJOtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:49:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:16349 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbZBJOtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:49:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Mt5qvmvYeYMuPQebyTNtccatHj/IEJMRkyel7T893/V7rqGu6HXuF/kQ5hrttOY3l8
         6k2gS6homZH0JDCJMw/1Zx32fFzPlIKciqGE/I2LegBmPQB91BLkcJxPUlJZbPJ9T68O
         N6yJ4q5NoeOzNd/G8e2v/a36zP53Zf8fLI2RU=
Date: Tue, 10 Feb 2009 15:49:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 1/2] tracing/sysprof: add missing
	tracing_{start,stop}_record_cmdline()
Message-ID: <20090210144910.GE5836@nowhere>
References: <4990fdb7.0e0f660a.1d27.5399@mx.google.com> <20090210122726.GA21531@elte.hu> <20090210123145.GA1403@elte.hu> <20090210141052.GA5836@nowhere> <20090210142543.GF16147@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210142543.GF16147@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 03:25:43PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Tue, Feb 10, 2009 at 01:31:45PM +0100, Ingo Molnar wrote:
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > 
> > > > > Add the missing pair tracing_{start,stop}_record_cmdline() to record well
> > > > > the cmdline associated with pid.
> > > > > 
> > > > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > > > ---
> > > > >  kernel/trace/trace_sysprof.c |    3 +++
> > > > >  1 files changed, 3 insertions(+), 0 deletions(-)
> > > > 
> > > > applied to tip/tracing/sysprof, thanks Frederic!
> > > 
> > > hm, causes a build failure:
> > > 
> > > kernel/built-in.o: In function `stack_trace_reset':
> > > trace_sysprof.c:(.text+0x3e91a): undefined reference to `tracing_stop_cmdline_record'
> > > kernel/built-in.o: In function `stack_trace_init':
> > > trace_sysprof.c:(.text+0x3e953): undefined reference to `tracing_start_cmdline_record'
> > > 
> > > 	Ingo
> > 
> > Sorry, this fixlet solves the problem:
> 
> Could you please send one combo patch? The patch was so small and was at
> the tail of tracing/sysprof that i didnt apply it after all.
> 
> 	Ingo


Ok.
I've dropped the build error example in the changelog, keeping only the reason
of the error, as this is a V2.
Tell me if you are fine with it.

--
>From 1656ef9b22049a0d93c7c3946e28774876df535b Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 10 Feb 2009 15:33:43 +0100
Subject: [PATCH v2] tracing/sysprof: add missing tracing_{start,stop}_record_cmdline()

Add the missing pair tracing_{start,stop}_record_cmdline() to record well
the cmdline associated with pid.

Changes in v2:

_ fix a build error, the sched_switch tracer is needed to record the
cmdline.

Reported-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/Kconfig         |    1 +
 kernel/trace/trace_sysprof.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 79be773..620f9cd 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -134,6 +134,7 @@ config SYSPROF_TRACER
 	bool "Sysprof Tracer"
 	depends on X86
 	select TRACING
+	select CONTEXT_SWITCH_TRACER
 	help
 	  This tracer provides the trace needed by the 'Sysprof' userspace
 	  tool.
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 84ca9d8..9902c15 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -238,6 +238,8 @@ static int stack_trace_init(struct trace_array *tr)
 {
 	sysprof_trace = tr;
 
+	tracing_start_cmdline_record();
+
 	mutex_lock(&sample_timer_lock);
 	start_stack_timers();
 	tracer_enabled = 1;
@@ -247,6 +249,7 @@ static int stack_trace_init(struct trace_array *tr)
 
 static void stack_trace_reset(struct trace_array *tr)
 {
+	tracing_stop_cmdline_record();
 	stop_stack_trace(tr);
 }
 
-- 
1.6.1



