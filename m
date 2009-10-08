Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbZJHSRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbZJHSRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932621AbZJHSRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:17:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532AbZJHSRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:17:15 -0400
Subject: Re: [BUG] wbsd.c: after spin_lock_bh uses spin_unlock instead
 spin_unlock_bh
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Strakh <strakh@ispras.ru>
Cc: Pierre Ossman <pierre@ossman.eu>, sdhci-devel@lists.ossman.eu,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200910081518.00707.strakh@ispras.ru>
References: <200910081518.00707.strakh@ispras.ru>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Oct 2009 20:20:25 +0200
Message-Id: <1255026025.26976.333.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 15:18 +0000, Alexander Strakh wrote:
> 	KERNEL_VERSION: 2.6.31
> 	DESCRIBE:
> Driver ./drivers/mmc/host/wbsd.c calls spin_lock_bh and then spin_unlock 
> instead of spin_unlock_bh:
> 
>  753 static void wbsd_request(struct mmc_host *mmc, struct mmc_request *mrq)
> ....
>  761         spin_lock_bh(&host->lock);
> ....
>  844 done:
>  845         wbsd_request_end(host, mrq);
>  846
>  847         spin_unlock_bh(&host->lock);
>  848 }
> 
> But in wsdb_request calls spin_unlock/spin_lock instead of 
> spin_unlock_bh/spin_lock_bh;
> 
>  206 static void wbsd_request_end(struct wbsd_host *host, struct mmc_request 
> ....
>  230         spin_unlock(&host->lock);
>  231         mmc_request_done(host->mmc, mrq);
>  232         spin_lock(&host->lock);
>  233 }

Doesn't look too odd, it simply leaves BH disabled, but unlocks the
spinlock.
