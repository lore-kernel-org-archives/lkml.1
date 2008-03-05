Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbYCEP4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbYCEP4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbYCEPz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:55:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:36145 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbYCEPz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:55:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=u+FFvO+0ZabrwaVgEtF6P7mF06/7s+3eB0ozUWg+9+9Xm4Bh5lY4Z494gWGZF83Zbpg0xNAuhmfB5IggqI8PhyAqJ6PZ7hWE7ov5/JiXwhUdYu8eOMaSLOzv5jdJLVO2m1vUQS6pv52sHPH1VTmvmROjAWGnscZAVF/EhaoKj7A=
Message-ID: <2c0942db0803050755u7e17118h923328fb79ee206b@mail.gmail.com>
Date: Wed, 5 Mar 2008 07:55:53 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: Are Linux pipes slower than the FreeBSD ones ?
Cc: "Eric Dumazet" <dada1@cosmosbay.com>, "David Miller" <davem@davemloft.net>,
       dmantipov@yandex.ru, linux-kernel@vger.kernel.org
In-Reply-To: <200803060238.39484.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <1389671204703217@webmail34.yandex.ru>
	 <200803060120.38032.nickpiggin@yahoo.com.au>
	 <47CEB449.6060204@cosmosbay.com>
	 <200803060238.39484.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: f0854ff648eff85e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m25FuHnq002194

On Wed, Mar 5, 2008 at 7:38 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:>> On Thursday 06 March 2008 01:55, Eric Dumazet wrote:>  > Nick Piggin a Ã©crit :>  > > On Wednesday 05 March 2008 20:47, Eric Dumazet wrote:>  > >> David Miller a Ã©crit :>  > >>> From: Antipov Dmitry <dmantipov@yandex.ru>>  > >>> Date: Wed, 05 Mar 2008 10:46:57 +0300>  > >>>>  > >>>> Despite of this obvious fact, recently I've tried to compare pipe>  > >>>> performance on Linux and FreeBSD systems. Unfortunately, Linux>  > >>>> results are poor - ~2x slower than FreeBSD. The detailed description>  > >>>> of the test case, preparation, environment and results are located>  > >>>> at http://213.148.29.37/PipeBench, and everyone are pleased to look>  > >>>> at, reproduce, criticize, etc.>  > >>>>  > >>> FreeBSD does page flipping into the pipe receiver, so rerun your test>  > >>> case but have either the sender or the receiver make changes to>  > >>> their memory buffer in between the read/write calls.>  > >>>>  > >>> FreeBSD's scheme is only good for benchmarks, rather then real life.>  > >>>  > >> page flipping might explain differences for big transferts, but note the>  > >> difference with small buffers (64, 128, 256, 512 bytes)>  > >>>  > >> I tried the 'pipe' prog on a fresh linux-2.6.24.2, on a dual Xeon 5120>  > >> machine, and we can notice that four cpus are used (but only two threads>  > >> are running on this benchmark)>  > >>  > > One thing to try is pinning both processes on the same CPU. This>  > > may be what the FreeBSD scheduler is preferring to do, and it ends>  > > up being really a tradeoff that helps some workloads and hurts>  > > others. With a very unscientific test with an old kernel, the>  > > pipe.c test gets anywhere from about 1.5 to 3 times faster when>  > > running it as taskset 1 ./pipe>  > >>  > >> # opreport -l /boot/vmlinux-2.6.24.2 |head -n 30>  > >> CPU: Core 2, speed 1866.8 MHz (estimated)>  > >> Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a>  > >> unit mask of 0x00 (Unhalted core cycles) count 100000>  > >> samples  %        symbol name>  > >> 52137     9.3521  kunmap_atomic>  > >>  > > I wonder if FreeBSD doesn't allocate their pipe buffers from kernel>  > > addressable memory. We could do this to eliminate the cost completely>  > > on highmem systems (whether it is a good idea I don't know, normally>  > > you'd actually do a bit of work between reading or writing from a>  > > pipe...)>  > >>  > >> 50983     9.1451  mwait_idle_with_hints>  > >> 50448     9.0492  system_call>  > >> 49727     8.9198  task_rq_lock>  > >> 24531     4.4003  pipe_read>  > >> 19820     3.5552  pipe_write>  > >> 16176     2.9016  dnotify_parent>  > >>  > > Just say no to dnotify.>  > >>  > >> 15455     2.7723  file_update_time>  > >>  > > Dumb question: anyone know why pipe.c calls this?>  >>  > Because pipe writer calls write() syscall -> file_update_time() in kernel>  > while pipe reader calls read() syscall -> touch_atime() in kernel>>  Yeah, but why does the pipe inode need to have its times updated?>  I guess there is some reason... hopefully not C&P related.
In principle so that the reader or writer can find out the last timethe other end did any processing of the pipe. And yeah, for POSIXcompliance: "Upon successful completion, pipe() will mark for updatethe st_atime, st_ctime and st_mtime fields of the pipe. " But it'd benice if there were a way to avoid touching it more than once a second(note the 'will mark for update' language). Or if the pipe is aphysical FIFO on a noatime filesystem?ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
