Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZDBPHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZDBPHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764035AbZDBPC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:02:59 -0400
Received: from mail.noc.grnet.gr ([83.212.9.3]:47054 "EHLO mail.noc.grnet.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764026AbZDBPC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:02:58 -0400
X-Greylist: delayed 647 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2009 11:02:57 EDT
Date: Thu, 2 Apr 2009 17:52:05 +0300
From: Apollon Oikonomopoulos <ao-lkml@noc.grnet.gr>
To: linux-kernel@vger.kernel.org
Subject: Block device cache issue
Message-ID: <20090402145205.GG30077@apollon.noc.grnet.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-7
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings to the list,

At my company, we have come across something that we think is a design 
limitation in the way the Linux kernel handles block device caches.  I 
will first describe the incident we encountered, before speculating on 
the actual cause.

As part of our infrastructure, we are running some Linux servers used as 
Xen Dom0s, using SAN LUNs as the VMs' disk images, so these LUNs contain 
normal MBR partition tables. At some point  we came across a VM, that - 
due to a misconfiguration of GRUB - failed on a reboot. We used 
multipath-tools' kpartx to create a device-mapper device pointing to the 
first partition of the LUN, mounted the filesystem, changed 
boot/grub/menu.lst, unmounted it and proceeded to boot the VM once more.  
To our surprise, Xen's pygrub showed the boot menu exactly as it was 
before the changes we made. We double-checked that the changes we made 
were indeed there and tried to find out what was actually going on.

As it turned out, the LUN device's read buffers had not been updated;  
losetup'ing the LUN device with the proper offset to the first partition 
and mounting it gave us exactly the image of the filesystem as it was 
_before_ our changes. We started digging into the kernel's buffer 
internals and came along the conclusion [1] that every block device  has 
its own pagecache, attached to a hash of (major,minor), that is 
independent from the caches of its containing or contained devices.  

Now, in practice one rarely - if ever - accesses the same data from 
these two different paths (disk + partition), except in scenarios like 
this. However currently there seems to be an implicit assumption that 
these two paths should not be used in the same "uptime" cycle at all, at 
least not without dropping the caches.  For the record, I managed to 
reproduce the whole issue by reading a single block through sda, dd'ing 
random data to it through sda1 and re-reading it through sda: its 
contents were intact (even hours later) and were up-to-date only when 
using O_DIRECT and finally when I dropped all caches (using 
/proc/sys/vm/drop_caches).

And now we come to the question part: Can someone please verify that the 
above statements are correct, or am I missing something? If they are, 
should it perhaps be the case that the partition's buffers somehow be 
linked with those of the containing device, or even be part of them? I 
don't even know if this is possible without significant overhead in the 
page cache (of which my understanding is very shallow), but keep in mind 
that this behaviour almost led to filesystem corruption (luckily we only 
changed a single file and hit a single inode).

Thank you for your time. Cheers,
Apollon

PS: I am not subscribed to the list, so I would appreciate if you could 
    Cc any answers to my address.


[1] If I interpret the contents of fs/buffer.c and 
include/linux/buffer_head.h correctly. Unfortunately, I'm not a kernel 
hacker, so I apologise if I'm mistaken at this point.

-- 
-----------------------------------------------------------
 Apollon Oikonomopoulos - GRNET Network Operations Centre
 Greek Research & Technology Network - http://www.grnet.gr
----------------------------------------------------------- 
