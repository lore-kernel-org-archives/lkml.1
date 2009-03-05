Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZCEJqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZCEJqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 04:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZCEJq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 04:46:27 -0500
Received: from ns.suse.de ([195.135.220.2]:40280 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbZCEJq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 04:46:26 -0500
Date: Thu, 5 Mar 2009 10:46:23 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Cc: ext-adrian.hunter@nokia.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error testing ext3 on brd ramdisk
Message-ID: <20090305094623.GA17815@wotan.suse.de>
References: <491D7C4C.3090907@nokia.com> <49A82C2E.4030903@dti2.net> <20090228055809.GC28496@wotan.suse.de> <49AC1A7A.1070108@dti2.net> <20090305065529.GB11916@wotan.suse.de> <49AF9932.2040301@dti2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49AF9932.2040301@dti2.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 10:19:46AM +0100, Jorge Boncompte [DTI2] wrote:
> Nick Piggin escribió:
> >>------------
> >>mount -no remount,ro /dev/ram0
> >>dd if=/dev/ram0 of=config.bin bs=1k count=1000
> >>mount -no remount,rw /dev/ram0
> >>md5sum config.bin
> >>dd if=config.bin of=/dev/hda1
> >>echo $md5sum | dd of=/dev/hda1 bs=1k seek=1100 count=32
> >>------------
> >>
> >>on system boot
> >>
> >>------------
> >>CHECK MD5SUM
> >>dd if=/dev/hda1 of=/dev/ram0 bs=1k count=1000
> >>fsck.minix -a /dev/ram0
> >>mount -nt minix /dev/ram0 /etc -o rw
> >>------------
> >>
> >>	I have never seen a MD5 failure on boot, just sometimes the 
> >>	filesystem is corrupted. Kernel config attached.
> >
> >>From your description, it suggests that the corrupted image is being
> >read from /dev/ram0 (becuase the md5sum passes).
> 
> 	No, it is read from /dev/hda1.

No I mean when it is first read from /dev/ram0 when you create the
image. Can you put some fsx.minix checks on the image file to try
to narrow down when exactly it is getting corrupted?


> >In your script, can you run fsck.minix on config.bin when you first
> >create it? What if you unmount /dev/ram0 before copying the image?
> 
> 	Yesterday I did some tests and found that doing...
> 
> -----------
> umount /etc (/etc is what is mounted from /dev/ram0)
> dd if=/dev/zero of=/dev/ram0 bs=1k count=1000
> mount /dev/ram0 /etc -t minix -o rw
> -----------
> ...succeds and mounts a corrupted filesystem with the old content. Doing 
> the same with the all ramdisk driver fails on mount with "no filesystem 
> found".
> 
> If I do...
> -----------
> umount /etc (/etc is what is mounted from /dev/ram0)
> echo 3 > /proc/sys/vm/drop_caches
> dd if=/dev/zero of=/dev/ram0 bs=1k count=1000
> mount /dev/ram0 /etc -t minix -o rw
> ----------
> ... then the mount fails with no filesystem found as it should.
> 
> 	Does this ring any bell? :-)

Humph. It seems like a problem with the buffercache layer rather
than brd itself. I'll dig some more.
