Return-Path: <linux-kernel-owner+w=401wt.eu-S933530AbYEVMr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbYEVMr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761400AbYEVMrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:47:45 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:37345 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761332AbYEVMro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:47:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwEAJoINUhMQWqh/2dsb2JhbACBVa13
Date: Thu, 22 May 2008 08:47:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: System call instrumentation
Message-ID: <20080522124739.GA14980@Krystal>
References: <20080504134838.GA21487@Krystal> <20080505065559.GD3350@elte.hu> <20080505105915.GA26444@Krystal> <20080505111029.GA9948@elte.hu> <20080505113057.GA28070@Krystal> <20080505122835.GA1523@elte.hu> <20080520034453.GA21313@Krystal> <20080520071804.482c173e@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080520071804.482c173e@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:33:11 up 83 days,  8:44,  4 users,  load average: 0.30, 0.24,
	0.28
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Mon, 19 May 2008 23:44:53 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > > Ideally, I'd like to have this kind of high-level information :
> > > > 
> > > > event name : kernel syscall
> > > > syscall name : open
> > > > arg1 (%s) : "somefile"    <-----
> > > > arg2 (%d) : flags
> > > > arg3 (%d) : mode
> > > > 
> > > > However, "somefile" has to be read from userspace. With the
> > > > protection involved, it would cause a performance impact to read
> > > > it a second time rather than tracing the string once it's been
> > > > copied to kernel-space.
> 
> the audit subsystem already does all of this... why not use that??
> (And it goes through great lengths to do it securely)
> 
> > > 
> 
> > Hrm, a quick benchmark on my pentium 4 comparing a normal open()
> > system call executed in a loop to a modified open() syscall which
> > executes the lines added in the following patch adds 450 cycles to
> > each open() system call. I added a putname/getname on purpose to see
> > the cost of a second userspace copy and it's not exactly free.
> 
> copying twice does mean that if the user wants, he can cheat you. He
> can, in another thread, change the string under you. So say you're
> doing this for anti-virus purposes, he can make you scan one file and
> open another.
> 
> 
> The audit subsystem was carefully designed to avoid this trap... how
> about using that?

Hrm, given tracing will have to grab __user * parameters passed to
various system calls, not limited to strings, the getname/putname
infrastructure would need to be expanded a lot. I doubt it's worth
adding such complexity (copy to temporary memory buffers and reference
counting) in those system calls to support kernel-wide tracing.

On the other hand, adding a marker in the traced function, at a code
location where the data copied into the kernel is accessible, won't add
such complexity and will help to keep good locality of reference (the
stack is meant to be a good cache-hot memory region). Because a dormant
marker does not have a significant performance hit (actually, my
benchmarks shows a small acceleration of the overall system, probably
due to cache line code layout modifications), I think it's legitimate to
add this kind of instrumentation in the existing kernel system call
functions.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
