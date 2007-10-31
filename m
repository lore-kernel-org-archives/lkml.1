Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbXJaQlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbXJaQlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbXJaQl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:41:29 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:61558 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878AbXJaQl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:41:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAHNNKEdMQWvU/2dsb2JhbACBWo5b
Date: Wed, 31 Oct 2007 12:36:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create kinst/ or ki/ directory ?
Message-ID: <20071031163623.GA4766@Krystal>
References: <20071029154741.cb093f55.rdunlap@xenotime.net> <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal> <472667F3.3000505@garzik.org> <20071030172442.GA4477@Krystal> <alpine.LFD.0.999.0710301044110.30120@woody.linux-foundation.org> <20071030185639.GA9077@Krystal> <alpine.LFD.0.999.0710301214300.30120@woody.linux-foundation.org> <20071030204043.GA13547@Krystal> <y0mk5p3qo8r.fsf@ton.toronto.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <y0mk5p3qo8r.fsf@ton.toronto.redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:08:19 up 93 days, 16:27,  3 users,  load average: 1.43, 1.31, 1.18
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > [...]  SystemTAP, for instance, does it out of tree by keeping a
> > separate list of address where kprobes must be installed. It does
> > the job on a distribution kernel maintainer perspective (Redhat),
> > since they freeze to a particular kernel version and update this
> > list every time it breaks, but will always be a source of
> > frustration for vanilla kernel users and kernel developers.
> 
> This misstates the details.  What systemtap has out-of-tree is a list
> of kernel function names (and parameter names), not addresses.  This
> list does change somewhat with kernel versions, but we generally keep
> up.  We do test with vanilla kernels, and several non-RH distributors
> test with their kernels.  It is a problem, but it is manageable.
> 

That's right, Systemtap uses symbols, thanks for the clarification. But
my point is still valid: SystemTAP expects function names and argument
names to stay unchanged, therefore using the kernel code itself as an
API to userspace tools. The markers act as a buffer between what
important events userspace tools expect and the actual kernel code.

> 
> > I think the best way to follow the code flow is to add markup in the
> > code itself: it would follow the kernel HEAD and let each subsystem
> > maintainer identify the key instrumentation sites of their
> > subsystem.
> 
> Of course - when and where the dormant overheads are acceptable, and

I have not been able to detect a significant dormant marker overhead
with the immediate values optimization. A load immediate and a predicted
conditional jump are surprisingly cheap.

> where the maintainers are willing to commit to a long-term interface
> (marker name/arguments).

Yes. I expect that kind of mark-up to be kept minimalistic.

> Systemtap can connect to markers as well as
> to kprobes and other event sources: mix & match based on what's
> available in your particular kernel and what data/computation you
> want.
> 

I think that SystemTAP's flexibility is great, but leads to fagileness
wrt kernel code changes. If the "core events" required by SystemTAP
(and also by LTTng by the way) could be turned into markers, I think it
would gain in robustness.

Providing the ability to instrument code locations with breakpoints, in
addition to this, will help users unsatisfied with the information
they have, unwilling to recompile their kernel or modules with their
own markers, ready to accept the two limitations :
- performance hit of a breakpoint
- unability to access variables within optimized functions

So yes, both approaches seems to be complementary.

> 
> > About extending on ptrace, I am sorry to say that this solution has
> > the same downsides as kprobes: it is too slow for high performance
> > applications, especially if turned on system-wide. [...]
> 
> Roland McGrath's ptrace-replacement (utrace) should help with this.
> 

Yes, I think he did a good job at it. However, it is not a replacement
for the markers, SystemTAP or LTTng, because it defines a limited
set of hardcoded events (implying yet another type of code markup) that
is by itself a pain to extend. I am not willing to ask a subsystem
maintainer to do more than to "just identify" their important code
paths, the equivalent of adding a printk to their code. I don't think it
is realistic to ask them to create specialized callbacks for each of the
sites they would like to instrument.

So I would say : I'll try to submit a core set of markers patches for
review on LKML and see what people have to say.

Mathieu

> 
> - FChE

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
