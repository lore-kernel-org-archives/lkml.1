Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYKFHxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYKFHxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYKFHxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:53:16 -0500
Received: from viefep20-int.chello.at ([62.179.121.40]:47799 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbYKFHxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:53:15 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] Inline double_unlock_balance()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sripathi Kodi <sripathik@in.ibm.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20081106073214.GA8459@elte.hu>
References: <200811051857.14944.sripathik@in.ibm.com>
	 <1225893576.7803.3021.camel@twins>  <20081106073214.GA8459@elte.hu>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 08:53:44 +0100
Message-Id: <1225958024.7803.4105.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-06 at 08:32 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Wed, 2008-11-05 at 18:57 +0530, Sripathi Kodi wrote:
> > > Hi,
> > > 
> > > We have a test case which measures the variation in the amount of time 
> > > needed to perform a fixed amount of work on the preempt_rt kernel. We 
> > > started seeing deterioration in it's performance recently. The test 
> > > should never take more than 10 microseconds, but we started 5-10% 
> > > failure rate. Using elimination method, we traced the problem to commit 
> > > 1b12bbc747560ea68bcc132c3d05699e52271da0 (lockdep: re-annotate 
> > > scheduler runqueues). When LOCKDEP is disabled, this patch only adds an 
> > > additional function call to double_unlock_balance(). Hence I inlined 
> > > double_unlock_balance() and the problem went away. Here is a patch to 
> > > make this change.
> > > 
> > > Thanks,
> > > Sripathi.
> > > 
> > > lockdep: Inline double_unlock_balance()
> > > 
> > > Additional function call for double_unlock_balance() causes latency 
> > > problems for some test cases on the preempt_rt kernel.
> > > 
> > > Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>
> > 
> > Acked-by; Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> hm, i'm not sure why it makes such a difference. Possibly cache 
> alignment or code generation details pushing the critical path just 
> beyond the L1 cache limit and causing thrashing?
> 
> Anyway, i've applied it to tip/sched/rt, as we generally want to 
> inline such short locking ops.

I'm thinking sripathi's gcc had a massive brainfart and did something
funny, maybe the extra register pressure from the calling convention
messed it up.

He failed to quantify the exact benefit, ie scheduling cost/latency
before and after and what platform. But still the patch is simple
enough.

