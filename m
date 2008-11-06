Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbYKFUUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbYKFUUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYKFUUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:20:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41615 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYKFUUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:20:10 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, alan@redhat.com, jbaron@redhat.com
Subject: Re: [PATCH] ftrace: add an fsync tracer
References: <20081105094902.27ec4b39@infradead.org>
	<1225976138.7803.4485.camel@twins>
	<20081106060624.58a0f967@infradead.org>
	<1225981141.7803.4577.camel@twins>
	<20081106063108.02b4813d@infradead.org>
	<1225983052.7803.4623.camel@twins>
	<20081106070157.065b2dcc@infradead.org>
	<alpine.DEB.1.10.0811061020311.31011@gandalf.stny.rr.com>
	<20081106094558.50d94bcc@infradead.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 06 Nov 2008 15:19:48 -0500
In-Reply-To: <20081106094558.50d94bcc@infradead.org> (Arjan van de Ven's message of "Thu, 6 Nov 2008 09:45:58 -0800")
Message-ID: <y0mej1ofvyz.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> [...]
> what is the real need is
> 1) Have a trace point in the source
> 2) Associate a "formatting function" with that point 
>    (which basically transforms the trace parameters to, say, a string)
> 3) A way to turn the trace point on/off.

For 1 and 2, it may be worth considering a plain trace_mark() in
do_sync().  The complication that makes this uglier than a one-liner
is d_path()'s buffer and error handling.

    {
    char *buffer = kzalloc (4096, GFP_KERNEL);
    trace_mark(fsync, "Process %s is calling fsync on %s\n",
                       current->comm,
                       ({char *err = d_path (...);
                         IS_ERR(err) ? "?" : err;}));
    kfree (buffer);
    }

With a bit of extension on the marker front, the allocation could be
made conditional on the marker being enabled.


For 3, the kernel could merge a backend that connects arbitrary
markers to an ftrace (or whatever) buffer.  Several compact prototypes
for the latter exist.


- FChE
