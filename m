Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbYK1XoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbYK1XoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 18:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYK1XoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 18:44:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46051 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbYK1Xn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 18:43:59 -0500
Subject: Re: [PATCH -v3 7/8] fsnotify: add in inode fsnotify markings
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, hch@infradead.org, a.p.zijlstra@chello.nl
In-Reply-To: <20081128054241.GJ28946@ZenIV.linux.org.uk>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172128.17115.68117.stgit@paris.rdu.redhat.com>
	 <20081128054241.GJ28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 28 Nov 2008 18:43:06 -0500
Message-Id: <1227915786.3393.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-28 at 05:42 +0000, Al Viro wrote:
> On Tue, Nov 25, 2008 at 12:21:28PM -0500, Eric Paris wrote:
> 
> > +void fsnotify_mark_get(struct fsnotify_mark_entry *entry)
> > +{
> > +	spin_lock(&entry->lock);
> > +	entry->refcnt++;
> > +	spin_unlock(&entry->lock);
> > +}
> 
> > +void fsnotify_mark_put(struct fsnotify_mark_entry *entry)
> > +{
> > +	spin_lock(&entry->lock);
> > +	entry->refcnt--;
> > +	/* if (!refcnt && killme) we are off both lists and nothing else can find us. */
> > +	if ((!entry->refcnt) && (entry->killme)) {
> > +		spin_unlock(&entry->lock);
> > +		fsnotify_mark_kill(entry);
> > +		return;
> > +	}
> > +	spin_unlock(&entry->lock);
> > +}
> 
> Uh-huh...  And what happens if fsnotify_mark_get() comes in the middle
> of final fsnotify_mark_put()?  You spin on entry->lock, gain it just before
> fsnotify_mark_kill() which proceeds to kfree entry under you just as you
> increment its refcnt...

fsnotify_mark_get() can only find this object through either the
entry->i_list or entry->g_list.  When we drop our ref to 0 and hold the
spinlock we know that no other task would have been able to find us on
those lists (everything that searches the i_list holds the
i_fsnotify_lock and that lock was dropped since we cleared ourselves
from that list and the same is true for the lock on the g_list side)

So if kill_me is set and the refcnt == 0 we are not on either list and
no other task could find this to try to call mark_get().   I'll review
it to make sure, but the design is that we are safe since nothing else
can find us to increment the ref cnt.
> 
> > +void fsnotify_clear_mark_group(struct fsnotify_group *group)
> > +{
> > +	struct fsnotify_mark_entry *entry;
> > +	struct inode *inode;
> > +
> > +	mutex_lock(&group->mark_mutex);
> > +	while (!list_empty(&group->mark_entries)) {
> > +		entry = list_first_entry(&group->mark_entries, struct fsnotify_mark_entry, g_list);
> > +
> > +		/* make sure the entry survives until it is off both lists */
> > +		fsnotify_mark_get(entry);
> > +
> > +		/* remove from g_list */
> > +		list_del_init(&entry->g_list);
> > +		mutex_unlock(&group->mark_mutex);
> > +
> > +		inode = entry->inode;
> > +
> > +		spin_lock(&entry->lock);
> > +		entry->killme = 1;
> > +		spin_unlock(&entry->lock);
> > 
> > +		/* remove from i_list */
> > +		spin_lock(&inode->i_fsnotify_lock);
> 
> ... and just what would keep the inode from being freed under you here?

I'll review.

