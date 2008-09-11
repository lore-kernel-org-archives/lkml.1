Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYIKTK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYIKTK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYIKTKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:10:51 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:34097 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753365AbYIKTKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:10:50 -0400
Date: Thu, 11 Sep 2008 15:10:49 -0400
To: Harun Scheutzow <harun04@scheutzow.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: vfat file system extreme fragmentation on multiprocessor
Message-ID: <20080911191049.GB31271@csclub.uwaterloo.ca>
References: <0ML29c-1KdqyO1YV1-0001g5@mrelayeu.kundenserver.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ML29c-1KdqyO1YV1-0001g5@mrelayeu.kundenserver.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 08:01:16PM +0200, Harun Scheutzow wrote:
> I like to share the following observation made with different kernels of 2.6.x series, a T7100 Core2Duo CPU (effectively 2 processors). I have not seen such a post while searching.
> 
> Two applications compress data at the same time and try to do their best to avoid fragmenting the file system by writing blocks of 50 MByte to a VFAT (FAT32) partition on SATA harddisk, cluster size 8 KByte. Resulting file size is 200 to 250 MByte. It is ok to get 4 to 5 fragments per file. But at random, approximately at every 4th file, there are a few 100 up to more than 4500 (most likely case approx 1500) fragments for each of the two files written in parallel.
> 
> My best guess: In this case both CPU cores were in the cluster allocation function of the fat file system at (nearly) the same time, allocating only a few clusters (guess 8) for their file before the other core got the next. The compression task is CPU bound. The harddisk could probably cater 4 cores. This reverses for decompression.
> 
> The files are ok, no corruption, just heavy fragmentation. I know vfat is not liked very much. Nevertheless I like to hope someone with more Linux kernel coding experience than me fixes this in the future.
> 
> vfat still seems to be the reliable way for data exchange accross platforms (anyone an ext2 driver for Win up to Vista which does not trash the f.s. every few days, or a reliable NTFS for Linux?). Anyway, it is a general design issue on SMP systems one should not forget.
> 
> I tried the same to an ext2 f.s.. It showed only very little fragmentation, most files were 1 piece, well done!
> 
> Best Regards, Harun Scheutzow

I don't think fat filesystems have any concept of reserving space for
expanding files.  It's a pretty simple filesystem after all designed for
a single cpu machine with a non-multitasking OS (if you can call DOS an
OS).  Space tends to be allocated from the start of the disk wherever
free space is found since otherwise you would have to go searching for
the free space, which isn't that efficient.

ext2 of course was designed to avoid fragmentation and has lots of fancy
things like cylinder groups, and reserving space and such as far as I
understand it.

Now what would happen if you used ftruncate to extend the file you open
to a large size, and then started writing it, and then set the size
correctly at the end?  Or if you simply used ftruncate to make the file
50MB initially, then wrote data until you hit 50MB, then extended it to
100MB, wrote more data, and so on, and at the end truncate to the
correct length?  My guess would be that the ftruncate call would go
allocate all the clusters for you right away and reserve the space,
after which you can go fill in those clusters with real date.  That if
it works ought to reduce the number of fragments you get.

Of course avoiding fragments on a filesystem that is practically
designed to fragment isn't going to be easy.

-- 
Len Sorensen
