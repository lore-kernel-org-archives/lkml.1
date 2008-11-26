Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYKZCB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYKZCB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYKZCBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:01:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44764 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbYKZCBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:01:48 -0500
Subject: Re: [PATCH -v3 0/8] file notification: fsnotify a unified file
 notification backend
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       hch@infradead.org, a.p.zijlstra@chello.nl
In-Reply-To: <20081125161435.f65d6f06.akpm@linux-foundation.org>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125161435.f65d6f06.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 21:00:51 -0500
Message-Id: <1227664851.3320.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-25 at 16:14 -0800, Andrew Morton wrote:
> On Tue, 25 Nov 2008 12:20:51 -0500
> Eric Paris <eparis@redhat.com> wrote:
> 
> > This series only reimplements dnotify using the new fsnotify backend.  If
> > accepted I will do the work to port inotify as well.  Currently struct inode
> > goes from:
> > 
> > #ifdef CONFIG_DNOTIFY
> >        unsigned long           i_dnotify_mask; /* Directory notify events */
> >        struct dnotify_struct   *i_dnotify; /* for directory notifications */
> > #endif
> > 
> > to:
> > #ifdef CONFIG_FSNOTIFY
> >        unsigned long           i_fsnotify_mask; /* all events this inode cares about */
> >        struct list_head        i_fsnotify_mark_entries; /* fsnotify mark entries */
> >        spinlock_t              i_fsnotify_lock; /* protect the entries list */
> > #endif
> > 
> > so the inode still grows, but the inotify fields will be dropped as well
> > resulting in a smaller struct inode.  These are all the fields fanotify will
> > want as well.
> 
> Did you consider using i_lock to protect that list?  Its mandate is "an
> innermost lock which protects fields within the inode".

I didn't really consider it. It absolutely could be used.  Currently
dnotify used the i_lock and inotify uses it's own smaller mutex.  If
people like I can try to run some perf tests between using i_lock and
this smaller lock and would gladly send a patch on top of this set to
drop the i_fsnotify_lock.

> > 29 files changed, 3100 insertions(+), 1977 deletions(-)
> 
> 	if (code > code_reviewers)
> 		fix();
> 
> but how?

patch #1 does nothing but move dnotify and inotify...
14 files changed, 1929 insertions(+), 1925 deletions(-)

So that total number seems worse than it is (but I'll agree that all of
this for no new functionality sucks.  But at least I promise a smaller
inode struct at the end!

