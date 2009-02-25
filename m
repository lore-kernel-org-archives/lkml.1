Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZBYNz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZBYNz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZBYNyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:54:54 -0500
Received: from THUNK.ORG ([69.25.196.29]:60145 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbZBYNyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:54:53 -0500
Date: Wed, 25 Feb 2009 08:54:37 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-ID: <20090225135437.GG7064@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Masami Hiramatsu <mhiramat@redhat.com>,
	Steven Rostedt <srostedt@redhat.com>
References: <20090225025608.956691460@goodmis.org> <20090225025753.798204550@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org> <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com> <20090224203308.8d623e0b.akpm@linux-foundation.org> <20090225081118.GC15303@elte.hu> <20090225002852.5ef5b869.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225002852.5ef5b869.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 12:28:52AM -0800, Andrew Morton wrote:
> A better approach would be to design simple, robust kernel interfaces
> which make sense and which aren't made all complex by putting the user
> interface in kernel space.  And to maintain corresponding userspace
> tools which manipulate and present the IO from those kernel interfaces.
> 
> But we don't do that, because userspace is hard, because we don't have
> a delivery process.  But nobody has even tried!  We can do this - it
> starts with `mkdir -p userspace/ktrace'.

I don't think it's just because we don't have a delivery process.  I
think it's because we've just been burned so many times with complex
user space tools that are built in C++, have impossible-to-understand
error handling ("try again with -vvvvvvv"), is hard to build because
they have huge dependencies on external libraries, or is filled with
distro dependencies and might not build on various distributions, or
is dependent on the RPM macros, etc.

Sure, if we do it ourselves, maybe we won't fall into the same set of
traps.  But after so many years of failure in creating a simple,
usable, tracing infrasructure, why not have something which is
self-contained in the kernel?  We can have a binary interface for the
people who make the uber-complex userspace tools, but 99% of the time
we don't need the complexity.

Also, I suspect the delivery problem is a lot more complicated than
you make it out to be.  It's not enough just to solve the kbuild
issues; there are the distribution packaging issues as well, and to
the extent that we have kernel-version-dependent userspace tools, how
do we standardize a system so that when the 2.6.29-rc6-gc457db2 kernel
is botted, we are using the tools associated with that kernel, and
when we have the 2.6.28.2 kernel booted, we use those tools instead?

If someone wants to work on putting together that infrastructure, I'm
sure it could be useful for more than just tracing.  I'll note though
that not all distributions have a reasonable system for dealing with
kernel-version dependent firmware packages yet, either.  (And whatever
happened to packaging firmware as a separate package from the kernel;
I haven't seen much progress on that front either.)

Sometimes, it's just much simpler and easier if we keep things all
bundled together in the kernel image.

						- Ted
