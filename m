Return-Path: <linux-kernel-owner+w=401wt.eu-S935935AbZAPPB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935935AbZAPPB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760759AbZAPPBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:01:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46656 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760526AbZAPPBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:01:47 -0500
Subject: Re: [patch 4/5] x86, ftrace, hw-branch-tracer: reset trace on close
From: Steven Rostedt <srostedt@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com
In-Reply-To: <20090116120153.A30291@sedona.ch.intel.com>
References: <20090116120153.A30291@sedona.ch.intel.com>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 16 Jan 2009 10:01:30 -0500
Message-Id: <1232118090.21980.85.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-01-16 at 12:01 +0100, Markus Metzger wrote:
> Reset the ftrace buffer on close. Since we use cyclic buffers to store
> the trace, the trace is not contiguous, anyway. This behaviour should
> be more natural.

So you want multiple reads of /debug/tracing/trace to return different
output? Kind of like the trace_pipe? But trace_pipe is a real consumer.

> 
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
> ---
> 
> Index: ftrace/kernel/trace/trace_hw_branches.c
> ===================================================================
> --- ftrace.orig/kernel/trace/trace_hw_branches.c	2009-01-14 15:26:11.000000000 +0100
> +++ ftrace/kernel/trace/trace_hw_branches.c	2009-01-14 15:26:16.000000000 +0100
> @@ -272,6 +272,11 @@
>  	mutex_unlock(&bts_tracer_mutex);
>  }
>  
> +static void trace_bts_close(struct trace_iterator *iter)
> +{
> +	tracing_reset_online_cpus(iter->tr);
> +}
> +
>  void trace_hw_branch_oops(void)
>  {
>  	mutex_lock(&bts_tracer_mutex);
> @@ -290,7 +295,8 @@

BTW, can you run your diff with the -p option. This will help in knowing
which function the change is in. There's some hunks where it is
ambiguous. If you use quilt, you can add:

  QUILT_DIFF_OPTS='-p'

to you .quiltrc file.

-- Steve



>  	.print_line	= bts_trace_print_line,
>  	.start		= bts_trace_start,
>  	.stop		= bts_trace_stop,
> -	.open		= trace_bts_prepare
> +	.open		= trace_bts_prepare,
> +	.close		= trace_bts_close
>  };
>  
>  __init static int init_bts_trace(void)
> ---------------------------------------------------------------------
> Intel GmbH
> Dornacher Strasse 1
> 85622 Feldkirchen/Muenchen Germany
> Sitz der Gesellschaft: Feldkirchen bei Muenchen
> Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
> Registergericht: Muenchen HRB 47456 Ust.-IdNr.
> VAT Registration No.: DE129385895
> Citibank Frankfurt (BLZ 502 109 00) 600119052
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
> 

