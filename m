Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbYK1Fmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbYK1Fmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 00:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbYK1Fmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 00:42:43 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46533 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYK1Fmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 00:42:42 -0500
Date: Fri, 28 Nov 2008 05:42:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, hch@infradead.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH -v3 7/8] fsnotify: add in inode fsnotify markings
Message-ID: <20081128054241.GJ28946@ZenIV.linux.org.uk>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com> <20081125172128.17115.68117.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125172128.17115.68117.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 12:21:28PM -0500, Eric Paris wrote:

> +void fsnotify_mark_get(struct fsnotify_mark_entry *entry)
> +{
> +	spin_lock(&entry->lock);
> +	entry->refcnt++;
> +	spin_unlock(&entry->lock);
> +}

> +void fsnotify_mark_put(struct fsnotify_mark_entry *entry)
> +{
> +	spin_lock(&entry->lock);
> +	entry->refcnt--;
> +	/* if (!refcnt && killme) we are off both lists and nothing else can find us. */
> +	if ((!entry->refcnt) && (entry->killme)) {
> +		spin_unlock(&entry->lock);
> +		fsnotify_mark_kill(entry);
> +		return;
> +	}
> +	spin_unlock(&entry->lock);
> +}

Uh-huh...  And what happens if fsnotify_mark_get() comes in the middle
of final fsnotify_mark_put()?  You spin on entry->lock, gain it just before
fsnotify_mark_kill() which proceeds to kfree entry under you just as you
increment its refcnt...

> +void fsnotify_clear_mark_group(struct fsnotify_group *group)
> +{
> +	struct fsnotify_mark_entry *entry;
> +	struct inode *inode;
> +
> +	mutex_lock(&group->mark_mutex);
> +	while (!list_empty(&group->mark_entries)) {
> +		entry = list_first_entry(&group->mark_entries, struct fsnotify_mark_entry, g_list);
> +
> +		/* make sure the entry survives until it is off both lists */
> +		fsnotify_mark_get(entry);
> +
> +		/* remove from g_list */
> +		list_del_init(&entry->g_list);
> +		mutex_unlock(&group->mark_mutex);
> +
> +		inode = entry->inode;
> +
> +		spin_lock(&entry->lock);
> +		entry->killme = 1;
> +		spin_unlock(&entry->lock);
> 
> +		/* remove from i_list */
> +		spin_lock(&inode->i_fsnotify_lock);

... and just what would keep the inode from being freed under you here?
