Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbZCWF0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbZCWF0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 01:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZCWFZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 01:25:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbZCWFZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 01:25:55 -0400
From: Neil Brown <neilb@suse.de>
To: roma1390 <roma1390@gmail.com>
Date: Mon, 23 Mar 2009 16:02:48 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18887.6136.84328.602390@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: raid6 grow "hangs" on 2.6.27 with mounted FS
In-Reply-To: message from roma1390 on Saturday March 21
References: <b410963b0903211329v3c4d787ep2f7a0587bee77789@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday March 21, roma1390@gmail.com wrote:
> i have 2.6.27
> trying thease command
> 
> # create raid6 with 4 block devices
> mdadm --create /dev/md2 --level=6 --raid-devices=4 /dev/loop{1,2,3,4}
> # wait to sync
> sleep 3
> # create and mount FS
> mkfs.ext2 /dev/md2
> mount /dev/md2 -t ext2 /mnt
> 
> # add block device and grow, wait for resync
> mdadm --add /dev/md2  /dev/loop5
> mdadm --grow /dev/md2 --raid-devices=5
> sleep 3
> 
> # dmesg prints: VFS: busy inodes on changed media.
> # umount hangs ...
> umount /dev/md2
> # also: "mdadm --query /dev/md2" hangs in D state.

Thanks for the detailed report.

I can almost reproduce this.
However when I run it, the "mdadm --grow" prints 
    mdadm: Need to backup 384K of critical section..
(as expected) and then hangs.

If I interrupt it and proceed, then the umount hangs.

Is this the case for you?

The umount hangs because there is something important that mdadm needs
to do which it didn't do because it was interrupted.  During the
'critical section', mdadm causes all writes to the start of the device
to be blocked.  The umount tries to write the filesystem superblock
and hangs.
You can test if this is the problem by running the command

 cat /sys/block/md2/md/suspend_hi > /sys/block/md2/md/suspend_lo

That should allow the 'umount' to complete.

This will only happen on very small arrays that take less than a
couple of seconds for the reshape to complete.  I have a patch for
mdadm which makes it more robust in this situation.  It will be in
future releases.

Does this explain what is happening to you?

Thanks,
NeilBrown
