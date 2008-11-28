Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbYK1NF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbYK1NF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 08:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYK1NFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 08:05:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37471 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYK1NFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 08:05:47 -0500
Date: Fri, 28 Nov 2008 14:05:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the
	trace output
Message-ID: <20081128130531.GB26793@elte.hu>
References: <492DEDE9.9010109@gmail.com> <20081127103424.GA9132@elte.hu> <c62985530811270506o51195654y628f8ab68ff68ac7@mail.gmail.com> <20081127135155.GA23076@elte.hu> <c62985530811270644r2de621ecwfdeb1d353197bdae@mail.gmail.com> <alpine.DEB.1.10.0811271028260.18691@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811271028260.18691@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 27 Nov 2008, Fr?d?ric Weisbecker wrote:
> > >
> > >> > ---------------------------------------------------------
> > >> > CPU)     cost   |  function
> > >> > ---------------------------------------------------------
> > >> >
> > >> >  0)             |  sys_read() {
> > >> >  0)    0.331 us |    fget_light();
> > >> >  0)             |    vfs_read() {
> > >> >  0)             |      rw_verify_area() {
> > >> >  0)             |        security_file_permission() {
> > >> >  0)    0.306 us |          cap_file_permission();
> > >> >  0)    0.300 us |          cap_file_permission();
> > >> >  0)    8.909 us |        }
> > >> >  0)    0.993 us |      }
> > >> >  0)   11.649 us |+   }
> > >> >  0)             |    do_sync_read() {
> > >> >  0)             |      sock_aio_read() {
> > >> >  0)             |        __sock_recvmsg() {
> > >> >  0)             |          security_socket_recvmsg() {
> > >> >  0)  100.319 us |!           cap_socket_recvmsg();
> > >> > ---------------------------------------------------------
> > >
> > > Hm?
> > 
> > I like it before the CPU number. The main purpose would be to scroll
> > quickly the file and find the overheads. That would be easy if set as
> > a first character.
> 
> No, please keep the CPU # first.  If anything, you will want to separate 
> out the CPUs first. Otherwise you will see things all mixed up.
> 
> Hmm, I could also add a per cpu files.
> 
>  debugfs/tracing/buffers/cpu0
>  debugfs/tracing/buffers/cpu1
>  debugfs/tracing/buffers/cpu2
>  debugfs/tracing/buffers/cpu3
> 
> That would print out the trace for a single CPU.

yes, doing that makes sense anyway: if someone wants to make the mistake 
of capturing a _LOT_ of tracing events without pre-filtering them in the 
kernel intelligently (just to be able to waste days sorting them apart 
and analyzing them, and then billing the client for the cost), then it 
would make sense to start 4 threads on all 4 CPUs, switch the ftrace 
output mode into raw binary format and read the per cpu buffers into 
userspace buffer.

We could perhaps even zero-copy it all straight to the pagecache: the 
ring-buffer is 4K pages based already and the data is position 
independent.

->splice_read() / ->splice_write() support for the ring-buffer would 
nicely enable all of that, to all splice-able IO transports. (i.e. the 
majority of IO transports that matter)

> BTW, I'm really not here. I'm on holiday eating turkeys.

okay.

	Ingo
