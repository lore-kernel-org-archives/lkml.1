Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbYIDVUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbYIDVUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYIDVUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:20:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102AbYIDVUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:20:32 -0400
Date: Thu, 4 Sep 2008 14:19:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ilya Yanok <yanok@emcraft.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, wd@denx.de,
       yur@emcraft.com, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
Message-Id: <20080904141945.f5c4c3eb.akpm@linux-foundation.org>
In-Reply-To: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  4 Sep 2008 01:43:51 +0400
Ilya Yanok <yanok@emcraft.com> wrote:

> From: Yuri Tikhonov <yur@emcraft.com>
> 
> Should clear the next pointer of the TX if we are sure that the
> next TX (say NXT) will be submitted to the channel too. Overwise,
> we break the chain of descriptors, because we lose the information
> about the next descriptor to run. So next time, when invoke
> async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
> NXT will be never submitted.
> 
> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>

This patch should include your signed-off-by: as well.  Because you
were on the delivery path, as described in
Documentation/SubmittingPatches, section 12.  

> 
> diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
> index 85eaf7b..e8362c1 100644
> --- a/crypto/async_tx/async_tx.c
> +++ b/crypto/async_tx/async_tx.c
> @@ -137,7 +137,8 @@ async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
>  		spin_lock_bh(&next->lock);
>  		next->parent = NULL;
>  		_next = next->next;
> -		next->next = NULL;
> +		if (_next && _next->chan == chan)
> +			next->next = NULL;
>  		spin_unlock_bh(&next->lock);
>  
>  		next->tx_submit(next);

Dan, please review asap?
