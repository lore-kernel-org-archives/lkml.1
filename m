Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbZGNBri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbZGNBri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 21:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZGNBri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 21:47:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44302 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbZGNBrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 21:47:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Jul 2009 10:45:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Vladislav D. Buzov" <vbuzov@embeddedalley.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Linux memory management list <linux-mm@kvack.org>,
       Dan Malek <dan@embeddedalley.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] Resource usage threshold notification addition to
 res_counter (v3)
Message-Id: <20090714104543.c7e7fe32.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A5BDF5D.8090306@embeddedalley.com>
References: <1246998310-16764-1-git-send-email-vbuzov@embeddedalley.com>
	<1247530581-31416-1-git-send-email-vbuzov@embeddedalley.com>
	<1247530581-31416-2-git-send-email-vbuzov@embeddedalley.com>
	<20090714093022.6e8c1cc0.kamezawa.hiroyu@jp.fujitsu.com>
	<4A5BDF5D.8090306@embeddedalley.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 18:29:01 -0700
"Vladislav D. Buzov" <vbuzov@embeddedalley.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Mon, 13 Jul 2009 17:16:20 -0700
> > Vladislav Buzov <vbuzov@embeddedalley.com> wrote:
> >
> >   
> >> This patch updates the Resource Counter to add a configurable resource usage
> >> threshold notification mechanism.
> >>
> >> Signed-off-by: Vladislav Buzov <vbuzov@embeddedalley.com>
> >> Signed-off-by: Dan Malek <dan@embeddedalley.com>
> >> ---
> >>  Documentation/cgroups/resource_counter.txt |   21 ++++++++-
> >>  include/linux/res_counter.h                |   69 ++++++++++++++++++++++++++++
> >>  kernel/res_counter.c                       |    7 +++
> >>  3 files changed, 95 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/Documentation/cgroups/resource_counter.txt b/Documentation/cgroups/resource_counter.txt
> >> index 95b24d7..1369dff 100644
> >> --- a/Documentation/cgroups/resource_counter.txt
> >> +++ b/Documentation/cgroups/resource_counter.txt
> >> @@ -39,7 +39,20 @@ to work with it.
> >>   	The failcnt stands for "failures counter". This is the number of
> >>  	resource allocation attempts that failed.
> >>  
> >> - c. spinlock_t lock
> >> + e. unsigned long long threshold
> >> +
> >> + 	The resource usage threshold to notify the resouce controller. This is
> >> +	the minimal difference between the resource limit and current usage
> >> +	to fire a notification.
> >> +
> >> + f. void (*threshold_notifier)(struct res_counter *counter)
> >> +
> >> +	The threshold notification callback installed by the resource
> >> +	controller. Called when the usage reaches or exceeds the threshold.
> >> +	Should be fast and not sleep because called when interrupts are
> >> +	disabled.
> >> +
> >>     
> >
> > This interface isn't very useful..hard to use..can't you just return the result as
> > "exceeds threshold" to the callers ?
> >
> > If I was you, I'll add following state to res_counter
> >
> > enum {
> > 	RES_BELOW_THRESH,
> > 	RES_OVER_THRESH,
> > } res_state;
> >
> > struct res_counter {
> > 	.....
> > 	enum	res_state	state;
> > }
> >
> > Then, caller does
> > example)
> > 	prev_state = res->state;
> > 	res_counter_charge(res....)
> > 	if (prev_state != res->state)
> > 		do_xxxxx..
> >
> > notifier under spinlock is not usual interface. And if this is "notifier",
> > something generic, notifier_call_chain should be used rather than original
> > one, IIUC.
> >
> > So, avoiding to use "callback" is a way to go, I think.
> >
> >   
> The reason of having this callback is to support the hierarchy, which
> was the problem in previous implementation you pointed out.
> 
> When a new page charged we want to walk up the hierarchy and find all
> the ancestors exceeding their thresholds and notify them. To avoid
> walking up the hierarchy twice, I've expanded res_counter with "notifier
> callback" called by res_counter_charge() for each res_counter in the
> tree which exceeds the limit.
> 
> In the example above, the hierarchy is not supported. We know only state
> of the res_counter/memcg which current thread belongs to.
> 
How heavy res_coutner can be ? ;) plz don't check at "every charge", use some
filter.

plz discuss with Balbir. His softlimit adds something similar. And I don't think
both are elegant.

I'll consider more (of course, I may not be able to find any..) and rewrite the
whole thing if I have a chance.

Briefly thinking, it's not very bad to have following interface.

==
/*
 * This function is for checking all ancestors's state. Each ancestors are
 * pased to check_function() ony be one until res->parent is not NULL.
 */
void res_counter_callback(struct res_counter *res, int (*check_function)())
{
	do {
		if ((*check_function)(res))
			break;
		res = res->parent;
	} while (res);
}
==
Calling this once per 1000 charges or once per sec will not be very bad. And we can
keep res_counter simple. If you want some trigger, you can add something as
you like.

Thanks,
-Kame

