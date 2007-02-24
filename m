Return-Path: <linux-kernel-owner+w=401wt.eu-S933578AbXBXWuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbXBXWuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933577AbXBXWuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:50:22 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43365 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933572AbXBXWuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:50:21 -0500
Date: Sat, 24 Feb 2007 23:50:21 +0100
From: Adrian Bunk <bunk@stusta.de>
To: YOSHIFUJI Hideaki / =?utf-8?B?5ZCJ6Jek6Iux5piO?= 
	<yoshfuji@linux-ipv6.org>
Cc: clem@clem.clem-digital.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.20-git8 fails compile -- net/built-in.o __ipv6_addr_type
Message-ID: <20070224225021.GT12392@stusta.de>
References: <20070213.111345.78160400.yoshfuji@linux-ipv6.org> <200702130236.l1D2a0u7014457@clem.clem-digital.net> <20070213.115510.21486123.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070213.115510.21486123.yoshfuji@linux-ipv6.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 11:55:10AM +0900, YOSHIFUJI Hideaki / 吉藤英明 wrote:
> In article <200702130236.l1D2a0u7014457@clem.clem-digital.net> (at Mon, 12 Feb 2007 21:35:59 -0500 (EST)), Pete Clements <clem@clem.clem-digital.net> says:
> 
> > Quoting YOSHIFUJIHideaki/=?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
> >   > In article <20070212181216.c55ca788.akpm@linux-foundation.org> (at Mon, 12 Feb 2007 18:12:16 -0800), Andrew Morton <akpm@linux-foundation.org> says:
> >   > 
> >   > > > On Mon, 12 Feb 2007 20:10:13 -0500 (EST) Pete Clements <clem@clem.clem-digital.net> wrote:
> >   > > > 2.6.20-git8 fails compile:
> >   > > > 
> >   > > >   CHK     include/linux/compile.h
> >   > > >   UPD     include/linux/compile.h
> >   > > >   CC      init/version.o
> >   > > >   LD      init/built-in.o
> >   > > >   LD      .tmp_vmlinux1
> >   > > > net/built-in.o: In function `svc_udp_recvfrom':
> >   > > > svcsock.c:(.text+0x61be4): undefined reference to `__ipv6_addr_type'
> >   > > > make: *** [.tmp_vmlinux1] Error 1
> >   > > > 
> >   > > 
> >   > > Please send the .config.
> >   > 
> >   > and, the gcc version...
> >   > 
> >   > --yoshfuji
> >   > -
> > 
> > git 7 compiled just fine.
> 
> Ah, this is because of new ipv6 support in sunrpc code.
> Enable it if it is statically compiled.
> 
> Alternatively, we could 
> - export __ipv6_addr_type in new net/ipv6/addrconf_core.c
> or
> - introduce tiny inline for chcking if the address is link-local.
> 
> Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
> 
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 63ae947..27dcb31 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -107,12 +107,12 @@ static inline void svc_reclassify_socket
>  		sock_lock_init_class_and_name(sk, "slock-AF_INET-NFSD",
>  		    &svc_slock_key[0], "sk_lock-AF_INET-NFSD", &svc_key[0]);
>  		break;
> -
> +#ifdef CONFIG_IPV6
>  	case AF_INET6:
>  		sock_lock_init_class_and_name(sk, "slock-AF_INET6-NFSD",
>  		    &svc_slock_key[1], "sk_lock-AF_INET6-NFSD", &svc_key[1]);
>  		break;
> -
> +#endif
>  	default:
>  		BUG();
>  	}
> @@ -131,7 +131,7 @@ static char *__svc_print_addr(struct soc
>  			NIPQUAD(((struct sockaddr_in *) addr)->sin_addr),
>  			htons(((struct sockaddr_in *) addr)->sin_port));
>  		break;
> -#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
> +#if defined(CONFIG_IPV6)
>...


In the CONFIG_IPV6=m, CONFIG_SUNRPC=m case, this will result in no IPV6 
support here.

If you are going this way, a Kconfig helper variable might be better:

config SUNRPC_IPV6
	bool
	default y if (SUNRPC=y && IPV6=y) || (SUNRPC=m && IPV6) 


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

