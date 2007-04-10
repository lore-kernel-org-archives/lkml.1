Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXDJL1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXDJL1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933075AbXDJL1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:27:52 -0400
Received: from thunk.org ([69.25.196.29]:47615 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255AbXDJL1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:27:51 -0400
Date: Tue, 10 Apr 2007 07:27:18 -0400
From: Theodore Tso <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Eric Sandeen <sandeen@redhat.com>, Phillip Susi <psusi@cfl.rr.com>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add a norecovery option to ext3/4?
Message-ID: <20070410112718.GF13650@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
	Eric Sandeen <sandeen@redhat.com>, Phillip Susi <psusi@cfl.rr.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com> <461A760B.1040103@redhat.com> <20070410072253.GA28665@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070410072253.GA28665@lazybastard.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 09:22:53AM +0200, Jörn Engel wrote:
> > Under all conditions it should be safe to mount a read-only block
> > device, but that is not the same as mounting a filesystem read-only.
> 
> In particular, it is a lame excuse when this claim is true.  If the
> block-device is read-only, then journal replay will not work as expected
> and all the "not so easy" work has to be done anyway.
> 
> Did I miss anything?  Is it actually easier to mount a read-only device
> with unclean journal than mounting a read-write device and not replay
> the journal?

The problem is that ext3 defers writes even more than ext2 did in
order to make journalling (a) possible, and (b) more efficient.  So if
you mount the filesystem read-only without replaying the journal, you
may get incorrect data; you could get data belonging to another user's
file; the kernel could detect filesystem inconsistencies and decide
that the filesystem has errors.  Now, at least in theory the kernel
will not oops when it operates on an arbitrarily corrupted filesystem
(which is what a filesystems whose journal has not been run can look
like), BUT #1, this hasn't been as well tested we would probably like,
and #2, if the filesystem is marked with an errors-behavior of "reboot
on error", then system will reboot, because that's what you asked it
to do!

I suppose what you could do is to read in the journal, and use it to
create an remapping table so that when you want to read block #5126,
and block number 5126 is in the journal, to read the journal version
of the block instead of the one on disk.  That would allow for safe
access to a filesystem being mounted read-only without the journal
being present.

Patches gratefully accepted....

						- Ted
