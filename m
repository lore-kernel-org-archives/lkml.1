Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZDUAZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZDUAZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 20:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZDUAZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 20:25:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56166 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbZDUAZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 20:25:12 -0400
Date: Tue, 21 Apr 2009 01:25:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michal Simek <michal.simek@petalogix.com>
Cc: Nate Straz <nate-ltp@refried.org>, subrata@linux.vnet.ibm.com,
       ltp-list@lists.sourceforge.net,
       John Williams <john.williams@petalogix.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [LTP] statvfs -> f_bavail
Message-ID: <20090421002503.GA8633@ZenIV.linux.org.uk>
References: <49E759FB.70103@petalogix.com> <49E847FB.1030801@petalogix.com> <20090417173107.GA3590@refried.org> <49EC1352.6010900@petalogix.com> <20090420062642.GY26366@ZenIV.linux.org.uk> <49EC1945.1000805@petalogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC1945.1000805@petalogix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 08:42:13AM +0200, Michal Simek wrote:

> That mean that for all other fs is possible to set nr_blocks=0 (f_bavail=0) and for all this cases
> fsync02 test failed. That mean that make sense to test f_bavail value in LTP and if is zero
> don't work with it. Am I right?

Huh?
	a) ramfs has no such thing as "amount of available space", simply
because it has no limit on total size occupied.
	b) tmpfs *does* have a limit and will report f_bavail, unless you
tell it not to limit (that's what nr_blocks=... is; it sets the fs size limit
for tmpfs and 0 means "no limit, act as ramfs").
	c) nfs client has no fscking clue how much space is left on server
for non-root; moreover, in case of nfs root on client might very well be
mapped to something else on server.
	d) something local on-disk (ext2, ext3, etc., etc.) can and will fill
->f_bavail with non-zero data
	e) procfs has nothing to put there, period.  You can't create
files there, it doesn't have anything like fixed-sized something that might
be partially empty.

The bottom line: some filesystems have reasonable answer to "how much space
is left on that fs for non-root user".  Those fill the field in question.
And for some filesystems the question makes no sense whatsoever.

So statfs(2) has every right to leave the damn thing zero.  Whether it
will do that or not depends on the fs type.  Userland code must be able
to cope with that, unless it *knows* which filesystem type will it be
dealing with.

Incidentally, nr_blocks=... will be cheerfully shat upon by just about every
fs out there.  It's tmpfs-specific.
