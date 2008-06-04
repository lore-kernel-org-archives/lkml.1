Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbYFDWlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbYFDWlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbYFDWla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:41:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052AbYFDWl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:41:29 -0400
Date: Wed, 4 Jun 2008 15:41:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kobayashi.kk@ncos.nec.co.jp, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] per-task-delay-accounting: /proc export for memory
 reclaim delay
Message-Id: <20080604154124.5b5b5bf7.akpm@linux-foundation.org>
In-Reply-To: <20080604120235.940B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
	<20080603194608.ed76ecf3.kobayashi.kk@ncos.nec.co.jp>
	<20080604120235.940B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2008 12:07:29 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> > diff --git a/fs/proc/array.c b/fs/proc/array.c
> > index 9e3b8c3..a3e6e86 100644
> > --- a/fs/proc/array.c
> > +++ b/fs/proc/array.c
> > @@ -498,7 +498,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
> > 
> >  	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
> >  %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
> > -%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
> > +%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %llu %lu %ld\n",
> >  		pid_nr_ns(pid, ns),
> >  		tcomm,
> >  		state,
> > @@ -544,6 +544,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
> >  		task->rt_priority,
> >  		task->policy,
> >  		(unsigned long long)delayacct_blkio_ticks(task),
> > +		(unsigned long long)delayacct_freepages_ticks(task),
> >  		cputime_to_clock_t(gtime),
> >  		cputime_to_clock_t(cgtime));
> 
> userland program oftern below access.
> thus, this patch break userland compatibility.
> 
> ----------------------------------------
> #!/usr/bin/perl
> 
> $stat = `cat /proc/$pid/stat`;
> split
> @stat_list = split(/ / , $stat);
> print stat_list[$index];
>                  ^
>                  |
>                  use array index number
> 

Any application which breaks if we add more things to /proc/pid/stat
just needs to be fixed.

But we can't add new fields in the middle of the line!  We can only add
new items to the end.

But I think it would be good if we just weren't to make this change. 
Do we really want to keep reporting the same information in two
separate ways?

If so, a new /proc/pid/delays would be a better way, but it might be a
bit late for doing that now, given that we already put
delayacct_blkio_ticks into /proc/pid/stat.


