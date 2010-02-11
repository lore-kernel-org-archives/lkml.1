Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0BKDC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 22:02:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44514 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab0BKDCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 22:02:55 -0500
Date: Thu, 11 Feb 2010 03:02:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [WTF] ... is going on with current->fs->{root,mnt} accesses in
 pohmelfs
Message-ID: <20100211030253.GQ30031@ZenIV.linux.org.uk>
References: <20100210100428.GL30031@ZenIV.linux.org.uk>
 <20100210101246.GA3509@ioremap.net>
 <20100210102422.GM30031@ZenIV.linux.org.uk>
 <20100210104515.GA6207@ioremap.net>
 <20100210110011.GN30031@ZenIV.linux.org.uk>
 <20100210111115.GA8376@ioremap.net>
 <20100210115938.GO30031@ZenIV.linux.org.uk>
 <20100210133007.GA17744@ioremap.net>
 <20100210210248.GP30031@ZenIV.linux.org.uk>
 <20100210212933.GA19919@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210212933.GA19919@ioremap.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 12:29:33AM +0300, Evgeniy Polyakov wrote:
> On Wed, Feb 10, 2010 at 09:02:48PM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> > Which would be... ?  E.g. between writepages() and rename().  What serializes
> > your write_inode_create() wrt renames?  IOW, how can the server decide that
> > data from writepages() should go to the same object regardless of the
> > rename?
> 
> rename and some other metadata operations as well as write itself
> request remote lock (if not grabbed already), acknowledge forces writeback to old path.

Um.  You do realize that d_move() happens with none of your locks held,
right?  It's done in vfs_rename_{other,dir}() and the only thing held
is s_vfs_rename_sem and i_mutex on parents.  How could your code in
writeback be able to distinguish

rename() is done
d_move() has happened, we see new pathname in dcache

from

rename() is done
d_move() has not yet happened, we see old pathname in dcache

and generate the right on-the-wire traffic in both cases?  Note that here
server has already seen rename request; as far as server and client are
concerned the rename() is over.
