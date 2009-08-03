Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbZHCRz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbZHCRz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZHCRzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:55:25 -0400
Received: from mga06.intel.com ([134.134.136.21]:39227 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753173AbZHCRzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:55:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,315,1246863600"; 
   d="scan'208";a="538225216"
Date: Mon, 3 Aug 2009 19:57:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcf50633: revise locking for ADC
Message-ID: <20090803175733.GD28606@sortiz.org>
References: <200907281845.n6SIjdjC025315@home.pavel.comp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907281845.n6SIjdjC025315@home.pavel.comp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, Jul 28, 2009 at 12:58:48AM +0400, Paul Fertser wrote:
> Current implementation is prone to races, this patch attempts to remove all
> but one (in pcf50633_adc_sync_read).
> 
> The idea is that we need to guard the queue access only on inserting and
> removing items. If we insert and there're no more items in the queue it
> means that the last irq already happened and we need to trigger ADC
> manually. If not, then the next conversion will be triggered by the irq
> handler upon completion of the previous.


> @@ -136,9 +133,13 @@ int pcf50633_adc_sync_read(struct pcf50633 *pcf, int mux, int avg)
>  	req->callback_param = req;
>  
>  	init_completion(&req->completion);
> -	adc_enqueue_request(pcf, req);
> +	err = adc_enqueue_request(pcf, req);
> +	if (err)
> +		return err;
> +
>  	wait_for_completion(&req->completion);
>  
> +	/* FIXME by this time req might be already freed */
In fact, this is problematic.
Shouldn't the request be freed by the callback (in the async request), or by
sync_read() ?

Your patch looks fine though, I applied it to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
