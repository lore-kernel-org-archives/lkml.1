Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab0COCev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 22:34:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53166 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0COCeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 22:34:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 15 Mar 2010 11:31:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <arighi@develer.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mmotm 5/5] memcg: dirty pages instrumentation
Message-Id: <20100315113104.b208571c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1268609202-15581-6-git-send-email-arighi@develer.com>
References: <1268609202-15581-1-git-send-email-arighi@develer.com>
	<1268609202-15581-6-git-send-email-arighi@develer.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 00:26:42 +0100
Andrea Righi <arighi@develer.com> wrote:

> Apply the cgroup dirty pages accounting and limiting infrastructure to
> the opportune kernel functions.
> 
> [ NOTE: for now do not account WritebackTmp pages (FUSE) and NILFS2
> bounce pages. This depends on charging also bounce pages per cgroup. ]
> 
> As a bonus, make determine_dirtyable_memory() static again: this
> function isn't used anymore outside page writeback.
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

A nitpick.

> @@ -660,6 +705,8 @@ void throttle_vm_writeout(gfp_t gfp_mask)
>  	unsigned long dirty_thresh;
>  
>          for ( ; ; ) {
> +		unsigned long dirty;
> +
>  		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
>  
>                  /*
> @@ -668,10 +715,10 @@ void throttle_vm_writeout(gfp_t gfp_mask)
>                   */
>                  dirty_thresh += dirty_thresh / 10;      /* wheeee... */
>  
> -                if (global_page_state(NR_UNSTABLE_NFS) +
> -			global_page_state(NR_WRITEBACK) <= dirty_thresh)
> -                        	break;
> -                congestion_wait(BLK_RW_ASYNC, HZ/10);
> +		dirty = get_dirty_writeback_pages();
> +		if (dirty <= dirty_thresh)
> +			break;
> +		congestion_wait(BLK_RW_ASYNC, HZ/10);
>  
>  		/*
>  		 * The caller might hold locks which can prevent IO completion

"dirty" seems not to be necessary.
	if (get_dirty_writeback_pages() < dirty_thresh) ?

Thanks,
-Kame



