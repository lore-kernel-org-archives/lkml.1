Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbZDDMkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbZDDMkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 08:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZDDMkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 08:40:09 -0400
Received: from rtr.ca ([76.10.145.34]:55333 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbZDDMkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 08:40:08 -0400
Message-ID: <49D75523.70705@rtr.ca>
Date: Sat, 04 Apr 2009 08:40:03 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       torvalds@linux-foundation.org, tytso@mit.edu, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>	<20090326174704.cd36bf7b.akpm@linux-foundation.org>	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>	<20090326182519.d576d703.akpm@linux-foundation.org>	<20090401210337.GB3797@csclub.uwaterloo.ca>	<20090401143622.b1885643.akpm@linux-foundation.org>	<20090401225737.GC3797@csclub.uwaterloo.ca>	<49D6214A.9030204@rtr.ca>	<20090403151648.GJ3795@csclub.uwaterloo.ca>	<49D65C80.4080003@garzik.org> <20090404011838.9c39a78a.akpm@linux-foundation.org>
In-Reply-To: <20090404011838.9c39a78a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 03 Apr 2009 14:59:12 -0400 Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Lennart Sorensen wrote:
>>> On Fri, Apr 03, 2009 at 10:46:34AM -0400, Mark Lord wrote:
>>>> My Myth box here was running 2.6.18 when originally set up,
>>>> and even back then it still took *minutes* to delete large files.
>>>> So that part hasn't really changed much in the interim.
>>>>
>>>> Because of the multi-minute deletes, the distro shutdown scripts
>>>> would fails, and power off the box while it was still writing
>>>> to the drives.  Ouch.
>>>>
>>>> That system has had XFS on it for the past year and a half now,
>>>> and for Myth, there's no reason not to use XFS.  It's great!
>>> Mythtv has a 'slow delete' option that I believe works by slowly
>>> truncating the file.  Seems they believe that ext3 is bad at handling
>>> large file deletes, so they try to spread out the pain.  I don't remember
>>> if that option is on by default or not.  I turned it off.
>> It's pretty painful for super-large files with lots of metadata.
>>
> 
> yeah.
> 
> There's a dirty hack you can do where you append one byte to the file
> every 4MB, across 1GB (say).  That will then lay the file out on-disk as
> 
> one bitmap block
> one data block
> one bitmap block
> one data block
> one bitmap block
> one data block
> one bitmap block
> one data block
> <etc>
> lots-of-data-blocks
> 
> So when the time comes to delete that gigabyte, the bitmaps blocks are
> only one block apart, and reading them is much faster.
> 
> That was one of the gruesome hacks I did way back when I was in the
> streaming video recording game.
> 
> Another was the slow-delete thing.
> 
> - open the file
> 
> - unlink the file
> 
> - now sit in a loop, slowly nibbling away at the tail with
>   ftruncate() until the file is gone.
> 
> The open/unlink was there so that if the system were to crash midway,
> ext3 orphan recovery at reboot time would fully delete the remainder of
> the file.
..

That's similar to what Mythtv currently does.
Except it nibbles away in painfully tiny chunks,
so deleting takes hours that way.

Which means it's still in progress when the system
auto-shutdowns between uses.  So the delete process
gets killed, and the subsequent remount,ro and umount
calls simply fail (fs is still busy), and it then
powers off while the drive light is still solidly busy.

That's where I modified the shutdown script to check
the result code, sleep, and loop again, for up to five
minutes before pulling the plug.

But switching to xfs cured all of that.  :)
