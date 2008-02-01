Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYBAN6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYBAN6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYBAN6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:58:32 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:36889 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752090AbYBAN6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:58:31 -0500
Message-ID: <47A325BC.6030305@ru.mvista.com>
Date: Fri, 01 Feb 2008 16:59:24 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       kgdb-bugreport@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Kgdb-bugreport] [PATCH 4/5] KGDB-8250: refactor configuration
References: <479FBAE8.3070809@web.de> <479FC57D.5030104@web.de>
In-Reply-To: <479FC57D.5030104@web.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jan Kiszka wrote:

> Sorry, previous version was missing some __init[data] attributes which
> were dropped in an intermediate stage. Here comes an updated patch:

> <---snip--->

> This major refactoring of the quite complex kgdb8250 configuration does
> the following:

>  - ensures that static configurations according to SERIAL_PORT_DFNS are
>    always loaded first
>  - tries to pull more accurate configuration via serial8250_get_port_def
>    if simple-config is used
>  - detects empty/invalid simple-configs
>  - enforces KGDB_PORT_NUM <= SERIAL_8250_NR_UARTS at kconfig level
>  - removes kgdb8250_add_port and its hook in serial_core (calling
>    serial8250_get_port_def in demand should provide us the same
>    information)

    You left powerpc-lite.patch broken with this change as it has multiple 
calls to kgdb8250_add_port()...

> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

> Index: b/drivers/serial/serial_core.c
> ===================================================================
> --- a/drivers/serial/serial_core.c
> +++ b/drivers/serial/serial_core.c
[...]
> @@ -2370,12 +2369,6 @@ int uart_add_one_port(struct uart_driver
>  	 */
>  	port->flags &= ~UPF_DEAD;
>  
> -#if defined(CONFIG_KGDB_8250)
> -	/* Add any 8250-like ports we find later. */
> -	if (port->type <= PORT_MAX_8250)
> -		kgdb8250_add_port(port->line, port);
> -#endif
> -

    I'm afraid this wasn't correct from the very start since this can add 
ports with .iotype that 8250_kgdb.c does not support. So, nothing to regret 
here...

WBR, Sergei
