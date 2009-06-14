Return-Path: <linux-kernel-owner+w=401wt.eu-S1762357AbZFNQJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762357AbZFNQJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 12:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZFNQI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 12:08:56 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:65367 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbZFNQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 12:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=t+UuuIZoC0rHFCMJj6vV7WmJhoZCnYPb24DVxV+ZWEFgkUlI+Jlq0lHpe4Mec0+fiH
         Nr3IfUs1sSe6P39gufQEv6hHwsAIQ+VgmZknIaczj2FXuw1od/s2JDdCrj2kYC8jczoZ
         Wse8rwZyDYXfgV/U/IXQfqM1/ccHvbdryMwao=
Message-ID: <4A351FA9.1090808@gmail.com>
Date: Sun, 14 Jun 2009 18:04:57 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <4A33A7A2.1050608@gmail.com> <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090614114613.GC9514@shareable.org>
In-Reply-To: <20090614114613.GC9514@shareable.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Marco wrote:
>> Simply because the ramdisk was not designed to work in a persistent
>> environment.
> 
> One thing with persistent RAM disks is you _really_ want it to be
> robust if the system crashes for any reason while it is being
> modified.  The last thing you want is to reboot, and find various
> directories containing configuration files or application files have
> been corrupted or disappeared as a side effect of writing something else.
> 
> That's one of the advantages of using a log-structured filesystem such
> as Nilfs, JFFS2, Logfs, UBIFS, Btrfs, ext3, reiserfs, XFS or JFS on a
> ramdisk :-)
> 
> Does PRAMFS have this kind of robustness?

There's the checksum, but the most important feature of this fs is the
write protection. The page table entries that map the
backing-store RAM are normally marked read-only. Write operations into
the filesystem temporarily mark the affected pages as writeable, the
write operation is carried out with locks held, and then the pte is
marked read-only again. This feature provides protection against
filesystem corruption caused by errant writes into the RAM due to
kernel bugs for instance. I provided a test module for this. When the
module is loaded tries to do a dirty write in the superblock, at this
point you should see an error on the write.

> 
>> In addition this kind of filesystem has been designed to work not
>> only with classic ram. You can think at the situation where you have
>> got an external SRAM with a battery for example. With it you can
>> "remap" in an easy way the SRAM. Moreover there's the issue of
>> memory protection that this filesystem takes care.  > Why is an
>> entire filesystem needed, instead of simply a block driver > if the
>> ramdisk driver cannot be used?  > >From documentation: "A relatively
>> straight-forward solution is to write a simple block driver for the
>> non-volatile RAM, and mount over it any disk-based filesystem such
>> as ext2/ext3, reiserfs, etc.  But the disk-based fs over
>> non-volatile RAM block driver approach has some drawbacks:
>>
>> 1. Disk-based filesystems such as ext2/ext3 were designed for
>> optimum performance on spinning disk media, so they implement
>> features such as block groups, which attempts to group inode data
>> into a contiguous set of data blocks to minimize disk seeking when
>> accessing files. For RAM there is no such concern; a file's data
>> blocks can be scattered throughout the media with no access speed
>> penalty at all. So block groups in a filesystem mounted over RAM
>> just adds unnecessary complexity. A better approach is to use a
>> filesystem specifically tailored to RAM media which does away with
>> these disk-based features.  This increases the efficient use of
>> space on the media, i.e. more space is dedicated to actual file data
>> storage and less to meta-data needed to maintain that file data.
> 
> All true, I agree.  RAM-based databases use different structures to
> disk-based databases for the same reasons.
> 
> Isn't there any good RAM-based filesystem already?  Some of the flash
> filesystems and Nilfs seem promising, using fake MTD with a small
> erase size.  All are robust on crashes.
> 

Good question. The only similar thing that I know it's a patch called
pmem provided by WindRiver. It's the main reason that I led to develop
this kind of fs. In addition in my projects to have this feature has
always been very useful.

>>    However direct I/O has to be enabled at every file open. To
>>    enable direct I/O at all times for all regular files requires
>>    either that applications be modified to include the O_DIRECT flag
>>    on all file opens, or that a new filesystem be used that always
>>    performs direct I/O by default."
> 
> There are other ways to include the O_DIRECT flag automatically.  A
> generic mount option would be enough.  I've seen other OSes with such
> an option.  That code for that would be tiny.
> 
> But standard O_DIRECT direct I/O doesn't work for all applications: it
> has to be aligned: device offset, application memory address and size
> all have to be aligned.
> 
> (It would be a nice touch to produce a generic mount option
> o_direct_when_possible, which turns on direct I/O but permits
> unaligned I/O.  That could be used with all applications.)
>
> As you say PRAMFS can work with special SRAMs needing memory
> protection (and maybe cache coherence?), if you mmap() a file does it
> need to use the page cache then?  If so, do you have issues with
> coherency between mmap() and direct read/write?

See my response above about my concept of protection. However the mmap
it's a similar approach. I can "mmap" the SRAM and I can write into it
my data, but I think the possibility to have a fs it's great. We can use
the device as normal disk, i.e. we can use cp, mv and so on.

> 
>> On this point I'd like to hear other embedded guys.
> 
> As one, I'd like to say if it can checksum the RAM at boot as well,
> then I might like to use a small one in ordinary SRAM (at a fixed
> reserved address) for those occasions when a reboot happens
> (intentional or not) and I'd like to pass a little data to the next
> running kernel about why the reboot happened, without touching flash
> every time.
> 
> -- Jamie
> 

Yeah Jamie, the goal of this fs is exactly that!

Marco
