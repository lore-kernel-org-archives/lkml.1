Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbXK0VfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbXK0VfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758761AbXK0VfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:35:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45820 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758757AbXK0VfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:35:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Chinner <dgc@sgi.com>
Subject: Re: XFS related Oops (suspend/resume related)
Date: Tue, 27 Nov 2007 22:53:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       Tino Keitel <tino.keitel@gmx.de>
References: <20071112064706.GA23595@dose.home.local> <200711271651.39180.rjw@sisk.pl> <20071127211155.GK119954183@sgi.com>
In-Reply-To: <20071127211155.GK119954183@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711272253.01136.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 27 of November 2007, David Chinner wrote:
> On Tue, Nov 27, 2007 at 04:51:38PM +0100, Rafael J. Wysocki wrote:
> > On Monday, 26 of November 2007, Rafael J. Wysocki wrote:
> > > On Monday, 26 of November 2007, David Chinner wrote:
> > > > Now there's a message that I haven't seen in about 3 years.
> > > > 
> > > > It indicates that the linux inode connected to the xfs_inode is not
> > > > the correct one. i.e. that the linux inode cache is out of step with
> > > > the XFS inode cache.
> > > > 
> > > > Basically, that is not supposed to happen. I suspect that the way
> > > > threads are frozen is resulting in an inode lookup racing with
> > > > a reclaim. The reclaim thread gets stopped after any use threads,
> > > > and so we could have the situation that a process blocked in lookup
> > > > has the XFS inode reclaimed and reused before it gets unblocked.
> > > > 
> > > > The question is why is it happening now when none of that code in
> > > > XFS has changed?
> > > > 
> > > > Rafael, when are threads frozen? Only when they schedule or call
> > > > try_to_freeze()?
> > > 
> > > Kernel threads freeze only when they call try_to_freeze().  User space tasks
> > > freeze while executing the signals handling code.
> > > 
> > > > Did the freezer mechanism change in 2.6.23 (this is on 2.6.23.1)?
> > > 
> > > Yes.  Kernel threads are not sent fake signals by the freezer any more.
> > 
> > Ah, sorry, this change has been merged after 2.6.23.  However, before 2.6.23
> > we had another important change that caused all kernel threads to have
> > PF_NOFREEZE set by default, unless they call set_freezable() explicitly.
> 
> So try_to_freeze() will never freeze a thread if it has not been
> set_freezable()? And xfsbufd will never be frozen?

No, it won't.

I must have overlooked it, probably because it calls refrigerator() directly
and not try_to_freeze() ...

I think something like the appended patch will help, then.

Greetings,
Rafael


---
Fix breakage caused by commit 831441862956fffa17b9801db37e6ea1650b0f69
that did not introduce the necessary call to set_freezable() in
xfs/linux-2.6/xfs_buf.c .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
@@ -1750,6 +1750,8 @@ xfsbufd(
 
 	current->flags |= PF_MEMALLOC;
 
+	set_freezable();
+
 	do {
 		if (unlikely(freezing(current))) {
 			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
