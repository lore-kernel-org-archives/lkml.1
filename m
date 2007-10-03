Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbXJCMrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbXJCMrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbXJCMrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:47:00 -0400
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:1553 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbXJCMrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:47:00 -0400
Subject: Re: [PATCH] writeback: avoid possible balance_dirty_pages() lockup
	on a light-load bdi
From: richard kennedy <richard@rsk.demon.co.uk>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Chuck Ebbert <cebbert@redhat.com>, Greg KH <gregkh@suse.de>,
       Chakri n <chakriin5@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Krzysztof Oledzki <olel@ans.pl>, akpm@linux-foundation.org,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20071002020040.GA5275@mail.ustc.edu.cn>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <391063897.19256@ustc.edu.cn> <470118EE.1020103@redhat.com>
	 <20071002020040.GA5275@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 13:46:52 +0100
Message-Id: <1191415612.3123.21.camel@castor.rsk.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 10:00 +0800, Fengguang Wu wrote:
> On Mon, Oct 01, 2007 at 11:57:34AM -0400, Chuck Ebbert wrote:
> > On 09/29/2007 07:04 AM, Fengguang Wu wrote:
...
> 
> (expecting real world confirmations...)
> 
> Here is a new safer version.  It's more ugly though.
> 
> ---
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
> 
> Fix it by returning on 'zero dirty inodes' in the current bdi.
> (In fact there are slight differences between 'dirty inodes' and 'dirty pages'.
> But there is no available counters for 'dirty pages'.)
> 
> But the newly introduced 'break' could make the nr_writeback drift away
> above the dirty limit. The workaround is to limit the error under 1MB.
> 
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

I've been testing 2.6.23-rc9 + this patch all morning but have just seen
a lockup. As usual it happened  just after a large file copy finished
and while nr_dirty is still large. I'm sorry to say I didn't have a
serial console running so I don't have an other info. I will try again
and see if I can capture some more data.

I did notice that at the beginning of my tests the dirty blocks are
written back more quickly than usual

nr_dirty count after the copy finished and then 60 seconds later :-
after copy	+60 seconds
73520		0
73533		0
68554		1
 
but after several iterations of my testcase & just before the lockup
68560		57165
71974		62896
 
which is about the same as a unpatched kernel.

Richard
   

