Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYHQM64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYHQM64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYHQM6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:58:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbYHQM6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:58:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] net: forcedeth use pci_choose_state instead of PCI_D3hot - v2
Date: Sun, 17 Aug 2008 15:02:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeff Garzik <jgarzik@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
References: <1218954333-12819-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1218954333-12819-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171502.02946.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of August 2008, Yinghai Lu wrote:
> after
> 
> | commit f735a2a1a4f2a0f5cd823ce323e82675990469e2
> | Author: Tobias Diedrich <ranma+kernel@tdiedrich.de>
> | Date:   Sun May 18 15:02:37 2008 +0200
> |
> |    [netdrvr] forcedeth: setup wake-on-lan before shutting down
> |
> |    When hibernating in 'shutdown' mode, after saving the image the suspend hook
> |    is not called again.
> |    However, if the device is in promiscous mode, wake-on-lan will not work.
> |    This adds a shutdown hook to setup wake-on-lan before the final shutdown.
> |
> |    Signed-off-by: Tobias Diedrich <ranma+kernel@tdiedrich.de>
> |    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
> my servers with nvidia mcp55 nic doesn't work with msi in second kernel by kexec
> 
> after remove pci_set_power_state(, PCI_D3hot) that nic/msi will work again.
> 
> check with e1000 is using pci_choose_state in _shutdown.
> 
> So change that pci_choose_state(pdev, ...), and it works.

Well, this doesn't look like a good solution to me, because you're putting
PMSG_SUSPEND in there, which is not correct for shutdown.  The right thing to
do would be to avoid changing the device power state if nv_shutdown() is
used for kexec or to rework the initialization of the adapter to handle the
case when it's initially in D3.

Does it help if you just remove the pci_set_power_state(pdev, PCI_D3hot)
altogether?

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  drivers/net/forcedeth.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/net/forcedeth.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/forcedeth.c
> +++ linux-2.6/drivers/net/forcedeth.c
> @@ -5988,7 +5988,7 @@ static void nv_shutdown(struct pci_dev *
>  	pci_enable_wake(pdev, PCI_D3hot, np->wolenabled);
>  	pci_enable_wake(pdev, PCI_D3cold, np->wolenabled);
>  	pci_disable_device(pdev);
> -	pci_set_power_state(pdev, PCI_D3hot);
> +	pci_set_power_state(pdev, pci_choose_state(pdev, PMSG_SUSPEND));
>  }
>  #else
>  #define nv_suspend NULL

Thanks,
Rafael
