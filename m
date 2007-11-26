Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbXKZVR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbXKZVR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXKZVRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:17:19 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45957 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751261AbXKZVRS (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:17:18 -0500
Date: Tue, 27 Nov 2007 08:17:05 +1100
From: David Chinner <dgc@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, David Chinner <dgc@sgi.com>,
       xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: freeze vs freezer
Message-ID: <20071126211705.GC119954183@sgi.com>
References: <4744FD87.7010301@goop.org> <200711240047.21624.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711240047.21624.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2007 at 12:47:21AM +0100, Rafael J. Wysocki wrote:
> On Thursday, 22 of November 2007, Jeremy Fitzhardinge wrote:
> > It seems that a process blocked in a write to an xfs filesystem due to
> > xfs_freeze cannot be frozen by the freezer.
> 
> The freezer doesn't handle tasks in TASK_UNINTERRUPTIBLE and I don't know how
> to make it handle them without at least partially defeating its purpose.

So how do you handle threads that are blocked on I/O or a lock during
the system freeze process, then?

> > I see this if I suspend my laptop while doing something xfs-filesystem
> > intensive, like a kernel build.  My suspend scripts freeze the XFS
> > filesystem (as Dave said I should), which presumably blocks some writer,
> > and then the freezer times out and fails to complete.
> > 
> > Here's part of the process dump the freezer does when it times out:
> > 
> > cc1           D 00000000     0 18138  18137
> >        dd5f1e24 00200082 00000002 00000000 ecdeeb00 ecdeec64 c200f280 00000001 
> >        009c09a0 dd5f1e0c dd5f1e0c 0000000f 00000000 00000000 00000000 dd5f1e74 
> >        c7beb480 dd5f1e88 dd5f1ea8 c0228d97 e8889540 dd5f1e38 c015b75d dd5f1e44 
> > Call Trace:
> >  [<c0228d97>] xfs_write+0xf4/0x6d9
> >  [<c0226038>] xfs_file_aio_write+0x53/0x5b
> >  [<c0171c15>] do_sync_write+0xae/0xec
> >  [<c0172343>] vfs_write+0xa4/0x120
> >  [<c01728d7>] sys_write+0x3b/0x60
> >  [<c0106fae>] sysenter_past_esp+0x6b/0xa1
> >  =======================
> > 
> > 
> > I haven't looked at how to fix this yet.  I only just worked out why I
> > was getting suspend failures.
> 
> Well, you can add freezer_do_not_count()/freezer_count() annotations to
> xfs_write() (and whatever else is blocked as a result of the XFS being frozen).

May as well annotate the whole VFS, then, because once the transaction
subsystem is frozen any operation that modifies the filesystem will get
blocked like this.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
