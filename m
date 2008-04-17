Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYDQIoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYDQIoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbYDQInw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:43:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:14663 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756420AbYDQInt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=ld735bcRX2N2JzMc2rT/2UabcH9kLP2klnjFS3e7YfWq0UxcWCmPG2rZLxQ2Z+5Yu2ytdBqfBfbSuqXyFo0yorCJQQ6DljP9g857eewExp1eIzquALhiKGqCIVtXBMeJkVuYUT2fwdrxEQBccAeU+Oz/aL10Hpa8zcz+YdA3Y4I=
Message-ID: <48070DBE.7000804@tuffmail.co.uk>
Date: Thu, 17 Apr 2008 09:43:42 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
CC: Scott Lovenberg <scott.lovenberg@gmail.com>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: RFC: Self-snapshotting in Linux
References: <ajbvb-3Ur-21@gated-at.bofh.it> <ajd42-7Gt-49@gated-at.bofh.it>	 <db1091b2-68a6-4f71-800e-c4df6f8641ca@m44g2000hsc.googlegroups.com>	 <804dabb00804160806o39a2c89eg8d3a3387beb7b5cb@mail.gmail.com>	 <20080416195053.GB27967@redhat.com> <48065C64.7010808@gmail.com> <804dabb00804162323r1b6a9d2ta9d4074aafbc67a2@mail.gmail.com>
In-Reply-To: <804dabb00804162323r1b6a9d2ta9d4074aafbc67a2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Teoh wrote:
> On Thu, Apr 17, 2008 at 4:07 AM, Scott Lovenberg
> <scott.lovenberg@gmail.com> wrote:
>   
>>  Vivek Goyal wrote:
>>
>>  On Wed, Apr 16, 2008 at 11:06:05PM +0800, Peter Teoh wrote:
>>
>>
>>  On 4/16/08, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
>>
>>
>>  Scott Lovenberg wrote:
>>
>>
>>
>>  Peter Teoh wrote:
>>
>>  > Maybe you load up another kernel to handle the snapshot, and then hand
>>  > the system back to it afterwards? What do you think?
>>
>>
>> Isn't that just what Ying Huans kexec-based hibernation does?
>>
>>
>>  This list is awesome. After I read up on this kexec-based hibernation
>> thing:
>>
>> http://kerneltrap.org/node/11756
>>
>> I realized it is about the same idea. Some differences though:
>>
>> My original starting point was VMWare's snapshot idea. Drawing an
>> analogy from there, the idea is to freeze and restore back entire
>> kernel + userspace application. For integrity reason, filesystem
>> should be included in the frozen image as well.
>>
>> Currently, what we are doing now is to have a bank of Norton
>> Ghost-based images of the entire OS and just selectively restoring
>> back the OS we want to work on. Very fast - less than 30secs the
>> entire OS can be restored back. But problem is that it need to be
>> boot up - which is very slow. And there userspace state cannot be
>> frozen and restored back.
>>
>> VMWare images is slow, and cannot meet bare-metal CPU/direct hardware
>> access requirements. There goes Xen's virtualization approach as
>> well.
>>
>> Another approach is this (from an email by Scott Lovenberg) - using
>> RELOCATABLE kernel (or may be not?????I really don't know, but idea is
>> below):
>>
>> a. Assuming we have 32G (64bit hardware can do that) of memory, but
>> we want to have 7 32-bit OS running (not concurrently) - so then
>> memory is partition into 8 x 4GB each - the lowest 4GB reserved for
>> the current running OS. Each OS will be housed into each 4G of
>> memory. When each OS is running, it will access its own partition on
>> the harddisk/memory, security concerns put aside. Switching from one
>> OS to another OS is VOLUNTARILY done by the user - equivalent to that
>> of "desktop" feature in Solaris CDE. Restoring back essentially is
>> just copying from each of the 4GB into the lowest 4GB memory range.
>> Because only the lowest 4gb is used, only 32 bit instruction is
>> needed, 64bit is needed only when copying from one 4GB memory
>> partition into the lowest 4GB region, and vice versa. And together
>> with using partitioning of harddisk for each OS, switching among the
>> different OS kernel should be in seconds, much less than 1 minute,
>> correct?
>>
>>
>>  [CCing Huang and Eric]
>>
>> I think Huang is doing something very similar in kexec based hibernation
>> and probably that idea can be extended to achive above.
>>
>> Currently if system has got 4G of memory then one can reserve some
>> amount of RAM, lets say 128 MB (with in 4G) and load the kernel there
>> and let it run from there. Huang's implementation is also targetting
>> the same thing where more than one kernel be in RAM at the same time
>> (in mutually exclusive RAM locations) and one can switch between those
>> kernels using kexec techniques.
>>
>> To begin with, he is targetting co-existence of just two kernels and
>> second kernel can be used to save/resume the hibernated image.
>>
>> In fact, because of RELOCATABLE nature of kernel, you don't have to
>> copy the kernel to lower 4GB of memory (Assuming all 64bit kernels
>> running). At max one might require first 640 KB of memory and that
>> can be worked out, if need be.
>>
>> This will indeed need to put devices into some kind of sleep state so
>> that next kernel can resume it.
>>
>> So I think a variant of above is possible where on a large memory system
>> multiple kernels can coexist (while accessing separate disk partitions)
>> and one ought to be able to switch between kernels.
>>
>> Technically, there are few important pieces. kexec, relocatable kernel,
>> hibernation, kexec based hibernation. First three pieces are already
>> in place and fourth one is under development and after that I think
>> it is just a matter of putting everything together.
>>
>> Thanks
>> Vivek
>>     
>
> Wow...this is amazing discussion...I love it.
>
> Can I asked a few questions?
>
>   
>>  What about the way that the kernel does interrupt masks on CPUs during a
>> critical section of code on SMP machines?  It basically flushes the TLB, and
>> the cache, moves the process in critical section to a (now) isolated CPU,
>>     
>
> 1.   Where is this isolation from multiple running CPU to single
> running CPU currently done in the kernel?   If the CPU are executing
> some inter-CPU order dependent stuff, like memory barriers, then can u
> just freeze them?   And when resuming - is it necessary to restore
> back in the same order?
>
> 2.   At the userspace level, what is the mechanism of freezing (APIs,
> syscall, ioctl) everything - swap, fs, physical memory etc?
>
> I tool a look at s2ram, and saw that it uses ioctl() with
> SNAPSHOT_SET/GET_SWAP_PAGE and all the amazing work done:
>
> http://lkml.org/lkml/2008/1/31/566
>
> which are snapshotting for the swap, how about the fs and physical
> mem...where is it done?   Or is it not necessary to be be done?
>   
Um.  You want to look at s2disk, not s2ram.  s2ram shouldn't really do 
anything with snapshots; it just puts the hardware into a special 
low-power state (or rather, asks the kernel to do so).  If it does any 
snapshotting, that's more a hang-over from s2disk - you should look at 
the original.

