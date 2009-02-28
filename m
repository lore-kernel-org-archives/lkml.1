Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbZB1F6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbZB1F6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 00:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbZB1F6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 00:58:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:42872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbZB1F6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 00:58:12 -0500
Date: Sat, 28 Feb 2009 06:58:09 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
Cc: ext-adrian.hunter@nokia.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error testing ext3 on brd ramdisk
Message-ID: <20090228055809.GC28496@wotan.suse.de>
References: <491D7C4C.3090907@nokia.com> <49A82C2E.4030903@dti2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49A82C2E.4030903@dti2.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 07:08:46PM +0100, Jorge Boncompte [DTI2] wrote:
> Adrian Hunter escribió:
> >Hi
> >
> >I am trying to test EXT3 on a ramdisk and after some number of mounts
> >(anywhere from 7 to 603 so far), I get errors from e2fsck like this:
> >
> >/dev/ram0: HTREE directory inode 137 has an invalid root node.
> >HTREE INDEX CLEARED.
> >/dev/ram0: Entry 'f1770' in /work/p0/da/d1c61 (137) has deleted/unused 
> >inode 692.  CLEARED.
> >/dev/ram0: Entry 'fa37' in /work/p0/da/d1c61 (137) has deleted/unused 
> >inode 799.  CLEARED.
> >/dev/ram0: Entry 'c1686' in /work/p0/da/d1c61 (137) has deleted/unused 
> >inode 470.  CLEARED.
> >/dev/ram0: Entry 'c19b8' in /work/p0/da/d1c61 (137) has an incorrect 
> >filetype (was 3, should be 1).
> >
> >/dev/ram0: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
> >      (i.e., without -a or -p options)
> >
> >
> >This is what I do:
> >
> >
> >modprobe brd rd_nr=1 rd_size=4096
> >mkfs.ext3 /dev/ram0
> >dmesg -n8
> >i=0
> >while (true); do
> >    i=`expr $i + 1`
> >    echo -------------------------------------------------------------
> >    echo Cycle $i
> >    date
> >    echo Mounting
> >    sleep 1
> >    mount -t ext3 /dev/ram0 /mnt/test_file_system || exit 1
> >    echo Removing old fsstress data
> >    rm -rf /mnt/test_file_system/work
> >    mkdir /mnt/test_file_system/work || exit 1
> >    echo Starting fsstress
> >    fsstress -d /mnt/test_file_system/work -p 3 -l 0 -n 100000000 &
> >    echo Sleeping 30 seconds
> >    sleep 30
> >    echo Stopping fsstress
> >    while (ps -e | grep fsstress);do
> >        pkill fsstress
> >        sleep 1
> >    done
> >    echo Unmounting
> >    umount /mnt/test_file_system || exit 1
> >    echo Checking
> >    sleep 1
> >    e2fsck -fvp /dev/ram0 || exit 1
> >done
> >
> >
> >It seems to happen ever since the introduction of brd (Feb '08).
> >
> >Does anyone know what is going on?
> >
> 	Hi,
> 
> 	I have added Nick Piggin to the CC: as maintainer of the brd driver.
> 
> 	After switching an embedded distribution that /etc on a ramdisk 
> 	based minix filesystem from 2.6.23.17 to 2.6.29-rcX i am too getting errors 
> ant the filesystem is corrupted. Does not happen always. The visible 
> effect with text files after reboot is getting the old version of the 
> file and "\0"'s at the end.
> 
> 	Did you found a solution?

What architectures are you using? It's possible that brd is missing
a cacheflush. I test it pretty heavily on x86 and no problems, so
this might point to an arch specific problem.

---
 drivers/block/brd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -275,8 +275,10 @@ static int brd_do_bvec(struct brd_device
 	if (rw == READ) {
 		copy_from_brd(mem + off, brd, sector, len);
 		flush_dcache_page(page);
-	} else
+	} else {
+		flush_dcache_page(page);
 		copy_to_brd(brd, mem + off, sector, len);
+	}
 	kunmap_atomic(mem, KM_USER0);
 
 out:
