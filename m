Return-Path: <linux-kernel-owner+w=401wt.eu-S1765621AbZDHSAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765621AbZDHSAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbZDHR7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:59:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35062 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbZDHR7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:59:50 -0400
Date: Wed, 8 Apr 2009 19:58:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.29] Fix for enabling branch profiling makes sparse
	unusable
Message-ID: <20090408175850.GA1158@elte.hu>
References: <200904051620.02311.bart.vanassche@gmail.com> <e2e108260904081029u621e46bbmc95cff280f70085c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2e108260904081029u621e46bbmc95cff280f70085c@mail.gmail.com>
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


* Bart Van Assche <bart.vanassche@gmail.com> wrote:

> On Sun, Apr 5, 2009 at 4:20 PM, Bart Van Assche
> <bart.vanassche@gmail.com> wrote:
> > One of the changes between kernels 2.6.28 and 2.6.29 is that a branch profiler
> > has been added for if() statements. Unfortunately this patch makes the sparse
> > output unusable with CONFIG_TRACE_BRANCH_PROFILING=y: when branch profiling is
> > enabled, sparse prints so much false positives that the real issues are no
> > longer visible. This behavior can be reproduced as follows:
> > * enable CONFIG_TRACE_BRANCH_PROFILING, e.g. by running make allyesconfig or
> >  make allmodconfig.
> > * run make C=2
> >
> > Result: a huge number of the following sparse warnings.
> > ...
> > include/linux/cpumask.h:547:2: warning: symbol '______r' shadows an earlier one
> > include/linux/cpumask.h:547:2: originally declared here
> > ...
> >
> > The patch below fixes this by disabling branch profiling while analyzing the
> > kernel code with sparse.
> >
> > See also:
> > * http://lkml.org/lkml/2008/11/21/18
> > * http://bugzilla.kernel.org/show_bug.cgi?id=12925
> >
> > Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
> >
> > --- orig/linux-2.6.29/include/linux/compiler.h  2009-03-23 19:12:14.000000000 -0400
> > +++ linux-2.6.29/include/linux/compiler.h       2009-03-24 08:46:46.000000000 -0400
> > @@ -75,7 +75,8 @@ struct ftrace_branch_data {
> >  * Note: DISABLE_BRANCH_PROFILING can be used by special lowlevel code
> >  * to disable branch tracing on a per file basis.
> >  */
> > -#if defined(CONFIG_TRACE_BRANCH_PROFILING) && !defined(DISABLE_BRANCH_PROFILING)
> > +#if defined(CONFIG_TRACE_BRANCH_PROFILING) \
> > +    && !defined(DISABLE_BRANCH_PROFILING) && !defined(__CHECKER__)
> >  void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
> >
> >  #define likely_notrace(x)      __builtin_expect(!!(x), 1)
> 
> (ping)
> 
> Hello,
> 
> Is there any chance the above patch will get included in the 2.6.30 kernel ?

it already is part of .30-rc1, see 
d9ad8bc0ca823705413f75b50c442a88cc518b35.

	Ingo
