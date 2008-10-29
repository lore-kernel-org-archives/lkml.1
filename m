Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYJ2Tyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYJ2Tyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 15:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYJ2TyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 15:54:21 -0400
Received: from smtp1.riverbed.com ([206.169.144.12]:56469 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYJ2TyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 15:54:20 -0400
Date: Wed, 29 Oct 2008 12:54:03 -0700
From: Arthur Jones <ajones@riverbed.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
CC: sct@redhat.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: ext3: slow symlink corruption on umount...
Message-ID: <20081029195403.GA8333@ajones-laptop.nbttech.com>
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081027165423.GB25797@ajones-laptop.nbttech.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one's turning out to be a slippery fish.
I have found that the corruption appears to
be due to ->writepage() not getting called at all
for any of the long symlinks...

Ring any bells anyone?  Any ideas where to look
or what to test?  This is my first foray into
ext3 and I could definitely use some expert advice...

Arthur

On Mon, Oct 27, 2008 at 09:54:23AM -0700, Arthur Jones wrote:
> Some additional info -- and attempting to cast a wider
> net on the CC:
> 
> I do not see the long symlink corruption with mount -o data=writeback
> and we've now seen a couple cases where the symlink corruption
> does not require a umount...
> 
> Arthur
> 
> On Fri, Oct 24, 2008 at 11:37:34AM -0700, Arthur Jones wrote:
> > Hi All,  I'm seeing slow symlink corruption on ext3 on linux-2.6.27,
> > yesterday's linux-2.6 git tree and 2.6.9 RHEL4.7.  I.e. every kernel
> > I've tried I see this effect.  To reproduce this, I need:
> > 
> > * 250MB + tar file in memory (tmpfs or in the buffer cache)
> > * long symlinks in the tar file (over 60 characters)
> > * umount immediately after untarring
> > 
> > What I see is that the symlinks are corrupted, e.g.:
> > 
> > # ls -l etc/vmware-vix-disklib
> > etc/vmware-vix-disklib -> ??f
> > 
> > fsck shows:
> > 
> > Symlink /etc/vmware-vix-disklib (inode #16454) is invalid.
> > 
> > Debugfs shows:
> > 
> > debugfs:  stat <16454>
> > Inode: 16454   Type: symlink    Mode:  0777   Flags: 0x0   Generation: 1431972005
> > User:     0   Group:     0   Size: 65
> > File ACL: 0    Directory ACL: 0
> > Links: 1   Blockcount: 8
> > Fragment:  Address: 0    Number: 0    Size: 0
> > ctime: 0x4900ac69 -- Thu Oct 23 09:55:05 2008
> > atime: 0x4900ac84 -- Thu Oct 23 09:55:32 2008
> > mtime: 0x4900ac69 -- Thu Oct 23 09:55:05 2008
> > BLOCKS:
> > (0):56034
> > TOTAL: 1
> > 
> > I'm still tracking down exactly what's going on.  Anyone seen
> > anything like this before?  ext2 does not show this effect (I've
> > not tried ext4).  It happens when the backing block device is
> > a SATA drive or flash.
> > 
> > Thanks,
> > 
> > Arthur
