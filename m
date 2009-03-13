Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbZCMFiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbZCMFiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758120AbZCMFht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:37:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758159AbZCMFhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:37:47 -0400
Date: Thu, 12 Mar 2009 22:33:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de
Subject: Re: [PATCH 2/7] writeback: switch to per-bdi threads for flushing
 data
Message-Id: <20090312223321.ccfe51b2.akpm@linux-foundation.org>
In-Reply-To: <1236868428-20408-3-git-send-email-jens.axboe@oracle.com>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com>
	<1236868428-20408-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 15:33:43 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:

> This gets rid of pdflush for bdi writeout and kupdated style cleaning.
> This is an experiment to see if we get better writeout behaviour with
> per-bdi flushing. Some initial tests look pretty encouraging. A sample
> ffsb workload that does random writes to files is about 8% faster here
> on a simple SATA drive during the benchmark phase. File layout also seems
> a LOT more smooth in vmstat:
> 
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
>  0  1      0 608848   2652 375372    0    0     0 71024  604    24  1 10 48 42
>  0  1      0 549644   2712 433736    0    0     0 60692  505    27  1  8 48 44
>  1  0      0 476928   2784 505192    0    0     4 29540  553    24  0  9 53 37
>  0  1      0 457972   2808 524008    0    0     0 54876  331    16  0  4 38 58
>  0  1      0 366128   2928 614284    0    0     4 92168  710    58  0 13 53 34
>  0  1      0 295092   3000 684140    0    0     0 62924  572    23  0  9 53 37
>  0  1      0 236592   3064 741704    0    0     4 58256  523    17  0  8 48 44
>  0  1      0 165608   3132 811464    0    0     0 57460  560    21  0  8 54 38
>  0  1      0 102952   3200 873164    0    0     4 74748  540    29  1 10 48 41
>  0  1      0  48604   3252 926472    0    0     0 53248  469    29  0  7 47 45
> 
> where vanilla tends to fluctuate a lot in the creation phase:
> 
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
>  1  1      0 678716   5792 303380    0    0     0 74064  565    50  1 11 52 36
>  1  0      0 662488   5864 319396    0    0     4   352  302   329  0  2 47 51
>  0  1      0 599312   5924 381468    0    0     0 78164  516    55  0  9 51 40
>  0  1      0 519952   6008 459516    0    0     4 78156  622    56  1 11 52 37
>  1  1      0 436640   6092 541632    0    0     0 82244  622    54  0 11 48 41
>  0  1      0 436640   6092 541660    0    0     0     8  152    39  0  0 51 49
>  0  1      0 332224   6200 644252    0    0     4 102800  728    46  1 13 49 36
>  1  0      0 274492   6260 701056    0    0     4 12328  459    49  0  7 50 43
>  0  1      0 211220   6324 763356    0    0     0 106940  515    37  1 10 51 39
>  1  0      0 160412   6376 813468    0    0     0  8224  415    43  0  6 49 45
>  1  1      0  85980   6452 886556    0    0     4 113516  575    39  1 11 54 34
>  0  2      0  85968   6452 886620    0    0     0  1640  158   211  0  0 46 54

Confused.  The two should be equivalent for
one-filesystem-per-physical-disk.  What made it change?

> So apart from seemingly behaving better for buffered writeout, this also
> allows us to potentially have more than one bdi thread flushing out data.
> This may be useful for NUMA type setups.

Bear in mind that the XFS guys found that one thread per fs had
insufficient CPU power to keep up with fast devices.

