Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbZCII5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbZCII5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZCII4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:56:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47843 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbZCII4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:56:53 -0400
Message-ID: <49B4D9CD.4080803@redhat.com>
Date: Mon, 09 Mar 2009 09:56:45 +0100
From: Ivan Vecera <ivecera@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: Tim Durack <tdurack@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: r8169 MAC problem
References: <9e246b4d0903061127q7c82103dq88c5184765f3c17a@mail.gmail.com> <9e246b4d0903061129g7b66dc3bm8013b75be671ca33@mail.gmail.com> <20090306200515.GA26365@electric-eye.fr.zoreil.com>
In-Reply-To: <20090306200515.GA26365@electric-eye.fr.zoreil.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Please Cc: Ivan.
> 
> Tim Durack <tdurack@gmail.com> :
> [...]
>> Any ideas?
> 
> Damn me, I should have noticed that the delay was below spec :o(
Francois, you are right, but IMHO there is no problem with reading of MAC from
EEPROM (see log... "MAC address found...") but there is a problem with assignment
of this MAC.
Interesting is that Tim's eth0 and eth1 are affected but eth2 is working well
thought all of them have the same XID. Maybe some delay after leaving of programming
mode could help.

Ivan
> 
> Can you try the patch below on top of the current git kernel ?
> 
> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index b347340..dfd42db 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@ -1970,9 +1970,14 @@ static const struct net_device_ops rtl8169_netdev_ops = {
>  };
>  
>  /* Delay between EEPROM clock transitions. Force out buffered PCI writes. */
> -#define RTL_EEPROM_DELAY()	RTL_R8(Cfg9346)
>  #define RTL_EEPROM_READ_CMD	6
>  
> +static void rtl_eeprom_delay(void __iomem *ioaddr)
> +{
> +	RTL_R8(Cfg9346);
> +	ndelay(450);
> +}
> +
>  /* read 16bit word stored in EEPROM. EEPROM is addressed by words. */
>  static u16 rtl_eeprom_read(void __iomem *ioaddr, int addr)
>  {
> @@ -1992,7 +1997,7 @@ static u16 rtl_eeprom_read(void __iomem *ioaddr, int addr)
>  
>  	/* enter programming mode */
>  	RTL_W8(Cfg9346, Cfg9346_Program | Cfg9346_EECS);
> -	RTL_EEPROM_DELAY();
> +	rtl_eeprom_delay(ioaddr);
>  
>  	/* write command and requested address */
>  	while (cmd_len--) {
> @@ -2002,29 +2007,29 @@ static u16 rtl_eeprom_read(void __iomem *ioaddr, int addr)
>  
>  		/* write a bit */
>  		RTL_W8(Cfg9346, x);
> -		RTL_EEPROM_DELAY();
> +		rtl_eeprom_delay(ioaddr);
>  
>  		/* raise clock */
>  		RTL_W8(Cfg9346, x | Cfg9346_EESK);
> -		RTL_EEPROM_DELAY();
> +		rtl_eeprom_delay(ioaddr);
>  	}
>  
>  	/* lower clock */
>  	RTL_W8(Cfg9346, Cfg9346_Program | Cfg9346_EECS);
> -	RTL_EEPROM_DELAY();
> +	rtl_eeprom_delay(ioaddr);
>  
>  	/* read back 16bit value */
>  	for (i = 16; i > 0; i--) {
>  		/* raise clock */
>  		RTL_W8(Cfg9346, Cfg9346_Program | Cfg9346_EECS | Cfg9346_EESK);
> -		RTL_EEPROM_DELAY();
> +		rtl_eeprom_delay(ioaddr);
>  
>  		result <<= 1;
>  		result |= (RTL_R8(Cfg9346) & Cfg9346_EEDO) ? 1 : 0;
>  
>  		/* lower clock */
>  		RTL_W8(Cfg9346, Cfg9346_Program | Cfg9346_EECS);
> -		RTL_EEPROM_DELAY();
> +		rtl_eeprom_delay(ioaddr);
>  	}
>  
>  	RTL_W8(Cfg9346, Cfg9346_Program);

