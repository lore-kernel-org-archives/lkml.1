Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbXJBCPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbXJBCPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 22:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbXJBCPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 22:15:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40149 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbXJBCPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 22:15:38 -0400
Date: Mon, 1 Oct 2007 19:14:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Chuck Ebbert <cebbert@redhat.com>, Greg KH <gregkh@suse.de>,
       Chakri n <chakriin5@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Krzysztof Oledzki <olel@ans.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       richard kennedy <richard@rsk.demon.co.uk>
Subject: Re: [PATCH] writeback: avoid possible balance_dirty_pages() lockup
 on a light-load bdi
Message-Id: <20071001191457.2f7c7538.akpm@linux-foundation.org>
In-Reply-To: <391290444.23950@ustc.edu.cn>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	<391063897.19256@ustc.edu.cn>
	<470118EE.1020103@redhat.com>
	<391290444.23950@ustc.edu.cn>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 10:00:40 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> writeback: avoid possible balance_dirty_pages() lockup on a light-load bdi
> 
> On a busy-writing system, a writer could be hold up infinitely on a
> light-load device. It will be trying to sync more than available dirty data.
> 
> The problem case:
> 
> 0. sda/nr_dirty >= dirty_limit;
>    sdb/nr_dirty == 0
> 1. dd writes 32 pages on sdb
> 2. balance_dirty_pages() blocks dd, and tries to write 6MB.
> 3. it never gets there: there's only 128KB dirty data.
> 4. dd may be blocked for a loooong time

Please quantify loooong.
 
> Fix it by returning on 'zero dirty inodes' in the current bdi.
> (In fact there are slight differences between 'dirty inodes' and 'dirty pages'.
> But there is no available counters for 'dirty pages'.)
> 
> But the newly introduced 'break' could make the nr_writeback drift away
> above the dirty limit. The workaround is to limit the error under 1MB.

I'm still not sure that we fully understand this yet.

If the sdb writer is stuck in balance_dirty_pages() then all sda writers
will be in balance_dirty_pages() too, madly writing stuff out to sda.  And
pdflush will be writing out sda as well.  All this writeout to sda should
release the sdb writer.

Why isn't this happening?


> Cc: Chuck Ebbert <cebbert@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  mm/page-writeback.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- linux-2.6.22.orig/mm/page-writeback.c
> +++ linux-2.6.22/mm/page-writeback.c
> @@ -250,6 +250,11 @@ static void balance_dirty_pages(struct a
>  			pages_written += write_chunk - wbc.nr_to_write;
>  			if (pages_written >= write_chunk)
>  				break;		/* We've done our duty */
> +			if (list_empty(&mapping->host->i_sb->s_dirty) &&
> +			    list_empty(&mapping->host->i_sb->s_io) &&
> +			    nr_reclaimable + global_page_state(NR_WRITEBACK) <=
> +				    dirty_thresh + (1 << (20-PAGE_CACHE_SHIFT)))
> +				break;
>  		}
>  		congestion_wait(WRITE, HZ/10);
>  	}

Well that has a nice safetly net.  Perhaps it could fail a bit later on,
but that depends on why it's failing.

How well tested was this?

If we merge this for 2.6.23 then I expect that we'll immediately unmerge it
for 2.6.24 because Peter's stuff fixes this problem by other means.

Do we all agree with the above sentence?
