Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbXG1Sqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbXG1Sqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 14:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbXG1SqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 14:46:13 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:47803 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbXG1SqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 14:46:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Jiwi9mF9RgMty2isXsuLaJuTLSyzmhyBoql5M/JowwOUfY9y4FH73Gybol4iPRONRna4UqBhdVUdBhcyujLIQnCPUM3a1854KVBbTjFukmlY2QzYV8dO4wh7ZcSH1bbPcp6pZfOZLji/0HFkJH+SZYCTj7ZwGZDWOGwILOEJb00=
Message-ID: <46AB8DF9.8060903@googlemail.com>
Date: Sat, 28 Jul 2007 20:42:01 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jason.wessel@windriver.com, amitkale@linsyssoft.com
Subject: Re: NETPOLL=y , NETDEVICES=n compile error ( Re: 2.6.23-rc1-mm1 )
References: <20070725040304.111550f4.akpm@linux-foundation.org>	<46AB646D.8020104@googlemail.com> <20070728102639.872ec9a0.akpm@linux-foundation.org>
In-Reply-To: <20070728102639.872ec9a0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 28 Jul 2007 17:44:45 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> Hi,
>>
>> I got this compile error with a randconfig ( http://194.231.229.228/MM/randconfig-auto-82.broken.netpoll.c ).
>>
>> ...
>>
>> net/core/netpoll.c: In function 'netpoll_poll':
>> net/core/netpoll.c:155: error: 'struct net_device' has no member named 'poll_controller'
>> net/core/netpoll.c:159: error: 'struct net_device' has no member named 'poll_controller'
>> net/core/netpoll.c: In function 'netpoll_setup':
>> net/core/netpoll.c:670: error: 'struct net_device' has no member named 'poll_controller'
>> make[2]: *** [net/core/netpoll.o] Error 1
>> make[1]: *** [net/core] Error 2
>> make: *** [net] Error 2
>> make: *** Waiting for unfinished jobs....
>>
>> ...
>>
>>
>> I think is because KGDBOE selects just NETPOLL.
>>
> 
> Looks like it.
> 
> Select went and selected NETPOLL and NETPOLL_TRAP but things like
> CONFIG_NETDEVICES and CONFIG_NET_POLL_CONTROLLER remain unset.  `select'
> remains evil.
> 
> Something like this..
> 
> --- a/lib/Kconfig.kgdb~kgdb-kconfig-fix
> +++ a/lib/Kconfig.kgdb
> @@ -175,8 +175,7 @@ endchoice
>  config KGDBOE
>  	tristate "KGDB: On ethernet" if !KGDBOE_NOMODULE
>  	depends on m && KGDB
> -	select NETPOLL
> -	select NETPOLL_TRAP
> +	depends on NETPOLL_TRAP && NET_POLL_CONTROLLER
>  	help
>  	  Uses the NETPOLL API to communicate with the host GDB via UDP.
>  	  In order for this to work, the ethernet interface specified must
> _
> 
> 


That doesn't fix it. With that patch an 'make oldconfig' all NETPOLL stuff gone and we end up with :

...

drivers/built-in.o: In function `option_setup':
/work/crazy/linux-git/MM/linux-2.6.23-rc1/drivers/net/kgdboe.c:160: undefined reference to `netpoll_parse_options'
drivers/built-in.o: In function `configure_kgdboe':
/work/crazy/linux-git/MM/linux-2.6.23-rc1/drivers/net/kgdboe.c:183: undefined reference to `netpoll_setup'
/work/crazy/linux-git/MM/linux-2.6.23-rc1/drivers/net/kgdboe.c:189: undefined reference to `netpoll_cleanup'
drivers/built-in.o: In function `eth_post_exception_handler':
/work/crazy/linux-git/MM/linux-2.6.23-rc1/drivers/net/kgdboe.c:119: undefined reference to `netpoll_set_trap'
drivers/built-in.o: In function `eth_pre_exception_handler':
/work/crazy/linux-git/MM/linux-2.6.23-rc1/drivers/net/kgdboe.c:111: undefined reference to `netpoll_set_trap'
drivers/built-in.o: In function `eth_flush_buf':
/work/crazy/linux-git/MM/linux-2.6.23-rc1/drivers/net/kgdboe.c:138: undefined reference to `netpoll_send_udp'
drivers/built-in.o: In function `eth_get_char':
/work/crazy/linux-git/MM/linux-2.6.23-rc1/drivers/net/kgdboe.c:127: undefined reference to `netpoll_poll'
drivers/built-in.o: In function `cleanup_kgdboe':
/work/crazy/linux-git/MM/linux-2.6.23-rc1/drivers/net/kgdboe.c:217: undefined reference to `netpoll_cleanup'
make: *** [.tmp_vmlinux1] Error 1

...


If I get that right  select is needed here because  all NETPOLL{_*} depends on if NETDEVICES && if NET_ETHERNET.

Also doing 
	
	...
	select NETPOLL_TRAP 
	select NETPOLL
	select NET_POLL_CONTROLLER
	...

makes the driver happy and everything compiles fine.

I think there may be a logical issue ( again if I got it right ).
We need some ethernet card to work with kgdboe right ? but we don't have any if !NETDEVICES && !NET_ETHERNET.

So maybe some ' depends on ... && NETDEVICES!=n && NET_ETHERNET!=n ' is needed too ? 

( really sory if I said something stupid these Kconfig depends are not really easy to figure for me )


Gabriel 
