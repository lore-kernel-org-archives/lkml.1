Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYFWOBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYFWOBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYFWOBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:01:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38826 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbYFWOBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:01:46 -0400
Date: Mon, 23 Jun 2008 15:01:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/3] vfs: make d_path() consistent across mount
	operations
Message-ID: <20080623140144.GX28946@ZenIV.linux.org.uk>
References: <20080616112804.930095761@szeredi.hu> <20080616112830.003942737@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616112830.003942737@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 01:28:07PM +0200, Miklos Szeredi wrote:
> From: Andreas Gruenbacher <agruen@suse.de>
> 
> The path that __d_path() computes can become slightly inconsistent when it
> races with mount operations: it grabs the vfsmount_lock when traversing mount
> points but immediately drops it again, only to re-grab it when it reaches the
> next mount point.  The result is that the filename computed is not always
> consisent, and the file may never have had that name. (This is unlikely, but
> still possible.)
> 
> Fix this by grabbing the vfsmount_lock for the whole duration of
> __d_path().

Umm...  I don't see problems with doing that, but I hope you realize that
the notion of "ever having that name" is not the same as "pathnam resolution
on that name ever leading to that file" - path_walk() is *NOT* atomic
wrt rename() (or mount --move, indeed) and it's quite possible to walk
into subdirectory, have it moved under you, then see .. as the next pathname
component and step out into new parent.

Said that, it makes sense to avoid dropping/regaining the lock in that
case - it's less work and I don't believe that it would increase contention
on vfsmount_lock.  So I'm applying that one, just be careful with assumptions
about consistency, etc. in the general area.
