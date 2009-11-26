Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbZKZIps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbZKZIps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759839AbZKZIpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:45:44 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57570 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760025AbZKZIpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:45:42 -0500
Date: Thu, 26 Nov 2009 09:45:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Moyer Jeff Moyer <jmoyer@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [PATCH] Fix regression in direct writes performance due to
	WRITE_ODIRECT flag removal
Message-ID: <20091126084548.GO8742@kernel.dk>
References: <20091124212628.GC2803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124212628.GC2803@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24 2009, Vivek Goyal wrote:
> Hi Jens,
> 
> There seems to be a regression in direct write path due to following
> commit in for-2.6.33 branch of block tree.
> 
> commit 1af60fbd759d31f565552fea315c2033947cfbe6
> Author: Jeff Moyer <jmoyer@redhat.com>
> Date:   Fri Oct 2 18:56:53 2009 -0400
> 
>     block: get rid of the WRITE_ODIRECT flag
> 
> 
> Marking direct writes as WRITE_SYNC_PLUG instead of WRITE_ODIRECT, sets
> the NOIDLE flag in bio and hence in request. This tells CFQ to not expect
> more request from the queue and not idle on it (despite the fact that
> queue's think time is less and it is not seeky).
> 
> So direct writers lose big time when competing with sequential readers.
> 
> Using fio, I have run one direct writer and two sequential readers and
> following are the results with 2.6.32-rc7 kernel and with for-2.6.33
> branch.
> 
> Test
> ====
> 1 direct writer and 2 sequential reader running simultaneously.
> 
> [global]
> directory=/mnt/sdc/fio/
> runtime=10
> 
> [seqwrite]
> rw=write
> size=4G
> direct=1
> 
> [seqread]
> rw=read
> size=2G
> numjobs=2
> 
> 2.6.32-rc7
> ==========
> direct writes: aggrb=2,968KB/s
> readers	     : aggrb=101MB/s
> 
> for-2.6.33 branch
> =================
> direct write: aggrb=19KB/s
> readers	      aggrb=137MB/s

Thanks, that shows pretty well the impact that idling can have :-).
I have applied it.

-- 
Jens Axboe

