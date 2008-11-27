Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYK0QZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYK0QZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYK0QZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:25:14 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:7163 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYK0QZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:25:13 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH -v3 6/8] fsnotify: add group priorities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org
In-Reply-To: <20081125172123.17115.31274.stgit@paris.rdu.redhat.com>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172123.17115.31274.stgit@paris.rdu.redhat.com>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 17:25:09 +0100
Message-Id: <1227803109.4454.1773.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 12:21 -0500, Eric Paris wrote:
> In preperation for blocking fsnotify calls group priorities must be added.
> When multiple groups request the same event type the lowest priority group
> will receive the notification first.

> @@ -114,9 +117,26 @@ struct fsnotify_group *fsnotify_find_group(unsigned int group_num, unsigned long
>  
>  	group->ops = ops;
>  
> -	/* add it */
> -	list_add_rcu(&group->group_list, &fsnotify_groups);
> +	/* Do we need to be the first entry? */
> +	if (list_empty(&fsnotify_groups)) {
> +		list_add_rcu(&group->group_list, &fsnotify_groups);
> +		goto out;
> +	}
> +
> +	list_for_each_entry(group_iter, &fsnotify_groups, group_list) {
> +		/* insert in front of this one? */
> +		if (priority < group_iter->priority) {
> +			/* I used list_add_tail() to insert in front of group_iter...  */
> +			list_add_tail_rcu(&group->group_list, &group_iter->group_list);
> +			break;
> +		}
>  
> +		/* are we at the end?  if so insert at end */
> +		if (list_is_last(&group_iter->group_list, &fsnotify_groups)) {
> +			list_add_tail_rcu(&group->group_list, &fsnotify_groups);
> +			break;
> +		}
> +	}
>  out:
>  	mutex_unlock(&fsnotify_grp_mutex);
>  	fsnotify_recalc_global_mask();

What priority range do you need to cater for, and how many groups? I can
imagine for many groups and limit range a priority list might be better
suited.

