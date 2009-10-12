Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbZJLOCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbZJLOCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbZJLOCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:02:45 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:40467 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbZJLOCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=LTeqbxy0Q6se97LqDGBQS9z9GzJPytZ+UquaBH/4dnbyl1qgfWN48o53dEqTMwohd1
         69hld5RRFGUEeWSQ4BQxZhNaHpM2H8C3ZgsUJKpdu/RC3A1awjYmxVjVCe/o6fb3D0Yj
         7Gifn05BX85eyVE4ULdIoM1NfQEK15fE6YMR8=
MIME-Version: 1.0
Date: Mon, 12 Oct 2009 16:01:58 +0200
Message-ID: <bb145bd20910120701p70c176d9p85028da7afec094c@mail.gmail.com>
Subject: *Really* bad I/O latency with md raid5+dm-crypt+lvm
From: Christian Pernegger <pernegger@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please keep me CCed as I'm not subscribed to LKML]

Summary: I was hoping to use a layered storage setup, namely lvm on
dm-crypt on md raid5 for a new box I'm setting up, but that isn't
looking so good since a single heavyish writer will monopolise any and
all I/O on the "device". F. ex. while cp'ing a few GB of data from an
external disk to the array it takes ~10sec to run ls and ~2min to
start aptitude. Clueless attempts at a diagnosis below.

Hardware:
AMD Athlon II X2 250
2GB Crucial DDR2-ECC RAM (more after testing)
ASUS M4A785D-M PRO
4x WD1000FYPS
        connected to onboard SATA controller (AMD SB710 / ahci)

Software:
Debian 5.03 (lenny/stable)
Kernel: linux-image-2.6.30-bpo.2-amd64 (based on 2.6.30.5 it seems)

The 4 disks are each partitioned into a 256MB sdX1 and a $REST sdX2.
The sdX1s make up md0, a raid1 w/ 1.0 superblock for /boot.
The sdX2s make up md1, a raid5 w/ 1.1 superblock, 1MiB chunk size and
stripe_cache_size = 8192.
On top of md1 sits md1_crypt, a dm-crypt/luks layer using
aes-cbc-essiv:sha256 and a 256 bit key. It's aligned to 6144 sectors
(=3MiB / 1 stripe)
The whole of md1_crypt is an lvm PV with a metadatasize of 3008KiB.
(That's the poor-man's way of aligning the data to align the data to
3MiB / 1 stripe. The lvm tools in stable are too old for proper
alignment options.)
The VG consisting of md1_crypt has 16GiB root, 4GiB swap, 200GiB home
and $REST data LVs.
All filesystems are ext3 with stride=256 and stripe-width=768. home is
mounted acl,user_xattr, data acl,user_xattr,noatime. Readahed on the
LVs is at 6MiB (2 stripes).

So, first question: should this kind of setup work at all or am I
doing something pathological in the first place?

Anyway, as soon as I copy something to the array or create a larger
(upwards of a few hundred MiB) tar archive the box becomes utterly
unresponsive until that job is finished. Even on the local console the
completion time for a simple ls or cat is of the order of tens of
seconds, just forget about launching emacs.

Now I know that people have been ranting about desktop responsiveness
for a while but that was very much an abstract thing for me until now.
I'd never have thought it would hit me on a personal streaming media /
backups / multi-user general purpose server. Well, at the moment it's
single-user, single-job ... :-(

Here's what I tried:
changing scheduler from cfq to deadline (no effect)
tuning proc/sys/vm/dirty*ratio way down (no effect)
turning off NCQ (some effect, maybe)
raising queue/nr_requests really high, e. g. 1000000 (helps
noticeably, especially when NCQ is off)

Ideas:
According to openssl speed aes-256-cbc the CPUs encryption speed is
~113 MiB/s (single core, est. for 512b blocks). Obviously the array is
much faster than that. I can't find the benchmarks ATM but the numbers
seemed plausible for 70 MiB/s (optimistic est. for sequential access)
disks at the time. So lets say at least 50% faster. Wouldn't this move
the bottleneck for requests away from the scheduler queue thus
rendering it ineffective?

Also, running btrace on the various block device layers I never see
>4k writes, even when using dd with a blocksize of 3 MiB. Is this
normal? btrace on (one of) the component disks shows some merged
requests at least. Am I wrong or would scheduling/merging lots and
lots of 4k blocks effectively, take an *insane* queue length?

All comments and suggestions welcome

Thank you,

Chris
