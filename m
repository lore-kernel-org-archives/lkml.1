Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbZDMWUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbZDMWUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZDMWUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:20:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbZDMWUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:20:04 -0400
Date: Tue, 14 Apr 2009 00:19:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Theodore Ts'o" <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: blktrace: event traces displayed wrong while ftrace blktrace
	is active
Message-ID: <20090413221938.GE8514@elte.hu>
References: <E1LtUBT-0007kq-HU@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LtUBT-0007kq-HU@closure.thunk.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Ts'o <tytso@mit.edu> wrote:

> Hi Li,
> 
> Thanks for working on the ftrace blktrace code; I was wondering if you
> could take a look at something.   While the nop or syscall tracer is
> selected ("echo nop > /sys/kernel/debug/tracing/current_tracer"), the
> event traces display like this:
> 
>            <...>-4491  [001]  9556.305696: jbd2_start_commit: dev dm-0:8 transaction 335442
>            <...>-4491  [001]  9556.305700: jbd2_commit_locking: dev dm-0:8 transaction 335442
>            <...>-4491  [001]  9556.305713: jbd2_commit_flushing: dev dm-0:8 transaction 335442
>            <...>-4491  [001]  9556.305720: jbd2_submit_inode_data: dev dm-0 transaction ino 3807454
>            <...>-4491  [001]  9556.305833: jbd2_commit_logging: dev dm-0:8 transaction 335442
>            <...>-4491  [000]  9556.307241: jbd2_end_commit: dev dm-0:8 transaction 335442 head 334303
> 
> That is, the timestamp information what CPU, what pid, etc., is present.
> 
> However, if the blk tracer is active, this information is missing:
> 
> jbd2_start_commit: dev dm-0:8 transaction 333227
> jbd2_commit_locking: dev dm-0:8 transaction 333227
> jbd2_commit_flushing: dev dm-0:8 transaction 333227
> jbd2_submit_inode_data: dev dm-0 transaction ino 1466869
> jbd2_submit_inode_data: dev dm-0 transaction ino 1310793
> jbd2_commit_logging: dev dm-0:8 transaction 333227
> jbd2_end_commit: dev dm-0:8 transaction 333227 head 332814
>
> The context information for the blktrace is present:
> 
>               rm-25433 [001]  9578.307485:   8,18   m   N cfq25433 slice expired t=0
>               rm-25433 [001]  9578.307486:   8,18   m   N cfq25433 put_queue
>       kjournald2-14059 [001]  9579.032457:   8,18   A   W 5631242 + 8 <- (8,18) 3671312
>       kjournald2-14059 [001]  9579.032462:   8,18   Q   W 5631242 + 8 [kjournald2]
>       kjournald2-14059 [001]  9579.032470:   8,18   G   W 5631242 + 8 [kjournald2]
> 
> It's just the context information for the event traces which are
> missing.
> 
> Anyway, if you could take a look at this, it would be much appreciated.
> Usually I can interpolate the the timestamps from the surrounding
> blktrace lines, but it would be nice if I didn't have to do that.

Yes - this happens because event tracer events are integrated based 
on the TP_printk() format in the TRACE_EVENT() definition. So the 
above:

   jbd2_commit_flushing: dev dm-0:8 transaction 333227

Comes from your TP_printk() definition for that event. That format 
is funneled through a number of macro stages to end up being called 
by kernel/trace/trace.c:print_trace_fmt().

This is printed 'as-is' to allow maximum flexibility in shaping the 
TP_format() output. I suspect it might make sense to standardize 
this some more and bring it in line with the native plugin printout 
style.

OTOH, what makes more sense instead is to concetrate on the event 
tracer itself, and making sure it does all the things you need. 
Having to do 'echo blk > current_tracer' is really an interim stage 
- we want the generic tracer to be able to do all these things as 
well - i.e. we want to integrate blktrace some more.

Anyway, added some more Cc:s.

	Ingo
