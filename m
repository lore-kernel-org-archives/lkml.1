Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbYI2QGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbYI2QGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 12:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYI2QGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 12:06:09 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:54145 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbYI2QGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 12:06:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAMSZ4EhMQWq+/2dsb2JhbACBYrpDgWc
Date: Mon, 29 Sep 2008 12:06:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Martin Bligh <mbligh@google.com>,
       prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
Message-ID: <20080929160605.GB11029@Krystal>
References: <20080927134012.GA11930@Krystal> <1222535419.16700.300.camel@lappy.programming.kicks-ass.net> <1222592370.16700.311.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1222592370.16700.311.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:50:09 up 116 days, 20:30,  9 users,  load average: 0.12, 0.32,
	0.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Sat, 2008-09-27 at 19:10 +0200, Peter Zijlstra wrote:
> > On Sat, 2008-09-27 at 09:40 -0400, Mathieu Desnoyers wrote:
> 
> > > It does not provide _any_ sort of locking on buffer data. Locking should be done
> > > by the caller. Given that we might think of very lightweight locking schemes,
> 
> Which defeats the whole purpose of the exercise, we want to provide a
> single mechanism - including locking - that is usable to all. Otherwise
> everybody gets to do the hard part themselves, which will undoubtedly
> result in many broken/suboptimal locking schemes. 
> 

Well, this is my answer to Steven's "this is too complex" comments,
which I suspect is really a "this is too implement to implement". Sorry
Steven, but you do not actually propose anything to address my concerns,
which are : I want to export this data to userspace without tricky
dependencies on the compiler ABI. I also don't want to be limited in
locking infrastructure implementation.

Those are the kind of concerns that are much easier to address in a
layered and modular implementation. If we try to do everything in the
same C file, we end up having typing/memory management/time management
all closely tied.

So I am all for providing a common infrastructure which implements all
this, but I think this infrastructure should itself be layered and
modular.

Also, I have something really really near to the requirements expressed
in LTTng, which is :

Linux Kernel Markers : Event data typing exportable to userspace without
                       tricky compiler ABI dependency.
                       TODO : Export marker list to debugfs.
                              Allow individual marker enable/disable
                              through debugfs file.
                              Use per client buffer marker IDs rather
                              than a global ID table.
                              Export the markers IDs/format/name through
                              one small buffer for each client buffer.
ltt-relay :            Buffer coherency management. TODO : splice.
ltt-relay-alloc :      Buffer allocation and read/write, without vmap.
ltt-tracer :           In-kernel API to manage trace allocation,
                       start/stop.
                       TODO : Currently has a statically limited set of
                       buffers. Should be extended so that clients could
                       register new buffers.
ltt-control :          Netlink control which calls the in-kernel
                       ltt-tracer API.
                       TODO : switch from netlink to debugfs.
ltt-timestamp :        Timestamping infrastructure (tsc, global
                       counter). Currently supports about 6
                       architectures. Has an asm-generic fallback.
ltt-heartbeat :        Deal with 32 TSC overflow by periodically writing
                       an event in every buffers.
                       TODO : switch to "extended time" field by keeping
                       track of the previously written timestamp.

If you think it's worthwhile, I could post a selected set of my patches
to LKML to see the reactions. However, note that there are a few TODOs,
so it does not address all the requirements.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
