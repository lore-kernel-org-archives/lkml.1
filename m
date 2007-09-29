Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXI2LxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXI2LxP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 07:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbXI2LxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 07:53:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33907 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbXI2Lw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 07:52:59 -0400
Subject: Re: A unresponsive file system can hang all I/O in the system on
	linux-2.6.23-rc6 (dirty_thresh problem?)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Chakri n <chakriin5@gmail.com>, Krzysztof Oledzki <olel@ans.pl>,
       akpm@linux-foundation.org,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <391063897.19256@ustc.edu.cn>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <391063897.19256@ustc.edu.cn>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 13:48:01 +0200
Message-Id: <1191066481.18147.115.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-09-29 at 19:04 +0800, Fengguang Wu wrote:
> On Thu, Sep 27, 2007 at 11:32:36PM -0700, Chakri n wrote:
> > Hi,
> > 
> > In my testing, a unresponsive file system can hang all I/O in the system.
> > This is not seen in 2.4.
> > 
> > I started 20 threads doing I/O on a NFS share. They are just doing 4K
> > writes in a loop.
> > 
> > Now I stop NFS server hosting the NFS share and start a
> > "dd" process to write a file on local EXT3 file system.
> > 
> > # dd if=/dev/zero of=/tmp/x count=1000
> > 
> > This process never progresses.
> 
> Peter, do you think this patch will help?

In another sub-thread:

> It's works on .23-rc8-mm2 with out any problems.
> 
> "dd" process does not hang any more.
> 
> Thanks for all the help.
> 
> Cheers
> --Chakri

So the per-bdi dirty patches that are in -mm already fix the problem.

> ===
> writeback: avoid possible balance_dirty_pages() lockup on light-load bdi
> 
> On a busy-writing system, a writer could be hold up infinitely on a
> light-load device. It will be trying to sync more than enough dirty data.
> 
> The problem case:
> 
> 0. sda/nr_dirty >= dirty_limit;
>    sdb/nr_dirty == 0
> 1. dd writes 32 pages on sdb
> 2. balance_dirty_pages() blocks dd, and tries to write 6MB.
> 3. it never gets there: there's only 128KB dirty data.
> 4. dd may be blocked for a loooong time as long as sda is overloaded
> 
> Fix it by returning on 'zero dirty inodes' in the current bdi.
> (In fact there are slight differences between 'dirty inodes' and 'dirty pages'.
> But there is no available counters for 'dirty pages'.)
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  mm/page-writeback.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- linux-2.6.22.orig/mm/page-writeback.c
> +++ linux-2.6.22/mm/page-writeback.c
> @@ -227,6 +227,9 @@ static void balance_dirty_pages(struct a
>  		if (nr_reclaimable + global_page_state(NR_WRITEBACK) <=
>  			dirty_thresh)
>  				break;
> +		if (list_empty(&mapping->host->i_sb->s_dirty) &&
> +		    list_empty(&mapping->host->i_sb->s_io))
> +			break;
>  
>  		if (!dirty_exceeded)
>  			dirty_exceeded = 1;
> 

On the patch itself, not sure if it would have been enough. As soon as
there is a single dirty inode on the list one would get caught in the
same problem as before.

That is, if NFS_dirty+NFS_unstable+NFS_writeback > dirty_limit this
break won't fix it.

