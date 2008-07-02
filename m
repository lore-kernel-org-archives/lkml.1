Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbYGBTnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbYGBTnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 15:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYGBTm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 15:42:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52161 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYGBTm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 15:42:58 -0400
Date: Wed, 2 Jul 2008 20:42:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, Artem.Bityutskiy@nokia.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch] vfs: fix lookup on deleted directory
Message-ID: <20080702194249.GV28946@ZenIV.linux.org.uk>
References: <E1KE81v-0000d8-Kp@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KE81v-0000d8-Kp@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 09:30:15PM +0200, Miklos Szeredi wrote:

> Lookup can install a child dentry for a deleted directory.  This keeps
> the directory dentry alive, and the inode pinned in the cache and on
> disk, even after all external references have gone away.
> 
> This isn't a big problem normally, since memory pressure or umount
> will clear out the directory dentry and its children, releasing the
> inode.  But for UBIFS this causes problems because its orphan area can
> overflow.
> 
> Fix this by returning ENOENT for all lookups on a S_DEAD directory
> before creating a child dentry.

I wonder if it would be better to do that in a slightly different way:
if ->lookup() returns negative dentry, check if parent is dead and drop
the sucker if it is.  OTOH, "no ->lookup() will be ever called for
dead ones" seems to be a nice property and we are on sufficiently slow
path to not worry about the cost of check-and-branch-not-taken, so I'll
probably drop my variant and pick yours instead.
