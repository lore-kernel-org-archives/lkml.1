Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbXBRToI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbXBRToI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 14:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXBRToI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 14:44:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53019 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbXBRToG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 14:44:06 -0500
Date: Sun, 18 Feb 2007 11:43:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.20-mm2
Message-Id: <20070218114326.35d7645b.akpm@linux-foundation.org>
In-Reply-To: <200702181344.54959.rjw@sisk.pl>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
	<200702181344.54959.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007 13:44:54 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, 18 February 2007 06:51, Andrew Morton wrote:
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.20-mm2/
> > 
> > Will appear later at
> > 
> >  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/
> 
> Two problems:
> 
> 1) A showstopper with the root partition on RAID1:
> 
> md: raid1 personality registered for level 1
> [--snip--]
> md: multipath personality registered for level -4
> register_blkdev: failed to get major for mdp
> [--snip--]
> VFS: Cannot open root device "md1" or unknown-block(0,0)

Someone else reported that against mainline.  Can you please debug it a bit?

I'd suggested reverting the recent changes in there:

--- a/block/genhd.c~a
+++ a/block/genhd.c
@@ -61,14 +61,6 @@ int register_blkdev(unsigned int major, 
 	/* temporary */
 	if (major == 0) {
 		for (index = ARRAY_SIZE(major_names)-1; index > 0; index--) {
-			/*
-			 * Disallow the LANANA-assigned LOCAL/EXPERIMENTAL
-			 * majors
-			 */
-			if ((60 <= index && index <= 63) ||
-					(120 <= index && index <= 127) ||
-					(240 <= index && index <= 254))
-				continue;
 			if (major_names[index] == NULL)
 				break;
 		}
_

but I don't see how they could cause this.


> At the moment I have no serial console attached to the box, so I had to rewrite
> the messages manually.

netconsole is good.

> 2) On HPC nx6325 I get the following 100% of the time during the resume from
> disk:
> 
> BUG: at drivers/pci/pci.c:823 pcim_enable_device()
> 
> Call Trace:
>  [<ffffffff80325ff8>] pcim_enable_device+0x93/0xb3
>  [<ffffffff803a974a>] ata_pci_device_do_resume+0x21/0x5e
>  [<ffffffff803b5e6c>] sil_pci_device_resume+0x1c/0x51
>  [<ffffffff8032800d>] pci_device_resume+0x22/0x53
>  [<ffffffff8039ae58>] resume_device+0xca/0x131
>  [<ffffffff8039af40>] dpm_resume+0x81/0xd3
>  [<ffffffff8039afc2>] device_resume+0x30/0x45
>  [<ffffffff802a0792>] snapshot_ioctl+0x245/0x63e
>  [<ffffffff8023cfcc>] do_ioctl+0x5e/0x77
>  [<ffffffff8022d2b3>] vfs_ioctl+0x25c/0x279
>  [<ffffffff80246a80>] sys_ioctl+0x5f/0x82
>  [<ffffffff80215586>] sys_write+0x47/0x70
>  [<ffffffff8025711e>] system_call+0x7e/0x83
> 
> Nevertheless, the system seems to be fully functional after the resume.
> 
> [I've been observing it since 2.6.20-git10 and have reported it for a couple
> of times, but apparently nobody cares. :-(]

This is a Tejun thing - apparently it's due to swsusp calling suspend once
and resume twice (or is it vice versa).  He'll be looking into it soon.
