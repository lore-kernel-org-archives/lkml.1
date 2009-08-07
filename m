Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbZHGR3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbZHGR3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZHGR3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:29:40 -0400
Received: from anna.cs.tau.ac.il ([132.67.192.229]:46222 "EHLO cs.tau.ac.il"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751631AbZHGR3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:29:39 -0400
Date: Fri, 7 Aug 2009 20:29:38 +0300
To: linux-kernel@vger.kernel.org
Cc: nzaidenberg@mac.com, Nezer.Zaidenberg@edfenergy.com,
       scipioenterprises@yahoo.com, tomerma1@post.tau.ac.il
Subject: Asynchronous Mirror
Message-ID: <20090807172938.GA1882@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="Kernel Mail"
User-Agent: Mutt/1.5.18 (2008-05-17)
From: tomerma1@tau.ac.il (Tomer Margalit)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am currently writing a (BSD licensed) asynchronous mirror device, as part of a workshop for Tel Aviv University (under the direction of Nezer Zaidenberg).

The purpose of the device is to be able to attach to an existing device, intercept the incoming writes, and send them to a remote location (and remote here means other side of the world).
The asynchronous part is that the device keeps a window of about a minute of writes and makes sure it sends all of it (if more writes are recieved while the window is full, they are blocked until the it clears).

I am in charge of writing the kernel part of it, and so ive written an alpha version (Located in "http://www.cs.tau.ac.il/~tomerma1/amirror_src.zip")).

Right now the driver is designed like this (right now it is designed only for one asynchronous mirror device):
There are two modules. The main module creates a device on top of the target device, intercepts writes, and puts them in a kernel buffer (several dozen pages - but will be changed to the whole window to save copies).
The other module creates a device, only to be used by a daemon. The daemon allocates a buffer (the send window) and creates two threads - one ioctls the other module, and stays in the ioctl. The ioctl/daemon thread continously copies the kernel buffer to the daemon buffer. The other thread just sends whatever is in the send buffer.

Right now im trying to get rid of the other module and put the ioctl in the main module (and just tell the daemon to ioctl the main module).
However, this causes a problem that i cant explain...
When i do a write to the device (offset: 0, data: "a" (len: 1)), the following thing happens:
1) The device is opened.
2) A read is issued (as it should to get the data that must be rewritten in the rest of the page ).
3) The device is closed and the write ends successfully.
4) 30+ seconds afterwards the actual write is recieved.

When i use two modules, this never happens - the write comes before the device is closed, and (i think, no proof though) the write ends after the write is issued. Needless to say that i added an idle ioctl that just waits to the two-module version and the same thing (as the single-module version) happens (hinting that the ioctl is changing some things).

Since it seems like the ioctl causes the problem i will probably change the ioctl to spawn a kernel thread and work from there (hoping that will solve it).

(BTW, im using a custom make_request function (i call blk_queue_make_request)).

I would appreciate it if you could help me with the following:
1) Why is the ioctl causing this sort of behavior (if there is no ioctl in the same module it seems to be ok...)?
2) Does the custom make_request function promise me that EVERY bio recieved by the device is directly handed to my make_request function? Or is there some kind of schedualer that hands me the requests (I looked at the I/O schedualer algorithm in the biodoc.txt, but it seems to be relevant only for devices that use a request_queue)?
3) I saw (in the generic_make_request code) that only one make request can be active at a time... Is that something i can/should base my code on?
4) Can generic_make_request be called several times? Cause in the code 
(blk-core.c) the first line checks that current->bio_tail is non-null and then dereferences, and the last line changes it to null.. If generic_make_request can be called several times then how do you know that they cant mess each other up (i havent seen any locking (in the low level at least))?
5) I have assumed in the code that the bios that i get are sector aligned and are in sector multiples... Is that a correct assumption? (cause i havent seen an exact statement that that is the case anywhere...) Also (sorry, silly question, but i dont like assuming things) would it be valid to assume that the size of a page (kmap(p) where p is struct page) is PAGE_SIZE (or more specifically, is the maximal length for a single bio_vec PAGE_SIZE?)?
6) Im currently using generic_make_request to resubmit a bio (or returning non-zero in make_request and changing bi_bdev to the target)... Does it resubmit it to the request_queue in the usual way? Or does it bypass it somehow?
7) About my open and release, i thought that the proper thing to put there is the target device's open and release (so that target device can prepare), but as far as i could see, in the raid implementation (md.c i think), the open and release methods dont tell the underlying devices to open/release... So, should i forget about it? or is it important?
8) I dont use procfs or sysfs at all, and i intend on using only ioctls for special commands... However in several places it was written that sysfs is supposed to introduce standartization to the driver model (didnt really try to understand it cause ioctls are fine by me)... Should i reconsider not using sysfs/procfs?
9) Any suggestions for the code/interesting features would be most welcome.

Thanks in advance,
         Tomer
