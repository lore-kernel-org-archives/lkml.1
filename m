Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbZAMGw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbZAMGw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 01:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZAMGwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 01:52:05 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:58073 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbZAMGwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 01:52:02 -0500
Subject: ALLANC: Proposal to add progress records to process accounting
To: linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 7.0 August 18, 2005
Message-ID: <OFEF944F55.A27961D6-ONC825753D.001C91E6-C825753D.00252053@au1.ibm.com>
From: Allan Chandler <allachan@au1.ibm.com>
Date: Tue, 13 Jan 2009 15:54:50 +0900
X-MIMETrack: Serialize by Router on d23ml003/23/M/IBM(Release 7.0.2FP3HF80 | July 14, 2008) at
 13/01/2009 17:54:51
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I wanted to float an idea to get the community view before trying to
implement something in the kernel for possible submission. I've structured
this post into short description, long description and initial technical
analysis so you can just stop reading when you get bored. Any suggestions
on the value of this proposal, or improvements to the analysis, would be
greatly appreciated. I'd say "be gentle" since this is my first foray onto
LKML, but I'm willing to wear whatever scorn is heaped upon me :-).

Short description:
==================

Change process accounting to output 'progress' records for long-lived
processes (in addition to current records on process termination).

Longer description:
===================

We (more specifically, the customers of our product) have been using
process accounting for chargeback (departments are charged based on their
usage) and performance (capacity planning) purposes.  A heavily used
application, IBM Websphere Application Server [bless their little hearts
:-( ], recently changed its behaviour from "JVM processes exit regularly to
be replaced by others" to "JVM processes hang around for weeks without
exiting". So now the process accounting records aren't being written
frequently. I realize this is our problem, not yours, but bear with me, the
solution may be beneficial for others.

We currently suggest the workaround that customers periodically restart WAS
itself so that records are written more frequently.  One customer has even
taken to monitoring /proc/PID/stat but that's a bit of a kludge.

This proposal is a suggestion to add a new type of record to process
accounting that gives periodic updates of a process while it's still
active, rather than waiting for process exit (the exit record is still
written).  It appears to me that there must be many long-lived processes
that could benefit from this change, inasmuch as they could be monitored
during their lifetime rather than only at exit.

Technical analysis:
===================

The BSD process accounting within Linux writes type-3 records to the
process accounting file when a process exits (this is done via a call to
kernel/acct.c/acct_process() in kernel/exit.c/do_exit()).

The proposal is to add another type (type-6 since 1-5 are taken, I believe)
which is a incremental view of the process statistics, i.e, what's been
added since the last incremental view (or process startup if this is the
first increment). These records are exactly the same format as type-3 and
will be written for any process that hasn't written a record in a while
(for our purposes, 24 hours is fine but it may be better to make this
configurable).

There are two types of fields in the record, snapshot (such as ac_uid,
ac_gid, ac_tty, ac_btime, ac_mem) and cumulative (such as ac_stime,
ac_etime). The cumulative fields would only have the difference between the
last type-6 and current values, so that you're not reliant on working out
the values by referring to the previous type-6.

So, let's say we have a process that runs for an 45 minutes and we have our
configurable time set to 20 minutes. Further say process accounting only
output PID and user/system/elapsed time (to make this next bit easier to
understand):

At time t, process 42 starts.
At time t+20min, process 42 has used 4 seconds system time, 12 seconds user
time and outputs:
      rectype=6,pid=42, etime=1200, stime=4, utime=12
At time t+40min, process 42 has used 19 seconds system time (since start),
38 seconds user time (since start) and outputs:
      rectype=6,pid=42, etime=1200, stime=15, utime=26
At time t+45min, process 42 exits, having used 20 seconds system time
(since start), 40 seconds user time (since start) and outputs:
      rectype=6,pid=42, etime=300, stime=1, utime=2
      rectype=3,pid=42, etime=2700, stime=20, utime=40

So, as you can see, the type-3 is still output on process exit, not
breaking any programs (such as dump_acct) that expect them. However,
programs which want a more timely view of the process activity can look at
the type-6 records.

How to implement it, that's the tricky bit. My first thought is to do
checks on process context switch. Any process that becomes inactive and
hasn't written a type-6 for too long will immediately write its type-6
before the next process starts running. We'd need to ensure we don't add
too much overhead to the context switch (that's putting it mildly).  I
assume this would be somewhere in kernel/sched.c/context_switch() or
kernel/sched.c/prepare_task_switch() although I haven't yet looked in great
detail.

The code that currently outputs the type-3 (kernel/acct.c/acct_process())
would also output a type-6 first so the type-6 information is up to date
with the type-3.

>From what I can see, the process accounting information can be reached from
the process descriptor stored with the process kernel stack
(current->signal->pacct) so there may have to be some more space allocated
there for incremental information.  Quite a bit of the type-3 record is
calculated from different structures under current, so that may be another
performance issue although hopefully not since, in the vast majority of
context switches, we're just adding a simple check to see if too much time
has elapsed since the last type-6. Only every N hours would more of a load
be put on the switch.

Anyway, that's where I'm at for now. I'd appreciate any comments from those
almost certainly more knowledgable than I.

Cheers,
Pax.
==========
Two strings walk into a bar. The first one says: "Hello, I'd like some
Vodka please.ytewsr@)W$(#*$&!^Y@)^&30@#!".
"You'll have to excuse my friend," the second one says, "he's not
null-terminated".
==========
Allan Chandler (Pax), Senior IT Specialist, Australia Development
Laboratory (ADL), Perth, IBM Corporation
Internet: allachan@au1.ibm.com, Phone: +61 8 926 13019, Fax: +61 8 921
89201
Location code MP25, 77 St George's Terrace (Allendale Square), Level 25,
Perth WA 6000
_______________________________________________

