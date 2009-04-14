Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbZDNIjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbZDNIjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZDNIj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:39:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51884 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZDNIjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:39:25 -0400
Date: Tue, 14 Apr 2009 10:38:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Shawn Du <duyuyang@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-btrace@vger.kernel.org
Subject: Re: PATCH 1/3] blktrace: support per-partition tracing
Message-ID: <20090414083856.GF27003@elte.hu>
References: <49E42620.4050701@cn.fujitsu.com> <20090414080919.GB27003@elte.hu> <49E448F6.5010506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E448F6.5010506@cn.fujitsu.com>
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

> Ingo Molnar wrote:
> > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> >> From: Shawn Du <duyuyang@gmail.com>
> >>
> >> Though one can specify '-d /dev/sda1' when using blktrace, it 
> >> still traces the whole sda.
> >>
> >> To support per-partition tracing, when we start tracing, we 
> >> initialize bt->start_lba and bt->end_lba to the start and end 
> >> sector of that partition.
> >>
> >> Note some actions are per device, thus we don't filter 0-sector 
> >> events.
> >>
> >> The original patch and discussion can be found here:
> >> 	http://marc.info/?l=linux-btrace&m=122949374214540&w=2
> >>
> >> Signed-off-by: Shawn Du <duyuyang@gmail.com>
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > 
> > Thanks - beyond the small detail i mailed about a few minutes ago 
> > the series looks good: i'll queue this up in tracing/blktrace unless 
> > Jens has second thoughts.
> > 
> > Lets note that this approach still has the (long existing) 
> > limitation that only one device can be block-traced at a time.
> > 
> 
> No, both userspace blktrace and ftrace-plugin trace can trace
> more than one device at a time.
> 
>  # btrace /dev/sda /dev/dm-0
> 
> or
> 
>  # echo 1 > /sys/block/sda/trace/enable
>  # echo 1 > /sys/block/dm-0/trace/enable

When they are independent - but not multiple partitions at a time:

 [root@aldebaran ~]# echo 1 > /sys/block/sda/sda1/trace/enable 
 [root@aldebaran ~]# echo 1 > /sys/block/sda/sda2/trace/enable 
 -bash: echo: write error: Device or resource busy
 [root@aldebaran ~]#

Nor did i see any "trace all block IO in the system" kind of 
functionality in blktrace. (or maybe there's one that i missed?)

> > Furthermore, various other aspects of act_log_check() itself 
> > could be expressed in terms of per tracepoint filters as well: 
> > the PID filter field for example - which is supported in the 
> > ioctl ABI but currently not exposed in the user-space blktrace 
> > utility. Same goes for the action mask which is frequently used.
> > 
> 
> Actually action mask can be specified by 'blktrace -a/-A 
> mask/mask_name'

Yes, this is what i meant by "which is frequently used".

	Ingo
