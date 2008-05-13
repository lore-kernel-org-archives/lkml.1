Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbYEMKXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbYEMKXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 06:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYEMKXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 06:23:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54389 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYEMKXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 06:23:40 -0400
Date: Tue, 13 May 2008 06:23:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       util-linux-ng@vger.kernel.org
Subject: Re: [BUG] remount ro on loopback mount leaves unmountable
	filesystem behind
Message-ID: <20080513102340.GA15112@infradead.org>
References: <20080513085047.GY155679365@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513085047.GY155679365@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 06:50:47PM +1000, David Chinner wrote:
> Same thing, but remounting the loop filesystem readonly
> before unmounting:
> 
> $ mount -t xfs /dev/sdb6 /mnt/scratch
> $ mkdir /mnt/scratch/mnt
> $ touch /mnt/scratch/img
> $ mkfs.xfs -f -d file,name=/mnt/scratch/img,size=1g
> $ mount -t xfs -o loop /mnt/scratch/img /mnt/scratch/mnt
> $ mount -t xfs -o remount,ro /mnt/scratch/img /mnt/scratch/mnt
> $ umount /mnt/scratch/mnt
> $ umount /mnt/scratch
> umount: /mnt/scratch: device is busy
> umount: /mnt/scratch: device is busy

This is a problem in mount, no the kernel.  Before the remount the
/etc mtab looks something like this:

/qemu/test.img /mnt xfs rw,loop=/dev/loop0 0 0

and after it looks something like this:

/qemu/test.img /mnt xfs ro 0 0

As a workaround do a losetup -d /dev/loop0 after unmounting the
filesystem.

