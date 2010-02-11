Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0BKRKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 12:10:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43722 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab0BKRKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:10:19 -0500
Date: Thu, 11 Feb 2010 17:10:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [WTF] ... is going on with current->fs->{root,mnt} accesses in
 pohmelfs
Message-ID: <20100211171018.GR30031@ZenIV.linux.org.uk>
References: <20100210102422.GM30031@ZenIV.linux.org.uk>
 <20100210104515.GA6207@ioremap.net>
 <20100210110011.GN30031@ZenIV.linux.org.uk>
 <20100210111115.GA8376@ioremap.net>
 <20100210115938.GO30031@ZenIV.linux.org.uk>
 <20100210133007.GA17744@ioremap.net>
 <20100210210248.GP30031@ZenIV.linux.org.uk>
 <20100210212933.GA19919@ioremap.net>
 <20100211030253.GQ30031@ZenIV.linux.org.uk>
 <20100211150805.GA18705@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211150805.GA18705@ioremap.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 06:08:05PM +0300, Evgeniy Polyakov wrote:
> On Thu, Feb 11, 2010 at 03:02:54AM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> > Um.  You do realize that d_move() happens with none of your locks held,
> > right?  It's done in vfs_rename_{other,dir}() and the only thing held
> > is s_vfs_rename_sem and i_mutex on parents.  How could your code in
> > writeback be able to distinguish
> 
> No, it happens with my lock held. It is not a lock, but kind of
> IO delegation, i.e. it is not dropped when rename or other protected
> operation completed. Instead another client sends request to grab it and
> server asks current holder to drop cache, perform writeback or whatever
> else is needed.

And should such a request come between return from ->rename() and call
of d_move() that follows it?

> It can be a problem though if d_move() is called outside of path
> protected by the VFS dir operations like rename/created/unlink and so
> on, i.e. on behalf of some entity in the kernel which decides to move
> dentries on itself. In this case POHMELFS is not protected.

Not an issue; there's no such fs-independent callers.

Fundamentally, how do you deal with MOESI when the mapping from strings you
are using as object IDs to actual objects can change as the result of
operations?  What's more, operation on one object can change that mapping
for a huge number of other objects (rename() close to fs root changing
pathnames of all files anywhere in the subtree being moved).
