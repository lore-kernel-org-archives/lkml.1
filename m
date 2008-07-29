Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYG2DGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYG2DGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 23:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYG2DGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 23:06:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:56439 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbYG2DGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 23:06:34 -0400
Subject: Re: [PATCH] powerpc/lpar - defer prefered console setup
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bastian Blank <waldi@debian.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080728185651.GA29530@wavehammer.waldi.eu.org>
References: <20080728185651.GA29530@wavehammer.waldi.eu.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 13:06:18 +1000
Message-Id: <1217300778.11188.233.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 20:56 +0200, Bastian Blank wrote:
> Hi
> 
> The powerpc lpar code adds a prefered console at a very early state,
> during arch_setup. This runs even before the console setup from the
> command line and takes preference.
> 
> This patch moves the prefered console setup into an arch_initcall which
> runs later and allows the specification of the correct console on the
> command line. The udbg console remains as boot console.
> 
> There is a different problem that the code does not pick up the correct
> console because it uses a part (4) of the lpar device number (30000004)
> instead of the correct index 1.
> 
> Signed-off-by: Bastian Blank <waldi@debian.org>

Shouldn't it be a console_initcall() ? 

Now, regarding the "different problem" I think it's even worse than
that, looking at the code there's some non sensical things in here...

add_preferred_console() argument is what gets compared to
console->index, right ? Now if you look at hvc_instantiate(),
it compares each "index" argument passed in to hvc_con_driver.index,
and that index argument passed from hvc_find_vtys() has strictly
nothing to do with the vtermno, it's purely the index of the node
found in order...

So I think the whole stuff is non-sensical and needs fixing. 

Cheers,
Ben.

> diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
> index 9235c46..626290d 100644
> --- a/arch/powerpc/platforms/pseries/lpar.c
> +++ b/arch/powerpc/platforms/pseries/lpar.c
> @@ -57,6 +57,7 @@ extern void pSeries_find_serial_port(void);
>  
> 
>  int vtermno;	/* virtual terminal# for udbg  */
> +static char *console_name;
>  
>  #define __ALIGNED__ __attribute__((__aligned__(sizeof(long))))
>  static void udbg_hvsi_putc(char c)
> @@ -232,18 +233,24 @@ void __init find_udbg_vterm(void)
>  		udbg_putc = udbg_putcLP;
>  		udbg_getc = udbg_getcLP;
>  		udbg_getc_poll = udbg_getc_pollLP;
> -		add_preferred_console("hvc", termno[0] & 0xff, NULL);
> +		console_name = "hvc";
>  	} else if (of_device_is_compatible(stdout_node, "hvterm-protocol")) {
> -		vtermno = termno[0];
>  		udbg_putc = udbg_hvsi_putc;
>  		udbg_getc = udbg_hvsi_getc;
>  		udbg_getc_poll = udbg_hvsi_getc_poll;
> -		add_preferred_console("hvsi", termno[0] & 0xff, NULL);
> +		console_name = "hvsi";
>  	}
>  out:
>  	of_node_put(stdout_node);
>  }
>  
> +static void __init enable_vterm(void)
> +{
> +	if (console_name)
> +		add_preferred_console(console_name, vtermno, NULL);
> +}
> +arch_initcall(enable_vterm);
> +
>  void vpa_init(int cpu)
>  {
>  	int hwcpu = get_hard_smp_processor_id(cpu);
> 

