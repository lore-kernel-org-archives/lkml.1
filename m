Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYIEJMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYIEJMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 05:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYIEJMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 05:12:14 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:65313 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752125AbYIEJMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 05:12:12 -0400
Subject: Re: [PATCH 1/3] PCI: vpd handle longer delays in access
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ben Hutchings <bhutchings@solarflare.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080904205718.543005986@vyatta.com>
References: <20080904205636.130211023@vyatta.com>
	 <20080904205718.543005986@vyatta.com>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 11:11:41 +0200
Message-Id: <1220605901.7080.14.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 13:56 -0700, Stephen Hemminger wrote:
> plain text document attachment (vpd-delay.patch)
> Accessing the VPD area can take a long time.  The existing 
> VPD access code fails consistently on my hardware. There are comments
> in the SysKonnect vendor driver that it can take up to 13ms per word. 
> 
> Change the access routines to:
>   * use a mutex rather than spinning with IRQ's disabled and lock held
>   * have a longer timeout
>   * call schedule while spinning to provide some responsivness
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> 
> --- a/drivers/pci/access.c	2008-09-04 09:06:51.000000000 -0700
> +++ b/drivers/pci/access.c	2008-09-04 10:16:52.000000000 -0700
> @@ -133,7 +133,7 @@ PCI_USER_WRITE_CONFIG(dword, u32)
>  
>  struct pci_vpd_pci22 {
>  	struct pci_vpd base;
> -	spinlock_t lock; /* controls access to hardware and the flags */
> +	struct mutex lock;
>  	u8	cap;
>  	bool	busy;
>  	bool	flag; /* value of F bit to wait for */
> @@ -144,29 +144,33 @@ static int pci_vpd_pci22_wait(struct pci
>  {
>  	struct pci_vpd_pci22 *vpd =
>  		container_of(dev->vpd, struct pci_vpd_pci22, base);
> -	u16 flag, status;
> -	int wait;
> +	u16 flag = vpd->flag ? PCI_VPD_ADDR_F : 0;
> +	unsigned long timeout = jiffies + (vpd->flag ? HZ/50 : HZ/10);
> +	u16 status;
>  	int ret;
>  
>  	if (!vpd->busy)
>  		return 0;
>  
> -	flag = vpd->flag ? PCI_VPD_ADDR_F : 0;
> -	wait = vpd->flag ? 10 : 1000; /* read: 100 us; write: 10 ms */
>  	for (;;) {
> -		ret = pci_user_read_config_word(dev,
> -						vpd->cap + PCI_VPD_ADDR,
> +		ret = pci_user_read_config_word(dev, vpd->cap + PCI_VPD_ADDR,
>  						&status);
>  		if (ret < 0)
> -			return ret;
> +			break;
> +
>  		if ((status & PCI_VPD_ADDR_F) == flag) {
>  			vpd->busy = false;
> -			return 0;
> +			break;
>  		}
> -		if (wait-- == 0)
> +
> +		if (time_after(jiffies, timeout))
>  			return -ETIMEDOUT;
> -		udelay(10);
> +		if (signal_pending(current))
> +			return -EINTR;
> +		yield();

At the very least put a big comment in here that we're polling the
hardware without completion event.

yield() is not good either, when used with a RT task (IMHO still the
only valid use of yield) it mostly doesn't spend any time away from this
task at all.

The other option, schedule_hrtimeout() isn't ideal either because on
crappy hardware it will fall back to jiffie based timeouts and I _hope_
that most hardware is less shitty than the 13ms reported in the
changelog.

Can we make this a per device delay that starts out small (the previous
10 us sound good) and gets doubled every once in a while when not enough
for a particular device?

That way we can - at some threshold - switch to sleeping delays..

>  	}
> +
> +	return ret;
>  }


