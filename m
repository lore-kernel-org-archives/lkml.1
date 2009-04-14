Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZDNJpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZDNJpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbZDNJnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:43:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56992 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078AbZDNJns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:43:48 -0400
Date: Tue, 14 Apr 2009 11:43:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Shawn Du <duyuyang@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-btrace@vger.kernel.org
Subject: Re: PATCH 1/3] blktrace: support per-partition tracing
Message-ID: <20090414094326.GB3558@elte.hu>
References: <49E42620.4050701@cn.fujitsu.com> <20090414080919.GB27003@elte.hu> <49E448F6.5010506@cn.fujitsu.com> <20090414083856.GF27003@elte.hu> <49E44F15.9030906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E44F15.9030906@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.3
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> >>> Lets note that this approach still has the (long existing) 
> >>> limitation that only one device can be block-traced at a time.
> >>>
> >> No, both userspace blktrace and ftrace-plugin trace can trace
> >> more than one device at a time.
> >>
> >>  # btrace /dev/sda /dev/dm-0
> >>
> >> or
> >>
> >>  # echo 1 > /sys/block/sda/trace/enable
> >>  # echo 1 > /sys/block/dm-0/trace/enable
> > 
> > When they are independent - but not multiple partitions at a time:
> 
> The only way to trace multipl partitions is to trace the whole 
> sda, or set trace/start_lsa and trace/end_lsa properly.

... or, once we have the filtering engine upgraded, to use 
or-connected filters:

 # [mockup example]

 sector >= 20000 && sector <= 30000
 ||
 sector >= 50000 && sector <= 60000

Note that users dont have to care about these expressions - they 
could get auto-added when tracing is enabled for a partition.

Such type of more complex compound filters are possible already - 
what we dont have is comparison operators (right now we only have == 
and !=), nor built-in convenience support for dev_t.

Another variant would be:

 dev == sda1
 ||
 dev == sda3

type of compound filters - achieving the same goal as the sector 
based filter.

> >  [root@aldebaran ~]# echo 1 > /sys/block/sda/sda1/trace/enable 
> >  [root@aldebaran ~]# echo 1 > /sys/block/sda/sda2/trace/enable 
> >  -bash: echo: write error: Device or resource busy
> 
> That's because struct blk_trace is attached to struct 
> request_queue, sda1 and sda2 share the same rq:
> 
>   # echo 1 > /sys/block/sda/sda1/trace/enable 
>   # cat /sys/block/sda/sda1/trace/enable 
>   1
>   # cat /sys/block/sda/sda2/trace/enable 
>   1

yes - i'm just pointing out the limitation. It's no big issue 
currently - most of the actual tracing happens on specific 
devices/partitions. (Perhaps 'whole system blk tracing' is a common 
pattern though.)

I'm just pointing out that this is a beauty wart, and that it will 
be mostly addressed when we go to TRACE_EVENT() based tracepoints in 
blktrace :-)

	Ingo
