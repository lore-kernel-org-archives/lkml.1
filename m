Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab0BBS1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:27:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49298 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab0BBS1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:27:23 -0500
Date: Tue, 2 Feb 2010 19:26:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, Stephane Eranian <eranian@google.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jamie Iles <jamie.iles@picochip.com>, Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH] perf_events, x86: PEBS support
Message-ID: <20100202182653.GB19320@elte.hu>
References: <1265129772.24455.329.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265129772.24455.329.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Totally uncompiled and untested, but it looks to be about mostly there so I 
> thought I'd post it.
> 
> One of the things that is missing is keeping the count value sane while 
> using PEBS -- another is dealing with auto frequency things, I thought 
> about single shot PEBS assist for that.
> 
> After this we can do something like PERF_SAMPLE_REGS, but for that we need 
> to think about how to expose pt_regs to userspace or something (or maybe it 
> already is, I haven't checked).
> 
> Also, initially I'll go through all the other hw perf implementations 
> (powerpc, sparc, arm, sh) and make then refuse to create attr.precise 
> counters -- precise meaning the reported IP is not influenced by OoO 
> artefacts.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/kernel/cpu/perf_event.c |  354 ++++++++++++++++++++++++++++++++++-----
>  include/linux/perf_event.h       |    4 
>  2 files changed, 314 insertions(+), 44 deletions(-)

Very nice!

> @@ -203,8 +203,9 @@ struct perf_event_attr {
>  				enable_on_exec :  1, /* next exec enables     */
>  				task           :  1, /* trace fork/exit       */
>  				watermark      :  1, /* wakeup_watermark      */
> +				precise        :  1,

I think we want to default to precise events even if not specifically 
requested by user-space, in the cases where that's possible on the CPU 
without additional limitations.

That way people will default to better (and possibly cheaper) PEBS profiling 
on modern Intel CPUs.

	Ingo
