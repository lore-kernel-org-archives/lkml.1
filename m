Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbYCEOVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbYCEOVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 09:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYCEOVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 09:21:02 -0500
Received: from n5a.bullet.mud.yahoo.com ([209.191.126.232]:39541 "HELO
	n5a.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751764AbYCEOVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 09:21:00 -0500
X-Yahoo-Newman-Id: 149527.65394.bm@omp409.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=sVQlD+mTYCCsBfY4pZS/hLuHjC2epEt+TAmM7Yqjg3d+52BARu6VRWdFgPA5Y5SH9a9KbqDO4GjP+DiRfwnxoB0TC5uCRUq/xfQnAbq8OjOMnkv9lCwN4h6E2nM8XsKAge1ZLvrtrOkoDse/d3hNaldrFXUwwXLRbTcIxV6H4jI=  ;
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: Are Linux pipes slower than the FreeBSD ones ?
Date: Thu, 6 Mar 2008 01:20:37 +1100
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, dmantipov@yandex.ru,
       linux-kernel@vger.kernel.org
References: <1389671204703217@webmail34.yandex.ru> <20080305.000014.245410231.davem@davemloft.net> <47CE6C41.3090303@cosmosbay.com>
In-Reply-To: <47CE6C41.3090303@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803060120.38032.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008 20:47, Eric Dumazet wrote:
> David Miller a écrit :
> > From: Antipov Dmitry <dmantipov@yandex.ru>
> > Date: Wed, 05 Mar 2008 10:46:57 +0300
> >
> >> Despite of this obvious fact, recently I've tried to compare pipe
> >> performance on Linux and FreeBSD systems. Unfortunately, Linux
> >> results are poor - ~2x slower than FreeBSD. The detailed description
> >> of the test case, preparation, environment and results are located
> >> at http://213.148.29.37/PipeBench, and everyone are pleased to look
> >> at, reproduce, criticize, etc.
> >
> > FreeBSD does page flipping into the pipe receiver, so rerun your test
> > case but have either the sender or the receiver make changes to
> > their memory buffer in between the read/write calls.
> >
> > FreeBSD's scheme is only good for benchmarks, rather then real life.
>
> page flipping might explain differences for big transferts, but note the
> difference with small buffers (64, 128, 256, 512 bytes)
>
> I tried the 'pipe' prog on a fresh linux-2.6.24.2, on a dual Xeon 5120
> machine, and we can notice that four cpus are used (but only two threads
> are running on this benchmark)

One thing to try is pinning both processes on the same CPU. This
may be what the FreeBSD scheduler is preferring to do, and it ends
up being really a tradeoff that helps some workloads and hurts
others. With a very unscientific test with an old kernel, the
pipe.c test gets anywhere from about 1.5 to 3 times faster when
running it as taskset 1 ./pipe


> # opreport -l /boot/vmlinux-2.6.24.2 |head -n 30
> CPU: Core 2, speed 1866.8 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a
> unit mask of 0x00 (Unhalted core cycles) count 100000
> samples  %        symbol name
> 52137     9.3521  kunmap_atomic

I wonder if FreeBSD doesn't allocate their pipe buffers from kernel
addressable memory. We could do this to eliminate the cost completely
on highmem systems (whether it is a good idea I don't know, normally
you'd actually do a bit of work between reading or writing from a
pipe...)


> 50983     9.1451  mwait_idle_with_hints
> 50448     9.0492  system_call
> 49727     8.9198  task_rq_lock
> 24531     4.4003  pipe_read
> 19820     3.5552  pipe_write
> 16176     2.9016  dnotify_parent

Just say no to dnotify.


> 15455     2.7723  file_update_time

Dumb question: anyone know why pipe.c calls this?


