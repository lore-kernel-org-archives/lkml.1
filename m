Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbXH1PxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbXH1PxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 11:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXH1PxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 11:53:11 -0400
Received: from web32614.mail.mud.yahoo.com ([68.142.207.241]:46591 "HELO
	web32614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753413AbXH1PxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 11:53:10 -0400
X-YMail-OSG: XExD4KUVM1lQ53dC7DrxcwgFI9.W1ibml3iXBhgll26fJ.wpbNEmsny7L5zqJcuhMePqNASHrLAFFmW6ZcoiyJShZg--
X-RocketYMMF: knobi.rm
Date: Tue, 28 Aug 2007 08:53:07 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Understanding I/O behaviour - next try
To: linux-kernel@vger.kernel.org
Cc: Peter zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com,
       spam trap <spamtrap@knobisoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <713252.42570.qm@web32614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keywords: I/O, bdi-v9, cfs

Hi,

 a while ago I asked a few questions on the Linux I/O behaviour,
because I were (still am) fighting some "misbehaviour" related to heavy
I/O.

 The basic setup is a dual x86_64 box with 8 GB of memory. The DL380
has a HW RAID5, made from 4x72GB disks and about 100 MB write cache.
The performance of the block device with O_DIRECT is about 90 MB/sec.

 The problematic behaviour comes when we are moving large files through
the system. The file usage in this case is mostly "use once" or
streaming. As soon as the amount of file data is larger than 7.5 GB, we
see occasional unresponsiveness of the system (e.g. no more ssh
connections into the box) of more than 1 or 2 minutes (!) duration
(kernels up to 2.6.19). Load goes up, mainly due to pdflush threads and
some other poor guys being in "D" state.

 The data flows in basically three modes. All of them are affected:

local-disk -> NFS
NFS -> local-disk
NFS -> NFS

 NFS is V3/TCP.

 So, I made a few experiments in the last few days, using three
different kernels: 2.6.22.5, 2.6.22.5+cfs20.4 an 2.6.22.5+bdi-v9.

 The first observation (independent of the kernel) is that we *should*
use O_DIRECT, at least for output to the local disk. Here we see about
90 MB/sec write performance. A simple "dd" using 1,2 and 3 parallel
threads to the same block device (through a ext2 FS) gives:

O_Direct: 88 MB/s, 2x44, 3x29.5
non-O_DIRECT: 51 MB/s, 2x19, 3x12.5

- Observation 1a: IO schedulers are mostly equivalent, with CFQ
slightly worse than AS and DEADLINE
- Observation 1b: when using a 2.6.22.5+cfs20.4, the non-O_DIRECT
performance goes [slightly] down. With three threads it is 3x10 MB/s.
Ingo?
- Observation 1c: bdi-v9 does not help in this case, which is not
surprising.

 The real question here is why the non-O_DIRECT case is so slow. Is
this a general thing? Is this related to the CCISS controller? Using
O_DIRECT is unfortunatelly not an option for us.

 When using three different targets (local disk plus two different NFS
Filesystems) bdi-v9 is a big winner. Without it, all threads are [seem
to be] limited to the speed of the slowest FS. With bdi-v9 we see a
considerable speedup.

 Just by chance I found out that doing all I/O inc sync-mode does
prevent the load from going up. Of course, I/O throughput is not
stellar (but not much worse than the non-O_DIRECT case). But the
responsiveness seem OK. Maybe a solution, as this can be controlled via
mount (would be great for O_DIRECT :-).

 In general 2.6.22 seems to bee better that 2.6.19, but this is highly
subjective :-( I am using the following setting in /proc. They seem to
provide the smoothest responsiveness:

vm.dirty_background_ratio = 1
vm.dirty_ratio = 1
vm.swappiness = 1
vm.vfs_cache_pressure = 1

 Another thing I saw during my tests is that when writing to NFS, the
"dirty" or "nr_dirty" numbers are always 0. Is this a conceptual thing,
or a bug?

 In any case, view this as a report for one specific loadcase that does
not behave very well. It seems there are ways to make things better
(sync, per device throttling, ...), but nothing "perfect yet. Use once
does seem to be a problem.

Cheers
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
