Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbYG3JOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbYG3JOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759264AbYG3JOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:14:09 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:3070 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759355AbYG3JOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:14:07 -0400
Date: Wed, 30 Jul 2008 04:13:47 -0500 (CDT)
Message-Id: <200807300913.m6U9DluI040346@sullivan.realtime.net>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH] hvc - register all available consoles (was: Re: [PATCH] powerpc/lpar - defer prefered console setup)
To: Bastian Blank <waldi@debian.org>
In-Reply-To: <20080730073438.GA29700@wavehammer.waldi.eu.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Michael Ellerman <michael@ellerman.id.au>
References: <20080730073438.GA29700@wavehammer.waldi.eu.org>,
	<20080730062919.GA27281@wavehammer.waldi.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Jul 30 at 17:34:38 EST in 2008, Bastian Blank wrote:
> On Wed, Jul 30, 2008 at 08:29:19AM +0200, Bastian Blank wrote:
>> Okay, so hvc_console is the culprit. It don't register a preferred
>> console if it knows it is not the first in the list.
>
> The patch registers all available hvc consoles. It adds one "struct
> console" for all possible hvc consoles.

[ a 6 page patch adding forward declartions, arrays of console
structs, moving lots of code and creating N struct console in the
hvc_driver shell]

After previously having written:
> On Wed, Jul 30, 2008 at 08:23:13AM +0200, Bastian Blank wrote:
>> On Wed, Jul 30, 2008 at 12:34:51PM +1000, Michael Ellerman wrote:
>>> On Mon, 2008-07-28 at 20:56 +0200, Bastian Blank wrote:
>>>  * add_preferred_console - add a device to the list of preferred consoles.
>>>  ...
>>>  * The last preferred console added will be used for kernel messages
>>>  * and stdin/out/err for init. 
>>> 
>>> The last console will be added by the console= parsing, and so that will
>>> be used. The console we add in the pseries setup is only used if nothing
>>> is specified on the command line.
>> 
>> Okay, then there is a completely different problem. In the case of
>> "console=hvc0 console=hvc1" it uses the _first_ add stdin/out bla and
>> ignores the second one completely.
> 
> Okay, so hvc_console is the culprit. It don't register a preferred
> console if it knows it is not the first in the list.
> 
> Bastian


[ back to the patch ]
> -/*
> - * Early console initialization.  Precedes driver initialization.
> - *
> - * (1) we are first, and the user specified another driver
> - * -- index will remain -1
> - * (2) we are first and the user specified no driver
> - * -- index will be set to 0, then we will fail setup.
> - * (3)  we are first and the user specified our driver
> - * -- index will be set to user specified driver, and we will fail
> - * (4) we are after driver, and this initcall will register us
> - * -- if the user didn't specify a driver then the console will match
> - *
> - * Note that for cases 2 and 3, we will match later when the io driver
> - * calls hvc_instantiate() and call register again.
> - */
> -static int __init hvc_console_init(void)
> -{
> -	register_console(&hvc_con_driver);
> -	return 0;
> 


Please explain how the reasoning you removed breaks down.

What is your usage case?


More importantly , how is this different than, say, drivers/serial/8250.c,
which also registers just one struct console?

would not console=ttyS0 console=ttyS1 have the same problem?


Please instrument the calls to register_console and add_preferred_console
and give a detailed description of the problem you are encountering.

Perhaps the real fix should be scan the command line for console= at
console_init time?   How does that compare to __setup that is called now?



>  		for (i = 0; i < n; ++i) {
>  #ifdef CONFIG_MAGIC_SYSRQ
> -			if (hp->index == hvc_con_driver.index) {
> +			if (consoles[hp->index].console.flags & CON_CONSDEV) {
>  				/* Handle the SysRq Hack */
>  				/* XXX should support a sequence */
>  				if (buf[i] == '\x0f') {	/* ^O */
> @@ -775,8 +764,8 @@ struct hvc_struct __devinit *hvc_alloc(uint32_t vtermno, int irq,
>  	 * see if this vterm id matches one registered for console.
>  	 */
>  	for (i=0; i < MAX_NR_HVC_CONSOLES; i++)
> -		if (vtermnos[i] == hp->vtermno &&
> -		    cons_ops[i] == hp->ops)
> +		if (consoles[i].vtermno == hp->vtermno &&
> +		    consoles[i].ops == hp->ops)
>  			break;
>  


NACK
you broke this assertion:
>  /*
>   * Initial console vtermnos for console API usage prior to full console
>   * initialization.  Any vty adapter outside this range will not have usable
>   * console interfaces but can still be used as a tty device.  This has to be
>   * static because kmalloc will not work during early console init.
>   */


The idea is you might want serial port to 250 other partitions, but only
need to have your choice of console be on the first 8 or so.

milton
