Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYDNNh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYDNNh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYDNNhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:37:15 -0400
Received: from tamago.serverit.net ([91.189.209.155]:52816 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750755AbYDNNhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:37:14 -0400
X-Greylist: delayed 3006 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2008 09:37:14 EDT
Date: Mon, 14 Apr 2008 15:46:33 +0300 (EEST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.org>
X-X-Sender: szaka@tamago.serverit.net
To: Anton Altaparmakov <aia21@cam.ac.uk>
cc: Miklos Szeredi <miklos@szeredi.hu>, dwmw2@infradead.org, hch@infradead.org,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
In-Reply-To: <14725485.776281208170999085.JavaMail.szaka@kolumbus.fi>
Message-ID: <Pine.LNX.4.62.0804141444320.22065@tamago.serverit.net>
References: <14725485.776281208170999085.JavaMail.szaka@kolumbus.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 14 Apr 2008 Anton Altaparmakov wrote:
> On 14 Apr 2008, at 08:49, Andrew Morton wrote:
> > On Mon, 14 Apr 2008 09:25:46 +0200 Miklos Szeredi  <miklos@szeredi.hu>
> > wrote:
> > 
> > > And I didn't advocate moving
> > > ntfs to fuse, still that was done and the resulting filesystem at the
> > > moment happens to outperform the kernel one in every respect ;)
> > 
> > Gad.  Why?

Well, not only the kernel ntfs (in metadata operations) but also XFS, JFS, 
ext2 in metadata operations, ext3 in large bulk writes on commodity 
hardware.

It's also important to note that ntfs-3g isn't optimized yet at all. There 
are several major performance bootlenecks still in the kernel, FUSE and 
ntfs-3g itself.

Answering the why, the issue is almost never the context switch but the 
file system design and the quality of the implementation. While the latter 
still needs a lot of work on several areas (the size of the Microsoft NTFS 
driver is almost like all the in-kernel file system altogether) but the 
design can very nicely compensate the latter. E.g. ntfs (and ntfs-3g) 
already supports almost all the things what ext4 will include.

> No-one has "moved" ntfs to fuse.  

Yes, historically the user space ntfs code was moved to the kernel. The 
kernel always lagged somehow behind when this work was stopped a few years 
ago.

> However the kernel one as available in the kernel source tree doesn't 
> have many write-features, it can only overwrite files, it cannot 
> create/delete files, etc.  So I guess if you define "performance" to mean 
> "features" then sure ntfsmount/ntfs-3g have more features than the public 
> kernel driver.  If you define "performance" to mean "speed" then no 
> ntfsmount/ntfs-3g can't compare to the kernel except in very limited and 
> meaningless benchmarks...

First comes reliability for ntfs-3g. There are just too many million users. 
This is non-negotiable. Because of this, ntfs-3g is indeed not optimized 
yet. 

However the bootlenecks are almost always storage related (seeks, 
bandwidth, buses) on commodity desktop systems. Embedded devices and 
servers come a bit later with the CPU usage optimizations.

> btw. even comparing features, the fuse solutions lag behind in some  respects,
> e.g. no-one can "kill -9" the kernel driver 

I consider this as a benefit for FUSE file systems. An unloadable kernel 
module results reboot which is much more intrusive.

> leaving a corrupt file system on the volume 

That would be a file system driver implementation bug. What I never denied 
for ntfs-3g. Surely it's solvable but this was never a priority based on 
user wishes.

> (and under no-one I include the OOM killer for example!) 

The OOM killer can be configured and if the fs still uses too much memory 
then probably it's better to be killed/restarted with journaling support.
The important here would be the kernel finally fixing the non-sync behavior 
when it clams to do so (see recent kernel threads).

On the other hand, when in-kernel drivers leak then you get a system 
panic. 

> and another example is that the fuse solutions require large amounts of 
> ram whereas the kernel driver can happily function in 1MiB ram 

A FUSE driver can also happily function in much less than 1 MB RAM.

> when they find a large directory and the user has only 32MiB ram for 
> example...  

This is a FUSE fs implementation, not FUSE problem.

	Szaka

--
NTFS-3G:  http://ntfs-3g.org

