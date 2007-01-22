Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXAVWMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXAVWMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 17:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbXAVWMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 17:12:07 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:30566 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932078AbXAVWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 17:12:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=j7o4kpujUmGRHlTuCShXHSUf2ARYF8mkqW5nLIEW8/hTV3mvLyu5TDITYTx17Kd70965qT3wwg+7geq06VAQW5La441q/h0YK0C7zGUmJKSMmzEp86IWKNIOiwsFW/fLrmnrZSzCovGL6aqQcHms66acK6Pe1i5G88av7Cz3TaM=  ;
X-YMail-OSG: e30Sat4VM1lXFV7kOuZi5bPlhkkYPGsaJb8nJ4j0XSmaNI2C8BW4FntORQZv_58eBzpDyQ5mNjfiTiP1GeyPzP5UV523B4rpXBsjS.6EGcx5RS9AP7GjibxgUp4dHPQ-
From: David Brownell <david-b@pacbell.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH 2.6.20-rc5] SPI: alternative fix for spi_busnum_to_master
Date: Mon, 22 Jan 2007 14:12:02 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org, hcegtvedt@atmel.com, akpm@osdl.org
References: <20070118.202849.70477632.nemoto@toshiba-tops.co.jp> <20070122.112509.55511116.nemoto@toshiba-tops.co.jp>
In-Reply-To: <20070122.112509.55511116.nemoto@toshiba-tops.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701221412.02452.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 January 2007 6:25 pm, Atsushi Nemoto wrote:

> Here is a revised version.  The children list of spi_master_class
> contains only spi_master class so we can just compare bus_num member
> instead of class_id string.

Looks just a bit iffy ... though, thanks for helping to finally
sort this out!


> +	down(&spi_master_class.sem);
> +	list_for_each_entry(cdev, &spi_master_class.children, node) {
> +		cdev = class_device_get(cdev);
> +		if (!cdev)
> +			continue;

That "continue" case doesn't seem like it should be possible... but
at any rate, the "get" can be deferred until the relevent class
device is known, since that _valid_ handle can't disappear so long
as that semaphore is held.  And if you find the right device but
can't get a reference ... no point in continuing!

Something like a class_find_device() would be the best way to solve
this sort of problem, IMO.  But we don't have one of those.  :(


> +		master = container_of(cdev, struct spi_master, cdev);
> +		if (master->bus_num == bus_num)
> +			break;
> +		master = NULL;
> +		class_device_put(cdev);
> +	}
> +	up(&spi_master_class.sem);
> +	return master;
>  }
>  EXPORT_SYMBOL_GPL(spi_busnum_to_master);
>  
> 
