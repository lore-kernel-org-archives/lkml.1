Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbZGAFqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbZGAFqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZGAFqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:46:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbZGAFqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:46:44 -0400
Date: Tue, 30 Jun 2009 22:46:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: ffsb create_4k 16% regression
Message-Id: <20090630224639.95722c8e.akpm@linux-foundation.org>
In-Reply-To: <1246426380.2560.473.camel@ymzhang>
References: <1246262818.2560.443.camel@ymzhang>
	<1246426380.2560.473.camel@ymzhang>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Jul 2009 13:33:00 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> On Mon, 2009-06-29 at 16:06 +0800, Zhang, Yanmin wrote:
> > I run many ffsb test cases on JBODs (typically 13/12 disks). Comparing
> > with kernel 2.6.30, 2.6.31-rc1 has about 16% regression with
> > ffsb_create_4k. The sub test case creates files continuously for 10
> > minitues and every file is 1MB.
> > 
> > Bisect located below patch. 
> > 
> > 
> > 5cee5815d1564bbbd505fea86f4550f1efdb5cd0 is first bad commit
> > commit 5cee5815d1564bbbd505fea86f4550f1efdb5cd0
> > Author: Jan Kara <jack@suse.cz>
> > Date:   Mon Apr 27 16:43:51 2009 +0200
> > 
> >     vfs: Make sys_sync() use fsync_super() (version 4)
> >     
> >     It is unnecessarily fragile to have two places (fsync_super() and do_sync())
> >     doing data integrity sync of the filesystem. Alter __fsync_super() to
> >     accommodate needs of both callers and use it. So after this patch
> >     __fsync_super() is the only place where we gather all the calls needed to
> >     properly send all data on a filesystem to disk.
> > 
> > 
> > As a matter of fact, ffsb calls sys_sync in the end to make sure all data is
> > flushed to disks and the flushing is counted into the result. vmstat shows
> > ffsb is blocked when syncing for a long time. With 2.6.30, ffsb is blocked for
> > a short time.
> > 
> > I checked the patch and did experiments to recover the original methods. Eventually,
> > the root cause is the patch deletes the calling to wakeup_pdflush when syncing, so
> > only ffsb is blocked on disk I/O. ___wakeup_pdflush could ask pdflush to write back pages
> > with ffsb at the same time.
> > 
> > Below patch against 2.6.31-rc1 fixes it.
> > 
> > ___Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> > 
> > ---
> > 
> > --- linux-2.6.31-rc1/fs/sync.c	2009-06-29 12:18:03.000000000 +0800
> > +++ linux-2.6.31-rc1_sync/fs/sync.c	2009-06-29 14:56:49.000000000 +0800
> > @@ -114,6 +114,7 @@ restart:
> >  
> >  SYSCALL_DEFINE0(sync)
> >  {
> > +	wakeup_pdflush(0);
> >  	sync_filesystems(0);
> >  	sync_filesystems(1);
> >  	if (unlikely(laptop_mode))
> Andrew,
> 
> Would you like to consider the patch for mm tree?

OK.

But if we're to restore that operation, we should also restore the nice
comment explaining why we are doing it:

-/*
- * sync everything.  Start out by waking pdflush, because that writes back
- * all queues in parallel.
- */
-static void do_sync(unsigned long wait)

I'll take care of that.
