Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbZKAQwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbZKAQwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 11:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZKAQwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 11:52:12 -0500
Received: from isilmar.linta.de ([213.133.102.198]:52975 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752525AbZKAQwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 11:52:09 -0500
Date: Sun, 1 Nov 2009 17:47:36 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
	2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Message-ID: <20091101164736.GA5666@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Jose Marino <braket@hotmail.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Linux PCI <linux-pci@vger.kernel.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200911010010.07394.rjw@sisk.pl> <200911010024.12081.rjw@sisk.pl> <200911010936.10409.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911010936.10409.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sun, Nov 01, 2009 at 09:36:10AM +0100, Rafael J. Wysocki wrote:
> Commit 0c570cdeb8fdfcb354a3e9cd81bfc6a09c19de0c
> (PM / yenta: Fix cardbus suspend/resume regression) caused resume to
> fail on systems with two CardBus bridges.  While the exact nature
> of the failure is not known at the moment, it can be worked around by
> splitting the yenta resume into an early part, executed during the
> early phase of resume, that will only resume the socket and power it
> up if there was a card in it during suspend, and a late part,
> executed during "regular" resume, that will carry out all of the
> remaining yenta resume operations.
> 
> Fixes http://bugzilla.kernel.org/show_bug.cgi?id=14334, which is a
> listed regression from 2.6.31.

The only issue I see is that we now return 0 unconditionally on the resume
callbacks. Otherwise, it's

Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>

> Index: linux-2.6/drivers/pcmcia/yenta_socket.c
> ===================================================================
> --- linux-2.6.orig/drivers/pcmcia/yenta_socket.c
> +++ linux-2.6/drivers/pcmcia/yenta_socket.c
> @@ -1275,16 +1275,26 @@ static int yenta_dev_resume_noirq(struct
>  	if (socket->type && socket->type->restore_state)
>  		socket->type->restore_state(socket);
>  
> -	return pcmcia_socket_dev_resume(dev);
> +	pcmcia_socket_dev_early_resume(dev);
> +	return 0;
> +}
> +
> +static int yenta_dev_resume(struct device *dev)
> +{
> +	pcmcia_socket_dev_late_resume(dev);
> +	return 0;
>  }
>  
>  static struct dev_pm_ops yenta_pm_ops = {
>  	.suspend_noirq = yenta_dev_suspend_noirq,
>  	.resume_noirq = yenta_dev_resume_noirq,
> +	.resume = yenta_dev_resume,
>  	.freeze_noirq = yenta_dev_suspend_noirq,
>  	.thaw_noirq = yenta_dev_resume_noirq,
> +	.thaw = yenta_dev_resume,
>  	.poweroff_noirq = yenta_dev_suspend_noirq,
>  	.restore_noirq = yenta_dev_resume_noirq,
> +	.restore = yenta_dev_resume,
>  };
>  
>  #define YENTA_PM_OPS	(&yenta_pm_ops)
> Index: linux-2.6/drivers/pcmcia/cs.c
> ===================================================================
> --- linux-2.6.orig/drivers/pcmcia/cs.c
> +++ linux-2.6/drivers/pcmcia/cs.c
> @@ -98,10 +98,13 @@ EXPORT_SYMBOL(pcmcia_socket_list_rwsem);
>   * These functions check for the appropriate struct pcmcia_soket arrays,
>   * and pass them to the low-level functions pcmcia_{suspend,resume}_socket
>   */
> +static int socket_early_resume(struct pcmcia_socket *skt);
> +static int socket_late_resume(struct pcmcia_socket *skt);
>  static int socket_resume(struct pcmcia_socket *skt);
>  static int socket_suspend(struct pcmcia_socket *skt);
>  
> -int pcmcia_socket_dev_suspend(struct device *dev)
> +static void pcmcia_socket_dev_run(struct device *dev,
> +				  int (*cb)(struct pcmcia_socket *))
>  {
>  	struct pcmcia_socket *socket;
>  
> @@ -110,29 +113,34 @@ int pcmcia_socket_dev_suspend(struct dev
>  		if (socket->dev.parent != dev)
>  			continue;
>  		mutex_lock(&socket->skt_mutex);
> -		socket_suspend(socket);
> +		cb(socket);
>  		mutex_unlock(&socket->skt_mutex);
>  	}
>  	up_read(&pcmcia_socket_list_rwsem);
> +}
>  
> +int pcmcia_socket_dev_suspend(struct device *dev)
> +{
> +	pcmcia_socket_dev_run(dev, socket_suspend);
>  	return 0;
>  }
>  EXPORT_SYMBOL(pcmcia_socket_dev_suspend);
>  
> -int pcmcia_socket_dev_resume(struct device *dev)
> +void pcmcia_socket_dev_early_resume(struct device *dev)
>  {
> -	struct pcmcia_socket *socket;
> +	pcmcia_socket_dev_run(dev, socket_early_resume);
> +}
> +EXPORT_SYMBOL(pcmcia_socket_dev_early_resume);
>  
> -	down_read(&pcmcia_socket_list_rwsem);
> -	list_for_each_entry(socket, &pcmcia_socket_list, socket_list) {
> -		if (socket->dev.parent != dev)
> -			continue;
> -		mutex_lock(&socket->skt_mutex);
> -		socket_resume(socket);
> -		mutex_unlock(&socket->skt_mutex);
> -	}
> -	up_read(&pcmcia_socket_list_rwsem);
> +void pcmcia_socket_dev_late_resume(struct device *dev)
> +{
> +	pcmcia_socket_dev_run(dev, socket_late_resume);
> +}
> +EXPORT_SYMBOL(pcmcia_socket_dev_late_resume);
>  
> +int pcmcia_socket_dev_resume(struct device *dev)
> +{
> +	pcmcia_socket_dev_run(dev, socket_resume);
>  	return 0;
>  }
>  EXPORT_SYMBOL(pcmcia_socket_dev_resume);
> @@ -546,29 +554,34 @@ static int socket_suspend(struct pcmcia_
>  	return 0;
>  }
>  
> -/*
> - * Resume a socket.  If a card is present, verify its CIS against
> - * our cached copy.  If they are different, the card has been
> - * replaced, and we need to tell the drivers.
> - */
> -static int socket_resume(struct pcmcia_socket *skt)
> +static void socket_start_resume(struct pcmcia_socket *skt)
>  {
> -	int ret;
> -
> -	if (!(skt->state & SOCKET_SUSPEND))
> -		return -EBUSY;
> -
>  	skt->socket = dead_socket;
>  	skt->ops->init(skt);
>  	skt->ops->set_socket(skt, &skt->socket);
> +	if (skt->state & SOCKET_PRESENT)
> +		skt->resume_status = socket_setup(skt, resume_delay);
> +}
> +
> +static int socket_early_resume(struct pcmcia_socket *skt)
> +{
> +	if (skt->state & SOCKET_SUSPEND)
> +		socket_start_resume(skt);
> +
> +	return 0;
> +}
> +
> +static int socket_late_resume(struct pcmcia_socket *skt)
> +{
> +	if (!(skt->state & SOCKET_SUSPEND))
> +		return 0;
>  
>  	if (!(skt->state & SOCKET_PRESENT)) {
>  		skt->state &= ~SOCKET_SUSPEND;
>  		return socket_insert(skt);
>  	}
>  
> -	ret = socket_setup(skt, resume_delay);
> -	if (ret == 0) {
> +	if (skt->resume_status == 0) {
>  		/*
>  		 * FIXME: need a better check here for cardbus cards.
>  		 */
> @@ -596,6 +609,20 @@ static int socket_resume(struct pcmcia_s
>  	return 0;
>  }
>  
> +/*
> + * Resume a socket.  If a card is present, verify its CIS against
> + * our cached copy.  If they are different, the card has been
> + * replaced, and we need to tell the drivers.
> + */
> +static int socket_resume(struct pcmcia_socket *skt)
> +{
> +	if (!(skt->state & SOCKET_SUSPEND))
> +		return -EBUSY;
> +
> +	socket_start_resume(skt);
> +	return socket_late_resume(skt);
> +}
> +
>  static void socket_remove(struct pcmcia_socket *skt)
>  {
>  	dev_printk(KERN_NOTICE, &skt->dev,
> Index: linux-2.6/include/pcmcia/ss.h
> ===================================================================
> --- linux-2.6.orig/include/pcmcia/ss.h
> +++ linux-2.6/include/pcmcia/ss.h
> @@ -262,6 +262,8 @@ struct pcmcia_socket {
>  	struct device			dev;
>  	/* data internal to the socket driver */
>  	void				*driver_data;
> +	/* status of the card during resume from a system sleep state */
> +	int				resume_status;
>  };
>  
>  
> @@ -280,6 +282,8 @@ extern struct pccard_resource_ops pccard
>  
>  /* socket drivers are expected to use these callbacks in their .drv struct */
>  extern int pcmcia_socket_dev_suspend(struct device *dev);
> +extern void pcmcia_socket_dev_early_resume(struct device *dev);
> +extern void pcmcia_socket_dev_late_resume(struct device *dev);
>  extern int pcmcia_socket_dev_resume(struct device *dev);
>  
>  /* socket drivers use this callback in their IRQ handler */
