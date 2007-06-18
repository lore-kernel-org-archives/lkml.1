Return-Path: <linux-kernel-owner+w=401wt.eu-S1764409AbXFRUJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764409AbXFRUJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:09:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760357AbXFRUIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:08:54 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:61902 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762142AbXFRUIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:08:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18038.58959.395499.718380@stoffel.org>
Date: Mon, 18 Jun 2007 16:08:47 -0400
From: "John Stoffel" <john@stoffel.org>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
In-Reply-To: <4676C2D6.8030708@vlnb.net>
References: <20070612161029.GB28279@think.oraclecorp.com>
	<4676C2D6.8030708@vlnb.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Vladislav" == Vladislav Bolkhovitin <vst@vlnb.net> writes:

>> The basic list of features looks like this:
>> 
>> * Extent based file storage (2^64 max file size)
>> * Space efficient packing of small files
>> * Space efficient indexed directories
>> * Dynamic inode allocation
>> * Writable snapshots
>> * Subvolumes (separate internal filesystem roots)
>> - Object level mirroring and striping
>> * Checksums on data and metadata (multiple algorithms available)
>> - Strong integration with device mapper for multiple device support
>> - Online filesystem check
>> * Very fast offline filesystem check
>> - Efficient incremental backup and FS mirroring

Vladislav> I would also suggest one more feature: support for block
Vladislav> level de-duplication. I mean:

Vladislav> 1. Ability for Btrfs to have blocks in several files to
Vladislav> point to the same block on disk

Yikes!  I'd be *very* wary of this feature.  It's going to be
computationally expensive to do, and it's going to make the entire
filesystem more fragile, since now one bit of corruption means that
possibly all files with that block are now toast.  

There would need to be some serious parity checking done here to make
me feel confortable with such a system.  

Vladislav> 2. Support for new syscall or IOCTL to de-duplicate as a
Vladislav> single transaction two or more blocks on disk, i.e. link
Vladislav> them to one of them and free others

Do you want it per-block, or per-file?  

Vladislav> 3. De-de-duplicate blocks on disk, i.e. copy them on write

You mean that if two files are sharing blocks and one gets written to,
then the changes are copied to a new block and the pointers updated?
Sure, that's a integral part of the concest.

Vladislav> I suppose that de-duplication itself would be done by some
Vladislav> user space process that would scan files, determine blocks
Vladislav> with the same data and then de-duplicate them by using
Vladislav> syscall or IOCTL (2).

Lots of work... where do you keep the metadata then?  In the
filesystem?  

Vladislav> That would be very usable feature, which in most cases
Vladislav> would allow to shrink occupied disk space on 50-90%.

Maybe.  It's reliability I'd be concerned about here.

John
