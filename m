Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbZASN0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbZASN0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760732AbZASNZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:25:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759862AbZASNY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:24:58 -0500
Date: Sat, 17 Jan 2009 00:38:48 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Mason <chris.mason@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
Message-ID: <20090117023848.GH6562@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>,
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <fweisbec@gmail.com>
References: <20090116004050.273665842@goodmis.org> <1232142467.5090.19.camel@think.oraclecorp.com> <20090116222600.GA3899@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116222600.GA3899@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 16, 2009 at 11:26:00PM +0100, Ingo Molnar escreveu:
> 
> * Chris Mason <chris.mason@oracle.com> wrote:
> 
> > On Thu, 2009-01-15 at 19:40 -0500, Steven Rostedt wrote:
> > > Ingo,
> > > 
> > > The first patch is critical, and needs to stay with trace_output.c
> > > Not that critical since trace_output.c is not in mainline yet.
> > > 
> > > The second patch gives the ability to stack trace functions.
> > > I've been leery about adding this and still keep it a separate
> > > option from the "stacktrace" that already exists. This is because
> > > when enabled with no filtering, the lag between typing and seeing
> > > what is typed can be up to 10 seconds or more.
> > > 
> > 
> > I mostly asked for this because I often try to find the most common
> > reason a given function is called, and oprofile isn't always a great way
> > to catch it.  systemtap can do it too if you can get systemtap to work
> > against your current devel kernel, but there are limits on how much
> > memory it'll use.
> > 
> > I've attached some simple python code that parses the output of the
> > function stack tracer, it makes some dumb assumptions about the format
> > but isn't a bad proof of concept.  The first such assumption is that
> > you're only filtering on a single function.
> > 
> > Here is some example output, trying to find the most common causes of
> > native_smp_send_reschedule() during a btrfs dbench run.
> > 
> > It relates to the Oracle OLTP thread because oracle heavily uses IPC
> > semaphores to trigger wakeups of processes as various events finish.
> > I'd bet that try_to_wakeup is the most common cause of the reschedule
> > calls there as well.
> > 
> > For btrfs, the btree lock mutexes come back into the profile yet again.
> > It would be interesting to change the spinning mutex code to look for
> > spinners and skip the wakeup on unlock, but that's a different thread
> > entirely.
> > 
> > The short version is: thanks Steve, this is really cool!
> > 
> > 12058 hits: 
> >  <= check_preempt_wakeup
> >  <= try_to_wake_up
> >  <= wake_up_process
> >  <= __mutex_unlock_slowpath
> >  <= mutex_unlock
> >  <= btrfs_tree_unlock
> >  <= unlock_up
> >  ===========
> 
> Cool! We've got scripts/tracing/ [with one Python script in it already] - 
> so if this is tidied up to be generally useful we could put it there.
> 
> The other thing is that there's the statistics framework of ftrace, being 
> worked on by Frederic and Steve. That tries to handle and provide 
> higher-order summaries/"views" of plain traces, like histograms and counts 
> - provided by the kernel.

That I plan to use to provide something similar (equal?) in blkftrace to what
blktrace produces when it stops a tracing session:

  8,0    1     3767     2.180288230 31765  C   W 126227253 + 8 [0]
^CCPU0 (8,0):
 Reads Queued:           0,        0KiB	 Writes Queued:         141, 564KiB
 Read Dispatches:        0,        0KiB	 Write Dispatches:        0, 0KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        0,        0KiB	 Writes Completed:        0, 0KiB
 Read Merges:            0,        0KiB	 Write Merges:           45, 180KiB
 Read depth:             1        	 Write depth:             2
 IO unplugs:             2        	 Timer unplugs:           0
CPU1 (8,0):
 Reads Queued:           2,        8KiB	 Writes Queued:         679, 2,716KiB
 Read Dispatches:        2,        8KiB	 Write Dispatches:      598, 3,280KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        2,        8KiB	 Writes Completed:      598, 3,280KiB
 Read Merges:            0,        0KiB	 Write Merges:          177, 708KiB
 Read depth:             1        	 Write depth:             2
 IO unplugs:             3        	 Timer unplugs:           0

Total (8,0):
 Reads Queued:           2,        8KiB	 Writes Queued:         820, 3,280KiB
 Read Dispatches:        2,        8KiB	 Write Dispatches:      598, 3,280KiB
 Reads Requeued:         0		 Writes Requeued:         0
 Reads Completed:        2,        8KiB	 Writes Completed:      598, 3,280KiB
 Read Merges:            0,        0KiB	 Write Merges:          222, 888KiB
 IO unplugs:             5        	 Timer unplugs:           0

Throughput (R/W): 3KiB/s / 1,504KiB/s
Events (8,0): 4,289 entries
Skips: 0 forward (0 -   0.0%)
[root@doppio ~]# 

:-)

- Arnaldo
