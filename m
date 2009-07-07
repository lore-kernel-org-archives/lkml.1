Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZGGBjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZGGBjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 21:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbZGGBjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 21:39:44 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:53346 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752957AbZGGBjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 21:39:44 -0400
X-SpamScore: -19
X-BigFish: VPS-19(z34a4jz1432R98dN1805Mzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4A52A74D.8000005@am.sony.com>
Date: Mon, 6 Jul 2009 18:39:25 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] ftrace: Add duration filtering to function graph
 tracer
References: <4A528769.5020200@am.sony.com> <alpine.DEB.2.00.0907062017510.8813@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0907062017510.8813@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2009 01:39:25.0857 (UTC) FILETIME=[C2D40910:01C9FEA3]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 6 Jul 2009, Tim Bird wrote:
> 
>> Add duration filtering to the function graph tracer.
>>
>> The duration filter value is set in the 'tracing_thresh'
>> pseudo-file.  Values are in microseconds (as is customary
>> for that file).
>>
>> This adds ring_buffer_peek_previous(), used to help
>> remove the function entry event from the trace log,
>> where this is possible.
>>
>> To use:
>>  $ cd <debugfs tracing directory>
>>  $ echo 100 >tracing_thresh
>>  $ echo function_graph >current_tracer
>>  $ cat trace
> 
> I see what you are trying to do, but this can be really dangerous. 
> Remember, the ring buffer is now lockless. This could probably cause some 
> problems with various races.

That's something I'm worried about.

Note that this patch only uses ring_buffer_peek_previous (which doesn't
alter anything in the log), and ring_buffer_event_discard(), which should
be atomic on "blotting out" the entry.  Obviously, a change of page
contents between the two would make things interesting, but since
this is in the committed area of a page, that seems really unlikely.

However, the truly dangerous stuff is in updating the commit pointer.
(ring_buffer_rewind_tail in patch 2/2).

As near as I can tell, that should be safe when a reader is not
going at the same time as a writer.  In my use cases, I don't let
readers and writers go at the same time (that is, the trace is always
stopped when I'm dumping it.)  I'm not sure if this is an acceptable
condition to put on use of this feature or not, but it it was found
to guarantee safeness, it could be enforced via the user interface.

> If you want a duration field in the function graph tracer, perhaps only do 
> the recording on the exit side. That may be tricky since you would also 
> need to keep the stack order as well.

This might work.

For a single process, I have calling order in ret_stack.  I also have calltime,
which should be granular enough to disentangle the call starts for functions
from different processes.  It might need a post-trace reprocessor to fix up
the results, though.

> Perhaps implement an auxiliary ring buffer?
This is a possibility.  Are you thinking of something like double-buffering
the events?

Another thing I thought of was to not commit the entry event until function
exit.  I'm not sure the ring buffer supports having an entry outstanding for
long periods of time, though. This would, I believe, hold readers at the entries for
the last 'completed' functions, which might solve reader/writer races.

I should add, that although this stuff looks dangerous, it's working pretty
well for me here.  As a debug tool, I could tolerate the occasional hang.
I'm not seeing any so far, but to be honest I haven't really pounded hard
on it yet.

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

