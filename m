Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbYI3VQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbYI3VQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 17:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYI3VQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 17:16:34 -0400
Received: from nef2.ens.fr ([129.199.96.40]:1199 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbYI3VQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 17:16:33 -0400
X-Greylist: delayed 2931 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2008 17:16:32 EDT
Date: Tue, 30 Sep 2008 22:27:29 +0200
From: Quentin Godfroy <godfroy@clipper.ens.fr>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David.Madore@ens.fr
Subject: possible (ext4 related?) memory leak in kernel 2.6.26
Message-ID: <20080930202728.GA6358@goelette.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Tue, 30 Sep 2008 22:27:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lists,

I'd like to report the following problem : after ~ 10 days' uptime on a
Debian 2.6.26-1-686 kernel, my system becomes extremely sluggish and
unresponsive and the OOM-killer starts targeting even innocent processes like
identd or rsync (when the swap is disabled). The machine is low on RAM (192
MB) but this has never been a problem before. As for the slowness, strace
shows that the brk() syscall takes ages to complete; the blocking processes
are in the D state (and for some reason the kernel gives no wchan info).

Free reports a large and constantly growing 'buffers' figure (more than
50% of the available memory). No userland processes seems to be consuming
lare amounts of memory (sum of RSS in 'ps aux' is about 30 megs), and the
overall system is mostly idle.

for instance, the following command reports 

$ free ; dpkg -l '*' >/dev/null; dmesg | tail -n 2
             total       used       free     shared    buffers     cached
Mem:        190356     178920      11436          0     126104      12520
-/+ buffers/cache:      40296     150060
Swap:            0          0          0
/* Waits a minute or so */
Killed
[811245.911859] Out of memory: kill process 6639 (dpkg-query) score 7292 or a child
[811245.911972] Killed process 6639 (dpkg-query)

Config has nothing unusual except that all fs are ext4, which I am begining
to suspect may be the culprit, as every night some process stat()s and
read()s something like 850,000 files, which is maybe fs-stressing; also,
umounting then remounting /home makes the 'buffers' drop from 127304 to
55920 and partially solves the problem.

For info, on umount the last lines in the dmesg read:

[811842.209432] EXT4-fs: mballoc: 12288 blocks 12288 reqs (0 success)
[811842.209547] EXT4-fs: mballoc: 13038 extents scanned, 5902 goal hits,
6315 2^N hits, 0 breaks, 0 lost
[811842.209638] EXT4-fs: mballoc: 768 generated and it took 12577042
[811842.209695] EXT4-fs: mballoc: 1588424 preallocated, 371043 discarded
[811842.372165] kjournald2 starting.  Commit interval 5 seconds
[811842.373381] EXT4 FS on hda4, internal journal
[811842.373473] EXT4-fs: mounted filesystem with ordered data mode.
[811842.373529] EXT4-fs: file extents enabled
[811842.374013] EXT4-fs: mballoc enabled

I believe the problem appeared in 2.6.25, but I am not sure.

Regards,
Quentin Godfroy
