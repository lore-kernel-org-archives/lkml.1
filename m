Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbYIACRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbYIACRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 22:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYIACRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 22:17:19 -0400
Received: from mail.suse.de ([195.135.220.2]:60112 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbYIACRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 22:17:18 -0400
From: Neil Brown <neilb@suse.de>
To: Alistair John Strachan <alistair@devzero.co.uk>
Date: Mon, 1 Sep 2008 12:17:06 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18619.20642.697691.541752@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: md (regression): reboot/shutdown hangs
In-Reply-To: message from Alistair John Strachan on Thursday August 28
References: <200808282005.09416.alistair@devzero.co.uk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday August 28, alistair@devzero.co.uk wrote:
> Hi Neil,
> 
> Commit 2b25000bf5157c28d8591f03f0575248a8cbd900 ("Restore force switch of md 
> array to readonly at reboot time.") causes a reboot/shutdown to hang 
> indefinitely on my box. Reverting this single commit makes the problem go 
> away. It was first released with 2.6.27-rc3, I believe, and so this is a 
> regression vs 2.6.26 (Rafael CCed).
> 
> I think the problem might be because my rootfs is on a RAID5 and my distro 
> fails to stop it completely before halt/reboot.
> 
> Please let me know if there's any more information you need from me.

Thanks for the report.

I'm having trouble figuring out why this ever worked.  I must be
missing something.

I can only reproduce a hang when calling reboot when a sync is needed.
I dirty a file and then 
   reboot -f -n

This will always have blocked except between the commit that you
mention and an earlier commit which broke something which that commit
was fixing.

This is because the reboot calls do_md_stop while holding the mddev
lock, and do_md_stop calls invalidate_partition.  If this finds any dirty
data to flush, the writeout will (most likely) need to mark the
superblock as dirty first, which cannot happen while the mddev lock is
held.  So we get a deadlock.

The call to invalidate_partition should not be needed in any case except a
reboot, and in that case you really don't want it (if you wanted to
sync, you would have done that first).
So I plan to remove it.  With it gone I cannot reproduce a hang.  If
you can, I would love to hear about it.

Thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8cfadc5..4790c83 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3841,8 +3841,6 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 
 		del_timer_sync(&mddev->safemode_timer);
 
-		invalidate_partition(disk, 0);
-
 		switch(mode) {
 		case 1: /* readonly */
 			err  = -ENXIO;
