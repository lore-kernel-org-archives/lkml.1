Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbZJNJTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbZJNJTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 05:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbZJNJTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 05:19:11 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:43063 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbZJNJTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 05:19:09 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC v2 PATCH 4/8] sched: Enforce hard limits by throttling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
In-Reply-To: <20091014034122.GA3568@in.ibm.com>
References: <20090930124919.GA19951@in.ibm.com>
	 <20090930125252.GE19951@in.ibm.com> <1255444020.8392.362.camel@twins>
	 <20091014034122.GA3568@in.ibm.com>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 11:17:44 +0200
Message-Id: <1255511864.8392.370.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 09:11 +0530, Bharata B Rao wrote:
> On Tue, Oct 13, 2009 at 04:27:00PM +0200, Peter Zijlstra wrote:
> > On Wed, 2009-09-30 at 18:22 +0530, Bharata B Rao wrote:
> > 
> > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > index 0f1ea4a..77ace43 100644
> > > --- a/include/linux/sched.h
> > > +++ b/include/linux/sched.h
> > > @@ -1024,7 +1024,7 @@ struct sched_domain;
> > >  struct sched_class {
> > >     const struct sched_class *next;
> > >  
> > > -   void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
> > > +   int (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
> > >     void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
> > >     void (*yield_task) (struct rq *rq);
> > >  
> > 
> > I really hate this, it uglfies all the enqueue code in a horrid way
> > (which is most of this patch).
> > 
> > Why can't we simply enqueue the task on a throttled group just like rt?
> 
> We do enqueue a task to its group even if the group is throttled. However such
> throttled groups are not enqueued further. In such scenarios, even though the
> task enqueue to its parent group succeeded, it really didn't add any task to
> the cpu runqueue (rq). So we need to identify this condition and don't
> increment rq->running. That is why this return value is needed.

I would still consider those tasks running, the fact that they don't get
to run is a different matter.

This added return value really utterly craps up the code and I'm not
going to take it.

What I'm not seeing is why all this code looks so very much different
from the rt bits.

