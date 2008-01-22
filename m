Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbYAVHmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbYAVHmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 02:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYAVHlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 02:41:53 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:43258 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752193AbYAVHlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 02:41:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pf/U2WjTnjvj14wCiF5v/AQ1dgJpMMpBvDrO6J8fHyMJbrLN22NhXsGd66dHbS8Y8t+dWbBB9k2lFDgk03xKt3QuIsHh41QsQGWjF4JlG1Co6TOs5R30TfHIyoOZqDrEcxWH4g5lpvmhQYOxK2cn9ynhglBEvECa/PE3Afa84J0=  ;
X-YMail-OSG: QUcNvr8VM1mwUCPjXJGTo0ljPZQ5c_jLvPfSXcUK5KKBo8MMuKryrdTRLVDEfwP5rPsZ6Egx4w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 6/6] spi : use class iteration api
Date: Mon, 21 Jan 2008 23:41:50 -0800
User-Agent: KMail/1.9.6
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
References: <20080112095711.GF2893@darkstar.te-china.tietoenator.com> <200801212256.11484.david-b@pacbell.net> <20080122071418.GA3725@darkstar.te-china.tietoenator.com>
In-Reply-To: <20080122071418.GA3725@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801212341.50999.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2008, Dave Young wrote:
> Convert to use the class iteration api.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

Ack.


> ---
>  drivers/spi/spi.c |   24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff -upr linux/drivers/spi/spi.c linux.new/drivers/spi/spi.c
> --- linux/drivers/spi/spi.c	2008-01-22 15:09:49.000000000 +0800
> +++ linux.new/drivers/spi/spi.c	2008-01-22 15:09:49.000000000 +0800
> @@ -485,6 +485,15 @@ void spi_unregister_master(struct spi_ma
>  }
>  EXPORT_SYMBOL_GPL(spi_unregister_master);
>  
> +static int __spi_master_match(struct device *dev, void *data)
> +{
> +	struct spi_master *m;
> +	u16 *bus_num = data;
> +
> +	m = container_of(dev, struct spi_master, dev);
> +	return m->bus_num == *bus_num;
> +}
> +
>  /**
>   * spi_busnum_to_master - look up master associated with bus_num
>   * @bus_num: the master's bus number
> @@ -499,17 +508,12 @@ struct spi_master *spi_busnum_to_master(
>  {
>  	struct device		*dev;
>  	struct spi_master	*master = NULL;
> -	struct spi_master	*m;
>  
> -	down(&spi_master_class.sem);
> -	list_for_each_entry(dev, &spi_master_class.children, node) {
> -		m = container_of(dev, struct spi_master, dev);
> -		if (m->bus_num == bus_num) {
> -			master = spi_master_get(m);
> -			break;
> -		}
> -	}
> -	up(&spi_master_class.sem);
> +	dev = class_find_device(&spi_master_class, &bus_num,
> +				__spi_master_match);
> +	if (dev)
> +		master = container_of(dev, struct spi_master, dev);
> +	/* reference got in class_find_device */
>  	return master;
>  }
>  EXPORT_SYMBOL_GPL(spi_busnum_to_master);
> 


