Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbXCXNtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbXCXNtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 09:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbXCXNtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 09:49:46 -0400
Received: from mx.melware.net ([217.91.97.190]:2428 "EHLO mx.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbXCXNtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 09:49:45 -0400
Date: Sat, 24 Mar 2007 14:49:42 +0100 (CET)
From: Armin Schindler <armin@melware.de>
X-X-Sender: armin@phoenix.one.melware.de
To: Adrian Bunk <bunk@stusta.de>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] fix ISDN_CAPI<->ISDN_DIVAS
In-Reply-To: <20070324130622.GE752@stusta.de>
Message-ID: <Pine.LNX.4.61.0703241442220.28244@phoenix.one.melware.de>
References: <20070324130622.GE752@stusta.de>
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007, Adrian Bunk wrote:
> Randy Dunlap reported in kernel Bugzilla #8241 the following compile 
> error with CONFIG_ISDN_CAPI=m, CONFIG_ISDN_DIVAS=y:
> 
> <--  snip  -->
> 
> ...
> WARNING: "DIVA_DIDD_Read" [drivers/isdn/hardware/eicon/divacapi.ko] undefined!
> WARNING: "DIVA_DIDD_Read" [drivers/isdn/hardware/eicon/diva_mnt.ko] undefined!
> WARNING: "DIVA_DIDD_Read" [drivers/isdn/hardware/eicon/diva_idi.ko] undefined!
> WARNING: "proc_net_eicon" [drivers/isdn/hardware/eicon/diva_idi.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> <--  snip  -->
> 
> 
> Kconfig contains the following strange thing:
> 
> menu "Active Eicon DIVA Server cards"
>         depends on NET && ISDN && ISDN_CAPI!=n
> 
> 
> It seems that except for ISDN_DIVAS_DIVACAPI (that already has a proper 
> dependency), nothing here actually requires ISDN_CAPI?

Not quite true. Yes, the base modules for the divas driver do not require 
ISDN_CAPI, but without ISDN_CAPI it doesn't make any sense.

The patch below (go into /hardware even for non ISDN_CAPI) is wrong. The
subdir /hardware was created for new drivers using CAPI. So it is correct to
go there when ISDN_CAPI != n only.

I don't understand the warnings above. The symbols are exported by divas 
modules, so why is it causing warnings? There have been no change in the 
divas modules for this. Any change in the kernel module creation structure
which may causing this?

Armin
 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
>  drivers/isdn/Makefile               |    2 +-
>  drivers/isdn/hardware/eicon/Kconfig |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.21-rc4-mm1/drivers/isdn/hardware/eicon/Kconfig.old	2007-03-23 21:30:30.000000000 +0100
> +++ linux-2.6.21-rc4-mm1/drivers/isdn/hardware/eicon/Kconfig	2007-03-23 21:26:09.000000000 +0100
> @@ -3,7 +3,7 @@
>  #
>  
>  menu "Active Eicon DIVA Server cards"
> -	depends on NET && ISDN && ISDN_CAPI!=n
> +	depends on NET && ISDN
>  
>  config CAPI_EICON
>  	bool "Support Eicon cards"
> --- linux-2.6.21-rc4-mm1/drivers/isdn/Makefile.old	2007-03-23 21:27:19.000000000 +0100
> +++ linux-2.6.21-rc4-mm1/drivers/isdn/Makefile	2007-03-23 21:27:38.000000000 +0100
> @@ -4,7 +4,7 @@
>  
>  obj-$(CONFIG_ISDN_I4L)			+= i4l/
>  obj-$(CONFIG_ISDN_CAPI)			+= capi/
> -obj-$(CONFIG_ISDN_CAPI)			+= hardware/
> +obj-$(CONFIG_ISDN)			+= hardware/
>  obj-$(CONFIG_ISDN_DIVERSION)		+= divert/
>  obj-$(CONFIG_ISDN_DRV_HISAX)		+= hisax/
>  obj-$(CONFIG_ISDN_DRV_ICN)		+= icn/
> 
