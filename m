Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbXBPHQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbXBPHQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932293AbXBPHQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:16:20 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34551 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103AbXBPHQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:16:19 -0500
Date: Fri, 16 Feb 2007 12:46:17 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070216071617.GB4527@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214202209.GC301@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214202209.GC301@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 11:22:09PM +0300, Oleg Nesterov wrote:
> > o Splits CPU_DEAD into two events namely
> >   - CPU_DEAD: which will be handled while the processes are still
> >               frozen.
> > 
> >   - CPU_DEAD_KILL_THREADS: To be handled after we thaw_processes.
> 
> 
> Imho, this is not right. This change the meaning of CPU_DEAD, and so
> we should fix all users of CPU_DEAD as well.

Why should we fix all users? Only users who were doing a kthread_stop()
in CPU_DEAD need to be fixed. From my count, only 5 users (out of a
total of 35) need to be fixed to not do kthread_stop in CPU_DEAD.

> 
> How about
> 
> 	CPU_DEAD_WHATEVER
> 		the processes are still frozen
> 
> 	CPU_DEAD
> 		after we thaw_processes
> 
> This way we can add processing of the new CPU_DEAD_WHATEVER event where
> it may help. 

Well, -most- of the work needs to be done in a state when processes are
frozen. The only exception is cleaning up of per-cpu threads (which is
not possible with processes frozen - if we can find a way to make that
possible, then everything can be done in CPU_DEAD).

If we go by the change suggested above, then we need to fix all users of
CPU_DEAD to do what they are doing in CPU_DEAD_WHATEVER (when processes
are frozen). I would rather avoid this invasive change and let
CPU_DEAD be sent with processes frozen still.

> CPU_UP_PREPARE is called after freeze_processes()... Probably this works,
> but imho this is no good. Suppose for a moment that khelper will be frozen
> (yes, yes it can't be), then we can't do kthread_create().

Yes, I am worried about doing so many things with processes frozen.
Maybe time (and more testing) will tell us if this is a bad thing or
not. The only dependency I have found so far is that kthread workqueue needs to
be up (and hence its worker thread needs to be exempted from hotplug
freeze). We should mark kthread workqueue accordingly as not freezable
for hotplug.


-- 
Regards,
vatsa
