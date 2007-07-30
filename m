Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbXG3KNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbXG3KNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 06:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXG3KNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 06:13:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:8968 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbXG3KNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 06:13:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=I8S0Zul88xAnNluuxzB4r14r0ppqGX7y5CbySYLHQ0Qw2GmMLbXrq5/aEhEXOdMMv+7NjUbl8XtuD9w8YUFluu4c1mnPQ3ximCTATSs/CvRovObxj9l+UXfPatYnzeCx7eHVvM34/uFNLFwS9yEWXoTSz+ApEu6aDv62TOY65XU=
Message-ID: <46ADB8BD.6010600@googlemail.com>
Date: Mon, 30 Jul 2007 12:09:01 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Satyam Sharma <satyam.sharma@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lguest <lguest@ozlabs.org>
Subject: Re: [PATCH] Make lguest compile with CONFIG_BLOCK=n and	CONFIG_NET=n
References: <46ACAFBF.6060609@googlemail.com>	 <1185755123.12151.102.camel@localhost.localdomain>	 <a781481a0707291748x5a70c2d3i83ef54d7f2336b33@mail.gmail.com> <1185757669.12151.108.camel@localhost.localdomain>
In-Reply-To: <1185757669.12151.108.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Mon, 2007-07-30 at 06:18 +0530, Satyam Sharma wrote:
>> On 7/30/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> +config LGUEST_NET
>>> +       tristate
>>> +       depends on LGUEST_GUEST && NET
>> default y ?
> 
> Thanks, that does work better.  Clean configs get an "N" otherwise 8(
> 
>> I /think/ the default "y" would also automatically become "m" if any of the
>> dependencies are modules ... probably need to test this, though.
> 
> No, it doesn't seem to.  But LGUEST_GUEST is a bool anyway, so it's OK.
> 
> Thanks!
> Rusty.

Works fine this way.

BTW the wrong patch without the default y got merged.


> ==
> Make lguest compile with CONFIG_BLOCK=n and CONFIG_NET=n
> 
> Gabriel C reports lguest doesn't compile with CONFIG_BLOCK=n.  Fix
> this by introducing a config var for the block device, which depends
> on LGUEST && BLOCK.  Do the same for the net driver, rather then
> depending gratuitously on CONFIG_NET.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff -r 9e987fcabb16 drivers/block/Makefile
> --- a/drivers/block/Makefile	Mon Jul 30 09:47:25 2007 +1000
> +++ b/drivers/block/Makefile	Mon Jul 30 10:02:32 2007 +1000
> @@ -31,4 +31,4 @@ obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
>  obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
>  
>  obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
> -obj-$(CONFIG_LGUEST_GUEST)	+= lguest_blk.o
> +obj-$(CONFIG_LGUEST_BLOCK)	+= lguest_blk.o
> diff -r 9e987fcabb16 drivers/lguest/Kconfig
> --- a/drivers/lguest/Kconfig	Mon Jul 30 09:47:25 2007 +1000
> +++ b/drivers/lguest/Kconfig	Mon Jul 30 10:03:39 2007 +1000
> @@ -1,6 +1,6 @@ config LGUEST
>  config LGUEST
>  	tristate "Linux hypervisor example code"
> -	depends on X86 && PARAVIRT && NET && EXPERIMENTAL && !X86_PAE
> +	depends on X86 && PARAVIRT && EXPERIMENTAL && !X86_PAE
>  	select LGUEST_GUEST
>  	select HVC_DRIVER
>  	---help---
> @@ -18,3 +18,13 @@ config LGUEST_GUEST
>  	  The guest needs code built-in, even if the host has lguest
>  	  support as a module.  The drivers are tiny, so we build them
>  	  in too.
> +
> +config LGUEST_NET
> +	tristate
> +	default y
> +	depends on LGUEST_GUEST && NET
> +
> +config LGUEST_BLOCK
> +	default y
> +	tristate
> +	depends on LGUEST_GUEST && BLOCK
> diff -r 9e987fcabb16 drivers/net/Makefile
> --- a/drivers/net/Makefile	Mon Jul 30 09:47:25 2007 +1000
> +++ b/drivers/net/Makefile	Mon Jul 30 10:02:22 2007 +1000
> @@ -177,7 +177,7 @@ obj-$(CONFIG_HPLANCE) += hplance.o 7990.
>  obj-$(CONFIG_HPLANCE) += hplance.o 7990.o
>  obj-$(CONFIG_MVME147_NET) += mvme147.o 7990.o
>  obj-$(CONFIG_EQUALIZER) += eql.o
> -obj-$(CONFIG_LGUEST_GUEST) += lguest_net.o
> +obj-$(CONFIG_LGUEST_NET) += lguest_net.o
>  obj-$(CONFIG_MIPS_JAZZ_SONIC) += jazzsonic.o
>  obj-$(CONFIG_MIPS_AU1X00_ENET) += au1000_eth.o
>  obj-$(CONFIG_MIPS_SIM_NET) += mipsnet.o
> 
> 
> 
