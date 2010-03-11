Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab0CKQBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:01:44 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42385 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab0CKQBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:01:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Qsav+CHasa02ur7o1p1l1oQODYDauUybnr159HlvYwCH9mr2WaVQ+zGN921uBYXjBW
         GILiefgZWCrmdvsIK1aWep94daBMFKxE85mJiDsWBZOKkV8dpPjwGLwD7E99JiHZgE65
         uMtVKJaIMKdw31grN8nOBDe1LWJFn0XKRkP0o=
MIME-Version: 1.0
In-Reply-To: <201003112030.44605.knikanth@suse.de>
References: <4B947393.2050002@kernel.org> <201003111927.24829.knikanth@suse.de>
	 <472A4C80-30CE-4875-8073-F7E61659B6F0@mit.edu>
	 <201003112030.44605.knikanth@suse.de>
Date: Thu, 11 Mar 2010 11:01:41 -0500
X-Google-Sender-Auth: dc7d63b423b045dd
Message-ID: <170fa0d21003110801p3ce6c5e9xe77b6f9f833fe19d@mail.gmail.com>
Subject: Re: ATA 4 KiB sector issues.
From: Mike Snitzer <snitzer@redhat.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Theodore Tso <tytso@mit.edu>, Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 10:00 AM, Nikanth Karthikesan <knikanth@suse.de> wrote:
> On Thursday 11 March 2010 19:58:11 Theodore Tso wrote:
>> On Mar 11, 2010, at 8:57 AM, Nikanth Karthikesan wrote:
>> > I guess, what he meant was, to keep filesystem blocks aligned, even if
>> > the partition is not. Say if the partition is mis-aligned by 512-bytes,
>> > let the filesystem waste 4k-512bytes and keep it's blocks aligned. But it
>> > might be a case of over-engineering, possibly requiring disk format
>> > change.
>>
>> Ah, yes, I agree with you; that's probably what he meant.
>>
>> Sure, that's theoretically possible, but it would mean changing every
>>  single filesystem, and it would require a file system format change --- or
>>  at least a file system format extension.
>>
>> It would seem to be way easier to simply fix the partitioning tools to do
>>  the right thing, though.
>>
>
> Yes. May be, just a simple but transparent device-mapper like mapping on top
> of the mis-aligned partition, to do the alignment. Then the file-system code
> need not change much.
>
> But Linux already has device-mapper and Linux will not be affected with mis-
> aligned partitions, when we use LVM.

Well, device-mapper and LVM needed to be updated to make them "just
work" but yes that work has been done.

> But the actual problem here is that partitioning tools might create partitions
> that wont allow other operating-systems to boot. So it might be enough, if the
> partitioning tools just create partitions with (mis-)alignment requirement for
> Windows.

I'm not following...

Anyway, 4K drives that are 512b logical and 4K physical may or may not
also have "DOS partition compensation" that use LBA -1 as the first
naturally (4K) aligned start.  This means that the partition tools
need to shift the start of the first primary partition to be offset by
3584 bytes (7 512b sectors) for use with Linux.  But for windows,
AFAIK windows XP and windows 7 create all partitions aligned on 1MB
boundaries.  Linux's parted and fdisk create 1MB aligned partitions
now too.

So the only outlier is older versions of windows (< XP) and Linux (old
fdisk and parted, etc also use DOS partitioning) that don't use
naturally aligned (e.g. 1MB) partition boundaries.  In those versions
of Windows and LInux there are ways to change the default start of
sector 63.   That said, there is an opportunity to improve
documentation for how to workaround DOS partitioning on these
operating systems.

One other piece worth mentioning on this "IO Toplogy" support in the
entire Linux I/O Stack is the virt layers.  hch has already extended
the virt-io protocol and qemu is in the finishing stages of being
updated to properly consume the "IO Topology" information.  So we
really don't have any gaps in the Linux I/O stack.

mkp in particular, Jens, James, myself, and others implemented and
refined the SCSI and block changes.  kzak, jim meyering, hans de
goede, hch, eric sandeen, bob peterson, myself and others updated all
other I/O stack layers ranging from DM to LVM, libblkid, fdisk, parted
to anaconda to mkfs.ext[234], mkfs.xfs, mkfs.gfs2 to virt-io and qemu.
 FYI, all of these advances will be in Fedora 13 (quite a few are
already in Fedora 12).

There are obviously other Linux systems and userland tools (likely
Xen, other mkfs.* and more) that should be updated.  Hopefully
maintainers and/or contributors of these projects will follow-up to
address those that need updating.

Again please see:
http://oss.oracle.com/~mkp/docs/linux-advanced-storage.pdf
http://people.redhat.com/msnitzer/docs/io-limits.txt
Some omissions include: Linux MD, which has been updated as mkp
pointed out, and I neglected to talk about virt-io and qemu (but like
I said they have been updated too).

Hopefully we're all closer to being on the same page now.

Mike
