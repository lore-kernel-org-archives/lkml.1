Return-Path: <linux-kernel-owner+w=401wt.eu-S1031552AbXEDUmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031552AbXEDUmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031554AbXEDUmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:42:17 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031552AbXEDUmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:42:15 -0400
Date: Fri, 4 May 2007 13:42:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Remove constructor from buffer_head
Message-Id: <20070504134212.c18d2d65.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705032007540.16627@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007 20:08:41 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> Performance tests show a slight improvements in netperf (not a
> strong case for a performance improvement but removing the
> constructor has definitely no negative impact so why keep
> this around?).
> 
> TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to localhost (127.0.0.1) port 0 AF_INET
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
> Before:
>  87380  16384  16384    10.01    6026.04
>  87380  16384  16384    10.01    5992.17
>  87380  16384  16384    10.01    6071.23
> 
> After:
>  87380  16384  16384    10.01    6090.20
>  87380  16384  16384    10.01    6078.3
>  87380  16384  16384    10.00    6013.52
> 
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  fs/buffer.c |   22 ++++------------------


So I benchmarked this by repeatedly extending (via write()) and truncating
a 10MB file, on ext2.  Using create-delete.c from
http://www.zip.com.au/~akpm/linux/patches/stuff/ext3-tools.tar.gz

Machine is a fast 2x4 core Woodcrest.  CONFIG_SLAB=y

The command used was

	time create-delete -s $((16 * 1024 * 1024)) -n 300 foo

which will allocate and free 300*4096 buffer_heads.

With patch:

akpm2:/mnt/sda2> time create-delete -s $((16 * 1024 * 1024)) -n 300 foo
create-delete -s $((16 * 1024 * 1024)) -n 300 foo  0.00s user 4.56s system 99% cpu 4.565 total
akpm2:/mnt/sda2> time create-delete -s $((16 * 1024 * 1024)) -n 300 foo
create-delete -s $((16 * 1024 * 1024)) -n 300 foo  0.00s user 4.60s system 99% cpu 4.612 total
akpm2:/mnt/sda2> time create-delete -s $((16 * 1024 * 1024)) -n 300 foo
create-delete -s $((16 * 1024 * 1024)) -n 300 foo  0.00s user 4.60s system 99% cpu 4.602 total
akpm2:/mnt/sda2> time create-delete -s $((16 * 1024 * 1024)) -n 300 foo
create-delete -s $((16 * 1024 * 1024)) -n 300 foo  0.00s user 4.56s system 99% cpu 4.567 total
akpm2:/mnt/sda2> time create-delete -s $((16 * 1024 * 1024)) -n 300 foo
create-delete -s $((16 * 1024 * 1024)) -n 300 foo  0.00s user 4.59s system 95% cpu 4.824 total

Without patch:

akpm2:/mnt/sda2> time create-delete -s $((16 * 1024 * 1024)) -n 300 foo
create-delete -s $((16 * 1024 * 1024)) -n 300 foo  0.00s user 4.42s system 99% cpu 4.419 total
akpm2:/mnt/sda2> time create-delete -s $((16 * 1024 * 1024)) -n 300 foo
create-delete -s $((16 * 1024 * 1024)) -n 300 foo  0.00s user 4.42s system 99% cpu 4.421 total
akpm2:/mnt/sda2> time create-delete -s $((16 * 1024 * 1024)) -n 300 foo
create-delete -s $((16 * 1024 * 1024)) -n 300 foo  0.00s user 4.42s system 99% cpu 4.427 total
akpm2:/mnt/sda2> time create-delete -s $((16 * 1024 * 1024)) -n 300 foo
create-delete -s $((16 * 1024 * 1024)) -n 300 foo  0.00s user 4.42s system 99% cpu 4.417 total
akpm2:/mnt/sda2> time create-delete -s $((16 * 1024 * 1024)) -n 300 foo
create-delete -s $((16 * 1024 * 1024)) -n 300 foo  0.00s user 4.42s system 99% cpu 4.435 total

So the patch took the average system time from 4.42 seconds up to 4.582
seconds.  Nice slowdown!

It could just be the usual inter-kernel-build noise, dunno.

I'd investigate further, but someone has gone and broken oprofile.

