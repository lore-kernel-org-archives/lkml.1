Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYFXWXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYFXWXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 18:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYFXWXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 18:23:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829AbYFXWXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 18:23:33 -0400
Date: Tue, 24 Jun 2008 15:22:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: vcgandhi1@aol.com, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Fix serial_match_port() for dynamic major tty-device
 numbers
Message-Id: <20080624152253.d9bd1da2.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0806220037250.461@axis700.grange>
References: <8CA6D5E4DEA920C-1128-2973@webmail-nb07.sysops.aol.com>
	<Pine.LNX.4.64.0804160046460.6851@axis700.grange>
	<8CA6D67D9E313CC-1128-35BB@webmail-nb07.sysops.aol.com>
	<8CA6D6D112DB4D4-1128-38B0@webmail-nb07.sysops.aol.com>
	<Pine.LNX.4.64.0804170103040.7335@axis700.grange>
	<8CA6E48B50204C0-15A8-47D0@webmail-nb06.sysops.aol.com>
	<Pine.LNX.4.64.0804171657320.6716@axis700.grange>
	<8CA6EC102F70775-15A8-8B4A@webmail-nb06.sysops.aol.com>
	<Pine.LNX.4.64.0804171915180.6716@axis700.grange>
	<8CA6EF5BC26E069-12A0-1888@webmail-nc13.sysops.aol.com>
	<Pine.LNX.4.64.0804181700300.5725@axis700.grange>
	<8CA6FF4B03B281A-E10-2E1C@webmail-nf05.sim.aol.com>
	<Pine.LNX.4.64.0804231108170.5160@axis700.grange>
	<8CA73B83C791846-148-41B9@webmail-nb17.sysops.aol.com>
	<Pine.LNX.4.64.0804241557340.5283@axis700.grange>
	<8CA914AC0F6817C-1684-368@webmail-nc03.sysops.aol.com>
	<Pine.LNX.4.64.0806220037250.461@axis700.grange>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 00:45:25 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> As reported by Vipul Gandhi, the current serial_match_port() doesn't work 
> for tty-devices using dynamic major number allocation. Fix it.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Tested-by: Vipul Gandhi <vcgandhi1@aol.com>
> 
> ---
> 
> diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
> index 0f5a179..593ae85 100644
> --- a/drivers/serial/serial_core.c
> +++ b/drivers/serial/serial_core.c
> @@ -1949,7 +1949,9 @@ struct uart_match {
>  static int serial_match_port(struct device *dev, void *data)
>  {
>  	struct uart_match *match = data;
> -	dev_t devt = MKDEV(match->driver->major, match->driver->minor) + match->port->line;
> +	struct tty_driver *tty_drv = match->driver->tty_driver;
> +	dev_t devt = MKDEV(tty_drv->major, tty_drv->minor_start) +
> +		match->port->line;
>  
>  	return dev->devt == devt; /* Actually, only one tty per port */

Well that sounds bad.  We need to work out whether this fix is needed
in 2.6.25 and possibly eariler.

What are the consequences of this error?
