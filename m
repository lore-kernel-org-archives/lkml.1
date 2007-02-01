Return-Path: <linux-kernel-owner+w=401wt.eu-S1422948AbXBAXu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422948AbXBAXu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 18:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422963AbXBAXu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 18:50:56 -0500
Received: from patroclus.tjworld.net ([84.12.34.246]:62108 "EHLO phwoarrr.tv"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422948AbXBAXuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 18:50:55 -0500
Subject: Re: [PATCH 1/1] filesystem: Disk Errors at boot-time caused by
	probe of partitions
From: TJ <linux@tjworld.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Neil Brown <neilb@suse.de>
In-Reply-To: <20070201142648.7d16e4b6.akpm@osdl.org>
References: <1170287439.13764.24.camel@butch.lan.tjworld.net>
	 <20070201142648.7d16e4b6.akpm@osdl.org>
Content-Type: text/plain
Organization: TJworld
Date: Thu, 01 Feb 2007 23:50:38 +0000
Message-Id: <1170373838.30201.45.camel@butch.lan.tjworld.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-Server: High Performance Mail Server - http://surgemail.com r=-2006397171
X-Authenticated-User: tj@tjworld.net 
X-DNS-Paranoid: DNS lookup didn't match (84.12.34.243)->(dns2.hornytunes.com)->()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 14:26 -0800, Andrew Morton wrote:

> The recursion is a concern.  Is there any way in which a cunningly-crafted
> device can cause sufficiently deep recursion to crash the kernel?

I did wonder about this, but couldn't think of an *elegant* way of
mirroring the extended_partition logic that would cope with any changes
to its implementation in msdos.c in the future, without someone paying
attention and knowing to manually change it in check_sane_values().

I could manually reflect the current policy, which appears to allow MBR
+extended+extended as the current limit?

> Also, from reading the replies I think we'd like to see some more
> explanation of why this is necessary: are you really really sure that those
> disks were incorrectly handling illegal sector numbers?

Yes. Without this patch during boot the kernel log is full of Disk
Errors - thousands of them - which even when I increased the kernel log
size to 1MB sometimes couldn't cope.

I've thought of recording the noise it makes because for anyone familiar with drives
it makes you want to reach for the power-off switch immediately - its not healthy, and
as I reported, does lead to physical issues too.

The errors report the physical and logical sectors, which made it easy
to understand early-on what was happening (seek requests originating in file-system logic),
but it took much longer to identify the *why*.

---- short extract ---
DC202XX: Primary channel reset.
ide2: reset: success
hde: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest
Error }
hde: task_in_intr: error=0x04 { DriveStatusError }
ide: failed opcode was: unknown
end_request: I/O error, dev hde, sector 238276076
printk: 8 messages suppressed.
Buffer I/O error on device hde2, logical block 47279294
hde: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest
Error }
hde: task_in_intr: error=0x04 { DriveStatusError }
ide: failed opcode was: unknown
hde: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest
Error } 
-----------

The log-buffer overflow in itself is a big block on identifying the
actions that occur before the errors start, because if you don't have
the time and skills to build a new kernel with increased log size and
debugging there is no clue as to the reason.
I had to stick with it because the array contains partitions and data
from a Windows 2003 Server installation that had to be maintained - 
couldn't just 'reformat'.

You can see the original bug report in the Ubuntu bug-tracker where I've
posted the findings and experience during the ongoing hunt for the cause
of the errors, where it shows *small* extracts of the errors being seen.

https://launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/77734

See particularly the additional comment I made dated 
2007-01-25 18:35:54 UTC where I narrowed down the errors to only
affecting 8 unique sector addresses, repeated thousands of times.

Comparing those 8 unique sector addresses with the known partition
layout and file-systems on the disks helped me determine roughly what
was going on, which is when I switched my attention to the detection of
the partitions themselves.

>  Knowing the IBM and Maxtor model numbers might be useful.

The Model number is Maxtor 6Y060L0.

I'm afraid I don't have the IBM model numbers because that system was
only used briefly to boot from a Flash-RAM card because it had a
matching FastTrak controller and RAID 1+0 array already defined.

> I assume you were using a driver in drivers/ide/?  Perhaps this is really
> an IDE-layer bug.

It is the 'generic' code within drivers/ide/ that issues requests to the drives.

In the early stages I did consider hacking the ide-disk code to just
stop it attempting to request 'illegal' sectors, but that would have
been ugly, could have caused unforeseen consequences, and didn't deal
with the true issue, which is simply a lack of bounds-checking.

If this was a memory buffer bounds-checking would be a priority, but the
partition structure code neglected to do any, which is the root cause of
the issue.

When I started hunting this bug I dropped calls to dump_stack() in the
functions generating the errors, but they turned out to be the interrupt
task handlers (as you'll see in the Ubuntu bug report) which only led to
the work_queue.

The thrashing of the heads comes on some time after (in kernel terms)
the partition is scanned so I was focusing on the file-system, etc., and
thinking the issue was in one of the init scripts.

It took me a long while to track it back to the results of the partition
scan, but as soon as I implemented this patch the problem stopped and
the drives initialise properly.

TJ.

