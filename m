Return-Path: <linux-kernel-owner+w=401wt.eu-S1760434AbZJIJVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760434AbZJIJVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758745AbZJIJVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:21:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:40155 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479AbZJIJVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:21:16 -0400
Subject: Re: select system call's implementation may have some bug, need
 your  help and confirm !!!
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: wu Jianfeng <stormplayer@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <9b2b86520910090052n267f94ebj7619b6c5b94b3539@mail.gmail.com>
References: <a5b3ea7b0910082255x5767726du4721d2ee38df38fa@mail.gmail.com>
	 <9b2b86520910090052n267f94ebj7619b6c5b94b3539@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 11:20:38 +0200
Message-Id: <1255080038.8802.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 08:52 +0100, Alan Jenkins wrote:
> On 10/9/09, wu Jianfeng <stormplayer@gmail.com> wrote:
> > A process may sleep for ever when he call select system call.
> > In detail, if the process was scheduled out just at the point it set
> > its state to TASK_INTERRUPTIBLE.
> >

> > set_current_state(TASK_INTERRUPTIBLE);
> > ## here set the process state TASK_INTERRUPTIBLE
> >
> >  ## if  the process was scheduled out here, then the process will
> > never can be waked up, because it has not been attached to any file 's
> > wait queue.
> 
> I'm not sure about that, but if you look at the current code (e.g. in
> linus' git tree) you will see this code has been changed.  Now
> set_current_state() is only called from poll_schedule_timeout(), and
> it won't suffer from the problem you suggested:
> 
> 
> int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
> 			  ktime_t *expires, unsigned long slack)
> {
> 	int rc = -EINTR;
> 
> 	set_current_state(state);
> 	if (!pwq->triggered)
> 		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
> 	__set_current_state(TASK_RUNNING);

It would still be liable to the problem suggested, if it were real,
which it is not, as Thomas pointed out.

The distinction is between getting preempted and calling schedule().

