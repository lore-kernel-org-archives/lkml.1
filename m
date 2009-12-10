Return-Path: <linux-kernel-owner+w=401wt.eu-S1761421AbZLJSfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421AbZLJSfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761411AbZLJSf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:35:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53704 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761092AbZLJSfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:35:21 -0500
Date: Thu, 10 Dec 2009 19:35:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210183508.GB17986@elte.hu>
References: <4B202778.4030801@am.sony.com>
 <20091210070800.GB16874@elte.hu>
 <20091210120332.GA5042@nowhere>
 <20091210141121.GB1436@elte.hu>
 <1260456803.2146.167.camel@gandalf.stny.rr.com>
 <20091210153845.GA28230@elte.hu>
 <y0md42magc1.fsf@fche.csb>
 <20091210175737.GB5256@elte.hu>
 <20091210180412.GB30999@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210180412.GB30999@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> Hi -
> 
> > > FWIW, those who want to collect such measurements today can do so 
> > > with a few lines of systemtap script for each of the above.
> > 
> > Well, i dont think stap can do workload instrumentation. It can do 
> > system-wide (and user local / task local) - but can it do per task 
> > hierarchies?
> 
> It can track the evolution of task hierarchies by listening to process 
> forking events, and filter other kernel/user events according to 
> then-current hierarchy data.  One primitive implementation of this is 
> in the target_set.stp tapset, but it's easy to script up other 
> policies.

target_set.stp is not really adequate. Have you actually _tried_ to use 
it on something real like hackbench, which runs thousands (or tens of 
thousands) of tasks? You'll soon find that associative arrays are not 
really adequate for that ...

Another problem i can see is that target_set.stp starts with:

   global _target_set # map: target-set-pid -> ancestor-pid

see that 'global' thing? It's a system global variable - i.e. you cannot 
measure two task hierarchies at once.

> > Also, i dont think stap supports proper separation of per workload 
> > measurements either. I.e. can you write a script that will work 
> > properly even if multiple monitoring tools are running, each trying 
> > to measure latencies?
> 
> Sure, always has.  You can run many scripts concurrently, each with 
> its own internal state.  (Overheads accumulate, sadly & naturally.)

To measure latencies you need two probes, a start and a stop one. How do 
you define a local variable that is visible to those two probes? You 
have to create a global variable - but that will/can clash with other 
instances.

( Also, you dont offer per application channels/state from the same 
  script. Each app has to define their own probes, duplicating the 
  script and increasing probe chaining overhead. )

The whole state sharing and eventing model of SystemTap is poorly 
thought out.

> > Also, i personally find built-in kernel functionality more trustable 
> > than dynamically built stap kernel modules that get inserted.
> 
> I understand.  In the absence of a suitable bytecode engine in the 
> kernel, this was the only practical way to do everything we needed.

You seem to be under the mistaken assumption that your course of action 
with SystemTap is somehow limited by what is available (or not) in the 
upstream kernel.

In reality you can implement anything you want (in fact you did 
precisely that - _against_ repeated advice of upstream kernel 
developers), and if it's good, it will be merged - simple as that. It 
might take years, but once you deliver the proof (which comes in form of 
lots of happy users/developers), it happens.

So saying 'but the kernel does not have a bytecode interpreter' (or any 
other excuse) is pretty lame.

	Ingo
