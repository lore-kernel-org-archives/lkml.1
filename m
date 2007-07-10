Return-Path: <linux-kernel-owner+w=401wt.eu-S1762104AbXGJDDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762104AbXGJDDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760162AbXGJDDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:03:24 -0400
Received: from smtpout.mac.com ([17.250.248.174]:63315 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170AbXGJDDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:03:23 -0400
In-Reply-To: <200707101207.16711.nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org> <200707061403.15932.nigel@nigel.suspend2.net> <CF605B91-2425-4FC2-9434-5F8877EEEEEB@mac.com> <200707101207.16711.nigel@nigel.suspend2.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4085C761-FB06-4723-8AB0-790B7ACE4FED@mac.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Mon, 9 Jul 2007 23:03:13 -0400
To: nigel@suspend2.net
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the detailed reply!

On Jul 09, 2007, at 22:07:15, Nigel Cunningham wrote:
> On Friday 06 July 2007 15:01:48 Kyle Moffett wrote:
>> Suppose hibernate is implemented like this:
>>
>> (1) Userspace program calls sys_freeze_processes()
>>    (a) Pokes all CPUs with IPMIs and tells them to finish the  
>> currently running timeslot then stop
>>    (b) Atomically sends SIGSTOP to all userspace processes in a  
>> non-trappable way, except the calling process and any process  
>> which is ptracing it.
>>    (c) Returns to the calling process.
>
> Ok. First, I'll ignore the specification that userspace does this -  
> I don't think it matters whether it's userspace or kernel that does  
> the suspending and I'm yet to see a good reason for it to be  
> [required to be] done from userspace.

The reason it's _required_ to be done from userspace is that  
userspace is the only one which can figure out "These processes need  
to run for suspend to work", and then let those processes continue  
running after the freeze.  The *ONLY* reason this even stops  
processes at all is so we can do the post-device-mapper-snapshot code  
with very little usably-free RAM (IE: only about 1MB for a standard  
desktop system).


> In this first step, you've reinvented the first part of the current  
> freezer implementation. The reason we don't use a real signal is  
> precisely so we can have an untrappable SIGSTOP. In this regard, I  
> particularly remember Win4Lin from a few years ago. It would die if  
> you sent it a real signal, so we had to do it this way. No doubt  
> there are other instances I'm not aware of.

Well, you *do* want it to have semi-signal semantics, processes which  
receive it must not get back to userspace code so that they don't  
start allocating more memory when we're trying to do the freeze.  You  
also don't want a process to be able to trap it (IE: like SIGSTOP or  
SIGKILL).

On the other hand, it should be delivered asynchronously (IE: It  
doesn't break an interruptable sleep or respond to most is-a-signal- 
present checks).  You don't actually care if its sleeping in the  
kernel somewhere, just as long as it doesn't allocate much memory.

You would probably need a new signal "SIGFREEZE" which causes the  
process to be ignored as runnable the next time they schedule but  
never actually gets delivered, and a "SIGUNFREEZE" which does the  
reverse.  That way userspace could selectively resume processes based  
on its policy of "this needs to run for hibernation".


>> (2) Userspace process sends SIGCONT to only those processes which  
>> are necessary for sync and a device-mapper snapshot.
>
> How do you determine which ones are needed?

It's userspace's job to know which ones are needed.  For example, if  
you are hibernating over NFS then you need to resume the various NFS/ 
RPC daemons and threads.

> Why stop them in the first place?

So they aren't allocating memory when we are doing the device-mapper  
snapshot.


>> (3) Userspace calls sys_snapshot_kernel(snapshot_overhead_pages)
>>    (a) Kernel starts freeing memory and swapping stuff out to make  
>> room for a copy of *kernel* memory (not pagecache, not process  
>> RAM).   It does the same for at least snapshot_overhead_pages  
>> extra (used by userspace later).  It then allocates this memory to  
>> keep it from going away.  Since most processes are stopped we  
>> won't have much else competing with us for the RAM.
>
> Ok. So now you also need processes running that are needed for  
> swapping, because freeing that memory might involve swapping. Fully  
> agree with the logic though (not really surprising - this is what I  
> do in Suspend2^wTuxOnIce).
>
>>    (a) Kernel uses the device-mapper up-call-into-filesystem  
>> machinery to get all mounted filesystems synced and ready for a DM  
>> snapshot.  This may include sending data via the userspace  
>> processes resumed in (2).  Any deadlocks here are userspace's  
>> fault (see (2)).  Will need some modification to handle doing  
>> multiple blockdevs at a time.  Anything using FUSE is basically  
>> perma-synced anyways (no dep-handling needed), and anything using  
>> loop should already be handled by DM.  This includes allocating  
>> memory for the basic snapshot
>> datastructures.
>>    (b) At this point all blockdev operations should be halted and  
>> disk caches flushed; that's all we care about.
>>    (c) Go through the device tree and quiesce DMA and shut off  
>> interrupts.  Since all the disks are synced this is easy.
>>    (d) Use IPMIs again to get all the CPUs together, which should  
>> be easy as most processes are sleeping in IO or SIGSTOPed, and  
>> we're getting no interrupts.
>>    (e) One CPU turns off all interrupts on itself and takes an  
>> atomic snapshot of kernel memory into the previously allocated  
>> storage.  Once again, does not include pagecache.  The kernel also  
>> records a list of what pages *are* included in the pagecache.  It  
>> then marks all userspace pages as copy-on-write.
>
> Hotplugging cpus (when all those locking issues are taken care of)  
> is simpler.  Prior to cpu hotplugging, I used IMPIs to put  
> secondary cpus into a tight loop, so I know it's possible to do it  
> this way too.

