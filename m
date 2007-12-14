Return-Path: <linux-kernel-owner+w=401wt.eu-S1763122AbXLNGgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763122AbXLNGgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbXLNGgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:36:03 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:46588 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbXLNGgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:36:00 -0500
Date: Fri, 14 Dec 2007 09:35:58 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Cc: "dmonakhov@sw.ru" <DmitryMonakhov@2ka.mipt.ru>
Subject: Re: [3/4] DST: Network state machine.
Message-ID: <20071214063558.GA12017@2ka.mipt.ru>
References: <1197287250388@2ka.mipt.ru> <11972872511269@2ka.mipt.ru> <20071213204343.GC27398@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213204343.GC27398@dmon-lap.sw.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 11:43:43PM +0300, Dmitry Monakhov (dmonakhov@sw.ru) wrote:
> On 14:47 Mon 10 Dec     , Evgeniy Polyakov wrote:
> > 
> > Network state machine.
> > 
> > Includes network async processing state machine and related tasks.
> Hi, I've tried to play a little bit with DST and discover huge memory
> leak. Every read request from remote node result in bio + bio's pages leak.
> 
> Data flow:
> ->kst_export_ready 		## prepare and submit bio 
>   ->generic_make_request(bio) 	## submit it
> 
> ->kst_export_read_end_io	## block layer call bio_end_io callback
> 
> ->kst_thread_process_state	## process ready requests
>   ->kst_data_callback
>      ->kst_data_process_bio	## submit pages to network layer
>   ->kst_complete_req
>      ->kst_bio_endio
>        ->kst_export_read_end_io ## WoW we calling the same bio_end_io 
> 				## callback twice 
>      ->dst_free_request(req);   ## request will be destroyed but it's bio
> 				## and all bio's pages wasn't released.
> We may release bio's pages after it was sent to network, it is safe because
> sendpage() already called get_page(). I've attached simple patch which 
> this this.

Yes, your patch looks good.
Thanks a lot, Dmitry.

-- 
	Evgeniy Polyakov
