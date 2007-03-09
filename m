Return-Path: <linux-kernel-owner+w=401wt.eu-S2993011AbXCIGnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993011AbXCIGnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 01:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993008AbXCIGnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 01:43:39 -0500
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:38924 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2993011AbXCIGni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 01:43:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=A5L7zJUcANvRyOqRUJ/v/aUFh3LMjHjpoPwkifuw7yifa1HtP+HgCFve92rAJSU53uLN6QHSb1JAYgtTd+QNTOz3pCmE00U0TyejXWHFzqSOHq8y+QYrsDjXTL65d2Z6vQ638Jx4JEd/egIfevf+Lsv/QIvmojwHhPa+3RiRtz0=  ;
X-YMail-OSG: TkR.v5wVM1lJbxiDCxIWsFAs.wkP37tIKLqmY0KkNGa8gEaV1FXFaGs0AXLHJwIqQf08JPg75Z.bh45cP6O_NW_i9Zhz8DHwEeu5Z0ZMAdml5G0e8HFtio7JgQG.e1Sr60JhhLT112wdhko-
From: David Brownell <david-b@pacbell.net>
To: Chris Lesiak <chris.lesiak@licor.com>
Subject: Re: [PATCH] spi subsystem: destroy the spi_bitbang workqueue only after the spi master is unregistered
Date: Thu, 8 Mar 2007 22:19:32 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org
References: <45EEE34A.6070009@licor.com> <200703071031.39997.david-b@pacbell.net> <45EF4F32.2050601@licor.com>
In-Reply-To: <45EF4F32.2050601@licor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703082219.33296.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2007 3:48 pm, Chris Lesiak wrote:
> From: Chris Lesiak <chris.lesiak@licor.com>
> 
> This patch fixes a bug in the cleanup of an spi_bitbang bus. 

It's nearly right, but see below.


> @@ -505,28 +499,10 @@ EXPORT_SYMBOL_GPL(spi_bitbang_start);
>   */
>  int spi_bitbang_stop(struct spi_bitbang *bitbang)
>  {
> -	unsigned	limit = 500;
> -
> -	spin_lock_irq(&bitbang->lock);
> -	bitbang->shutdown = 0;
> -	while (!list_empty(&bitbang->queue) && limit--) {
> -		spin_unlock_irq(&bitbang->lock);
> -
> -		dev_dbg(bitbang->master->cdev.dev, "wait for queue\n");
> -		msleep(10);
> -
> -		spin_lock_irq(&bitbang->lock);
> -	}

You completely removed an odious busy-wait, which is good ...

> -	spin_unlock_irq(&bitbang->lock);
> -	if (!list_empty(&bitbang->queue)) {
> -		dev_err(bitbang->master->cdev.dev, "queue didn't empty\n");
> -		return -EBUSY;
> -	}
> +	spi_unregister_master(bitbang->master);

... but right here there should be a WARN_ON(!list_empty(...)) to
flag the corresponding bogosity:  that somehow a request never
completed.

>  
>  	destroy_workqueue(bitbang->workqueue);
>  
> -	spi_unregister_master(bitbang->master);
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(spi_bitbang_stop);
> 
> 
