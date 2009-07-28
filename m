Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZG1Sgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZG1Sgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZG1Sgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:36:53 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:36485 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbZG1Sgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:36:52 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0907280851360.3186@localhost.localdomain>
References: <4A6D79F6.3050509@redhat.com> <1248699365.6987.1628.camel@twins> 
	<20090727142536.465799aa@lxorguk.ukuu.org.uk> <4A6E529B.9030104@kernel.org> 
	<4A6E764E.80805@redhat.com> <20090728112734.5a75752d@lxorguk.ukuu.org.uk> 
	<alpine.LFD.2.01.0907280851360.3186@localhost.localdomain>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Tue, 28 Jul 2009 14:36:31 -0400
Message-ID: <f73f7ab80907281136k2d7797bat2526d1798aba2f85@mail.gmail.com>
Subject: Re: [PATCH] Allow userspace block device implementation
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Zachary Amsden <zamsden@redhat.com>,
       Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org,
       akpm@linux-foundation.org, Paul.Clements@steeleye.com, tytso@mit.edu,
       miklos <miklos@szeredi.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 12:00, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
> The fact that some distributions already go too far, and use DM whether it
> makes sense or not is only inconveniencing real users. It makes things
> like data portability much harder. I have had real-life cases where I
> wanted to move a disk from one machine to another, only to notice that the
> crazy default for the distro I had used was to make it impossible, because
> all the filesystems crossed disks.
>
> I've since learnt to not use DM (and instead doing a very inconvenient
> "partition everything by hand because the install tool doesn't allow for
> any simple automated way to make a sane install"), and to just put /home
> on one disk and / on the other, and then I can way more easily just move
> my /home disk around, for example.

That's not so much an argument against LVM as it is an argument for
fixing those distro installer tools...  Using device-mapper to map
standard Linux partition-tables has the following benefits:

  (1) The ability to rearrange, resize, and restructure
partition-tables on the fly.  The existing "re-read partition tables"
infrastructure does not safely and reasonably handle changes to the
partition-table while partitions are mounted.  Using device-mapper you
can shrink the mapped space associated with a partition then insert
and map a new partition in that gap... all without rebooting.

  (2) If you use DM via LVM and you have a bit of unallocated space,
you can create block-level snapshots.  This is useful for *much* more
than just a datacenter, it makes home backup tools much easier and
safer too.

  (3) Again, using LVM you can shrink one partition (/) and grow
another (/home), even if you didn't guess right in your initial
allocations.

Personally I am also extremely fond of running commands like "mke2fs
-j /dev/mapper/ares-tempdata" instead of "mke2fs -j /dev/sdb4"... err,
shoot, I meant /dev/sda4, there goes my /home partition...

Even when you are moving hard drives from one computer into another,
it makes it much easier keep track of them if you use the server name
in the "volume group" name.  When plug both backup drives into my
desktop, they're easily distinguished as /dev/mapper/ares_bkup-home
and /dev/mapper/philyra_bkup-home.

Admittedly there are some pretty crappy tools out there... I've had
problems with a few which could not reliably do partition math.  (if
the partitioner tells you that you have a 10240MB disk, and you tell
it to put 5120MB on one partition and 5120MB on the other, it should
not tell you that you over-allocated the disk by 1MB, even if it might
need that for metadata).

Perhaps what we need is a really minimal klibc toolkit built (by
default) as part of the kernel and embedded into the kernel image.  If
the bootloader specifies an external initrd then the in-kernel one
would either be ignored and discarded; otherwise it would provide
clean backwards-compatibility for any boot-time features and arguments
that have been removed from the kernel proper.

Cheers,
Kyle Moffett
