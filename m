Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbZCWPGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbZCWPGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758287AbZCWPG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:06:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43769 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757600AbZCWPGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:06:24 -0400
Date: Mon, 23 Mar 2009 16:06:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: rostedt@goodmis.org, compudj@krystal.dyndns.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] kmemtrace: restore original tracing data binary
	format, improve ABI
Message-ID: <20090323150613.GB21267@elte.hu>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro> <161be9ca8a27b432c4a6ab79f47788c4521652ae.1237813499.git.eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161be9ca8a27b432c4a6ab79f47788c4521652ae.1237813499.git.eduard.munteanu@linux360.ro>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> When kmemtrace was ported to ftrace, the marker strings were taken 
> as an indication of how the traced data was being exposed to the 
> userspace. However, the actual format had been binary, not text.
> 
> This restores the original binary format, while also adding an 
> origin CPU field (since ftrace doesn't expose the data per-CPU to 
> userspace), and re-adding the timestamp field. It also drops 
> arch-independent field sizing where it didn't make sense, so 
> pointers won't always be 64 bits wide like they used to.

Thanks Eduard, nice stuff! I'll pick up your patches as they are 
nice fixes and cleanups but you might want to take a look at a few 
things that happened in tracing land in the past few weeks:

firstly, you can now fetch data in a per CPU way:

[root@aldebaran tracing]# pwd
/debug/tracing
[root@aldebaran tracing]# ll per_cpu/
total 0
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu0
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu1
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu10
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu11
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu12
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu13
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu14
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu15
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu2
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu3
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu4
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu5
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu6
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu7
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu8
drwxr-xr-x 2 root root 0 2009-03-23 10:44 cpu9
[root@aldebaran tracing]# ll per_cpu/cpu0/
total 0
-rw-r--r-- 1 root root 0 2009-03-23 10:44 trace
-r--r--r-- 1 root root 0 2009-03-23 10:44 trace_pipe
-r--r--r-- 1 root root 0 2009-03-23 10:44 trace_pipe_raw

This is a relatively new addition. The trace_pipe_raw file can be 
used to fetch binary data, and it has working splice() support as 
well, for zero-copy data streaming.

To get those binary records the tracepoint has to be expressed not 
in terms of DEFINE_TRACE(), but in terms of DEFINE_EVENT(). See a 
few examples in:

  include/trace/irq_event_types.h
  include/trace/sched_event_types.h

With latest -tip you can also define simple in-situ filters on each 
tracepoint, via the 'filter' file. I think this capability would be 
particularly interesting for kmemtrace, to restrict tracing to a 
given cache only, to particular sizes, etc.

This too needs DEFINE_EVENT() definition. It's more elaborate to 
express tracepoints via DEFINE_EVENT() than via 
DECLARE/DEFINE_TRACE(), but it results in faster tracing and enables 
more built-in features.

See this commit in -tip:

 | commit 7ce7e4249921d5073e764f7ff7ad83cfa9894bd7
 | Author: Tom Zanussi <tzanussi@gmail.com>
 | Date:   Sun Mar 22 03:31:04 2009 -0500
 |
 |     tracing: add per-event filtering

for a short description about how these filters work.

Thanks,

	Ingo
