Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162Ab0AGA2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0AGA2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940Ab0AGA2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:28:37 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:47263 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab0AGA2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:28:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=jFCV1eM4kC4A5GPFvGWfWZmuVMLkO6Dts2v9spbcj4kzcuG2RWrIDUGCpLFgkYHGSq
         xmqqL75tfgZIWw4kAO1W2KgSipec8bqWsf/WGFHvok4ohrm94Ocx6trrMeo6j/Kv4D1Z
         mrBD8+A2KeP5mp0+r93o1gLJWbvj2PoehFZYc=
Date: Wed, 6 Jan 2010 18:28:30 -0600
From: J K Cliburn <jcliburn@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Chris Snook <chris.snook@gmail.com>, Jie Yang <jie.yang@atheros.com>,
       atl1-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] NET: atlx, fix memory leak
Message-ID: <20100106182830.4bd861fe@gmail.com>
In-Reply-To: <1262796856-21919-1-git-send-email-jslaby@suse.cz>
References: <1262796856-21919-1-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Jan 2010 17:54:16 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> Stanse found a memory leak in atl2_get_eeprom. eeprom_buff is not
> freed/assigned on all paths. Fix that.

Acked by: Jay Cliburn <jcliburn@gmail.com>

> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Jay Cliburn <jcliburn@gmail.com>
> Cc: Chris Snook <chris.snook@gmail.com>
> Cc: Jie Yang <jie.yang@atheros.com>
> Cc: atl1-devel@lists.sourceforge.net
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/atlx/atl2.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
> index c0451d7..ec52529 100644
> --- a/drivers/net/atlx/atl2.c
> +++ b/drivers/net/atlx/atl2.c
> @@ -1959,12 +1959,15 @@ static int atl2_get_eeprom(struct net_device
> *netdev, return -ENOMEM;
>  
>  	for (i = first_dword; i < last_dword; i++) {
> -		if (!atl2_read_eeprom(hw, i*4,
> &(eeprom_buff[i-first_dword])))
> -			return -EIO;
> +		if (!atl2_read_eeprom(hw, i*4,
> &(eeprom_buff[i-first_dword]))) {
> +			ret_val = -EIO;
> +			goto free;
> +		}
>  	}
>  
>  	memcpy(bytes, (u8 *)eeprom_buff + (eeprom->offset & 3),
>  		eeprom->len);
> +free:
>  	kfree(eeprom_buff);
>  
>  	return ret_val;

