Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbXGFFCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbXGFFCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 01:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbXGFFBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 01:01:55 -0400
Received: from smtpout.mac.com ([17.250.248.183]:52464 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbXGFFBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 01:01:54 -0400
In-Reply-To: <200707061403.15932.nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org> <200707060935.12706.nigel@nigel.suspend2.net> <1183694055.3388.108.camel@localhost.localdomain> <200707061403.15932.nigel@nigel.suspend2.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <CF605B91-2425-4FC2-9434-5F8877EEEEEB@mac.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 01:01:48 -0400
To: Nigel Cunningham <nigel@nigel.suspend2.net>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 06, 2007, at 00:03:15, Nigel Cunningham wrote:
> On Friday 06 July 2007 13:54:15 Benjamin Herrenschmidt wrote:
>> On Fri, 2007-07-06 at 09:35 +1000, Nigel Cunningham wrote:
>>>
>>> Nice try :) Okay then, you remove the freezer, try hibernating,  
>>> then get back to me after you've fixed your filesystem because  
>>> some process that wasn't frozen started writing things after the  
>>> atomic copy (making the on disk filesystem inconsistent with the  
>>> snapshot).
>>>
>>> As Pavel rightly said, you can get rid of the freezer, but you're  
>>> only going to have to implement another one that does the  
>>> essentially the same thing, even if it is at some other level.
>>
>> I was mostly talking about STR... Regarding STD, we have a  
>> different problem and we all know it. The freezer is one somewhat  
>> horrible way to get it working for now, I would prefer something  
>> more along the way that blocks the page cache from writing out new  
>> dirty pages though, except those specifically flagged by the  
>> snapshot.
>>
>> That is, some kind of proper snapshotting facility, as linus was  
>> describing some time ago.
>
> The kind of thing Linus was talking about would limit you (as  
> swsusp and uswsusp do now) to only half the amount of memory.

How so?  Suppose hibernate is implemented like this:

(1) Userspace program calls sys_freeze_processes()
   (a) Pokes all CPUs with IPMIs and tells them to finish the  
currently running timeslot then stop
   (b) Atomically sends SIGSTOP to all userspace processes in a non- 
trappable way, except the calling process and any process which is  
ptracing it.
   (c) Returns to the calling process.

(2) Userspace process sends SIGCONT to only those processes which are  
necessary for sync and a device-mapper snapshot.

(3) Userspace calls sys_snapshot_kernel(snapshot_overhead_pages)
   (a) Kernel starts freeing memory and swapping stuff out to make  
room for a copy of *kernel* memory (not pagecache, not process RAM).   
It does the same for at least snapshot_overhead_pages extra (used by  
userspace later).  It then allocates this memory to keep it from  
going away.  Since most processes are stopped we won't have much else  
competing with us for the RAM.
   (a) Kernel uses the device-mapper up-call-into-filesystem  
machinery to get all mounted filesystems synced and ready for a DM  
snapshot.  This may include sending data via the userspace processes  
resumed in (2).  Any deadlocks here are userspace's fault (see (2)).   
Will need some modification to handle doing multiple blockdevs at a  
time.  Anything using FUSE is basically perma-synced anyways (no dep- 
handling needed), and anything using loop should already be handled  
by DM.  This includes allocating memory for the basic snapshot  
datastructures.
   (b) At this point all blockdev operations should be halted and  
disk caches flushed; that's all we care about.
   (c) Go through the device tree and quiesce DMA and shut off  
interrupts.  Since all the disks are synced this is easy.
   (d) Use IPMIs again to get all the CPUs together, which should be  
easy as most processes are sleeping in IO or SIGSTOPed, and we're  
getting no interrupts.
   (e) One CPU turns off all interrupts on itself and takes an atomic  
snapshot of kernel memory into the previously allocated storage.   
Once again, does not include pagecache.  The kernel also records a  
list of what pages *are* included in the pagecache.  It then marks  
all userspace pages as copy-on-write.
   (f) That CPU finalizes the modified DM snapshot using the  
previously-allocated memory.
   (g) That CPU frees up the snapshot_overhead_pages memory allocated  
during step (a) for userspace to use.
   (h) The CPU does the equivalent of a "swapoff -a" without  
overwriting any data already on any swap device(s).
   (i) The CPU then IPMI-signals the other CPUs to wake them up
   (j) The kernel returns a FD-reference to the snapshot and the read- 
only halves of the CoW pagecache to the process which called  
sys_snapshot_kernel().

(4) The userspace process now has a reference to the copy of the  
kernel pages and the unmodified pagecache pages.  Since 99% of the  
processes aren't running, we aren't going to be having to CoW many of  
the pagecache pages.

(5) The userspace process uses read() or other syscalls to get data  
out of the kernel-snapshot FD in small chunks, within its  
snapshot_overhead_pages limit.  It compresses these and writes them  
out to the snapshot-storage blockdev (must not be mounted during  
snapshot), or to any network server.

(6) The userspace process syncs the disks and halts the system.  Any  
changed filesystem pages after the pseudo-DM-snapshot should have  
been stored in semi-volatile storage somewhere and will be discarded  
on the next reboot.

So basically your hibernate-overhead would consist of:
   (1) The pages necessary for the atomic snapshot of kernel memory  
and the list of pagecache pages at that time
   (2) A little memory necessary for the kernel non-persistent DM  
snapshot datastructures.
   (3) The snapshot_overhead_pages needed by userspace.

If you're using swap devices then you can save 99% of the state of  
the running kernel with an initial swapout overhead of virtually  
nothing beyond the size of the unswappable kernel memory.

Cheers,
Kyle Moffett

