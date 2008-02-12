Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYBLIKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYBLIKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbYBLIKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:10:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33528
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbYBLIKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:10:33 -0500
Date: Tue, 12 Feb 2008 00:11:04 -0800 (PST)
Message-Id: <20080212.001104.172517283.davem@davemloft.net>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080211.232139.14959431.davem@davemloft.net>
References: <200802061200.14690.chris.mason@oracle.com>
	<20080211.232139.14959431.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 11 Feb 2008 23:21:39 -0800 (PST)

> Filesystems like ext2 put their superblock 1 block into the partition
> in order to avoid overwriting disk labels and other uglies.  UFS does
> this too, as do several others.  One of the few exceptions I've been
> able to find is XFS.
> 
> This is a real issue on sparc where the default sun disk labels
> created use an initial partition where block zero aliases the disk
> label.  It took me a few iterations before I figured out why every
> btrfs make would zero out my disk label :-/

Actually it seems this is only a problem with mkfs.btrfs, it clears
out the first 64 4K chunks of the disk for whatever reason.

The following patch cures the disk label spamming problem for me:

--- vanilla/btrfs-progs-0.12/mkfs.c	2008-02-06 08:37:45.000000000 -0800
+++ btrfs-progs-0.12/mkfs.c	2008-02-12 00:07:43.000000000 -0800
@@ -210,7 +210,8 @@ int main(int ac, char **av)
 		exit(1);
 	}
 	memset(buf, 0, sectorsize);
-	for(i = 0; i < 64; i++) {
+	lseek(fd, BTRFS_SUPER_INFO_OFFSET, SEEK_SET);
+	for(i = BTRFS_SUPER_INFO_OFFSET / sectorsize; i < 64; i++) {
 		ret = write(fd, buf, sectorsize);
 		if (ret != sectorsize) {
 			fprintf(stderr, "unable to zero fill device\n");
