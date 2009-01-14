Return-Path: <linux-kernel-owner+w=401wt.eu-S1760613AbZANV4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613AbZANV4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZANV4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:56:41 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58451 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754927AbZANV4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:56:40 -0500
Date: Wed, 14 Jan 2009 16:54:30 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Alex Buell <alex.buell@munted.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27 BUG at fs/inode.c:263 with ext4
Message-ID: <20090114215430.GK6222@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alex Buell <alex.buell@munted.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090114210143.39e27168@lithium.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114210143.39e27168@lithium.local.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 09:01:43PM +0000, Alex Buell wrote:
> I've been testing ext4 with some spare disks, tonight I created an
> ext4fs on a USB 60GB hard disk, and backed up my /home partition
> onto it with rsync.
> 
> After umounting the device, and switching off the USB connection I
> got the following in my /var/log/messages.
> 
> What would this suggest? I'd be happy to supply further information
> if required.

Can you reproduce this error?  

The BUG is coming from fs/inode.c: 263, which in my kernel is this:

void clear_inode(struct inode *inode)
{
	might_sleep();
	invalidate_inode_buffers(inode);
       
       BUG_ON(inode->i_data.nrpages);   <--------------------
       BUG_ON(!(inode->i_state & I_FREEING));
       BUG_ON(inode->i_state & I_CLEAR);
       inode_sync_wait(inode);
       DQUOT_DROP(inode);

... and it's apparently coming from udevd when it deletes the device
node from /dev, which looks like is a tempfs filesystem.  That would
explain the call stack, which shows that clear_inode() was apparently
called from shmem_delete_inode():

> Jan 14 20:50:00 lithium [<c0157c55>] shmem_delete_inode+0x0/0xae
> Jan 14 20:50:00 lithium [<c016b6e3>] generic_delete_inode+0x91/0xf9
> Jan 14 20:50:00 lithium [<c016ae1d>] iput+0x48/0x4a
> Jan 14 20:50:00 lithium [<c0163a44>] do_unlinkat+0xb0/0x11f
> Jan 14 20:50:00 lithium [<c0112ace>] do_page_fault+0x23c/0x54a
> Jan 14 20:50:00 lithium [<c0102cb1>] sysenter_do_call+0x12/0x25

That would imply that there were pages from the block device still in
the page cache, which I suspect means they were left over from mke2fs
or fsck, or some other program directly accessing the block device
directly.  I wonder if this BUG can be triggered if a process has an
open file descriptor on the device at the time when it's powered off,
or pulled from the system?

Some details about how reliably you can reproduce this BUG would be
greatly appreciated.

							- Ted
