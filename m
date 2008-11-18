Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbYKREoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbYKREoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 23:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYKREoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 23:44:07 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:62848 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbYKREoG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 23:44:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAKPWIUlMQW5N/2dsb2JhbACBbc9Agnk
Date: Mon, 17 Nov 2008 23:44:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/16] Markers auto enable tracepoints (new API :
	trace_mark_tp())
Message-ID: <20081118044403.GA32759@Krystal>
References: <20081114224733.364965865@polymtl.ca> <20081114224948.134716055@polymtl.ca> <20081116075928.GB530@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20081116075928.GB530@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:39:31 up 1 day,  3:19,  3 users,  load average: 0.39, 0.12,
	0.06
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Add a new API trace_mark_tp(), which declares a marker within a 
> > tracepoint probe. When the marker is activated, the tracepoint is 
> > automatically enabled.
> > 
> > No branch test is used at the marker site, because it would be a 
> > duplicate of the branch already present in the tracepoint.
> > 
> > Impact: new API.
> 
> i dont know.
> 
> I was actually hoping for markers (the in-kernel API) to go away 
> completely - and be replaced with tracepoints.
> 
> Markers are the wrong design on several levels. They couple the kernel 
> dynamically with unknown (to the kernel) entities - and that is 
> causing complexity all around the place, clearly expressed in these 
> patches of yours.
> 
> Tracepoints are much more specific - typed and enumerated function 
> call callback points in essence - with some politeness that allows 
> external instrumentation entities to attach to those callbacks.
> 
> Is there any usecase of markers that should not be converted to either 
> tracepoints or to ftrace_printk() ?
> 
> 	Ingo

I'll try to explain the common use-case I have in mind. I think starting
from that we'll be able to better understand what pieces of tracepoints
and markers are useful, and which purpose they fulfill. I have other
use-cases in mind too, but for sake of clarity, let's begin with this
subset.

Tracepoints instrument the kernel. They identify code locations and
extract the state of pre-identified interesting variables at these
locations. They are built into the kernel. They are closely tied to
kernel internals, and hence only provide an in-kernel API.

Markers identify the name (and therefore numeric ID) to attach to an
"event" and the data types to export into trace buffers for this
specific event type. These data types are fully expressed in a marker
format-string table recorded in a "metadata" channel. The size of the
various basic types and the endianness is recorded in the buffer header.
Therefore, the binary trace buffers are self-described.

Data is exported through binary trace buffers out of kernel-space,
either by writing directly to disk, sending data over the network, crash
dump extraction, etc.

User-space applications, which run on an architecture with potentially
different endianness and different type sizes, reads the binary buffers.
Therefore, those buffers must be fully self-described so the application
can read them portably (or just on 32-bits userspace running under a
64-bits kernel).

In debug-mode tracing (where the developer wants to add
ftrace_printk()-like statements in its kernel and recompile), the
extracted information should be made available through the same binary
buffers where the information extracted from the tracepoints is saved.
Adding printk-like statements to the kernel should not suffer from the
time and buffer space penality of expanding the raw data to text.
However, ftrace_printk() requires to pretty-print the data in text.
It would be too cumbersome to ask developer to deploy their own
tracepoints whenever they want to create ad-hoc debug-style tracing
statements. This is where trace_mark() statements do better than
ftrace_printk() by allowing to dump the information to trace buffers in
binary format through a simple to use format-string based macro. Note
that each marker format string is dumped in the metadata table to
identify the new event types.

So that was my use-case which I think cannot be converted to tracepoints
nor ftrace_print(). If things are not as clear as they should be, don't
hesitate to ask for clarifications.

I also think we might consider removing the "multiple callback support"
from markers if we tie them more closely to the data extraction code,
given this multiple-callback role is already fulfilled by tracepoints.
OTOH, given my use-case can use markers as information source, thus
bypassing tracepoints for debug-style tracing, we may still need to
connect more than a single probe to the markers. I becomes very useful
for use-cases such as : dumping the kernel or userspace stack, reading
the performance counters and activating/de-activating the function
tracer at specific instrumentation sites.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
