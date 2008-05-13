Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbYEMW4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbYEMW4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbYEMW4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:56:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbYEMW4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:56:07 -0400
Date: Wed, 14 May 2008 00:55:58 +0200
From: Karel Zak <kzak@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       util-linux-ng@vger.kernel.org
Subject: Re: [BUG] remount ro on loopback mount leaves unmountable
	filesystem behind
Message-ID: <20080513225558.GU23843@nb.net.home>
References: <20080513085047.GY155679365@sgi.com> <20080513102340.GA15112@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513102340.GA15112@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 06:23:40AM -0400, Christoph Hellwig wrote:
> On Tue, May 13, 2008 at 06:50:47PM +1000, David Chinner wrote:
> > Same thing, but remounting the loop filesystem readonly
> > before unmounting:
> > 
> > $ mount -t xfs /dev/sdb6 /mnt/scratch
> > $ mkdir /mnt/scratch/mnt
> > $ touch /mnt/scratch/img
> > $ mkfs.xfs -f -d file,name=/mnt/scratch/img,size=1g
> > $ mount -t xfs -o loop /mnt/scratch/img /mnt/scratch/mnt
> > $ mount -t xfs -o remount,ro /mnt/scratch/img /mnt/scratch/mnt
> > $ umount /mnt/scratch/mnt
> > $ umount /mnt/scratch
> > umount: /mnt/scratch: device is busy
> > umount: /mnt/scratch: device is busy
> 
> This is a problem in mount, no the kernel.  Before the remount the
> /etc mtab looks something like this:
> 
> /qemu/test.img /mnt xfs rw,loop=/dev/loop0 0 0
> 
> and after it looks something like this:
> 
> /qemu/test.img /mnt xfs ro 0 0

 Yes, that's mount(8) bug. It doesn't read old options from /etc/mtab
 when you remount by "mount -o remount <src> <dest>".

> As a workaround do a losetup -d /dev/loop0 after unmounting the
> filesystem.

 ... or use "mount -o remount <dest>", for example:

   mount -t xfs -o remount,ro /mnt/scratch/mnt


    Karel

-- 
 Karel Zak  <kzak@redhat.com>
