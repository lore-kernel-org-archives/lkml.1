Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbYK1Xh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbYK1Xh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 18:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYK1Xht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 18:37:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51199 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbYK1Xht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 18:37:49 -0500
Subject: Re: [PATCH -v3 8/8] dnotify: reimplement dnotify using fsnotify
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, hch@infradead.org, a.p.zijlstra@chello.nl
In-Reply-To: <20081128051443.GH28946@ZenIV.linux.org.uk>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
	 <20081125172133.17115.96807.stgit@paris.rdu.redhat.com>
	 <20081128051443.GH28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Fri, 28 Nov 2008 18:37:32 -0500
Message-Id: <1227915452.3393.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-28 at 05:14 +0000, Al Viro wrote:
> On Tue, Nov 25, 2008 at 12:21:33PM -0500, Eric Paris wrote:
> 
> > +	.mark_clear_inode = clear_mark_dir_notify,
> 
> ... called under a spinlock
> 
> > +static void clear_mark_dir_notify(struct fsnotify_mark_entry *entry, struct inode *inode, unsigned long mask __attribute__ ((unused)), unsigned int flags)
> > +{
> ...
> > +	fsnotify_put_group(dnotify_group);
> 
> ... which grabs a mutex.

You're right, I should drop and retake the spinlock.  But in reality I
shouldn't ever get here and plan to replace all of this code with a
BUG() rather than the WARN() I have today since I know I can safely
recover.

> Incidentally, why the hell do you bother with refcounting on groups here?
> dnotify is not something that's going to be unloaded, for fsck sake...

Well, I do unregister dnotify if you stop watching any files.  I also
plan to implement inotify as one inotify_init() per group.  And fsnotify
groups exist only as long as there is a fsnotify socket bound....

-Eric

