Return-Path: <linux-kernel-owner+w=401wt.eu-S1757697AbZCXIru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbZCXIru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755109AbZCXIrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:47:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37780 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441AbZCXIrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:47:41 -0400
Date: Tue, 24 Mar 2009 09:47:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] blktrace: fix off-by-one bug
Message-ID: <20090324084717.GE13016@elte.hu>
References: <49C893FC.9080905@cn.fujitsu.com> <49C89447.5060303@cn.fujitsu.com> <20090324082754.GA13016@elte.hu> <49C89ACE.9070102@cn.fujitsu.com> <49C89CBC.4030600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C89CBC.4030600@cn.fujitsu.com>
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

> Li Zefan wrote:
> >>> -	if (unlikely(what == 0 || what > ARRAY_SIZE(what2act)))
> >>> +	if (unlikely(what == 0 || what >= ARRAY_SIZE(what2act)))
> >> ah, nice. How did you notice - did we miss "remap" events due to 
> >> this bug?
> >>
> 
> forgot to mention, we didn't miss any "remap" events.
> 
> > 
> > By code review, but we can get NULL dereference bug if we receive an
> > "abort" event, this event may be generated only when using device-mapper.
> > 
> 
> and not NULL dereference, but accessing invalid memory.
> 
> what2act["abort"]->print(...)
> 
> and "abort" == ARRAY_SIZE(what2act).

Ah. This:

        [__BLK_TA_QUEUE]        = {{  "Q", "queue" },      blk_log_generic },
        [__BLK_TA_BACKMERGE]    = {{  "M", "backmerge" },  blk_log_generic },
        [__BLK_TA_FRONTMERGE]   = {{  "F", "frontmerge" }, blk_log_generic },
        [__BLK_TA_GETRQ]        = {{  "G", "getrq" },      blk_log_generic },
        [__BLK_TA_SLEEPRQ]      = {{  "S", "sleeprq" },    blk_log_generic },
        [__BLK_TA_REQUEUE]      = {{  "R", "requeue" },    blk_log_with_error },
        [__BLK_TA_ISSUE]        = {{  "D", "issue" },      blk_log_generic },
        [__BLK_TA_COMPLETE]     = {{  "C", "complete" },   blk_log_with_error },
        [__BLK_TA_PLUG]         = {{  "P", "plug" },       blk_log_plug },
        [__BLK_TA_UNPLUG_IO]    = {{  "U", "unplug_io" },  blk_log_unplug },
        [__BLK_TA_UNPLUG_TIMER] = {{ "UT", "unplug_timer" }, blk_log_unplug },
        [__BLK_TA_INSERT]       = {{  "I", "insert" },     blk_log_generic },
        [__BLK_TA_SPLIT]        = {{  "X", "split" },      blk_log_split },
        [__BLK_TA_BOUNCE]       = {{  "B", "bounce" },     blk_log_generic },
        [__BLK_TA_REMAP]        = {{  "A", "remap" },      blk_log_remap },

does not have a __BLK_TA_ABORT entry currently - it should have, 
right?

	Ingo
