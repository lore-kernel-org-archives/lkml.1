Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYDHPlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYDHPlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYDHPlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:41:44 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:55047 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbYDHPln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:41:43 -0400
Message-ID: <47FB920F.60503@s5r6.in-berlin.de>
Date: Tue, 08 Apr 2008 17:41:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, sam <sam@ravnborg.org>
Subject: Re: [PATCH] introduce HAVE_EFFICIENT_UNALIGNED_ACCESS Kconfig symbol
References: <1207667127.14253.42.camel@johannes.berg>
In-Reply-To: <1207667127.14253.42.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> --- everything.orig/Documentation/unaligned-memory-access.txt	2008-04-04 23:42:50.000000000 +0200
> +++ everything/Documentation/unaligned-memory-access.txt	2008-04-04 23:52:15.000000000 +0200
> @@ -218,9 +218,35 @@ If use of such macros is not convenient,
>  where the source or destination (or both) are of type u8* or unsigned char*.
>  Due to the byte-wise nature of this operation, unaligned accesses are avoided.
>  
> +
> +Alignment vs. Networking
> +========================
> +
> +On architectures that require aligned loads, networking requires that the IP
> +header is aligned on a four-byte boundary to optimise the IP stack. For
> +regular ethernet hardware, the constant NET_IP_ALIGN is used, on most

                                                               . On

> +architectures this constant has the value 2 because the normal ethernet
> +header is 14 bytes long, so in order to get proper alignment one needs to

                          . So

> +DMA to an address that is can be expressed as 4*n + 2. One notable exception

                      which can

> +here is powerpc which defines NET_IP_ALIGN to 0 because DMA to unaligned
> +addresses can be very expensive and dwarf the cost of unaligned loads.
> +
> +For some ethernet hardware that cannot DMA to unaligned addresses like
> +4*n+2 or non-ethernet hardware, this can be a problem, and it is then
> +required to copy the incoming frame into an aligned buffer. Because this is
> +unnecessary on architectures that can do unaligned accesses, the code can be
> +made depend on CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS like so:

   made dependent on

> +
> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +	skb = original skb
> +#else
> +	skb = copy skb
> +#endif
> +
>  --
> -Author: Daniel Drake <dsd@gentoo.org>
> +Authors: Daniel Drake <dsd@gentoo.org>,
> +         Johannes Berg <johannes@sipsolutions.net>
>  With help from: Alan Cox, Avuton Olrich, Heikki Orsila, Jan Engelhardt,
> -Johannes Berg, Kyle McMartin, Kyle Moffett, Randy Dunlap, Robert Hancock,
> -Uli Kunitz, Vadim Lobanov
> +Kyle McMartin, Kyle Moffett, Randy Dunlap, Robert Hancock, Uli Kunitz,
> +Vadim Lobanov
>  
> --- everything.orig/arch/powerpc/Kconfig	2008-04-04 23:42:53.000000000 +0200
> +++ everything/arch/powerpc/Kconfig	2008-04-04 23:52:15.000000000 +0200
> @@ -103,6 +103,7 @@ config PPC
>  	select HAVE_OPROFILE
>  	select HAVE_KPROBES
>  	select HAVE_KRETPROBES
> +	select HAVE_EFFICIENT_UNALIGNED_ACCESS
>  
>  config EARLY_PRINTK
>  	bool
> --- everything.orig/arch/x86/Kconfig	2008-04-04 23:42:50.000000000 +0200
> +++ everything/arch/x86/Kconfig	2008-04-04 23:52:15.000000000 +0200
> @@ -23,6 +23,7 @@ config X86
>  	select HAVE_KPROBES
>  	select HAVE_KRETPROBES
>  	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
> +	select HAVE_EFFICIENT_UNALIGNED_ACCESS
>  
>  
>  config GENERIC_LOCKBREAK
> --- everything.orig/arch/Kconfig	2008-04-04 23:42:50.000000000 +0200
> +++ everything/arch/Kconfig	2008-04-04 23:52:15.000000000 +0200
> @@ -36,3 +36,22 @@ config HAVE_KPROBES
>  
>  config HAVE_KRETPROBES
>  	def_bool n
> +
> +config HAVE_EFFICIENT_UNALIGNED_ACCESS
> +	def_bool n
> +	help
> +	  Some architectures are unable to perform unaligned accesses
> +	  without the use of get_unaligned/put_unaligned. Others are
> +	  unable to perform such accesses efficiently (e.g. trap on

Wouldn't a comment be more appropriate instead of a help text?  This
option shouldn't be a visible make XYZconfig prompt.

I have no comment on the option itself; it's not my domain.
-- 
Stefan Richter
-=====-==--- -=-- -=---
http://arcgraph.de/sr/
