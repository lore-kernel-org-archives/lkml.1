Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610Ab0ARMHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0ARMHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575Ab0ARMHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:07:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab0ARMHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:07:08 -0500
Subject: Re: [PATCH 39/40] gfs2: use workqueue instead of slow-work
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <4B5444FD.4050500@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	 <1263776272-382-40-git-send-email-tj@kernel.org>
	 <1263807959.2715.4.camel@localhost>  <4B5444FD.4050500@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 18 Jan 2010 12:07:27 +0000
Message-ID: <1263816447.2715.45.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2010-01-18 at 20:24 +0900, Tejun Heo wrote:
> On 01/18/2010 06:45 PM, Steven Whitehouse wrote:
> > Hi,
> > 
> > On Mon, 2010-01-18 at 09:57 +0900, Tejun Heo wrote:
> >> Workqueue can now handle high concurrency.  Use system_long_wq instead
> >> of slow-work.
> >>
> >> Signed-off-by: Tejun Heo <tj@kernel.org>
> >> Cc: Steven Whitehouse <swhiteho@redhat.com>
> > 
> > Acked-by: Steven Whitehouse <swhiteho@redhat.com> on two conditions:
> > 
> >  i) That scheduling work on this new workqueue will not require any
> > GFP_KERNEL allocations (even hidden ones such as starting new threads)
> > before the work runs. This is required since the recovery code must not
> > call into the fs until after its recovered.
> 
> Oh, if that's the case, it needs its own wq with a rescuer.  I thought
> the recovery path wasn't invoked during allocation.  slow-work didn't
> guarantee such thing either.  Anyways, changing that is pretty easy.
> 
> Thanks.
> 

Hmm, I thought I'd checked slow work pretty carefully before I decided
to use it :( Looking at it though, its pretty unlikely that it would
cause a problem. We can be 100% safe by just increasing the number of
slow work threads to one per mounted gfs2 fs (assuming no other slow
work users).

Even then it starts new threads by scheduling slow work and thus it
looks like recovery would run before the slow work to start a new
thread, so its much less likely to cause a problem than if the new
thread was started before the slow work item was executed. We haven't
seen a problem during testing so far.

Anyway, if its easy to solve that problem in the new code, thats all
good :-) Thanks for pointing out this issue,

Steve.


