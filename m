Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbZCJQ4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbZCJQ4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbZCJQ41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:56:27 -0400
Received: from sh.osrg.net ([192.16.179.4]:35558 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776AbZCJQ4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:56:25 -0400
Date: Wed, 11 Mar 2009 01:55:42 +0900 (JST)
Message-Id: <20090311.015542.118514963.ryusuke@osrg.net>
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Asking for inclusion of nilfs2 in the mainline kernel
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 11 Mar 2009 01:55:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I've been working for the past serveral months to take review comments
and to continually solve users' problems come up in mainling list
(thanks for all giving comments and feedbacks!).  Also, I've tried to
stabilize API and disk format to restrict additional changes and
ensure backward compatibility.

Except adding ioctl commands for user-demanded features, I think the
interface was almost stabilized.  Now I'd like to ask for mainline
inclusion so that more people can try this in the tree.

This file system, nilfs2, provides continuous snapshotting; it gives
not only versioning capability of the entire file system but also
retroactively selectable and recoverable snapshots.

With nilfs2, users can even restore files and namespace mistakenly
overwritten or destroyed just a few seconds ago.

The restoration with nilfs snapshots is, for example, done as follows:

 # lscp
 (list checkpoints)

            CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
          33338  2009-03-08 14:45:49   cp    -         11          3
          33339  2009-03-08 14:50:22   cp    -     200523         81
          33340  2009-03-08 20:40:34   cp    -        136         61
          33341  2009-03-08 20:41:20   cp    -     187666       1604
          33342  2009-03-08 20:41:42   cp    -         51       1634
            ...

 # chcp ss 33339 ; lscp
 (select an existing checkpoint and change it into a snapshot)

            CNO        DATE     TIME  MODE  FLG   NBLKINC       ICNT
          33338  2009-03-08 14:45:49   cp    -         11          3
          33339  2009-03-08 14:50:22   ss    -     200523         81
          33340  2009-03-08 20:40:34   cp    -        136         61
          33341  2009-03-08 20:41:20   cp    -     187666       1604
          33342  2009-03-08 20:41:42   cp    -         51       1634
            ...

 # mount -t nilfs2 -r -o cp=33339 /dev/sdb1 /snap
 (mount the snapshot, then it will become accessible on the mount point)

Where snapshots will remain in the disk, whereas plain checkpoints
will be reclaimed automatically after a certain (guaranteed) period.

These snapshot operations are quickly performable.

There is no limit on the number of checkpoints and snapshots until the
volume gets full.  We have long term use experience of nilfs2 about
eleven months on a server; several thousands of checkpoints are dealt
with constantly there.

On the other hand, performance tuning has left on the back burner.  I
feel B-tree lookup routines and log writer have room for improvement
to get better read/write throughput.  In addition, defrag should be
applied, maybe with help from the userland cleaner daemon; a recent
measurement on the above aged partition shows 20~25% degradation.
These are todo items.

So, we'd like to address such remaining challenges with eliminating
user issues ongoingly and simplifying implementation at every
opportunity.


Nilfs userland tools:

 http://www.nilfs.org/en/download.html

General nilfs information:

 http://www.nilfs.org/en/

Nilfs usage:

 http://www.nilfs.org/en/about_nilfs.html

TODO items:

 http://www.nilfs.org/en/current_status.html

User Mailing list:

 https://www.nilfs.org/mailman/listinfo/users


Thanks,
Ryusuke Konishi
