Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbXJ3BnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbXJ3BnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 21:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXJ3BnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 21:43:12 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:36020 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbXJ3BnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 21:43:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAAMpJkdMQWvU/2dsb2JhbACBWo5W
Date: Mon, 29 Oct 2007 21:38:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeff Garzik <jeff@garzik.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, hch@infradead.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Create instrumentation directory (git repository)
Message-ID: <20071030013802.GA24492@Krystal>
References: <20071029215138.GA4233@Krystal> <20071029154741.cb093f55.rdunlap@xenotime.net> <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal> <472667F3.3000505@garzik.org> <20071029233515.GA19413@Krystal> <47267F15.9090302@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <47267F15.9090302@garzik.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:54:48 up 92 days,  1:13,  5 users,  load average: 0.22, 0.55, 0.67
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeff Garzik (jeff@garzik.org) wrote:
> Mathieu Desnoyers wrote:
> >I see no good reason to have so many different adhoc instrumentation
> >mechanisms for profiling (sched, vm, oprofile) and tracing (blktrace,
> >suspend/resume tracing) all over the place. Merging them in a single
> >directory seems like a good step towards a more generic
> >instrumentation/profiling/tracing infrastructure.
> 
> Moving files about in directories should be at the /lowest/ end of the 
> priority scale.  It makes diffs unreadable, file histories and diffing 
> difficult, and a host of other problems.
> 
> Please solve the /real/ problems, and then come back and clean up the 
> file structure after that is done.  Massive file renaming to satisfying 
> some imagined future everything-is-golden scheme is the /last/ step.  It 
> is the last step taken because the previous steps inevitably give you 
> guidance that you otherwise would not have had at the start of the task.
> 
> When I try to diff between old and new alpha oprofile code, I really 
> want to know that the reason why diffing is a pain in the ass is more 
> than "it seemed like a good first step."
> 

And how is this confirmed by the way the i386-x86_64 -> x86 merge is
done ? It seems like a good current counter-example of what you just
affirmed.

First organizing the functionally similar existing code into a single
placeholder will just help finding code duplication, just like two very
similar architectures such as i386 and x86_64.

Talking about solving "real" problems, this is what I have been working
on for about 3 years in the kernel tracing area, writing the LTTng
tracer. What I see at this point is that there is a strong interest for
collaboration between the instrumentation projects (LTTng, SystemTAP,
DTI), but since the code ends up being sprinkled all across the kernel,
it's rather hard to spot duplicates. Actually, I just ran into Linus's
suspend/resume tracer _today_.

Talking about solving real problems, this is also what I did with the
Linux Kernel Markers patch, which can now be used to instrument the
kernel code. But it only deals with one aspect of instrumentation: the
markup itself.

I would categorize what we need for instrumentation in the following
categories :

- Data identification
  * static markup, enabled dynamically, very low impact
  * dynamic markup
  * oprofile (especially for the performance counters)
  * stack traces
- Control
  * Tracing management
  * Profiling management
  * PMC management
- Data extraction
  * relay
  * debugfs
  * serial port output
  * LKCD

What I consider to fit into the instrumentation directory is the data
identification and the control mechanisms. The data extraction should be
done be generic pieces of infrastructure already present in the kernel.

Your suggestion of "first fixing the real problems" (do you mean by
this : add new code ?) and later bother about the file structure just
seems to go against most suggestions I have received from kernel
developers in the past years. Getting something new in the kernel is
much more straightforward if someone is willing to first clean up the
mess (I am quoting Thomas Gleixner here).  So, in this particular case,
addressing the real problem : people out there want a tracer in the
Linux kernel, will first require to clean up the currently existing
mess : overlapping instrumentation code sprinkled all over the place.


> 
> >Back to "profile" and "probes" directory names, they might be short, but
> >they do not represent the whole markup-profiling-tracing trio,
> >"profile" lacks the tracing part and "probe" lacks the markup part.
> 
> You can always add more letters (and words) to even reach the desired 
> level of specificity.  That does nothing to help readability though.
> 
> Anyway, it should be clear from existing precedent -- existing pathnames 
> -- that "instrumentation" is too long, and really IMO too vague anyway.
> 

I guess you don't use the Documentation/ directory often then. ;)

How about i13n ? :) Jokes aside, I could live with "probe", although it
doesn't fit the purpose exactly. Getting the perfect name, to me, come
second after the need to group those files.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
