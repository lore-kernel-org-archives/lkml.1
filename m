Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYK0QVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYK0QVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYK0QVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:21:04 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:63494 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYK0QVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:21:03 -0500
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
Date: Thu, 27 Nov 2008 17:20:49 +0100
Message-Id: <1227802849.4454.1765.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 12:21 -0500, Eric Paris wrote:
> +int fsnotify_check_notif_queue(struct fsnotify_group *group)
> +{
> +       mutex_lock(&group->notification_mutex);
> +       if (!list_empty(&group->notification_list))
> +               return 1;
> +       mutex_unlock(&group->notification_mutex);
> +       return 0;
> +}

> +void fsnotify_clear_notif(struct fsnotify_group *group)
> +{
> +       struct fsnotify_event *event;
> +
> +       while (fsnotify_check_notif_queue(group)) {
> +               event = get_event_from_notif(group);
> +               fsnotify_put_event(event);
> +               /* fsnotify_check_notif_queue() took this lock */
> +               mutex_unlock(&group->notification_mutex);
> +       }
> +}

That is quite horrible, please just open code that to keep the locking
symmetric.

