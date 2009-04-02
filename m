Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbZDBSps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbZDBSps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbZDBSpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:45:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36565 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZDBSph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:45:37 -0400
Date: Thu, 2 Apr 2009 20:45:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: markus.t.metzger@intel.com
Cc: tglx@linutronix.de, hpa@zytor.com, markus.t.metzger@gmail.com,
       roland@redhat.com, eranian@googlemail.com, oleg@redhat.com,
       juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/18] x86, bts: fix race when bts tracer is removed
Message-ID: <20090402184514.GC843@elte.hu>
References: <20090402145455.597376000@intel.com> <20090402145702.669790000@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402145702.669790000@intel.com>
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


* markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:

> +static inline void ds_take_timestamp(struct ds_context *context,
> +				     enum bts_qualifier qualifier,
> +				     struct task_struct *task)
> +{
> +	struct bts_tracer *tracer = context->bts_master;
> +	barrier();

why the barrier()?

> +
> +	if (tracer && (tracer->flags & BTS_TIMESTAMPS)) {
> +		struct bts_struct ts = {
> +			.qualifier = qualifier,
> +			.variant.timestamp.jiffies = jiffies_64,
> +			.variant.timestamp.pid = task->pid
> +		};
> +		bts_write(tracer, &ts);
> +	}

Why do we have .variant.timestamp.pid ? A PID is not a timestamp. It 
might be .event.jiffies and .event.pid perhaps.

Also, the whole function could be cleaned up by:

 1) returning early if !tracer || !(tracer->flags & BTS_TIMESTAMPS).

 2) Doing a cleaner initialization - something like:

struct bts_struct ts = {
	.qualifier		= qualifier,
	.variant.event.jiffies	= jiffies_64,
	.variant.event.pid	= task->pid
};

Also, raw use of jiffies_64 is buggy and racy. Why does this use 
jiffies to begin with - why not some finer grained time?

	Ingo
