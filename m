Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbYKXIc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbYKXIc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbYKXIcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:32:20 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:61738 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbYKXIcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:32:20 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] sched: Don't allow priority switch to realtime when
 the task doesn't belong to init_task_group and when CONFIG_RT_GROUP_SCHED
 isn't set
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval@linux.vnet.ibm.com>
In-Reply-To: <20081124035807.GA3278@in.ibm.com>
References: <20081120061854.GA4349@in.ibm.com>
	 <1227402676.7685.19942.camel@twins>  <20081124035807.GA3278@in.ibm.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 09:32:06 +0100
Message-Id: <1227515526.7685.21861.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 09:28 +0530, Bharata B Rao wrote:
> On Sun, Nov 23, 2008 at 02:11:16AM +0100, Peter Zijlstra wrote:
> > On Thu, 2008-11-20 at 11:48 +0530, Bharata B Rao wrote:
> > > Applies on 2.6.28-rc5.
> > > 
> > > With CONFIG_RT_GROUP_SCHED not set, don't allow a task's priority switch
> > > to realtime if the task isn't part of init_task_group.
> > > 
> > > A task belonging to a fair group could use sched_setscheduler/sched_setparam
> > > to become a realtime task. If such a task belongs to one of the
> > > child groups of init_task_group and if CONFIG_RT_GROUP_SCHED is not set,
> > > then it ends up getting queued in init_task_group's runqueue.
> > > So we have a situation where, a task belongs to one group (child)
> > > but ends in the runqueue of another group (init_task_group).
> > > This does not look correct.
> > > 
> > > Fix this by failing such priority change requests in sched_setscheduler()
> > > and sched_setparam().
> > 
> > NAK
> > 
> > !RT_GROUP means the RT tasks should be fully invariant to any grouping
> > configuration. This patch breaks that.
> > 
> > Furthermore your justification for this is plain wrong, you write as if
> > an RT tasks can belong to any grouping (in the !RT_GROUP case), by the
> 
> Hmm... but that's I the impression I got when I started an RT
> task in a subgroup and saw it listed in the tasks list of the cgroup.
> So if RT tasks don't care about grouping (!RT_GROUP_SCHED), may be then
> such tasks shoudn't be shown in the cgroup tasks list.

Sure, do as you like upon the cgroup interface

>  And may be as Ingo
> suggested they should be moved to init_task_group.

Bzzt, wrong! They should not be moved to any group, they cannot be moved
to any group, as they are group invariant.

>  Without that it makes one
> think that a task is contributing to the cpu time of a group in which
> it was started, but it in reality it is not.

Until one thinks more and realizes RT tasks don't contribute anything to
groups as they are not part of them.

