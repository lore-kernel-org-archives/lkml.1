Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbYCEPjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbYCEPjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbYCEPjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:39:12 -0500
Received: from n2a.bullet.mail.tp2.yahoo.com ([203.188.202.96]:28783 "HELO
	n2a.bullet.mail.tp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755426AbYCEPjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:39:11 -0500
X-Yahoo-Newman-Id: 584685.43245.bm@omp423.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=PsCQPLcR2JlSryja/l618qnf0XofTPqOJNqHlLIRyopR8nAoy5mEiGjCGo2OkTa3+Jd03PddU6Yh1Nf+0wjgVHf9vRrW8bR/004GfEchrzB3kGDYyDA11T3SzCaaItxB44mzAaJbZSbjb5LejkTw1/RzdpcwG6D8FLoM42YnNeM=  ;
X-YMail-OSG: EXlO0KkVM1l1JaoNhGnyQbN63NZNFVfs7Iy.gDQF8KIYkINkfnngAshC4e1QiJQR8RY5la0DvxLofbu1PIvB4K3HnrLVgAkGa6krSYy_BxYwNvJHNmw17aw1wIpopsFQsCRQq82fC9lgrWVzvrcEyGug
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: Are Linux pipes slower than the FreeBSD ones ?
Date: Thu, 6 Mar 2008 02:38:39 +1100
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, dmantipov@yandex.ru,
       linux-kernel@vger.kernel.org
References: <1389671204703217@webmail34.yandex.ru> <200803060120.38032.nickpiggin@yahoo.com.au> <47CEB449.6060204@cosmosbay.com>
In-Reply-To: <47CEB449.6060204@cosmosbay.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_/5rzHT+0regaSQ3"
Message-Id: <200803060238.39484.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_/5rzHT+0regaSQ3
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 06 March 2008 01:55, Eric Dumazet wrote:
> Nick Piggin a =E9crit :
> > On Wednesday 05 March 2008 20:47, Eric Dumazet wrote:
> >> David Miller a =E9crit :
> >>> From: Antipov Dmitry <dmantipov@yandex.ru>
> >>> Date: Wed, 05 Mar 2008 10:46:57 +0300
> >>>
> >>>> Despite of this obvious fact, recently I've tried to compare pipe
> >>>> performance on Linux and FreeBSD systems. Unfortunately, Linux
> >>>> results are poor - ~2x slower than FreeBSD. The detailed description
> >>>> of the test case, preparation, environment and results are located
> >>>> at http://213.148.29.37/PipeBench, and everyone are pleased to look
> >>>> at, reproduce, criticize, etc.
> >>>
> >>> FreeBSD does page flipping into the pipe receiver, so rerun your test
> >>> case but have either the sender or the receiver make changes to
> >>> their memory buffer in between the read/write calls.
> >>>
> >>> FreeBSD's scheme is only good for benchmarks, rather then real life.
> >>
> >> page flipping might explain differences for big transferts, but note t=
he
> >> difference with small buffers (64, 128, 256, 512 bytes)
> >>
> >> I tried the 'pipe' prog on a fresh linux-2.6.24.2, on a dual Xeon 5120
> >> machine, and we can notice that four cpus are used (but only two threa=
ds
> >> are running on this benchmark)
> >
> > One thing to try is pinning both processes on the same CPU. This
> > may be what the FreeBSD scheduler is preferring to do, and it ends
> > up being really a tradeoff that helps some workloads and hurts
> > others. With a very unscientific test with an old kernel, the
> > pipe.c test gets anywhere from about 1.5 to 3 times faster when
> > running it as taskset 1 ./pipe
> >
> >> # opreport -l /boot/vmlinux-2.6.24.2 |head -n 30
> >> CPU: Core 2, speed 1866.8 MHz (estimated)
> >> Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a
> >> unit mask of 0x00 (Unhalted core cycles) count 100000
> >> samples  %        symbol name
> >> 52137     9.3521  kunmap_atomic
> >
> > I wonder if FreeBSD doesn't allocate their pipe buffers from kernel
> > addressable memory. We could do this to eliminate the cost completely
> > on highmem systems (whether it is a good idea I don't know, normally
> > you'd actually do a bit of work between reading or writing from a
> > pipe...)
> >
> >> 50983     9.1451  mwait_idle_with_hints
> >> 50448     9.0492  system_call
> >> 49727     8.9198  task_rq_lock
> >> 24531     4.4003  pipe_read
> >> 19820     3.5552  pipe_write
> >> 16176     2.9016  dnotify_parent
> >
> > Just say no to dnotify.
> >
> >> 15455     2.7723  file_update_time
> >
> > Dumb question: anyone know why pipe.c calls this?
>
> Because pipe writer calls write() syscall -> file_update_time() in kernel
> while pipe reader calls read() syscall -> touch_atime() in kernel

Yeah, but why does the pipe inode need to have its times updated?
I guess there is some reason... hopefully not C&P related.

--Boundary-00=_/5rzHT+0regaSQ3
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fix-pipe.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix-pipe.patch"

Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c
+++ linux-2.6/fs/pipe.c
@@ -385,8 +385,6 @@ redo:
 		wake_up_interruptible_sync(&pipe->wait);
 		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	}
-	if (ret > 0)
-		file_accessed(filp);
 	return ret;
 }
 
@@ -558,8 +556,6 @@ out:
 		wake_up_interruptible_sync(&pipe->wait);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	}
-	if (ret > 0)
-		file_update_time(filp);
 	return ret;
 }
 

--Boundary-00=_/5rzHT+0regaSQ3--

