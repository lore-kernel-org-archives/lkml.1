Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbXLGLSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbXLGLSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 06:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXLGLSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 06:18:23 -0500
Received: from ns.suse.de ([195.135.220.2]:38982 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbXLGLSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 06:18:22 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: ptrace API extensions for BTS
Date: Fri, 7 Dec 2007 12:18:17 +0100
User-Agent: KMail/1.9.6
Cc: roland@redhat.com, markus.t.metzger@gmail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
References: <029E5BE7F699594398CA44E3DDF55444010F8D7C@swsmsx413.ger.corp.intel.com>
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444010F8D7C@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712071218.17914.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2007 10:11:04 Metzger, Markus T wrote:
> Roland, Andi,
>  
> I would like to discuss the ptrace user interface for the BTS extension.
> In previous emails,
> Andi suggested a stream-like interface, but is also OK with an
> array-like interface (as far as I understood).
> Roland is dubious about the ptrace API additions.
> 
> I would like to settle the discussion and find an interface that
> everybody can agree to, so I can implement that interface and we can
> move forward with the patch.

The most efficient interface would be zero copy with tracer user process
supplying memory that is pinned (get_user_pages()) subject to the
mlock rlimit. Then kernel telling the CPU to directly log into
that.

Kernel buffers would be only needed for the per CPU kernel 
logging.

Then the only information that would need to be passed with
system calls would be wakeup, tail position and perhaps a wrapping
counter.

> Regarding 1, we currently provide scheduling timestamps, which are arch

That's actually broken because you don't log the CPU number.
sched_clock() without the CPU number associated is meaningless 
on systems without synchronized, pstate invariant TSC 
[that is older Intel systems or some larger current systems]

And even if you log the CPU number it is unclear how user space
would make sense of that. It can't generally, even the kernel
can't. Perhaps better to just not supply any time stamps for this.

Even on systems that don't have unsync TSC problem above
it can be tricky to convert the TSC into real time. Right now
we don't report the TSC frequency for once. Usually it tends
to be at highest p state but finding that out is also 
difficult and unreliable (rounding errors) and might not
always be true in the future. Anyways could be solved
by reporting that separately in /proc/cpuinfo, but given all
the other problems I have my doubts it is really worth it. I would
suggest dropping the time stamp.

> Additional architectures may want to (re)use and extend the x86 bts
> record, or they may want to invent their own format. In the former case,

I think that's actually not a good goal. If the code is so complicated
that it makes sense sharing then you did something wrong :)

-Andi
