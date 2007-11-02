Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbXKBKdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbXKBKdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 06:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbXKBKdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 06:33:35 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:39068 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753118AbXKBKdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 06:33:33 -0400
Message-ID: <393999615.15343@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 2 Nov 2007 18:33:29 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: writeout stalls in current -git
References: <393056632.00561@ustc.edu.cn> <200710221505.35397.maximlevitsky@gmail.com> <20071022131045.GA5357@mail.ustc.edu.cn> <393060478.03650@ustc.edu.cn> <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com> <393903856.06449@ustc.edu.cn> <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com> <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com> <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193998532.27652.343.camel@twins>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Message-Id: <E1IntqD-0001dK-OE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 11:15:32AM +0100, Peter Zijlstra wrote:
> On Fri, 2007-11-02 at 10:21 +0800, Fengguang Wu wrote:
> 
> > Interestingly, no background_writeout() appears, but only
> > balance_dirty_pages() and wb_kupdate.  Obviously wb_kupdate won't
> > block the process.
> 
> Yeah, the background threshold is not (yet) scaled. So it can happen
> that the bdi_dirty limit is below the background limit.
> 
> I'm curious though as to these stalls, though, I can't seem to think of
> what goes wrong.. esp since most writeback seems to happen from pdflush.

Me confused too. The new debug patch will confirm whether emerge is
waiting in balance_dirty_pages().

> (or I'm totally misreading it - quite a possible as I'm still recovering
> from a serious cold and not all the green stuff has yet figured out its
> proper place wrt brain cells 'n stuff)

Do take care of yourself.

> 
> I still have this patch floating around:

I think this patch is OK for 2.6.24 :-)

Reviewed-by: Fengguang Wu <wfg@mail.ustc.edu.cn> 

> 
> ---
> Subject: mm: speed up writeback ramp-up on clean systems
> 
> We allow violation of bdi limits if there is a lot of room on the
> system. Once we hit half the total limit we start enforcing bdi limits
> and bdi ramp-up should happen. Doing it this way avoids many small
> writeouts on an otherwise idle system and should also speed up the
> ramp-up.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
> ---
>  mm/page-writeback.c |   19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/mm/page-writeback.c
> ===================================================================
> --- linux-2.6.orig/mm/page-writeback.c	2007-09-28 10:08:33.937415368 +0200
> +++ linux-2.6/mm/page-writeback.c	2007-09-28 10:54:26.018247516 +0200
> @@ -355,8 +355,8 @@ get_dirty_limits(long *pbackground, long
>   */
>  static void balance_dirty_pages(struct address_space *mapping)
>  {
> -	long bdi_nr_reclaimable;
> -	long bdi_nr_writeback;
> +	long nr_reclaimable, bdi_nr_reclaimable;
> +	long nr_writeback, bdi_nr_writeback;
>  	long background_thresh;
>  	long dirty_thresh;
>  	long bdi_thresh;
> @@ -376,11 +376,26 @@ static void balance_dirty_pages(struct a
>  
>  		get_dirty_limits(&background_thresh, &dirty_thresh,
>  				&bdi_thresh, bdi);
> +
> +		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
> +					global_page_state(NR_UNSTABLE_NFS);
> +		nr_writeback = global_page_state(NR_WRITEBACK);
> +
>  		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
>  		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> +
>  		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
>  			break;
>  
> +		/*
> +		 * Throttle it only when the background writeback cannot
> +		 * catch-up. This avoids (excessively) small writeouts
> +		 * when the bdi limits are ramping up.
> +		 */
> +		if (nr_reclaimable + nr_writeback <
> +				(background_thresh + dirty_thresh) / 2)
> +			break;
> +
>  		if (!bdi->dirty_exceeded)
>  			bdi->dirty_exceeded = 1;
>  
> 
> 

