Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYK0QRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYK0QRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYK0QRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:17:13 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:51857 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYK0QRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:17:08 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH -v3 5/8] fsnotify: unified filesystem notification
 backend
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org
In-Reply-To: <20081125172117.17115.4875.stgit@paris.rdu.redhat.com>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172117.17115.4875.stgit@paris.rdu.redhat.com>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 17:17:03 +0100
Message-Id: <1227802623.4454.1759.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 12:21 -0500, Eric Paris wrote:
> +struct fsnotify_group *fsnotify_find_group(unsigned int group_num, unsigned long mask, struct fsnotify_ops *ops)
> +{
> +       struct fsnotify_group *group_iter;
> +       struct fsnotify_group *group = NULL;
> +
> +       mutex_lock(&fsnotify_grp_mutex);
> +       list_for_each_entry_rcu(group_iter, &fsnotify_groups, group_list) {
> +               if (group_iter->group_num == group_num) {
> +                       if ((group_iter->mask == mask) &&
> +                           (group_iter->ops == ops)) {
> +                               fsnotify_get_group(group_iter);
> +                               group = group_iter;
> +                       } else
> +                               group = ERR_PTR(-EEXIST);
> +                       goto out;
> +               }
> +       }
> +
> +       group = kmalloc(sizeof(struct fsnotify_group), GFP_KERNEL);
> +       if (!group) {
> +               group = ERR_PTR(-ENOMEM);
> +               goto out;
> +       }
> +
> +       atomic_set(&group->refcnt, 1);
> +
> +       group->group_num = group_num;
> +       group->mask = mask;
> +
> +       mutex_init(&group->notification_mutex);
> +       INIT_LIST_HEAD(&group->notification_list);
> +       init_waitqueue_head(&group->notification_waitq);
> +
> +       group->ops = ops;
> +
> +       /* add it */
> +       list_add_rcu(&group->group_list, &fsnotify_groups);
> +
> +out:
> +       mutex_unlock(&fsnotify_grp_mutex);
> +       fsnotify_recalc_global_mask();
> +       return group;
> +}

Can't you do a lockless lookup and handle the insertion race?

Also, since it creates the object if its not found, _find_ might not be
the best name, how about obtain?

