Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbXEJAhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbXEJAhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbXEJAhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:37:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:42265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757281AbXEJAhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:37:45 -0400
From: Neil Brown <neilb@suse.de>
To: torvalds@linux-foundation.org
Date: Thu, 10 May 2007 10:37:06 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17986.26930.952993.510918@notabene.brown>
Cc: akpm@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Greaves <david@dgreaves.com>, Doug Ledford <dledford@redhat.com>
Subject: Please revert 5b479c91da90eef605f851508744bfe8269591a0 (md partition rescan)
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 Could you please revert

    5b479c91da90eef605f851508744bfe8269591a0

It causes an oops when auto-detecting raid arrays, and it doesn't seem
easy to fix.
The array may not be 'open' when do_md_run is called, so bdev->bd_disk
might be NULL, so bd_set_size can oops.
I cannot really open the array (blkdev_get) at this point as I
deadlock on mddev->reconfig_mutex.
I could simply guard against bdev->bd_disk being NULL, but that is too
ugly as sometimes the partitions would be found, and sometimes not.

This whole approach of opening an md device before it has been
assembled just seems to get more and more painful.  I think I'm going
to have to come up with something clever to provide both backward
comparability with usage expectation, and sane integration into the
rest of the kernel.
Maybe if you open before the array is assembled you get a completely
different bdev somehow, and on array assembly, a new bdev, or gendisk
or something, gets swapped in so the next open finds it....

Anyway, if that patch can go I'd appreciate it.

Thanks,
NeilBrown
