Return-Path: <linux-kernel-owner+w=401wt.eu-S2992813AbXDRQQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992813AbXDRQQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992812AbXDRQQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:16:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37039 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992800AbXDRQQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:16:45 -0400
Date: Wed, 18 Apr 2007 09:16:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: izumi2005@soft.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: [PATCH][BUG] Fix possible NULL pointer access in 8250 serial
 driver
Message-Id: <20070418091626.925f2d72.akpm@linux-foundation.org>
In-Reply-To: <1176884513.3945.54.camel@kane-linux>
References: <46242DD2.7030207@soft.fujitsu.com>
	<20070416225206.cf7d8cd2.akpm@linux-foundation.org>
	<1176884513.3945.54.camel@kane-linux>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 18 Apr 2007 17:21:53 +0900 Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:
> > I'd imagine that other serial drivers might get upset having their
> > ->get_mcrtl() called prior to being opened.  Perhaps we should be fixing
> > this in uart_read_proc()?
> > 
> 
> I looked at other serial drivers and I could not find any other
> drivers which accesses port->info in their ->get_mctrl(). This 
> is why we fix this problem in 8250 driver. But if there is a
> possibility that other drivers accesses port->info in their
> ->get_mctrl(), we should be fixing this in uart_read_proc(), as
> you said.

OK.  But port->info might not be the only state which is initialised
in open() which is used in get_mctrl().

> How about the following patch? We've also confirmed the problem
> is fixed by it.
> 

Thanks.  Or we could just avoid calling into ->get_mctrl() if the port isn't
opened.  Russell?  Any preferences?

> 
> 
> This patch fixes the problem that uninitialized (NULL) 'info' member
> of uart_port structure can be accessed if serial driver is accessed
> through /proc filesystem before uart_open(), which initializes the
> 'info' member', is called.
> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Signed-off-by: Taku Izumi <izumi2005@soft.fujitsu.com>
> 
> ---
>  drivers/serial/serial_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.21-rc5/drivers/serial/serial_core.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/drivers/serial/serial_core.c
> +++ linux-2.6.21-rc5/drivers/serial/serial_core.c
> @@ -1665,7 +1665,7 @@ static int uart_line_info(char *buf, str
>  	unsigned int status;
>  	int mmio, ret;
>  
> -	if (!port)
> +	if (!port || !port->info)
>  		return 0;
>  
>  	mmio = port->iotype >= UPIO_MEM;
> 
