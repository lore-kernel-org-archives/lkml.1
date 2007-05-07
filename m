Return-Path: <linux-kernel-owner+w=401wt.eu-S934120AbXEGO1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120AbXEGO1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934090AbXEGO1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:27:43 -0400
Received: from THUNK.ORG ([69.25.196.29]:55527 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934084AbXEGO1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:27:42 -0400
Date: Mon, 7 May 2007 10:27:36 -0400
From: Theodore Tso <tytso@mit.edu>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: JBD: ext2online wants too many credits (744 > 256)
Message-ID: <20070507142736.GC17180@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Frank van Maarseveen <frankvm@frankvm.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20070506222626.GA25632@janus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070506222626.GA25632@janus>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 12:26:26AM +0200, Frank van Maarseveen wrote:
> 2.6.20.6, FC4:
> 
> |JBD: ext2online wants too many credits (744 > 256)

You would be better off using resize2fs from e2fsprogs 1.39, BTW....

About the only reason to keep using the ext2resize packages is
ext2prepare, which is the off-line tool to add a resizing inode after
the fact, and the main reason that functionality hasn't been absorbed
into e2fsprogs is that it needs to be completely rewritten before I'm
willing to trust and maintain it...

> What is the limitation I should be aware of? Has it something to do with
> the journal log size?

Yes, the problem is the journal log size.  Since the original
filesystem was so small, the journal was kept small so as not to use a
huge percentage of the filesystem size.  Of course, with a larger
filesystem you probably want a larger journal anyway to get better
performance.  So that brings up a related problem, which is we don't
have a way of dynamically increasing the size of the journal, which we
probably would want to do as part of resizing the filesystem size.

So the short-term workaround for now, if you know that you're going to
take a filesystem which is 22M and increase it to 3G, is to create it
with largish journal in the first place:

	mke2fs -j -b 4096 -J size=16M /dev/vol1/project 22812

Note that if you were creating a 3G filesystem from scratch, by
default it would be using a 128M journal --- but it's a little hard to
fit a 128M journal in a 22M filesystem.  :-/

We're going to have to rethink the defaults of the journal size as it
relates to on-line resizing, but there might not be a lot of great
answers here.  We'll also have to look at the on-line resizing code
and see if there's a way to break up the resize operation into smaller
transactions as a way of avoiding this problem --- but that would
still leave the user stuck with a pathetically small 4M journal on a
3G filesystem.

						- Ted
