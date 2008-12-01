Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbYLAPWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbYLAPWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 10:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYLAPWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 10:22:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59708 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbYLAPWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 10:22:23 -0500
Subject: Re: [PATCH -v3 6/8] fsnotify: add group priorities
From: Eric Paris <eparis@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org
In-Reply-To: <1227803109.4454.1773.camel@twins>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172123.17115.31274.stgit@paris.rdu.redhat.com>
	 <1227803109.4454.1773.camel@twins>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 10:20:57 -0500
Message-Id: <1228144857.11752.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 17:25 +0100, Peter Zijlstra wrote:
> On Tue, 2008-11-25 at 12:21 -0500, Eric Paris wrote:
> > In preperation for blocking fsnotify calls group priorities must be added.
> > When multiple groups request the same event type the lowest priority group
> > will receive the notification first.
> 
> > @@ -114,9 +117,26 @@ struct fsnotify_group *fsnotify_find_group(unsigned int group_num, unsigned long
> >  
> >  	group->ops = ops;
> >  
> > -	/* add it */
> > -	list_add_rcu(&group->group_list, &fsnotify_groups);
> > +	/* Do we need to be the first entry? */
> > +	if (list_empty(&fsnotify_groups)) {
> > +		list_add_rcu(&group->group_list, &fsnotify_groups);
> > +		goto out;
> > +	}
> > +
> > +	list_for_each_entry(group_iter, &fsnotify_groups, group_list) {
> > +		/* insert in front of this one? */
> > +		if (priority < group_iter->priority) {
> > +			/* I used list_add_tail() to insert in front of group_iter...  */
> > +			list_add_tail_rcu(&group->group_list, &group_iter->group_list);
> > +			break;
> > +		}
> >  
> > +		/* are we at the end?  if so insert at end */
> > +		if (list_is_last(&group_iter->group_list, &fsnotify_groups)) {
> > +			list_add_tail_rcu(&group->group_list, &fsnotify_groups);
> > +			break;
> > +		}
> > +	}
> >  out:
> >  	mutex_unlock(&fsnotify_grp_mutex);
> >  	fsnotify_recalc_global_mask();
> 
> What priority range do you need to cater for, and how many groups? 

On a typical system I'd expect to see one group for dnotify (rpmidmapd
uses dnotify so most systems will end up having 1 group I would expect)

inotify I wouldn't expect more than 3-4 inotify_init() calls

fsnotify I wouldn't imagine more than 3 groups.

So total we are talking about maybe 10 groups on a system really making
use of fs notification?

> I can
> imagine for many groups and limit range a priority list might be better
> suited.

talking about plist.h?  Since I don't allow 2 groups with the same
priority I'd say a lot of the plist code would just be overhead (the
prio list and the node list would be the same)

That's not a big deal since I don't really care about the add/remove
code paths since they are all notification overhead/setup/teardown.  I
would think that cleaner simpler code would probably be a better idea
rather than performance for these areas especially since it looks like
the speed critical parts of plists (list_for_each_entry) would be the
exact same.

what I don't see is plists being protected by RCU and looking at
plist_del it doesn't seem like it would be rcu safe.  RCU safe plists
might be a good idea, but for now I think I should just do my own
priority listing so I don't have to hold a lock while I walk the group
list (that path is VERY hot)

-Eric

