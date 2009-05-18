Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZERIgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZERIgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZERIgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:36:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51537 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZERIgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:36:01 -0400
Date: Mon, 18 May 2009 10:35:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] convert block trace points to TRACE_EVENT()
Message-ID: <20090518083539.GC10687@elte.hu>
References: <4A0BB813.9080807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0BB813.9080807@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> TRACE_EVENT is a more generic way to define tracepoints. Doing so adds
> these new capabilities to this tracepoint:
> 
>   - zero-copy and per-cpu splice() tracing
>   - binary tracing without printf overhead
>   - structured logging records exposed under /debug/tracing/events
>   - trace events embedded in function tracer output and other plugins
>   - user-defined, per tracepoint filter expressions
>   ...

Nice!

> Cons and problems:
> 
>   - no dev_t info for the output of plug, unplug_timer and unplug_io events.
>     no dev_t info for getrq and sleeprq events if bio == NULL.
>     no dev_t info for rq_abort,...,rq_requeue events if rq->rq_disk == NULL.

Cannot we output the numeric major:minor pairs?

>   - for large packet commands, only 16 bytes of the command will be output.
>     Because TRACE_EVENT doesn't support dynamic-sized arrays, though it
>     supports dynamic-sized strings.
>
>   - a packet command is converted to a string in TP_assign, not TP_print.
>     While blktrace do the convertion just before output.

Couldnt we do a memcpy instead of the snprintf() in __dump_pdu()? We 
dont actually interpret the bytes there. We could extend the 
in-kernel printk format with a 'dump raw memory in hex' type of 
format specifier.

OTOH, packet requests are rather rare, right? So going to ASCII 
there results in a simpler interface. In the !blk_pc_request(rq) 
common case we just return early without any snprintf overhead.

>   - in blktrace, an event can have 2 different print formats, but 
>     a TRACE_EVENT has a unique format. (see the output of getrq 
>     and rq_insert)

Is this a problem?

I think a good way forward would be to benchmark the ioctl versus 
the splice based TRACE_EVENT tracing (via some artificially high 
rate event, to push things), and see where we are right now in terms 
of overhead.

	Ingo
