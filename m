Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYKDRPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYKDRPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYKDRPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:15:05 -0500
Received: from kroah.org ([198.145.64.141]:43331 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753123AbYKDRPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:15:03 -0500
Date: Tue, 4 Nov 2008 09:11:28 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Fix close races in USB serial
Message-ID: <20081104171128.GB630@kroah.com>
References: <20081104152916.30344.68193.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104152916.30344.68193.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 03:29:24PM +0000, Alan Cox wrote:
> From: Alan Cox <alan@redhat.com>
> 
> USB serial has always had races where the tty port usage count can hit zero
> during a receive event. The internal locking is a mutex so we can't use
> that in the IRQ handlers.
> 
> With krefs we can tackle this differently but we still need to be careful.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> ---
> 
>  drivers/usb/serial/usb-serial.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
> index 794b5ff..aafa684 100644
> --- a/drivers/usb/serial/usb-serial.c
> +++ b/drivers/usb/serial/usb-serial.c
> @@ -269,15 +269,19 @@ static void serial_close(struct tty_struct *tty, struct file *filp)
>  		return;
>  	}
>  
> -	--port->port.count;
> -	if (port->port.count == 0)
> +	if (port->port.count == 1)
>  		/* only call the device specific close if this
> -		 * port is being closed by the last owner */
> +		 * port is being closed by the last owner. Ensure we do
> +		 * this before we drop the port count. The call is protected
> +		 * by the port mutex
> +		 */
>  		port->serial->type->close(tty, port, filp);
>  
> -	if (port->port.count == (port->console? 1 : 0)) {
> +	if (port->port.count == (port->console ? 2 : 1)) {

Why are you testing for 2 here?

confused,

greg k-h
