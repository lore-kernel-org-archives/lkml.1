Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbXI0Ur6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbXI0Ur6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 16:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbXI0Urt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 16:47:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49179 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477AbXI0Urs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 16:47:48 -0400
Date: Thu, 27 Sep 2007 13:47:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: nickpiggin@yahoo.com.au, hirofumi@mail.parknet.co.jp,
       galak@kernel.crashing.org, zaitcev@redhat.com, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] writeback: remove unnecessary wait in
 throttle_vm_writeout()
Message-Id: <20070927134726.ac39b55f.akpm@linux-foundation.org>
In-Reply-To: <390857819.00313@ustc.edu.cn>
References: <390857819.00313@ustc.edu.cn>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 09:50:16 +0800
Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> We don't want to introduce pointless delays in throttle_vm_writeout()
> when the writeback limits are not yet exceeded, do we?
> 
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Pete Zaitcev <zaitcev@redhat.com>
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  mm/page-writeback.c |   18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> --- linux-2.6.23-rc8-mm1.orig/mm/page-writeback.c
> +++ linux-2.6.23-rc8-mm1/mm/page-writeback.c
> @@ -507,16 +507,6 @@ void throttle_vm_writeout(gfp_t gfp_mask
>  	long background_thresh;
>  	long dirty_thresh;
>  
> -	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
> -		/*
> -		 * The caller might hold locks which can prevent IO completion
> -		 * or progress in the filesystem.  So we cannot just sit here
> -		 * waiting for IO to complete.
> -		 */
> -		congestion_wait(WRITE, HZ/10);
> -		return;
> -	}
> -
>          for ( ; ; ) {
>  		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
>  
> @@ -530,6 +520,14 @@ void throttle_vm_writeout(gfp_t gfp_mask
>  			global_page_state(NR_WRITEBACK) <= dirty_thresh)
>                          	break;
>                  congestion_wait(WRITE, HZ/10);
> +
> +		/*
> +		 * The caller might hold locks which can prevent IO completion
> +		 * or progress in the filesystem.  So we cannot just sit here
> +		 * waiting for IO to complete.
> +		 */
> +		if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO))
> +			break;
>          }
>  }
>  

This is a pretty major bugfix.

GFP_NOIO and GFP_NOFS callers should have been spending really large
amounts of time stuck in that sleep.

I wonder why nobody noticed this happening.  Either a) it turns out that
kswapd is doing a good job and such callers don't do direct reclaim much or
b) nobody is doing any in-depth kernel instrumentation.

Now, how _would_ one notice this problem?  We don't have very good tools,
really.  Booting with "profile=sleep" and looking at the profile data would
be one way.  Repeatedly doing sysrq-T is another.  Perhaps the new
lockstat-via-lockdep code would allow this to be observed in some fashion,
dunno.

Anyway, this patch has the potential to significantly alter the dynamics of
the VM behaviour under particular workloads.  It might turn up other
stuff...

