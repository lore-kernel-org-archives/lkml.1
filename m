Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZDNVZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZDNVZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZDNVZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:25:38 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46837 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZDNVZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v4guqJ8XHwBELURfnFZu8mgrSAL83GrOeTc2KtdVgPGxrSCGraJbbCYmHp9rfqcVvl
         FMjlf0tmOEm/1ukGErBVEcBVqq7pt8K9bgoA7sfUjU4jkDF604xDe1jQgMremqzqx9WM
         ECBvc/X2V0rMEQjfEKe/KS3U/z59kq2agsUxY=
Date: Tue, 14 Apr 2009 23:25:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: blktrace: event traces displayed wrong while ftrace blktrace
	is active
Message-ID: <20090414212532.GD5968@nowhere>
References: <E1LtUBT-0007kq-HU@closure.thunk.org> <49E45F7B.7060709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E45F7B.7060709@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 06:03:39PM +0800, Li Zefan wrote:
> Theodore Ts'o wrote:
> > Hi Li,
> > 
> > Thanks for working on the ftrace blktrace code; I was wondering if you
> > could take a look at something.   While the nop or syscall tracer is
> > selected ("echo nop > /sys/kernel/debug/tracing/current_tracer"), the
> > event traces display like this:
> > 
> >            <...>-4491  [001]  9556.305696: jbd2_start_commit: dev dm-0:8 transaction 335442
> >            <...>-4491  [001]  9556.305700: jbd2_commit_locking: dev dm-0:8 transaction 335442
> >            <...>-4491  [001]  9556.305713: jbd2_commit_flushing: dev dm-0:8 transaction 335442
> >            <...>-4491  [001]  9556.305720: jbd2_submit_inode_data: dev dm-0 transaction ino 3807454
> >            <...>-4491  [001]  9556.305833: jbd2_commit_logging: dev dm-0:8 transaction 335442
> >            <...>-4491  [000]  9556.307241: jbd2_end_commit: dev dm-0:8 transaction 335442 head 334303
> > 
> > That is, the timestamp information what CPU, what pid, etc., is present.
> > 
> > However, if the blk tracer is active, this information is missing:
> > 
> > jbd2_start_commit: dev dm-0:8 transaction 333227
> > jbd2_commit_locking: dev dm-0:8 transaction 333227
> > jbd2_commit_flushing: dev dm-0:8 transaction 333227
> > jbd2_submit_inode_data: dev dm-0 transaction ino 1466869
> > jbd2_submit_inode_data: dev dm-0 transaction ino 1310793
> > jbd2_commit_logging: dev dm-0:8 transaction 333227
> > jbd2_end_commit: dev dm-0:8 transaction 333227 head 332814
> > 
> 
> The cause is:
> 
> static void blk_tracer_start(struct trace_array *tr)
> {
> 	blk_tracer_enabled = true;
> 	trace_flags &= ~TRACE_ITER_CONTEXT_INFO;  <--- !!
> }
> 
> If TRACE_ITER_CONTEXT_INFO is set, 'comm-pid [cpu] ts' will be
> printed, and vise versa.
> 
> The purpose to unset this flag is to make binary output can be
> parsed by blkparse.


Indeed. Note that you can overwrite this default by typing:

echo context-info > trace_option

after setting bkltrace as the current tracer.

Frederic.



> 
> > The context information for the blktrace is present:
> > 
> >               rm-25433 [001]  9578.307485:   8,18   m   N cfq25433 slice expired t=0
> >               rm-25433 [001]  9578.307486:   8,18   m   N cfq25433 put_queue
> >       kjournald2-14059 [001]  9579.032457:   8,18   A   W 5631242 + 8 <- (8,18) 3671312
> >       kjournald2-14059 [001]  9579.032462:   8,18   Q   W 5631242 + 8 [kjournald2]
> >       kjournald2-14059 [001]  9579.032470:   8,18   G   W 5631242 + 8 [kjournald2]
> > 
> > It's just the context information for the event traces which are
> > missing.
> > 
> > Anyway, if you could take a look at this, it would be much appreciated.
> > Usually I can interpolate the the timestamps from the surrounding
> > blktrace lines, but it would be nice if I didn't have to do that.
> > 
> 

