Return-Path: <linux-kernel-owner+w=401wt.eu-S1761021AbXIVG25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021AbXIVG25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 02:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbXIVG2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 02:28:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:11644 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbXIVG2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 02:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p4FDD6RR0/ygbfqIT704CW/7xP3pn4Ke25Xro9C5NCi/fQmzarh+b/B1vC5ClJ6KjLmduYLivVfoLPZii3tgGMf7UW1B90gGTbQO7Z57lhFE/nYC/F3SKrCgimDzarnxrk8Bzsu0eji+SS+VN84uVjb+WSAPM8HOXDrROhYB0Fg=
Message-ID: <92cbf19b0709212328w542adf48r7158c79017763a14@mail.gmail.com>
Date: Fri, 21 Sep 2007 23:28:44 -0700
From: "Chakri n" <chakriin5@gmail.com>
To: "Trond Myklebust" <Trond.Myklebust@netapp.com>
Subject: Re: [NFS] NFS on loopback locks up entire system(2.6.23-rc6)?
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1190398453.6690.12.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92cbf19b0709201722k6265e647x31b7d25bc54b63a0@mail.gmail.com>
	 <1190335423.6763.180.camel@heimdal.trondhjem.org>
	 <92cbf19b0709202012s375c6f54m588987b4bbf552bc@mail.gmail.com>
	 <1190384005.6680.20.camel@heimdal.trondhjem.org>
	 <92cbf19b0709210920p3647788dl11d8c4e0cee1f70f@mail.gmail.com>
	 <1190391881.6680.73.camel@heimdal.trondhjem.org>
	 <92cbf19b0709211106n12b1b4ecxc0d415aa097d21b2@mail.gmail.com>
	 <1190398453.6690.12.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/07, Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> No. The requirement for 'hard' mounts is not that the server be up all
> the time. The server can go up and down as it pleases: the client can
> happily recover from that.
>
> The requirement is rather that nobody remove it permanently before the
> application is done with it, and the partition is unmounted. That is
> hardly unreasonable (it is the only way I know of to ensure data
> integrity), and it is much less strict than the requirements for local
> disks.

Yes. I completely agree. This is required for data consistency.

But in my testing, if one of the NFS server/mount goes offline for
some point of time, the entire system slows down, especially IO.

In my test program, I forked off 50 threads to do 4K writes on 50
different files in a NFS mounted directory.

Now, I have turned off the NFS server and started another dd process
on local disk ("dd if=/dev/zero of=/tmp/x count=1000") and this dd
process progresses.

I see I/O wait of 100% in vmstat.
procs -----------memory---------- ---swap-- -----io---- --system--
-----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0 21      0 2628416  15152 551024    0    0     0     0   28  344  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0    8  340  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0   26  343  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0    8  341  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0   26  357  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0    8  325  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0   26  343  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0    8  325  0
0  0 100  0

I have about 4Gig of RAM in the system and most of the memory is free.
I see only about 550MB in buffers, rest all is pretty much available.

[root@h46 ~]# free
             total       used       free     shared    buffers     cached
Mem:       3238004     609340    2628664          0      15136     551024
-/+ buffers/cache:      43180    3194824
Swap:      4096532          0    4096532

Here is the stack trace for one of my test program threads and dd
process, both of them are stuck in congestion_wait.
--------------------------------------
PID: 3552   TASK: cb1fc610  CPU: 0   COMMAND: "dd"
 #0 [f5c04c38] schedule at c0624a34
 #1 [f5c04cac] schedule_timeout at c06250ee
 #2 [f5c04cf0] io_schedule_timeout at c0624c15
 #3 [f5c04d04] congestion_wait at c045eb7d
 #4 [f5c04d28] balance_dirty_pages_ratelimited_nr at c045ab91
 #5 [f5c04d7c] generic_file_buffered_write at c0457148
 #6 [f5c04e10] __generic_file_aio_write_nolock at c04576e5
 #7 [f5c04e84] generic_file_aio_write at c0457799
 #8 [f5c04eb4] ext3_file_write at f8888fd7
 #9 [f5c04ed0] do_sync_write at c0472e27
#10 [f5c04f7c] vfs_write at c0473689
#11 [f5c04f98] sys_write at c0473c95
#12 [f5c04fb4] sysenter_entry at c0404ddf
------------------------------------------
 #0 [f6050c10] schedule at c0624a34
 #1 [f6050c84] schedule_timeout at c06250ee
 #2 [f6050cc8] io_schedule_timeout at c0624c15
 #3 [f6050cdc] congestion_wait at c045eb7d
 #4 [f6050d00] balance_dirty_pages_ratelimited_nr at c045ab91
 #5 [f6050d54] generic_file_buffered_write at c0457148
 #6 [f6050de8] __generic_file_aio_write_nolock at c04576e5
 #7 [f6050e40] enqueue_entity at c042131f
 #8 [f6050e5c] generic_file_aio_write at c0457799
 #9 [f6050e8c] nfs_file_write at f8f90cee
#10 [f6050e9c] getnstimeofday at c043d3f7
#11 [f6050ed0] do_sync_write at c0472e27
#12 [f6050f7c] vfs_write at c0473689
#13 [f6050f98] sys_write at c0473c95
#14 [f6050fb4] sysenter_entry at c0404ddf
-----------------------------------

Can this be worked around, since most of the RAM is available, dd
process could infact find more memory for it's buffers rather than
waiting due to NFS requests. I believe this could be one reason why
file systems like VxFS use their own buffer cache different from
system-wide buffer cache.

Thanks
--Chakri
