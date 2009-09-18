Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbZIRTcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbZIRTcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbZIRTcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:32:41 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:42768 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbZIRTck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:32:40 -0400
From: Jim Meyering <jim@meyering.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: efficient access to "rotational";  new fcntl?
Date: Fri, 18 Sep 2009 21:31:50 +0200
Message-ID: <87vdjgqcbd.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

About a year ago, I fixed GNU rm to avoid quadratic readdir/stat seek
penalties on ext3 and ext4 that became overwhelming on directories with
many entries (1M entries started to look like infloop or DoS).

  From coreutils-7.0 NEWS:

    chgrp, chmod, chown, chcon, du, rm: now all display linear performance,
    even when operating on million-entry directories on ext3 and ext4 file
    systems.  Before, they would exhibit O(N^2) performance, due to linear
    per-entry seek time cost when operating on entries in readdir order.
    Rm was improved directly, while the others inherit the improvement
    from the newer version of fts in gnulib.

To do that efficiently, I changed the core readdir loop (mainly via
gnulib's fts.c) to preprocess entries, when needed, by sorting them
on inode, and *then* processing them.  This optimization is enabled
only when the affected file system is of a type likely to benefit,
and when the number of directory entries is large enough to matter.

However, with e.g., an ext4 partition on non-rotational hardware like
an SSD, that preprocessing is unnecessary and in fact wasted effort.
I'd like to avoid the waste by querying the equivalent of
/sys/.../rotational, via a syscall like fcntl or statvfs,
given a file descriptor.

Is there an efficient way to get that single bit?

IMHO, locating and opening-then-reading a file like
/sys/devices/pci0000:00/0000:00:1f.2/host4/target4:0:0/4:0:0:0/block/sdc/queue/rotational
is not appropriate in the context of a low-level library function like fts.

Jim
