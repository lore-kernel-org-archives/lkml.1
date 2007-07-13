Return-Path: <linux-kernel-owner+w=401wt.eu-S937199AbXGMT7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937199AbXGMT7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758677AbXGMT7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:59:36 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:25984 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757684AbXGMT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:59:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=krl7EqSXO7qL9Y5VltaHt4demv/ZmEuzdcJzeuwEpP7FbGP/vqV+26tizeDsfnp0HHxj90doHHS4ATzhH5YYrk3NgQe2njcqx3/MESik0QzO55eHYYpsjNkG6capnU5gx/8KYjRfyQh3OtaHacyd7h3jWYWGuK2EIoQH2jZdL9E=  ;
X-YMail-OSG: q8B0IJsVM1m8DLCMRpwWJbKS_8T34dcehQ9zawnNxk9Ulmi32FiUrrw742PCdy2VOhzLMrmpOHMN4t2T_4zyMqSf2HVOuuBUyFe_KzJe1X05jmJvisDh.fNV
From: David Brownell <david-b@pacbell.net>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: Re: [PATCH 1/5] use mutex instead of semaphore in SPI core/init code
Date: Fri, 13 Jul 2007 12:59:32 -0700
User-Agent: KMail/1.9.6
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070713192023.GD18159@traven> <20070713192347.GE18159@traven>
In-Reply-To: <20070713192347.GE18159@traven>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707131259.33011.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 July 2007, Matthias Kaehlcke wrote:
> The SPI core/init code uses a semaphore as mutex. Use the mutex
> API instead of the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

ACK ... and thanks!

> 
> --
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 4831edb..018884d 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -23,6 +23,7 @@
>  #include <linux/device.h>
>  #include <linux/init.h>
>  #include <linux/cache.h>
> +#include <linux/mutex.h>
>  #include <linux/spi/spi.h>
>  
>  
> @@ -185,7 +186,7 @@ struct boardinfo {
>  };
>  
>  static LIST_HEAD(board_list);
> -static DECLARE_MUTEX(board_lock);
> +static DEFINE_MUTEX(board_lock);
>  
>  
>  /**
> @@ -292,9 +293,9 @@ spi_register_board_info(struct spi_board_info const *info, unsigned n)
>  	bi->n_board_info = n;
>  	memcpy(bi->board_info, info, n * sizeof *info);
>  
> -	down(&board_lock);
> +	mutex_lock(&board_lock);
>  	list_add_tail(&bi->list, &board_list);
> -	up(&board_lock);
> +	mutex_unlock(&board_lock);
>  	return 0;
>  }
>  
> @@ -308,7 +309,7 @@ scan_boardinfo(struct spi_master *master)
>  	struct boardinfo	*bi;
>  	struct device		*dev = master->cdev.dev;
>  
> -	down(&board_lock);
> +	mutex_lock(&board_lock);
>  	list_for_each_entry(bi, &board_list, list) {
>  		struct spi_board_info	*chip = bi->board_info;
>  		unsigned		n;
> @@ -330,7 +331,7 @@ scan_boardinfo(struct spi_master *master)
>  			(void) spi_new_device(master, chip);
>  		}
>  	}
> -	up(&board_lock);
> +	mutex_unlock(&board_lock);
>  }
>  
>  /*-------------------------------------------------------------------------*/
> 
> -- 
> Matthias Kaehlcke
> Linux Application Developer
> Barcelona
> 
>     Ma patrie est où je suis, où personne ne me dérange, où personne
>     ne me demande que je suis, d'où je viens et ce que je fais
>                               (B. Traven)
>                                                                  .''`.
>     using free software / Debian GNU/Linux | http://debian.org  : :'  :
>                                                                 `. `'`
> gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
> 


