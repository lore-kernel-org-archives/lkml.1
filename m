Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYAJG6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYAJG6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 01:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYAJG6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 01:58:22 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41376 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751622AbYAJG6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 01:58:21 -0500
Message-ID: <399948307.22389@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 10 Jan 2008 14:58:13 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: jplatte@naasa.net
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
References: <200801071151.11200.lists@naasa.net> <200801091322.35133.lists@naasa.net> <399883439.31205@ustc.edu.cn> <200801091404.30330.lists@naasa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801091404.30330.lists@naasa.net>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JCrMj-0001HR-SZ@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 02:04:29PM +0100, Joerg Platte wrote:
> Am Mittwoch, 9. Januar 2008 schrieb Fengguang Wu:
> > On Wed, Jan 09, 2008 at 01:22:33PM +0100, Joerg Platte wrote:
> > > Am Mittwoch, 9. Januar 2008 schrieb Fengguang Wu:
> > >
> > > Thank your for the hint with the filesystems!
> > >
> > > > Thank you for the clue. However I cannot reproduce the bug on
> > > > ext2/2.6.24-rc7. Can you provide more details? Thank you.
> > >
> > > I attached some more information. I'm using the ata_piix driver for my
> > > PATA disk and cdrom drive and booted with hpet=force. Kernel 2.6.23.X has
> > > been
> >
> >                                                           ~~~~~~~~
> > 							  not 2.6.24-rc7?
> >
> No, 2.6.23.X was the last working kernel without this problem, the bug shows 
> up with 2.6.24-rcX. I just wanted to emphasis, that I don't think that it has 
> something to do with the hpet stuff. Kernel 2.6.24-rcX is unpatched, because 
> the hrt stuff has been merged.
> 
> > > patched with the -hrt patches to enable the hidden hpet time on the
> > > ICH4-M chipset. I just rebooted the notebook and mounted /tmp again as
> > > ext2 and now the iowait problem is back. Seems to be reproducible on my
> > > computer. What additional information do you need?
> >
> > I mounted an ext2 as tmp and find no problem. My config options are:
> >
> > CONFIG_EXT2_FS=y
> > CONFIG_EXT2_FS_XATTR=y
> > CONFIG_EXT2_FS_POSIX_ACL=y
> > CONFIG_EXT2_FS_SECURITY=y
> > # CONFIG_EXT2_FS_XIP is not set
> >
> > Fengguang
> 
> CONFIG_EXT2_FS=m
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> CONFIG_EXT2_FS_XIP=y
> 
> Here it is modular and I enabled CONFIG_EXT2_FS_XIP, but the same is enabled 
> on 2.6.23.X. Maybe it is related to libata? I additionally discovered, that 
> the problem disappears for a few seconds when I press the eject button for 
> the ultra bay of my thinkpad. Pressing the button unregisters the cdrom drive 
> to be able to replace it with a hard drive or a battery. Maybe this bug is 
> thinkpad relared?

At last I caught it :-)

[ 1862.219189] requeue_io 301: inode 50948 size 0 at 03:02(hda2)
[ 1862.219199] requeue_io 301: inode 51616 size 0 at 03:02(hda2)
[ 1862.219204] requeue_io 301: inode 51656 size 0 at 03:02(hda2)
[ 1862.219208] requeue_io 301: inode 51655 size 0 at 03:02(hda2)
[ 1862.219216] mm/page-writeback.c 668 wb_kupdate: pdflush(182) 10768 global 3100 0 0 wc _M tw 1024 sk 1
[ 1862.319039] requeue_io 301: inode 50948 size 0 at 03:02(hda2)
[ 1862.319050] requeue_io 301: inode 51616 size 0 at 03:02(hda2)
[ 1862.319055] requeue_io 301: inode 51656 size 0 at 03:02(hda2)
[ 1862.319059] requeue_io 301: inode 51655 size 0 at 03:02(hda2)
[ 1862.319068] mm/page-writeback.c 668 wb_kupdate: pdflush(182) 10768 global 3100 0 0 wc _M tw 1024 sk 1

They are some zero sized files, maybe something goes wrong with the truncate code.

