Return-Path: <linux-kernel-owner+w=401wt.eu-S965355AbXBFFx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965355AbXBFFx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 00:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965340AbXBFFx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 00:53:59 -0500
Received: from THUNK.ORG ([69.25.196.29]:46378 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965321AbXBFFx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 00:53:57 -0500
Date: Mon, 5 Feb 2007 22:17:44 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Christoph Hellwig <hch@lst.de>, akpm@osdl.org, haveblue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH[RFC] kill sysrq-u (emergency remount r/o)
Message-ID: <20070206031744.GA11018@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Christoph Hellwig <hch@lst.de>, akpm@osdl.org, haveblue@us.ibm.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070205173247.GA25790@lst.de> <Pine.LNX.4.61.0702052136310.19384@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702052136310.19384@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 09:40:08PM +0100, Jan Engelhardt wrote:
> 
> On Feb 5 2007 18:32, Christoph Hellwig wrote:
> >
> >in two recent discussions (file_list_lock scalability and remount r/o
> >on suspend) I stumbled over this emergency remount feature.  It's not
> >actually useful because it tries a potentially dangerous remount
> >despite writers still beeing in progress, which we can't get rid.
> 
> The current way is to remount things, and return -EROFS to any process
> that attempts to write(). Unless we want to kill processes to get rid of
> them [most likely we possibly won't], I am fine with how things are atm.
> So, what's the "dangerous" part, actually?

The dangerous part is that we change f->f_mode for all open files
without regard for whether there might be any writes underway at the
time.  This isn't *serious* although the results might be a little
strange and it might result in a confused return from write(2).  More
seriously, mark_files_ro() in super.c *only* changes f->f_mode and
doesn't deal with the possibility that the file might be mapped
read-write.  For filesystems that do delayed allocation, I'm not at
all convinced that an emergency read-only will result in the
filesystem doing anything at all sane, depending on what else the
filesystem might do when the filesystem is forced into read-only state.

> sysrq+u is helpful. It is like \( sysrq+s && make sure no further writes
> go to disk \).

I agree it is useful, but if we're going to do it we really should do
it right.  We should have real revoke() functionality on file
descriptors, which revokes all of the mmap()'s (any attempt to write
into a previously read/write mmap will cause a SEGV) as well as
changing f_mode, and then use that to implement emergency read-only
remount.

						- Ted
