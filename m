Return-Path: <linux-kernel-owner+w=401wt.eu-S932960AbZJHSf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbZJHSf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932829AbZJHSf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:35:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782AbZJHSf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:35:57 -0400
Date: Thu, 8 Oct 2009 20:35:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Alexander Strakh <strakh@ispras.ru>
Cc: Pierre Ossman <pierre@ossman.eu>, sdhci-devel@lists.ossman.eu,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] wbsd.c: after spin_lock_bh uses spin_unlock instead
 spin_unlock_bh
In-Reply-To: <200910081518.00707.strakh@ispras.ru>
Message-ID: <alpine.LRH.2.00.0910082030010.12171@twin.jikos.cz>
References: <200910081518.00707.strakh@ispras.ru>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Alexander Strakh wrote:

> 	KERNEL_VERSION: 2.6.31
> 	DESCRIBE:
> Driver ./drivers/mmc/host/wbsd.c calls spin_lock_bh and then spin_unlock 
> instead of spin_unlock_bh:
> 
>  753 static void wbsd_request(struct mmc_host *mmc, struct mmc_request *mrq)
> ...
>  761         spin_lock_bh(&host->lock);
> ...
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
> ...
>  230         spin_unlock(&host->lock);
>  231         mmc_request_done(host->mmc, mrq);
>  232         spin_lock(&host->lock);
>  233 }

And where exactly you see a bug?

wbsd_request_end() can be called in the following ways:

- through wbsd_finish_data() from tasklet (therefore no need to disable 
  tasklets there)
- from wbsd_request() directly. The sequence here is

	spin_lock_bh(&host->lock);
	...
	wbsd_request_end(host, mrq);
		spin_unlock(&host->lock);
		....
		spin_lock(&host->lock);		
	spin_unlock_bh(&host->lock);	

  So the whole thing runs with tasklets disabled, no matter what you do 
  with the host->lock, and they are only enabled at the very end of 
  wbsd_request()

So, what exact problem scenario do you see here?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

