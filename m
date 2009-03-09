Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbZCIHJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbZCIHJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 03:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZCIHIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 03:08:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37204 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZCIHIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 03:08:39 -0400
Date: Mon, 9 Mar 2009 08:08:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [TIP,BISECTED] Negative nice values have become big positive
	numbers
Message-ID: <20090309070824.GA9516@elte.hu>
References: <20090308231850.GB24445@silver.sucs.org> <alpine.DEB.2.00.0903081944470.2203@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903081944470.2203@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sun, 8 Mar 2009, Sitsofe Wheeler wrote:
> 
> > (Forgot to cc lkml. Resending...)
> > 
> > Formally negative nice values have started become very big in positive
> > integers in -tip kernels:
> > 
> >     2 root      15 2147483647     0    0    0 S  0.0  0.0   0:00.00 kthreadd    
> 
> Is this the output of top?

seems so.

> > I've just finished bisecting down to this commit:
> > 
> > commit 1427cdf0592368bdec57276edaf714040ee8744f
> > Author: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Date:   Fri Mar 6 17:21:47 2009 +0100
> 
> $ git show 1427cdf0592368bdec57276edaf714040ee8744f  | diffstat
>  include/linux/ftrace.h       |    3 +
>  kernel/trace/Kconfig         |    6 ++
>  kernel/trace/Makefile        |    1 
>  kernel/trace/trace.c         |   56 +++++++++++++++++++++++++++
>  kernel/trace/trace.h         |   12 +++++
>  kernel/trace/trace_bprintk.c |   87 
> +++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_output.c  |   75 +++++++++++++++++++++++++++++++++++++
>  7 files changed, 240 insertions(+)
> 
> I find it hard to believe that this would cause normal nice 
> values to be messed up. The only file that could could come 
> close to messing with nice values in top is ftrace.h:

Correct - maybe it's these two nearby commits that cause the 
problems:

 fef20d9: vsprintf: unify the format decoding layer for its 3 users
 4370aa4: vsprintf: add binary printf

they do affect generic code. If we broke vsnprintf (which the 
nice value output code uses) then that might be a plausible 
explanation.

	Ingo
