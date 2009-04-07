Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZDGHdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZDGHdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZDGHdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:33:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbZDGHdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:33:41 -0400
Date: Tue, 7 Apr 2009 00:31:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Apollon Oikonomopoulos <ao-lkml@noc.grnet.gr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Block device cache issue
Message-Id: <20090407003153.41fb9c78.akpm@linux-foundation.org>
In-Reply-To: <20090402145205.GG30077@apollon.noc.grnet.gr>
References: <20090402145205.GG30077@apollon.noc.grnet.gr>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 17:52:05 +0300 Apollon Oikonomopoulos <ao-lkml@noc.grnet.gr> wrote:

> Greetings to the list,
> 
> At my company, we have come across something that we think is a design 
> limitation in the way the Linux kernel handles block device caches.  I 
> will first describe the incident we encountered, before speculating on 
> the actual cause.
> 
> As part of our infrastructure, we are running some Linux servers used as 
> Xen Dom0s, using SAN LUNs as the VMs' disk images, so these LUNs contain 
> normal MBR partition tables. At some point  we came across a VM, that - 
> due to a misconfiguration of GRUB - failed on a reboot. We used 
> multipath-tools' kpartx to create a device-mapper device pointing to the 
> first partition of the LUN, mounted the filesystem, changed 
> boot/grub/menu.lst, unmounted it and proceeded to boot the VM once more.  
> To our surprise, Xen's pygrub showed the boot menu exactly as it was 
> before the changes we made. We double-checked that the changes we made 
> were indeed there and tried to find out what was actually going on.
> 
> As it turned out, the LUN device's read buffers had not been updated;  
> losetup'ing the LUN device with the proper offset to the first partition 
> and mounting it gave us exactly the image of the filesystem as it was 
> _before_ our changes. We started digging into the kernel's buffer 
> internals and came along the conclusion [1] that every block device  has 
> its own pagecache, attached to a hash of (major,minor), that is 
> independent from the caches of its containing or contained devices.  
> 
> Now, in practice one rarely - if ever - accesses the same data from 
> these two different paths (disk + partition), except in scenarios like 
> this. However currently there seems to be an implicit assumption that 
> these two paths should not be used in the same "uptime" cycle at all, at 
> least not without dropping the caches.  For the record, I managed to 
> reproduce the whole issue by reading a single block through sda, dd'ing 
> random data to it through sda1 and re-reading it through sda: its 
> contents were intact (even hours later) and were up-to-date only when 
> using O_DIRECT and finally when I dropped all caches (using 
> /proc/sys/vm/drop_caches).
> 
> And now we come to the question part: Can someone please verify that the 
> above statements are correct, or am I missing something?

The above statements are correct ;)

Similarly, the pagecache for /etc/password is separate from the
pagecache for the device upon which /etc is mounted.

> If they are, 
> should it perhaps be the case that the partition's buffers somehow be 
> linked with those of the containing device, or even be part of them? I 
> don't even know if this is possible without significant overhead in the 
> page cache (of which my understanding is very shallow), but keep in mind 
> that this behaviour almost led to filesystem corruption (luckily we only 
> changed a single file and hit a single inode).

It would incur overhead.  We could perhaps fix it by having a single
cache for /dev/sda and then just making /dev/sda1 access that cache
with an offset.  But it rarely if ever comes up - I guess the few
applications which do this sort of thing are taking suitable steps to
avoid it - fsync, ioctl(BKLFLSBUF), posix_fadvise(FADV_DONTNEED),
O_DIRECT, etc.