It may be simpler, but it really screws up things like cpusets,  
processor affinity, etc.  It also ties hibernation to the presently  
very-flakey CPU-hotplug support, which is probably not what we want.


> That way, though, you have less flexibility. What if a cpu really  
> is plugged in between hibernate and resume? With cpu hotplugging,  
> it's handled properly and transparently.  Without cpu hotplugging,  
> you could be using uninitialised data after the atomic restore.

IMHO if the user pulls a CPU while the box is hibernated, then he/she  
gets what he/she deserves.  If you really want to support that, then  
the user must do the hotplug operation *manually* before suspending.   
Anything else is just going to be shooting ourselves in the foot  
repeatedly.

> Marking userspace as COW makes things more complicated, too. You  
> then have to add code to the COW handling to update the list of  
> pages that need to be saved, and you reduce the reliability of the  
> whole process. You can't predict beforehand how many of these COW  
> pages are going to be needed, and therefore can't know how much  
> memory to free earlier on in the process. If you run out of memory,  
> what will be the effect?

You could pretty easily have a spare 128MB swap partition somewhere  
which is not used during system operation but is "swapon"ed by  
userspace after the COW snapshot to provide extra backing store.

>>    (f) That CPU finalizes the modified DM snapshot using the  
>> previously-allocated memory.
>>    (g) That CPU frees up the snapshot_overhead_pages memory  
>> allocated during step (a) for userspace to use.
>>    (h) The CPU does the equivalent of a "swapoff -a" without  
>> overwriting any data already on any swap device(s).
>
> You still need to remember what swap you're going to use to write  
> the image. You'll probably want to get this information (and  
> allocate the swap) sooner rather than later so that you're not  
> racing against the memory freeing earlier, and don't run into  
> issues with bmapping the pages or having enough memory to record  
> the bdevs & sector numbers (not usually an issue, but if swap is  
> highly fragmented...).

Who says we have to use this swap to write the image?  That may be  
the default use-case, but it's certainly shouldn't be mandatory.   
Really, for the write-image-to-swap case you would just need to  
preallocate sufficient memory for the bmap tables beforehand, then  
populate them at this phase.

>>    (i) The CPU then IPMI-signals the other CPUs to wake them up
>>    (j) The kernel returns a FD-reference to the snapshot and the  
>> read-only halves of the CoW pagecache to the process which called  
>> sys_snapshot_kernel().
>
> Readonly halves? I don't get that, sorry.

Well, each page is copy-on-write, so the FD reference would always  
provide access to the original page data, whereas the processes may  
end up copying the page so they can write to it.  The trick would be  
that shared pages need to remain shared between processes even after  
the copy-on-write.  This is likely to be the trickiest part.

>> (4) The userspace process now has a reference to the copy of the  
>> kernel pages and the unmodified pagecache pages.  Since 99% of the  
>> processes aren't running, we aren't going to be having to CoW many  
>> of the pagecache pages.
>
> Mmm, but you still don't know how many.

Yes, but at this point we're basically running a segment of userspace  
with full kernel services available.  Like I said above we can just  
add a dedicated 128MB swap device to provide some spare backing  
store.  When you start running low on memory it might even page out  
to the swap device a part of the atomic copy of kernel memory.

>> (5) The userspace process uses read() or other syscalls to get  
>> data out of the kernel-snapshot FD in small chunks, within its  
>> snapshot_overhead_pages limit.  It compresses these and writes  
>> them out to the snapshot-storage blockdev (must not be mounted  
>> during snapshot), or to any network server.
>>
>> (6) The userspace process syncs the disks and halts the system.   
>> Any changed filesystem pages after the pseudo-DM-snapshot should  
>> have been stored in semi-volatile storage somewhere and will be  
>> discarded on the next reboot.
>
> Are you thinking the changed filesystem pages are caught by COW?  
> (AFAIUI, kernel writes aren't). If (as I expect), you're thinking  
> about filesystem writes to DM based storage, what about non DM- 
> based filesystem pages?

No, but a kernel write to a DM-snapshot calls the DM-snapshot code  
which copies the segment(s) to the snapshot device and modifies them  
there.  Basically disk-filesystem pagecache pages would be synced and  
protected by the DM snapshot, while anonymous memory pages would be  
CoW-ed.  And it might not be an unreasonable requirement to state  
that the disk-based filesystems must all be mapped through DM- 
snapshot devices (even just straight 1:1 linear mappings), so that  
they can be trivially snapshotted.

>> So basically your hibernate-overhead would consist of:
>>    (1) The pages necessary for the atomic snapshot of kernel  
>> memory and the list of pagecache pages at that time
>>    (2) A little memory necessary for the kernel non-persistent DM  
>> snapshot datastructures.
>>    (3) The snapshot_overhead_pages needed by userspace.
>>
>> If you're using swap devices then you can save 99% of the state of  
>> the running kernel with an initial swapout overhead of virtually  
>> nothing beyond the size of the unswappable kernel memory.
>
> FWIW, let me note an important variation from how Suspend2 works;  
> it might provide food for thought. In Suspend2, we treat the  
> processes that remain stopped throughout the whole process  
> specially. We write their data to disk before the atomic copy  
> (usually 70 or 80% of memory), and then use the memory they occupy  
> for the destination of the atomic copy. This further reduces the  
> amount of memory that has to be freed, almost always to zero.

I suppose you could record swap-outs done to SIGFREEZEd processes  
specially, so that they would be swapped in again before resuming  
userspace.  That would effectively result in the same thing.

Cheers,
Kyle Moffett


