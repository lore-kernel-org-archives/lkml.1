Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYKFHci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYKFHci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYKFHca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:32:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57977 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYKFHca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:32:30 -0500
Date: Thu, 6 Nov 2008 08:32:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sripathi Kodi <sripathik@in.ibm.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Inline double_unlock_balance()
Message-ID: <20081106073214.GA8459@elte.hu>
References: <200811051857.14944.sripathik@in.ibm.com> <1225893576.7803.3021.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225893576.7803.3021.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2008-11-05 at 18:57 +0530, Sripathi Kodi wrote:
> > Hi,
> > 
> > We have a test case which measures the variation in the amount of time 
> > needed to perform a fixed amount of work on the preempt_rt kernel. We 
> > started seeing deterioration in it's performance recently. The test 
> > should never take more than 10 microseconds, but we started 5-10% 
> > failure rate. Using elimination method, we traced the problem to commit 
> > 1b12bbc747560ea68bcc132c3d05699e52271da0 (lockdep: re-annotate 
> > scheduler runqueues). When LOCKDEP is disabled, this patch only adds an 
> > additional function call to double_unlock_balance(). Hence I inlined 
> > double_unlock_balance() and the problem went away. Here is a patch to 
> > make this change.
> > 
> > Thanks,
> > Sripathi.
> > 
> > lockdep: Inline double_unlock_balance()
> > 
> > Additional function call for double_unlock_balance() causes latency 
> > problems for some test cases on the preempt_rt kernel.
> > 
> > Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>
> 
> Acked-by; Peter Zijlstra <a.p.zijlstra@chello.nl>

hm, i'm not sure why it makes such a difference. Possibly cache 
alignment or code generation details pushing the critical path just 
beyond the L1 cache limit and causing thrashing?

Anyway, i've applied it to tip/sched/rt, as we generally want to 
inline such short locking ops.

	Ingo
