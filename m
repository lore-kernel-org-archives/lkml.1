Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYGWNPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYGWNPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 09:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYGWNPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 09:15:31 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:38159 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbYGWNPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 09:15:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAD/HhkhMRKxB/2dsb2JhbACBWrB6
Date: Wed, 23 Jul 2008 09:15:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@qumranet.com>, Jan Kiszka <jan.kiszka@siemens.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
Message-ID: <20080723131527.GB15401@Krystal>
References: <20080717160003.359557938@polymtl.ca> <487F7800.4010502@siemens.com> <20080717172853.GB29855@Krystal> <488604F8.1040008@siemens.com> <48862B01.7070907@qumranet.com> <1216799346.7257.125.camel@twins> <4886E6FD.4090200@qumranet.com> <1216803303.7257.138.camel@twins> <4886FA97.40104@qumranet.com> <1216806834.7257.156.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1216806834.7257.156.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:51:54 up 48 days, 17:32,  4 users,  load average: 0.60, 0.78,
	0.74
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2008-07-23 at 12:32 +0300, Avi Kivity wrote:
> > Peter Zijlstra wrote:
> > > There are currently no trace_mark() sites in the kernel that I'm aware
> > > of (except for the scheduler :-/, and those should be converted to
> > > tracepoints ASAP).
> > >
> > > Andrew raised the whole point about trace_mark() generating an
> > > user-visible interface and thus it should be stable, and I agree with
> > > that.
> > >
> > > What that means is that trace_mark() can only be used for really stable
> > > points.
> > >
> > > This in turn means we might as well use trace points.
> > >
> > > Which allows for the conclusion that trace_mark() is not needed and
> > > could be removed from the kernel.
> > >
> > > However - it might be handy for ad-hoc debugging purposes that never see
> > > the light of day (linus' git tree in this case). So on those grounds one
> > > could argue against removing trace_mark
> > 
> > But trace_mark() is so wonderful.
> 
> I guess tastes differ...
> 
> >   Can't we just declare the tracemarks 
> > as a non-stable interface?
> > 
> > Perhaps add an unstable_trace_mark() to make it clear.
> 
> At the very least it would need its own output channel. But I'm afraid
> this will be KS material.
> 

Hi Peter,

Currently what I have in LTTng includes this output channel. It works
for me, but if I can make it work for others that would be great.

- Tracepoints in kernel code to instrument the kernel.
- LTTng probes connect on those relatively stable tracepoints. They
  format the data so it's meaningful to userspace (e.g. extracts the pid
  of the prev and next process at sched_switch).
- The LTTng serializer is connected on those markers. It parses the
  format string to dynamically reserve space in the relay buffer, write
  a timestamp and event ID (one event ID is pre-assigned to a marker
  name) and copy the arguments from the stack to the event record (which
  has a variable size).

Event IDs and timestamps are added by LTTng, thus not required by
markers. However, one can think of this flow as an efficient and compact
binary data export mechanism to userspace.

Headers exports data type sizes and endianness, a special data channel
exports the mappings between { marker name, ID, format string } so
events are self-described. Therefore, one can add any event he likes and
it will be automatically understood by the tracing toolchain.

If an event is removed or filtered out or modified (by changing its
field name), the userspace trace analyser will detect it and the
specific probe which expects this event will fail to load, leading to
missing analyses, but nothing more than that.

So currently what we would have is, more or less : trace_marks located
within LTTng are kept in sync with userland, but the whole chain also
allows to add "debug-style" trace_marks directly in the kernel code
(this is really useful when trying to perform a low-impact printk-like
runtime bissection of a bug in the kernel code.

I actually see the trace_marks/LTTng combination as a printk which would
extract information in its binary form instead of using text-formatting.
The actual formatting can then be done later, in userland, if ever
needed (many analyses use the raw binary format directly). I guess KS
would be a good opportunity to discuss this interface topic.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
