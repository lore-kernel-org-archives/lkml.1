Return-Path: <linux-kernel-owner+w=401wt.eu-S1764382AbZDCL30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764382AbZDCL30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761863AbZDCL3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:29:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43070 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390AbZDCL3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:29:15 -0400
Date: Fri, 3 Apr 2009 13:29:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 01/18] x86, bts: fix race when bts tracer is removed
Message-ID: <20090403112900.GD31399@elte.hu>
References: <20090402145455.597376000@intel.com> <20090402145702.669790000@intel.com> <20090402184514.GC843@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E9271804B@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E9271804B@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu]
> >Sent: Thursday, April 02, 2009 8:45 PM
> >To: Metzger, Markus T
> >Cc: tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; roland@redhat.com;
> >eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel.com; linux-
> >kernel@vger.kernel.org
> >Subject: Re: [patch 01/18] x86, bts: fix race when bts tracer is removed
> >
> >
> >* markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:
> >
> >> +static inline void ds_take_timestamp(struct ds_context *context,
> >> +				     enum bts_qualifier qualifier,
> >> +				     struct task_struct *task)
> >> +{
> >> +	struct bts_tracer *tracer = context->bts_master;
> >> +	barrier();
> >
> >why the barrier()?
> 
> See http://lkml.org/lkml/2009/3/31/544
> 
> Oleg: "In theory, we need barrier() after reading ->bts_master.
> 
> (actually, I did see the bug reports when the compiler read the pointer
>  twice with the code like above)."

Please convert this piece of non-trivial information into a small 
two-sentence blurb and put it into a comment block.

> >struct bts_struct ts = {
> >	.qualifier		= qualifier,
> >	.variant.event.jiffies	= jiffies_64,
> >	.variant.event.pid	= task->pid
> >};
> >
> >Also, raw use of jiffies_64 is buggy and racy. Why does this use
> >jiffies to begin with - why not some finer grained time?
> 
> What would be a good time to use?

ktime_get() would be the primary candidate. (Or, perhaps, if 
performance is really an issue then trace_clock() or 
trace_clock_global().)

	Ingo
