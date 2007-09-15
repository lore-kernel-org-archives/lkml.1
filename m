Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbXIOQB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbXIOQB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 12:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXIOQBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 12:01:20 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:33841 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751768AbXIOQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 12:01:19 -0400
Date: Sat, 15 Sep 2007 12:01:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Wilder <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, SystemTAP <systemtap@sources.redhat.com>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] Trace code and documentation
Message-ID: <20070915160117.GA17485@Krystal>
References: <46E9CB14.7060000@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46E9CB14.7060000@us.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:23:31 up 47 days, 15:42,  3 users,  load average: 0.19, 0.52, 0.56
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Interesting work, but I think we could still enhance it. The interesting
things you bring is the trace control though debugfs files, which is
clear and simple. (I did it on top of netlink in LTTng, but I don't
really care about the mechanism, as long as we have the same
flexibility).

* David Wilder (dwilder@us.ibm.com) wrote:
[...]
> 
> +Overwrite mode can be called "flight recorder mode".  Flight recorder
> +mode is selected by setting the TRACE_FLIGHT_CHANNEL flag when
> +creating trace channels.  In flight mode when a tracing buffer is
> +full, the oldest records in the buffer will be discarded to make room
> +as new records arrive.	In the default non-overwrite mode, new records
> +may be written only if the buffer has room.  In either case, to
> +prevent data loss, a user space reader must keep the buffers
> +drained. Trace provides a means to detect the number of records that
> +have been dropped due to a buffer-full condition (non-overwrite mode
> +only).
> +

Since, in the end, we can represent the "flight recorder" as a simple flag,
can we imagine setting/unsetting it while the trace is active ?

Also, why is trace creation an in-kernel API ? What about a mkdir in
debugfs/trace ? I guess I see that this is because you need to keep a
pointer to the created trace so you can record your events it in. Have
you thought about keeping a global RCU list of active traces instead ?
One could then iterate on every active trace and record information in
them without having to bother about which specific trace it has created.
However, this should come with the ability to filter in/out events in
the handler on a per-trace basis.

The problem with the approach you propose is that it seems to tie a
specific event source to one trace channel.

It would be good to have some way to separate:

- event sources (markers/kprobes/...)
- active traces.
  Each of them would have an event filter.
- within each trace, the ability to create _multiple_ channels, so we
  can send the information in high/medium/low event rate channels on a
  per-event basis. This is really useful to gather hybrid traces made
  from flight recorder channels (high event rate) and non-over channels
  (important low rate information required to understand the trace).
- Each trace channel would be either global or per cpu, and would be a
  flight recorder channel or "normal", non overwrite, channel.


> +When per-CPU buffers are used, relay creates one debugfs file for each
> +running CPU.  The user-space consumer of the data is responsible for
> +reading the per-CPU buffers and collating the records presumably using
> +a time stamp or sequence number included in the trace records.	The
> +use of global buffers eliminates this extra work of sequencing
> +records; however the provider's data layer must hold a lock when
> +writing records.  The lock prevents writers running on different CPUs
> +from overwriting each other's data.  However, buffering may be slower
> +because writes to the buffer are serialized. Global buffering is
> +selected by setting the TRACE_GLOBAL_CHANNEL flag when creating trace
> +channels.
> +

We could allocate the trace buffers upon actions that would be
independant from trace creation. By doing so, we could then do a

echo 1 > path_to_trace/channel/global

Before we activate the trace or allocate the buffers. I would vote for a 

echo 1 > path_to_trace/channel/allocate

So we can separate the trace buffer allocation from trace start (because
start operation might have to be done near from the studied events and
we want it to be as lightweight as possible).

So, typical usage could be:

cd /mnt/debugfs/trace
mkdir mytrace
cd mytrace
echo 1 > start

The default could be that we create a trace with a "main" set of per-cpu
channels. i.e.:

mytrace/main

But then, a mkdir within the mytrace directory could add new custom
channels:

in mytrace:
mkdir processes
cd processes
(then set buffer size, nr subbuf, flight vs non flight, global..)
echo 1 > allocate

By default, a trace event filter would accept all events. Events could
be identified by a name (see markers proposed subsystem_event name).
Issuing a :

echo 0 > path_to_trace/filter
would disable all events
echo "event_name" > path_to_trace/filter
would add the event_name to the trace filter

By default, events would be sent into the "main" channel, but
echo "event_name" > path_to_trace/channel/filter
would send the event in the "channel" channel instead.


We could think of integrating the markers macro into this scheme to
describe the events. Instead of doing an explicit trace write in the
breakpoint handler, we could simply put a marker (it could even be a
branch-free marker if you prefer). In LTTng, upon trace start, I iterate
on all the kernel's markers to record, in a "control" channel, all the
marker names, their ids (I assign them a 16 bit id), and their format
strings. It allows me to parse the trace given only the timestamps,
event IDs and event specific data.

Mathieu
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
