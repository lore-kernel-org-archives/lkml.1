Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZDKIPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZDKIPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 04:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZDKIPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 04:15:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62636 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbZDKIPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 04:15:22 -0400
Message-ID: <49E051B9.8060805@cn.fujitsu.com>
Date: Sat, 11 Apr 2009 16:15:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] blktrace: fix output of BLK_TC_PC events
References: <49D3236D.3090705@cn.fujitsu.com> <49D32387.9040106@cn.fujitsu.com>
In-Reply-To: <49D32387.9040106@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I would like to ask what's the status of these 2 patches.

Arnaldo acked on them.

Li Zefan wrote:
> BLK_TC_PC events should be treated differently with BLK_TC_FS events.
> 
> Before this patch:
> 
>  # echo 1 > /sys/block/sda/sda1/trace/enable
>  # echo pc > /sys/block/sda/sda1/trace/act_mask
>  # echo blk > /debugfs/tracing/current_tracer
>  # (generate some BLK_TC_PC events)
>  # cat trace
>         bash-2184  [000]  1774.275413:   8,7    I   N [bash]
>         bash-2184  [000]  1774.275435:   8,7    D   N [bash]
>         bash-2184  [000]  1774.275540:   8,7    I   R [bash]
>         bash-2184  [000]  1774.275547:   8,7    D   R [bash]
>  ksoftirqd/0-4     [000]  1774.275580:   8,7    C   N 0 [0]
>         bash-2184  [000]  1774.275648:   8,7    I   R [bash]
>         bash-2184  [000]  1774.275653:   8,7    D   R [bash]
>  ksoftirqd/0-4     [000]  1774.275682:   8,7    C   N 0 [0]
>         bash-2184  [000]  1774.275739:   8,7    I   R [bash]
>         bash-2184  [000]  1774.275744:   8,7    D   R [bash]
>  ksoftirqd/0-4     [000]  1774.275771:   8,7    C   N 0 [0]
>         bash-2184  [000]  1774.275804:   8,7    I   R [bash]
>         bash-2184  [000]  1774.275808:   8,7    D   R [bash]
>  ksoftirqd/0-4     [000]  1774.275836:   8,7    C   N 0 [0]
> 
> After this patch:
> 
>  # cat trace
>         bash-2263  [000]   366.782149:   8,7    I   N 0 (00 ..) [bash]
>         bash-2263  [000]   366.782323:   8,7    D   N 0 (00 ..) [bash]
>         bash-2263  [000]   366.782557:   8,7    I   R 8 (25 00 ..) [bash]
>         bash-2263  [000]   366.782560:   8,7    D   R 8 (25 00 ..) [bash]
>  ksoftirqd/0-4     [000]   366.782582:   8,7    C   N (25 00 ..) [0]
>         bash-2263  [000]   366.782648:   8,7    I   R 8 (5a 00 3f 00) [bash]
>         bash-2263  [000]   366.782650:   8,7    D   R 8 (5a 00 3f 00) [bash]
>  ksoftirqd/0-4     [000]   366.782669:   8,7    C   N (5a 00 3f 00) [0]
>         bash-2263  [000]   366.782710:   8,7    I   R 8 (5a 00 08 00) [bash]
>         bash-2263  [000]   366.782713:   8,7    D   R 8 (5a 00 08 00) [bash]
>  ksoftirqd/0-4     [000]   366.782730:   8,7    C   N (5a 00 08 00) [0]
>         bash-2263  [000]   366.783375:   8,7    I   R 36 (5a 00 08 00) [bash]
>         bash-2263  [000]   366.783379:   8,7    D   R 36 (5a 00 08 00) [bash]
>  ksoftirqd/0-4     [000]   366.783404:   8,7    C   N (5a 00 08 00) [0]
> 
> This is what we do with PC events in user-space blktrace.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
