Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZCXIjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZCXIjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZCXIjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:39:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58140 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZCXIja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:39:30 -0400
Date: Tue, 24 Mar 2009 09:39:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] blktrace: print human-readable act_mask
Message-ID: <20090324083905.GB13016@elte.hu>
References: <49C893FC.9080905@cn.fujitsu.com> <49C89488.4030604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C89488.4030604@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Print stringified act_mask instead of hex value:
>  # cat act_mask
>  read,write,barrier,sync,queue,requeue,issue,complete,fs,pc,ahead,meta,
>  discard,drv_data
>  # echo "meta,write" > act_mask
>  # cat act_mask
>  write,meta

Nice!

It would also be nice to activate trace filters for the blktrace 
tracepoints - i.e. to convert them to the TRACE_EVENT() enumeration 
format. Beyond user-space parseable field enumeration and filter, 
that will also speed up tracing and allows binary record streaming 
with splice() zero-copy.

Via that "act_mask" can become a filterable field and you can define 
expressions to filter. All other fields like sector become in-kernel 
filterable too.

See a few examples here:

 include/trace/irq_event_types.h
 include/trace/sched_event_types.h

Note, blktrace tracepoints are certainly more complex than the 
tracepoints above - you can embedd C statements in TRACE_EVENT()'s 
TP_fast_assign() bit.

It was specifically designed to allow the support of blktrace 
tracepoints, so you can embedd the blk_pc_request() and disk_devt() 
translation for the block_rq_complete event or 
block_rq_requeue/issue tracepoints.

> +static struct {
> +	int mask;
> +	const char *str;
> +} mask_maps[] = {
> +	{ BLK_TC_READ,		"read"		},
> +	{ BLK_TC_WRITE,		"write"		},
> +	{ BLK_TC_BARRIER,	"barrier"	},
> +	{ BLK_TC_SYNC,		"sync"		},
> +	{ BLK_TC_QUEUE,		"queue"		},
> +	{ BLK_TC_REQUEUE,	"requeue"	},
> +	{ BLK_TC_ISSUE,		"issue"		},
> +	{ BLK_TC_COMPLETE,	"complete"	},
> +	{ BLK_TC_FS,		"fs"		},
> +	{ BLK_TC_PC,		"pc"		},
> +	{ BLK_TC_AHEAD,		"ahead"		},
> +	{ BLK_TC_META,		"meta"		},
> +	{ BLK_TC_DISCARD,	"discard"	},
> +	{ BLK_TC_DRV_DATA,	"drv_data"	},
> +};

(minor nit: this should be a const.)

Jens, Arnaldo, Steve, the series from Li looks good to me - Ack?

	Ingo
