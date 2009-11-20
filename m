Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbZKTKUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbZKTKUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 05:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbZKTKUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 05:20:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:39328 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752102AbZKTKUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 05:20:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19NdANnNk1NULfnZfy8UBH5vi4xH16331Pa3hpkRy
	0GhQlPgAEJ+lo8
Subject: Re: Lmbench performance drop 2.6.18-->2.6.27
From: Mike Galbraith <efault@gmx.de>
To: Ajay Patel <patela@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <90f56e480911191313n1050831ft4369ab5fcb937c01@mail.gmail.com>
References: <90f56e480911191313n1050831ft4369ab5fcb937c01@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 20 Nov 2009 11:20:09 +0100
Message-Id: <1258712409.15530.26.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-19 at 13:13 -0800, Ajay Patel wrote:
> Hi all,
> 
> Part of our evaluation to upgrade kernel we
> ran lmbench. The lmbench results shows significant performance
> drop from 2.6.18 to 2.6.27. (Results attached)
> 
> The benchmark was performed on same hardware with
> different distro. (Quad-Core AMD Opteron(tm) Processor 2346 HE,
> cpu MHz : 1795.597, cache size : 512 KB, x86_64 kernel)
> 
> The 2.6.18 based distribution was from CentOS release 5.4.
> (Linux cento-5.4 2.6.18-164.el5).
> The 2.6.27 based distribution was from FC10.
> (Fedora Core release 10 2.6.27.5-117.fc10-x86_64).
> 
> Does this results make sense?  Is this expected?
> Am I doing something wrong?

I think most of what you're seeing is config differences and the fact
that microbenchmarks are excellent at showing how horribly expensive
cache misses are.  You see radically different numbers when two halves
of a microbenchmark land in the same cache vs landing across the fence
from one another.

Sometimes affinity is great, sometimes not so great.  For evaluating,
wide spectrum testing is much safer than microbenchmarks, they can be
very misleading.  lmbench is really good at showing us that affinity
logic has always been a sore spot, and I'm very sure that's what you're
seeing.

Below are some numbers from my supermarket Q6600 box.  Notice the wild
swings when affinity goes wrong/right, same as your numbers.  Check out
the UNIX socket numbers in the last three lines.  Wake affine to cache
rather than to CPU, and that's what you get for that microbenchmark.
Latency numbers don't look very appetizing, but throughput goes through
the roof.

*Local* Communication latencies in microseconds - smaller is better
---------------------------------------------------------------------
Host                 OS 2p/0K  Pipe AF     UDP  RPC/   TCP  RPC/ TCP
                        ctxsw       UNIX         UDP         TCP conn
--------- ------------- ----- ----- ---- ----- ----- ----- ----- ----
marge     Linux 2.6.27. 1.070 3.757 4.87 8.305  12.7  12.9  16.1  34.
marge     Linux 2.6.27. 0.880 3.364 5.72 7.950  11.8  12.8  15.3  34.
marge     Linux 2.6.27. 0.810 3.458 4.77 7.978  11.7  12.9  15.3  34.
marge     Linux 2.6.27. 0.860 3.408 5.80 7.981  11.9  30.4  15.3  34.
marge     Linux 2.6.31. 0.820 3.127 5.63 8.060  13.0  29.6  16.6  34.
marge     Linux 2.6.31. 0.760 3.119 5.64 8.105  13.1  29.6  16.8  36.
marge     Linux 2.6.22. 4.420  10.9 20.7 7.705  10.7  22.5  29.9  27.
marge     Linux 2.6.22. 4.460 3.298 5.16 7.648  10.7  22.4  30.0  26.
marge     Linux 2.6.32- 0.830 3.069 4.92 8.337  13.0  13.1  17.6  37.
marge     Linux 2.6.32- 0.810 3.041 5.72 9.902  13.4  13.2  17.3  36.
marge     Linux 2.6.32- 0.800 3.050 5.65 8.312  13.4  13.0  17.2  36.
marge     Linux 2.6.32- 0.790 3.113 5.55 9.925  13.4  13.0  17.4  36.
marge     Linux 2.6.32- 0.800 3.082 4.78 8.353  13.4  13.0  17.2  36.
marge     Linux 2.6.32- 0.780 3.086 5.59 8.332  13.4  13.1  17.2  36.
marge     Linux 2.6.32- 1.470 4.758 7.32  10.1  13.4  12.9  16.7  21.
marge     Linux 2.6.32- 1.460 4.736 7.60  10.1  13.4  13.0  16.5  21.
marge     Linux 2.6.32- 1.290 4.571 7.69  10.1  13.3  12.9  16.4  21.

*Local* Communication bandwidths in MB/s - bigger is better
-----------------------------------------------------------------------------
Host                OS  Pipe AF    TCP  File   Mmap  Bcopy  Bcopy  Mem   Mem
                             UNIX      reread reread (libc) (hand) read write
--------- ------------- ---- ---- ---- ------ ------ ------ ------ ---- -----
marge     Linux 2.6.27. 2706 2535 1142 2793.2 4786.3 1285.4 1235.7 4456 1685.
marge     Linux 2.6.27. 2737 2811 749. 2773.3 4798.8 1245.3 1235.9 4387 1685.
marge     Linux 2.6.27. 2746 2838 2617 2785.0 4763.6 1239.6 1237.8 4423 1688.
marge     Linux 2.6.27. 2711 2776 2653 2772.8 4842.4 1404.5 1394.1 4492 1765.
marge     Linux 2.6.31. 2759 2847 735. 2808.2 4800.2 1238.4 1231.8 4485 1683.
marge     Linux 2.6.31. 2756 2842 1125 2792.1 4788.9 1239.8 1235.0 4475 1681.
marge     Linux 2.6.22. 2692 1843 1017 2746.4 4763.6 1293.3 1278.4 4439 1678.
marge     Linux 2.6.22. 2865 1872 1015 2776.4 4803.4 1291.7 1320.8 4421 1679.
marge     Linux 2.6.32- 2780 2889 2812 2802.0 4833.7 1239.2 1233.6 4510 1683.
marge     Linux 2.6.32- 2782 2892 2808 2808.4 4819.8 1240.5 1232.3 4438 1682.
marge     Linux 2.6.32- 2786 2877 2810 2824.7 4802.2 1237.9 1234.8 4433 1601.
marge     Linux 2.6.32- 2767 2873 1129 2801.7 4803.4 1238.3 1234.6 4467 1688.
marge     Linux 2.6.32- 2761 2890 736. 2814.8 4793.0 1245.4 1233.4 4483 1687.
marge     Linux 2.6.32- 2748 2883 755. 2805.1 4823.6 1243.0 1233.9 4353 1683.
marge     Linux 2.6.32- 1776 5116 2814 2809.7 4759.5 1245.4 1232.3 4451 1681.
marge     Linux 2.6.32- 2997 5119 1147 2809.7 4787.3 1242.2 1236.4 4462 1682.
marge     Linux 2.6.32- 2999 5122 1138 2808.3 4803.8 1242.7 1236.5 4498 1685.


