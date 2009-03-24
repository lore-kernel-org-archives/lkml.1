Return-Path: <linux-kernel-owner+w=401wt.eu-S1763707AbZCXR0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763707AbZCXR0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763593AbZCXR0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:26:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763499AbZCXR0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:26:06 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Steven Rostedt <rostedt@goodmis.org>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: ftrace not working?
Date: Tue, 24 Mar 2009 22:53:35 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.19-3.2-default; KDE/4.1.3; x86_64; ; )
Cc: rusty@rustcorp.com.au, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       =?utf-8?q?Fr=E9=A6=98=E9=A7=BBic_Weisbecker?= <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
References: <20090323083533.GE18837@elte.hu> <20090323200057.9027.A69D9226@jp.fujitsu.com> <20090323143226.GA18439@elte.hu>
In-Reply-To: <20090323143226.GA18439@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200903242253.36794.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009 20:02:26 Ingo Molnar wrote:
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > On Monday 23 March 2009 14:05:33 Ingo Molnar wrote:
> > > > one thing to note:
> > > > | CPU0: Intel QEMU Virtual CPU version 0.9.1 stepping 03
> > > > | Testing tracer nop: PASSED
> > > >
> > > > so it's a Qemu session, right?
> > >
> > > Yes. qemu-kvm.
> >
> > Ah, sorry. I don't know qemu and kvm at all ;)
>
> In terms of tracing it should just look like some weird old CPU with
> few capabilities and long delays. Nothing in ftrace depends on CPU
> capabilities (that wasnt present in pentia) so this is weird.
> Perhaps some timestamping problem? Virtual machines tend to have
> trouble with the TSC. Or code patching problems? But that does not
> explain the lack of explicit scheduler events.
>
> Or perhaps the fact that qemu sessions tend to boot with barely any
> RAM. Maybe the ringbuffer size is very low?
>

Nope, it is not a qemu problem, but ftrace. Most probably, it shouldn't work on
real hardware as well with my config. i.e., CONFIG_CPUMASK_OFFSTACK = y
and NR_CPUS = 4096 via CONFIG_MAXSMP.

The tracing_buffer_mask was getting freed and the bitmask was all zeros. And
for_each_tracing_cpu() never looped. Here is the patch that fixes the issue
for me. Tested only on qemu-kvm. ;)

Steve, Can you merge this.

Thanks
Nikanth

In tracer_alloc_buffers(), do not free tracing_cpumask and tracing_buffer_mask
on success.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 17bb88d..98f609d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3887,6 +3887,7 @@ __init static int tracer_alloc_buffers(void)
 
 	register_die_notifier(&trace_die_notifier);
 	ret = 0;
+	goto out;
 
 out_free_cpumask:
 	free_cpumask_var(tracing_cpumask);