At a high level, the answer to your question is that hibernation 
(remember that's the primary use-case here) "snapshots" the system in 
memory, after quiesing processes, some (but not all) kernel threads, and 
DMA, so that nothing can be writing to the memory at the same time.  You 
could call this a snapshot of physical memory, although it will exclude 
certain areas by request of the BIOS.  This snapshot is then written to 
a hibernation file/partition.

You're probably a bit confused about swap because the current swap file 
is usually used to store the hibernation image.  When one talks about 
hibernation the "snapshot" is just the saved state of memory.  The other 
things you ask about - swap and filesystem - are _already_ on disk in a 
consistent, persistent format; you don't need to "snapshot" them.

In theory this is all well documented.  You're probably better off 
getting a better overview starting from published articles or even 
Howtos, rather than asking people to tell you what their code is 
supposed to do - because they already did that when they wrote the 
docs.  I don't know if there's a really great index for hibernation as a 
whole, but you should obviouslly be reading the relevant stuff under 
Documentation/ in the kernel source tree.
>> and reroutes interrupts to another CPU.  If you took that basic model and
>> applied it to kernels instead of CPUs, you could probably get the desired
>> hand off of freezing one after flushing its caches back (or sideways and
>> then back in SMP) and moving the mm to your unfrozen kernel and routing the
>> processes there. After snapshotting, flush the cache back again, and reroute
>> each process to the once again unfrozen kernel, handing them back again?
>> Would this basic model work for isolation and snapshotting and then
>> transitioning back?  Oh, yeah, and block each process so it doesn't try to
>> run anything during snapshot :-).  Or, save PCs and then load them back
>>     
>
> I have not fully understand the detail patch as mentioned above, but
> this blocking of processes - can we just set all the processes to not
> runnable-to-be-resume state, and during resuming just set these back
> to runnable?   Or is more complicated than this?
>
> There are some scenario whereby if the state is broken, it may be
> difficult to be restored back again - eg, TCP/IP state machine.
> while download something, if the network driver just freeze, and later
> restored back again, will it be able to continue where it left off,
> downloading the HTTP continuing from where it left off?   Or SSH
> traffic....?    Can it worked?   Or unless the traffic is
> time-sensitive?  (eg, password within depends on time)
>   
Yah.  I think it can work for short intervals, but in general userspace 
needs to be able to restart network connections.  TCP connections will 
time out for a number of reasons, and your IP address might even 
change.  So you should use a reliable downloader like wget; use screen 
for persistent SSH connections, etc.  General techniques that were 
originally used to cope with unreliable network connections, dialup, etc.

Alan
