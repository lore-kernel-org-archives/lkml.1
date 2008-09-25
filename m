Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbYIYXp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbYIYXp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 19:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYIYXpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 19:45:15 -0400
Received: from fmailhost05.isp.att.net ([204.127.217.105]:36333 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYIYXpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 19:45:13 -0400
X-Originating-IP: [74.251.44.253]
Date: Thu, 25 Sep 2008 18:45:09 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Kevin Hao <kexin.hao@windriver.com>
Cc: Jeff Garzik <jgarzik@redhat.com>, Chris Snook <csnook@redhat.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: add net poll support for atl2 driver
Message-ID: <20080925184509.42bfabc2@osprey.hogchain.net>
In-Reply-To: <1221897404-20290-1-git-send-email-kexin.hao@windriver.com>
References: <1221897404-20290-1-git-send-email-kexin.hao@windriver.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAIVBMVEV2dXOAgYNxSD+aemaal42A
 gIBqYV2UU07Ik5GXfoFMRTdbKiVwAAACbUlEQVQ4jXXTzWvbMBQAcG3EZsmt0Owc3pgNPo1oxNFt
 pQnEN3Wrs3UnkdXq5tOwIdq9Pci3gUqJexo55KC/cs9O/dHBRIiMfpb03rNE4v800jxIQRzsXPEP
 jDwndhNelo9/ngE/SFdKmZQnfOT0YSSlQBKLiJBDH6w9SPwlp5evpduDr9biQqkV8Rh7p4NRNSO1
 4BHhpjLpIK2gWksIgl0LPLCHoBIcX6dp2kGKMYnfGJnjIFungZeuHA6dhSvqLXrA1zJmVKayCu1w
 DKuGAU+WZRRCsLdBFXgLl2Sw3N2ZEJDAn3VwEV9FK12YUGW+yqlIWiD30U5rbSi2efGuhRfxEXRB
 8e+uJE/AL5z78xrqVg6aBHlMTj9V7x/RJOMGHHI11ItVUW+B0JakkGPcUsJNHuY7/ZA04X4xwQ/D
 3I0FGgaT8iFponoJ26F+sNbu51O7l7QHHtNTbxMc5o/W+kw0S31Ub5i+pQBq/hjYPVPbJ/ic/aoC
 pbTQtxlAvvnZgNod89Y4D2sFXpMHZWU1yHb6Ft+g2aTJY84iY2iY4ySGmWdvmxlDprHkCgd1yDRV
 bXVfFQiZjyuyaU5p1pZkTbXBbxRagAyU2rZfcH2tTQ7+FpNQ4Ofb7lxdFzTHDGqAvHdEv0cIezi2
 be+0vzdUqawaDSATHfB7itGiIfrQu2p8UQOOooHTh5lUPn6lva/qQrWwQpCUTv08hGe3dkU9KWmJ
 Z2EGpAeDFc3kN8oMNbNJ/AzMFERUhjmehB7ws6XBTTnfeOXT9T/C9dn4HEshpPWIjDvgi5Px2U0G
 Hl7dzaQHg8U4Xn6oa4g3vVnqLz3ribDLdyFmAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 15:56:44 +0800
Kevin Hao <kexin.hao@windriver.com> wrote:

> Add netconsole support for Atheros L2 10/100 network device.
> 
> Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
> ---
>  drivers/net/atlx/atl2.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
> index d548a67..b2995ac 100644
> --- a/drivers/net/atlx/atl2.c
> +++ b/drivers/net/atlx/atl2.c
> @@ -1327,6 +1327,15 @@ static void atl2_setup_pcicmd(struct pci_dev
> *pdev) pci_write_config_dword(pdev, REG_PM_CTRLSTAT, 0);
>  }
>  
> +#ifdef CONFIG_NET_POLL_CONTROLLER
> +static void atl2_poll_controller(struct net_device *netdev)
> +{
> +	disable_irq(netdev->irq);
> +	atl2_intr(netdev->irq, netdev);
> +	enable_irq(netdev->irq);
> +}
> +#endif
> +
>  /*
>   * atl2_probe - Device Initialization Routine
>   * @pdev: PCI device information struct
> @@ -1410,6 +1419,9 @@ static int __devinit atl2_probe(struct pci_dev
> *pdev, netdev->do_ioctl = &atl2_ioctl;
>  	atl2_set_ethtool_ops(netdev);
>  
> +#ifdef CONFIG_NET_POLL_CONTROLLER
> +	netdev->poll_controller = atl2_poll_controller;
> +#endif
>  #ifdef HAVE_TX_TIMEOUT
>  	netdev->tx_timeout = &atl2_tx_timeout;
>  	netdev->watchdog_timeo = 5 * HZ;

Acked-by: Jay Cliburn <jacliburn@bellsouth.net>
