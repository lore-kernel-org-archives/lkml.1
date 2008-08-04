Return-Path: <linux-kernel-owner+w=401wt.eu-S1751535AbYHDWIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbYHDWIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYHDWHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:07:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47604 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbYHDWHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:07:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: BUG: scheduling while atomic: ip/23212/0x00000102
Date: Tue, 5 Aug 2008 00:10:44 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: arekm@maven.pl, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200808041845.10893.arekm@maven.pl> <20080804.143541.96067332.davem@davemloft.net>
In-Reply-To: <20080804.143541.96067332.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808050010.45615.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 4 of August 2008, David Miller wrote:
> From: Arkadiusz Miskiewicz <arekm@maven.pl>
> Date: Mon, 4 Aug 2008 18:45:10 +0200
> 
> > 
> > git kernel, pulled around  Sat Aug 2 13:32:05 CEST,
> > i686, thinkpad z60m notebook
> 
> Obviously the tg3 PCI power-management changes were totally untested.

If you mean the commit below, actually they were tested.

I run this code on a regular basis on my production box and I have never seen
this stack trace.  How exactly can I make it appear?

> And unfortunately this is usually par for the course for driver
> changes of this kind that I end up applying directly from Andrew's
> patch bombs. :-/

Sorry for causing the trouble, but had I seen the stack trace, I obviously
wouldn't have posted the patch.

> commit 12dac0756d357325b107fe6ec24921ec38661839
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Wed Jul 30 16:37:33 2008 -0700
> 
>     tg3: adapt tg3 to use reworked PCI PM code
>     
>     Adapt the tg3 driver to use the reworked PCI PM and make it use the
>     exported PCI PM core functions instead of accessing the PCI PM registers
>     directly by itself.
>     
>     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
> index 633c128..26aa37a 100644
> --- a/drivers/net/tg3.c
> +++ b/drivers/net/tg3.c
> @@ -1982,8 +1982,6 @@ static void tg3_power_down_phy(struct tg3 *tp)
>  static int tg3_set_power_state(struct tg3 *tp, pci_power_t state)
>  {
>  	u32 misc_host_ctrl;
> -	u16 power_control, power_caps;
> -	int pm = tp->pm_cap;
>  
>  	/* Make sure register accesses (indirect or otherwise)
>  	 * will function correctly.
> @@ -1992,18 +1990,10 @@ static int tg3_set_power_state(struct tg3 *tp, pci_power_t state)
>  			       TG3PCI_MISC_HOST_CTRL,
>  			       tp->misc_host_ctrl);
>  
> -	pci_read_config_word(tp->pdev,
> -			     pm + PCI_PM_CTRL,
> -			     &power_control);
> -	power_control |= PCI_PM_CTRL_PME_STATUS;
> -	power_control &= ~(PCI_PM_CTRL_STATE_MASK);
>  	switch (state) {
>  	case PCI_D0:
> -		power_control |= 0;
> -		pci_write_config_word(tp->pdev,
> -				      pm + PCI_PM_CTRL,
> -				      power_control);
> -		udelay(100);	/* Delay after power state change */
> +		pci_enable_wake(tp->pdev, state, false);
> +		pci_set_power_state(tp->pdev, PCI_D0);

Still, I don't think drivers should access the standard PCI PM registers
directly, so perhaps there should be a version of pci_set_power_state()
using udelay() instead of msleep() or we can just replace the msleep()
in pci_set_power_state() with udelay()?

Rafael
