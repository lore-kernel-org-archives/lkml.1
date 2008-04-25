Return-Path: <linux-kernel-owner+w=401wt.eu-S933023AbYDYVhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbYDYVhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 17:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763224AbYDYVhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 17:37:20 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57174 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762913AbYDYVhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 17:37:18 -0400
Date: Fri, 25 Apr 2008 23:37:02 +0200
From: Florian Westphal <fw@strlen.de>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: s-uchida@ap.jp.nec.com, vtaras@openvz.org, axboe@kernel.dk,
       m-takahashi@ex.jp.nec.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, tom-sugawara@ap.jp.nec.com,
       devel@openvz.org
Subject: Re: [Devel] Re: [RFC][v2][patch 0/12][CFQ-cgroup]Yet another I/O
	bandwidth controlling subsystem for CGroups based on CFQ
Message-ID: <20080425213702.GL19845@Chamillionaire.breakpoint.cc>
References: <008001c893db$4e2eccf0$ea8c66d0$@jp.nec.com> <6599ad830804021541s3c1e3197y77d87f63bf47e4b3@mail.gmail.com> <005d01c89559$9e538200$dafa8600$@jp.nec.com> <20080425.185444.115924172.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425.185444.115924172.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryo Tsuruta <ryov@valinux.co.jp> wrote:
[..]
> I'd like to see other benchmark results if anyone has.

Here are a few results. IO is issued in 4k chunks,
using O_DIRECT. Each process issues both reads
and writes. There are 60 such processes in each cgroup (except
where noted). Numbers given show the total count of io requests
(read and write) completed in 60 seconds. All processes use
the same partition, fs is ext3.

Vasily's scheduler:
------------------------------------------------------
| cgroup | s0                 | s1             |total |
|priority|  4                 |  4             |I/Os  |
------------------------------------------------------
|        | 24953              | 24062          | 49015|
|        | 29558(60 processes)| 14639 (30 proc)| 44197|
-------------------------------------------------------
|priority|    0               |  4             |      |
|        | 24221              | 24047          | 48268|
|priority|    1               |  4             |      |
|        | 24897              | 24509          | 49406|
|priority|    2               |  4             |      |
|        | 23295              | 23622          | 46917|
|priority|    0               |  7             |      |
|        | 22301              | 23373          | 45674|
-------------------------------------------------------

Satoshi's scheduler:
-------------------------------------------------------
| cgroup | s0                 | s1             |total |
|priority|  3                 |  3             |I/Os  |
|        | 25175              | 26463          | 51638|
|        | 26944 (60)         | 26698 (30)     | 53642|
-------------------------------------------------------
|priority|   0                |  3             |      |
|        | 60821              | 19846          | 80667|
|priority|   1                |  3             |      |
|        | 50608              | 25994          | 76602|
|priority|   2                |  3             |      |
|        | 32132              | 26641          | 58773|
|priority|   7                |  0             |      |
|        | 91387              | 12547          |103934|
------------------------------------------------------

So in short, i can't see any effect when i use Vasily's
i/o scheduler. Setting
echo 10 > /sys/block/hda/queue/iosched/cgrp_slice
did at least show different results in the 'prio 7 vs. prio 0 case'
(~29000 (prio 7) vs. 20000 (prio 0)).

What i found surprising is that Satoshis scheduler has
about twice of the io count...

Thanks, Florian
