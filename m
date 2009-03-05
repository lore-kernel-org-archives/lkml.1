Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZCEGzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZCEGzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 01:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZCEGzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 01:55:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:35719 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbZCEGzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 01:55:32 -0500
Date: Thu, 5 Mar 2009 07:55:29 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Cc: ext-adrian.hunter@nokia.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error testing ext3 on brd ramdisk
Message-ID: <20090305065529.GB11916@wotan.suse.de>
References: <491D7C4C.3090907@nokia.com> <49A82C2E.4030903@dti2.net> <20090228055809.GC28496@wotan.suse.de> <49AC1A7A.1070108@dti2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49AC1A7A.1070108@dti2.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 06:42:18PM +0100, Jorge Boncompte [DTI2] wrote:
> Nick Piggin escribió:
> >On Fri, Feb 27, 2009 at 07:08:46PM +0100, Jorge Boncompte [DTI2] wrote:
> >>	Hi,
> >>
> >>	I have added Nick Piggin to the CC: as maintainer of the brd driver.
> >>
> >>	After switching an embedded distribution that /etc on a ramdisk 
> >>	based minix filesystem from 2.6.23.17 to 2.6.29-rcX i am too getting 
> >>	errors ant the filesystem is corrupted. Does not happen always. The 
> >>visible effect with text files after reboot is getting the old version of 
> >>the file and "\0"'s at the end.
> >>
> >>	Did you found a solution?
> >
> >What architectures are you using? It's possible that brd is missing
> >a cacheflush. I test it pretty heavily on x86 and no problems, so
> >this might point to an arch specific problem.
> >
> >---
> > drivers/block/brd.c |    4 +++-
> > 1 file changed, 3 insertions(+), 1 deletion(-)
> >
> >Index: linux-2.6/drivers/block/brd.c
> >===================================================================
> >--- linux-2.6.orig/drivers/block/brd.c
> >+++ linux-2.6/drivers/block/brd.c
> >@@ -275,8 +275,10 @@ static int brd_do_bvec(struct brd_device
> > 	if (rw == READ) {
> > 		copy_from_brd(mem + off, brd, sector, len);
> > 		flush_dcache_page(page);
> >-	} else
> >+	} else {
> >+		flush_dcache_page(page);
> > 		copy_to_brd(brd, mem + off, sector, len);
> >+	}
> > 	kunmap_atomic(mem, KM_USER0);
> > 
> > out:
> 
> 	Hi, I am on 32bits x86, 2 x Xeon with HT CPUs, but I have seen the 
> 	same corruption on a KVM/QEMU guest with single emulated CPU.
> 
> 	With your patch on top of vanilla 2.6.29-rc3+plus some networking 
> patches I still get corruption sometimes.
> 
> 	The script that saves the configuration does...
> 
> ------------
> mount -no remount,ro /dev/ram0
> dd if=/dev/ram0 of=config.bin bs=1k count=1000
> mount -no remount,rw /dev/ram0
> md5sum config.bin
> dd if=config.bin of=/dev/hda1
> echo $md5sum | dd of=/dev/hda1 bs=1k seek=1100 count=32
> ------------
> 
> on system boot
> 
> ------------
> CHECK MD5SUM
> dd if=/dev/hda1 of=/dev/ram0 bs=1k count=1000
> fsck.minix -a /dev/ram0
> mount -nt minix /dev/ram0 /etc -o rw
> ------------
> 
> 	I have never seen a MD5 failure on boot, just sometimes the 
> 	filesystem is corrupted. Kernel config attached.

Hi Jorge,

Well I found and fixed something :) (see other mail) but I don't know
whether that applies to you here if you're running with a single CPU
and no preemption. But still, it might be worth trying that patch? I'm
sorry I'm still unable to reproduce a problem with your script
(although you don't describe how you create the filesystem before
you remount it).

>From your description, it suggests that the corrupted image is being
read from /dev/ram0 (becuase the md5sum passes).

In your script, can you run fsck.minix on config.bin when you first
create it? What if you unmount /dev/ram0 before copying the image?

Thanks,
Nick

