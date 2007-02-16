Return-Path: <linux-kernel-owner+w=401wt.eu-S1945966AbXBPQHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945966AbXBPQHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945969AbXBPQHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:07:45 -0500
Received: from mail.screens.ru ([213.234.233.54]:59000 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945965AbXBPQHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:07:40 -0500
Date: Fri, 16 Feb 2007 19:06:40 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070216160640.GD83@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214202209.GC301@tv-sign.ru> <20070216071617.GB4527@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216071617.GB4527@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Srivatsa Vaddagiri wrote:
>
> On Wed, Feb 14, 2007 at 11:22:09PM +0300, Oleg Nesterov wrote:
> > > o Splits CPU_DEAD into two events namely
> > >   - CPU_DEAD: which will be handled while the processes are still
> > >               frozen.
> > > 
> > >   - CPU_DEAD_KILL_THREADS: To be handled after we thaw_processes.
> > 
> > 
> > Imho, this is not right. This change the meaning of CPU_DEAD, and so
> > we should fix all users of CPU_DEAD as well.
> 
> Why should we fix all users? Only users who were doing a kthread_stop()
> in CPU_DEAD need to be fixed. From my count, only 5 users (out of a
> total of 35) need to be fixed to not do kthread_stop in CPU_DEAD.

But still we need to fix or at least check them,

> > How about
> > 
> > 	CPU_DEAD_WHATEVER
> > 		the processes are still frozen
> > 
> > 	CPU_DEAD
> > 		after we thaw_processes
> > 
> > This way we can add processing of the new CPU_DEAD_WHATEVER event where
> > it may help. 
> 
> Well, -most- of the work needs to be done in a state when processes are
> frozen. The only exception is cleaning up of per-cpu threads (which is
> not possible with processes frozen - if we can find a way to make that
> possible, then everything can be done in CPU_DEAD).
> 
> If we go by the change suggested above, then we need to fix all users of
> CPU_DEAD

Sorry, I can't understand you.

This patch adds the new state, why should we fix all users of CPU_DEAD
if they were correct? CPU_DEAD retains its old meaning, all users should
work as before?

>           to do what they are doing in CPU_DEAD_WHATEVER (when processes
> are frozen).

We don't have such users! because we don't have CPU_DEAD_WHATEVER yet.

IOW: I think this new state should have a new name, CPU_DEAD should continue
to be called as a last step. Then we can teach cpu callback's to to take an
advantage of CPU_DEAD_WHATEVER, and we can do this in a separate patches.

No?

> > CPU_UP_PREPARE is called after freeze_processes()... Probably this works,
> > but imho this is no good. Suppose for a moment that khelper will be frozen
> > (yes, yes it can't be), then we can't do kthread_create().
> 
> Yes, I am worried about doing so many things with processes frozen.
> Maybe time (and more testing) will tell us if this is a bad thing or
> not. The only dependency I have found so far is that kthread workqueue needs to
> be up (and hence its worker thread needs to be exempted from hotplug
> freeze). We should mark kthread workqueue accordingly as not freezable
> for hotplug.

Yes, this is what I was talking about.

Oleg.

