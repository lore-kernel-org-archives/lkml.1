Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbYFLFgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbYFLFgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 01:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYFLFgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 01:36:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393AbYFLFgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 01:36:06 -0400
Date: Wed, 11 Jun 2008 22:34:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 00/24] VM pageout scalability improvements (V12)
Message-Id: <20080611223430.cba0f1b6.akpm@linux-foundation.org>
In-Reply-To: <20080611184214.605110868@redhat.com>
References: <20080611184214.605110868@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 14:42:14 -0400 Rik van Riel <riel@redhat.com> wrote:

> On large memory systems, the VM can spend way too much time scanning
> through pages that it cannot (or should not) evict from memory. Not
> only does it use up CPU time, but it also provokes lock contention
> and can leave large systems under memory presure in a catatonic state.

Hey, I did some MM testing!


On a 900MB 2-way, allocate and memset 1000MB.

mainline:

vmm:/home/akpm> time usemem -m 1000
usemem -m 1000  0.10s user 10.27s system 62% cpu 16.567 total
vmm:/home/akpm> time usemem -m 1000
usemem -m 1000  0.12s user 10.23s system 63% cpu 16.234 total
vmm:/home/akpm> time usemem -m 1000
usemem -m 1000  0.13s user 9.90s system 63% cpu 15.812 total
vmm:/home/akpm> time usemem -m 1000
usemem -m 1000  0.11s user 9.98s system 65% cpu 15.494 total
vmm:/home/akpm> time usemem -m 1000
usemem -m 1000  0.12s user 9.94s system 62% cpu 16.000 total

2.6.26-rc5-mm3:

vmm:/home/akpm> time usemem -m 1000
usemem -m 1000  0.15s user 9.81s system 52% cpu 19.117 total
vmm:/home/akpm> time usemem -m 1000
usemem -m 1000  0.14s user 9.07s system 45% cpu 20.403 total
vmm:/home/akpm> time usemem -m 1000
usemem -m 1000  0.25s user 9.63s system 34% cpu 28.533 total
vmm:/home/akpm> time usemem -m 1000
usemem -m 1000  0.15s user 9.35s system 49% cpu 19.196 total
vmm:/home/akpm> time usemem -m 1000
usemem -m 1000  0.13s user 8.79s system 49% cpu 17.993 total

Seems to have saved a little CPU but the IO patterns got worse.



qsbench, 4 processes, memory size tuned to threshold-of-swapping*1.1:

Mainline:

vmm:/home/akpm/qsbench> time ./qsbench -p 4 -m 230
./qsbench -p 4 -m 230  175.45s user 45.67s system 60% cpu 6:08.40 total

2.6.26-rc5-mm3:

vmm:/home/akpm/qsbench> time ./qsbench -p 4 -m 230
./qsbench -p 4 -m 230  178.21s user 28.49s system 99% cpu 3:27.14 total

So woot!  Professional qsbench users will be pleased ;) It could have
been a fluke though - iirc qsbench is pretty unstable, especially on
the threshold.


Main thing is: it seems stable.  Old LTP ran for an hour or so before I
hit the msgctl08 crash (which is a regression in current mainline).

