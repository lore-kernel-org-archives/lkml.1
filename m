Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZHMGLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZHMGLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZHMGLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:11:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:55434 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbZHMGLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:11:43 -0400
From: Neil Brown <neilb@suse.de>
To: tomerma1@tau.ac.il (Tomer Margalit)
Date: Thu, 13 Aug 2009 16:11:55 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19075.44715.906342.101666@notabene.brown>
Cc: linux-kernel@vger.kernel.org, nzaidenberg@mac.com,
       Nezer.Zaidenberg@edfenergy.com, scipioenterprises@yahoo.com,
       tomerma1@post.tau.ac.il
Subject: Re: Asynchronous Mirror
In-Reply-To: message from Tomer Margalit on Friday August 7
References: <20090807172938.GA1882@localhost.localdomain>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday August 7, tomerma1@tau.ac.il wrote:
> Hi,
> 
> I am currently writing a (BSD licensed) asynchronous mirror device, as part of a workshop for Tel Aviv University (under the direction of Nezer Zaidenberg).

You are aware, I assume, that the Linux kernel already contains this
functionality as part of 'md', and is likely to gain a second
implementation in DRDB shortly..

Of course that doesn't mean you shouldn't enjoy yourself writing your
own.


> 
> The purpose of the device is to be able to attach to an existing device, intercept the incoming writes, and send them to a remote location (and remote here means other side of the world).
> The asynchronous part is that the device keeps a window of about a minute of writes and makes sure it sends all of it (if more writes are recieved while the window is full, they are blocked until the it clears).
> 
> I am in charge of writing the kernel part of it, and so ive written an alpha version (Located in "http://www.cs.tau.ac.il/~tomerma1/amirror_src.zip")).
> 
> Right now the driver is designed like this (right now it is designed only for one asynchronous mirror device):
> There are two modules. The main module creates a device on top of the target device, intercepts writes, and puts them in a kernel buffer (several dozen pages - but will be changed to the whole window to save copies).
> The other module creates a device, only to be used by a daemon. The daemon allocates a buffer (the send window) and creates two threads - one ioctls the other module, and stays in the ioctl. The ioctl/daemon thread continously copies the kernel buffer to the daemon buffer. The other thread just sends whatever is in the send buffer.
> 
> Right now im trying to get rid of the other module and put the ioctl in the main module (and just tell the daemon to ioctl the main module).
> However, this causes a problem that i cant explain...
> When i do a write to the device (offset: 0, data: "a" (len: 1)), the following thing happens:
> 1) The device is opened.
> 2) A read is issued (as it should to get the data that must be rewritten in the rest of the page ).
> 3) The device is closed and the write ends successfully.
> 4) 30+ seconds afterwards the actual write is recieved.
> 
> When i use two modules, this never happens - the write comes before the device is closed, and (i think, no proof though) the write ends after the write is issued. Needless to say that i added an idle ioctl that just waits to the two-module version and the same thing (as the single-module version) happens (hinting that the ioctl is changing some things).
> 

I suspect the important difference isn't the ioctl but rather the fact
that your daemon is keeping the device open.
When you open /dev/whatever and write, the data is stored in the page
cache and doesn't get sent to the device until the page is flushed,
usually after 30 seconds.
However when the last close on a block device happens (so there are no
longer any open filedescriptors on the device) it flushes all cached
pages immediately.
This explains what you see.


> Since it seems like the ioctl causes the problem i will probably change the ioctl to spawn a kernel thread and work from there (hoping that will solve it).
> 
> (BTW, im using a custom make_request function (i call blk_queue_make_request)).
> 
> I would appreciate it if you could help me with the following:
> 1) Why is the ioctl causing this sort of behavior (if there is no ioctl in the same module it seems to be ok...)?

It isn't the ioctl, it is the fact that the device is being held open.

> 2) Does the custom make_request function promise me that EVERY bio recieved by the device is directly handed to my make_request function? Or is there some kind of schedualer that hands me the requests (I looked at the I/O schedualer algorithm in the biodoc.txt, but it seems to be relevant only for devices that use a request_queue)?

Every bio received should be passed on immediately.  However writes to
a file or to /dev/XXX don't get translated into a bio immediately.


> 3) I saw (in the generic_make_request code) that only one make request can be active at a time... Is that something i can/should base my code on?

I guess you are talking about the recursion prevention...
If the code in the make_request function tries to call
generic_make_request on another device then that request is queued
until the first make_request completes.
You shouldn't need to worry about this in your code.


> 4) Can generic_make_request be called several times? Cause in the code 
> (blk-core.c) the first line checks that current->bio_tail is non-null and then dereferences, and the last line changes it to null.. If generic_make_request can be called several times then how do you know that they cant mess each other up (i havent seen any locking (in the low level at least))?

'current' is a per-thread data structure.  There is never any
contention accessing it so no locking is needed.

> 5) I have assumed in the code that the bios that i get are sector aligned and are in sector multiples... Is that a correct assumption? (cause i havent seen an exact statement that that is the case anywhere...) Also (sorry, silly question, but i dont like assuming things) would it be valid to assume that the size of a page (kmap(p) where p is struct page) is PAGE_SIZE (or more specifically, is the maximal length for a single bio_vec PAGE_SIZE?)?

Yes, bios are sector aligned and bi_size is a multiple of 512.
Each page in bio_vec is PAGE_SIZE though offset/size may point to a
subrange of that page.

> 6) Im currently using generic_make_request to resubmit a bio (or returning non-zero in make_request and changing bi_bdev to the target)... Does it resubmit it to the request_queue in the usual way? Or does it bypass it somehow?

I think that answer it 'yes', but I'm not certain what you mean.


> 7) About my open and release, i thought that the proper thing to put there is the target device's open and release (so that target device can prepare), but as far as i could see, in the raid implementation (md.c i think), the open and release methods dont tell the underlying devices to open/release... So, should i forget about it? or is it important?

See lock_rdev in md.c
It calls open_by_devnum from fs/block_dev.c
This call blkdev_get which called the ->open routine of the underlying device.

> 8) I dont use procfs or sysfs at all, and i intend on using only ioctls for special commands... However in several places it was written that sysfs is supposed to introduce standartization to the driver model (didnt really try to understand it cause ioctls are fine by me)... Should i reconsider not using sysfs/procfs?

If you want this accepted in to mainline (which would seem pointless
as we have 2 async-mirrors as I have already said), then using sysfs
(not procfs) would be advised, rather than ioctl.
If you are just doing it for your own education, then do whatever you
like.

NeilBrown


> 9) Any suggestions for the code/interesting features would be most welcome.
> 
> Thanks in advance,
>          Tomer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
