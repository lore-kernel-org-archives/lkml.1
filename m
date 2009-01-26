Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZAZSg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZAZSg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbZAZSgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:36:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751641AbZAZSgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:36:46 -0500
Date: Mon, 26 Jan 2009 10:35:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: rusty@rustcorp.com.au, travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090126103529.cb124a58.akpm@linux-foundation.org>
In-Reply-To: <20090126171618.GA32091@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<20090116191108.533053000@polaris-admin.engr.sgi.com>
	<20090124001537.7cfde78e.akpm@linux-foundation.org>
	<200901261711.43943.rusty@rustcorp.com.au>
	<20090125230130.bcdab2e5.akpm@linux-foundation.org>
	<20090126171618.GA32091@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 18:16:18 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > Yet another kernel thread for each CPU.  All because of some dung 
> > > > way down in arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c.
> > > > 
> > > > Is there no other way?
> > > 
> > > Perhaps, but this works.  Trying to be clever got me into this mess in 
> > > the first place.
> > > 
> > > We could stop using workqueues and change work_on_cpu to create a 
> > > thread every time, which would give it a new failure mode so I don't 
> > > know that everyone could use it any more.  Or we could keep a single 
> > > thread around to do all the cpus, and duplicate much of the workqueue 
> > > code.
> > > 
> > > None of these options are appealing...
> > 
> > Can we try harder please?  10 screenfuls of kernel threads in the ps 
> > output is just irritating.
> > 
> > How about banning the use of work_on_cpu() from schedule_work() handlers 
> > and then fixing that driver somehow?
> 
> Yes, but that's fundamentally fragile: anyone who happens to stick the 
> wrong thing into keventd (and it's dead easy because schedule_work() is 
> easy to use) will lock up work_on_cpu() users.
> 

--- a/kernel/workqueue.c~a
+++ a/kernel/workqueue.c
@@ -998,6 +998,8 @@ long work_on_cpu(unsigned int cpu, long 
 {
 	struct work_for_cpu wfc;
 
+	BUG_ON(current_is_keventd());
+
 	INIT_WORK(&wfc.work, do_work_for_cpu);
 	wfc.fn = fn;
 	wfc.arg = arg;
_


That wasn't so hard.

> work_on_cpu() is an important (and lowlevel enough) facility to be 
> isolated from casual interaction like that.

We have one single (known) caller in the whole kernel.  This is not
worth adding another great pile of kernel threads for!

> > What _is_ the bug anyway?  The only description we were given was
> > 
> >   Impact: remove potential clashes with generic kevent workqueue
> > 
> >   Annoyingly, some places we want to use work_on_cpu are already in
> >   workqueues.  As per Ingo's suggestion, we create a different
> >   workqueue for work_on_cpu.
> > 
> > which didn't bother telling anyone squat.
> > 
> > When was this bug added?  Was it added into that driver or was it due to 
> > infrastructural changes?
> 
> This fixes lockups during bootup caused by the cpumask changes/cleanups 
> which changed set_cpus_allowed()+on-kernel-stack-cpumask_t to 
> work_on_cpu().
> 
> Which was fine except it didnt take into account the interaction with the 
> kevents workqueue and the very wide cross section for worklet dependencies 
> that this brings with itself. work_on_cpu() was rarely used before so this 
> didnt show up.

Am still awaiting an understandable description of this alleged bug :(

If someone can be persuaded to cough up this information (which should
have been in the changelog from day #1) then perhaps someone will be
able to think of a more pleasing fix.  That's one of the reasons for
writing changelogs.
