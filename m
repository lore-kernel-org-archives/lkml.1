Return-Path: <linux-kernel-owner+w=401wt.eu-S932919AbXAWJNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbXAWJNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 04:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917AbXAWJNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 04:13:14 -0500
Received: from [85.204.20.254] ([85.204.20.254]:55219 "EHLO megainternet.ro"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932916AbXAWJNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 04:13:12 -0500
Subject: Re: [BUG] eth0 appers many times in /proc/interrupts after resume
From: Andrei Popa <andrei.popa@i-neo.ro>
Reply-To: andrei.popa@i-neo.ro
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: linux-kernel@vger.kernel.org, nigel@suspend2.net
In-Reply-To: <20070121212209.GB8958@slug>
References: <1167520557.2566.23.camel@nigel.suspend2.net>
	 <1167571281.7175.1.camel@localhost>
	 <1167599458.2662.8.camel@nigel.suspend2.net>
	 <1167605481.12328.0.camel@localhost>
	 <1167607994.2662.39.camel@nigel.suspend2.net>
	 <1167644970.7142.6.camel@localhost>
	 <1168317278.6948.9.camel@nigel.suspend2.net>
	 <1168448689.7430.1.camel@localhost>
	 <1168463852.3205.1.camel@nigel.suspend2.net>
	 <1169407062.1932.4.camel@localhost>  <20070121212209.GB8958@slug>
Content-Type: text/plain
Organization: I-NEO
Date: Tue, 23 Jan 2007 11:12:49 +0200
Message-Id: <1169543569.10364.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It's ok, after 4 suspend/resume cycles, eth0 only appers one time.

On Sun, 2007-01-21 at 21:22 +0000, Frederik Deweerdt wrote:
> On Sun, Jan 21, 2007 at 09:17:41PM +0200, Andrei Popa wrote:
> > It's the 10th resume and in /proc/interrupts eth0 appers 10 times.
> > 
> Hi,
> 
> The e100_resume() function should be calling netif_device_detach and
> free_irq. Could you try the following (compile tested) patch?
> 
> Regards,
> Frederik
> 
> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
> 
> diff --git a/drivers/net/e100.c b/drivers/net/e100.c
> index 2fe0445..0c376e4 100644
> --- a/drivers/net/e100.c
> +++ b/drivers/net/e100.c
> @@ -2671,6 +2671,7 @@ static int e100_suspend(struct pci_dev *pdev, pm_message_t state)
>  	del_timer_sync(&nic->watchdog);
>  	netif_carrier_off(nic->netdev);
>  
> +	netif_device_detach(netdev);
>  	pci_save_state(pdev);
>  
>  	if ((nic->flags & wol_magic) | e100_asf(nic)) {
> @@ -2682,6 +2683,7 @@ static int e100_suspend(struct pci_dev *pdev, pm_message_t state)
>  	}
>  
>  	pci_disable_device(pdev);
> +	free_irq(pdev->irq, netdev);
>  	pci_set_power_state(pdev, PCI_D3hot);
>  
>  	return 0;

