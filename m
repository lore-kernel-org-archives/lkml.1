Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZA3Wu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZA3Wu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZA3Wus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:50:48 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:35732 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZA3Wuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:50:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=KqZbkefSq6+rMnzecV8M4aPMu0c5PmFAlSNVT6P2Fv5nrBj+2+9KYCuzcZX2nsZn0J
         ReC0nDal86wPx7w3GD0ugP0md+IfA2Zi5a85ttoqgxNqdrE+Ry90WLXzyJvdqdHPdiOe
         JtVHUgGMqKAFU8OkpRPNuey4R0Ke6KJdrrx3o=
Date: Fri, 30 Jan 2009 17:50:36 -0500 (EST)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-desktop
To: Matt Carlson <mcarlson@broadcom.com>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
In-Reply-To: <20090130184030.GA14933@xw6200.broadcom.net>
Message-ID: <alpine.DEB.2.00.0901301743410.4989@parag-desktop>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <alpine.LFD.2.00.0901281636270.3123@localhost.localdomain> <alpine.DEB.2.00.0901282049040.5026@parag-desktop> <20090129184215.GA13459@xw6200.broadcom.net> <alpine.DEB.2.00.0901291700130.5149@parag-desktop>
 <20090129222247.GA13861@xw6200.broadcom.net> <alpine.DEB.2.00.0901291730030.5149@parag-desktop> <20090130184030.GA14933@xw6200.broadcom.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Jan 2009, Matt Carlson wrote:

> 
> If the PCI_COMMAND message doesn't match, then it means that the
> PCI_COMMAND register isn't getting restored for some reason.  If they do
> On Thu, Jan 29, 2009 at 02:35:44PM -0800, Parag Warudkar wrote:
> > 
> > 
> > On Thu, 29 Jan 2009, Matt Carlson wrote:
> > 
> > > FWIW, I can suspend and resume using the latest linux-2.6 kernel
> > > on a machine with a similar chip here.  The problem doesn't seem to
> > > affect all Broadcom devices.
> > 
> > It is failing for me on HP xw6600 workstation, if that helps in any way.
> > 
> > Parag
> 
> O.K.  Let's test some more assumptions.  Can you apply the following
> patch and observe the system logs when the device is first loaded and
> again after resume.  The patch looks at the pci command register to
> verify that memory space IO is indeed enabled.  (It should be.)  This is
> all that should be needed for MMIO to work.
> On Thu, Jan 29, 2009 at 02:35:44PM -0800, Parag Warudkar wrote:
> > 
> > 
> > On Thu, 29 Jan 2009, Matt Carlson wrote:

> O.K.  Let's test some more assumptions.  Can you apply the following
> patch and observe the system logs when the device is first loaded and
> again after resume.  The patch looks at the pci command register to
> verify that memory space IO is indeed enabled.  (It should be.)  This is
> all that should be needed for MMIO to work.
> match, then something else in the system is not getting restored
> correctly.
> 
Here is the output after applying the patch (fresh boot btw) -

[   29.698877] eth0: PCI_COMMAND reg = 0x406 (bit 1 is on)
[   29.698880] eth0: Reg value at offset 0x0 is 0x167b14e4
[   29.758169] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   31.295087] tg3: eth0: Link is up at 100 Mbps, full duplex.
[   31.295090] tg3: eth0: Flow control is off for TX and off for RX.
[   31.297574] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   41.872007] eth0: no IPv6 routers present
^^^ Pre-Suspend

[  245.924484] eth0: PCI_COMMAND reg = 0x406 (bit 1 is on)
[  245.924487] eth0: Reg value at offset 0x0 is 0xffffffff
[  247.317971] tg3: eth0: No firmware running.
[  258.710634] ADDRCONF(NETDEV_UP): eth0: link is not ready
^^^ Post-Suspend

So it looks like the memory space IO is enabled before and after suspend.
The device/vendor id goes 0xffffffff after resume - just like before.
Does that one matter? (Firmware may be looking at it?) 

> 
> diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
> index 8b3f846..67bb29f 100644
> --- a/drivers/net/tg3.c
> +++ b/drivers/net/tg3.c
> @@ -7225,8 +7225,17 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
>   */
>  static int tg3_init_hw(struct tg3 *tp, int reset_phy)
>  {
> +	u16 cmd;
> +
>  	tg3_switch_clocks(tp);
>  
> +	pci_read_config_word(tp->pdev, PCI_COMMAND, &cmd);
> +
> +	printk(KERN_NOTICE "%s: PCI_COMMAND reg = 0x%x (bit 1 is %s)\n",
> +	       tp->dev->name, cmd, (cmd & PCI_COMMAND_MEMORY) ? "on" : "off");
> +	printk(KERN_NOTICE "%s: Reg value at offset 0x0 is 0x%x\n",
> +	       tp->dev->name, tr32(0x0));
> +
>  	tw32(TG3PCI_MEM_WIN_BASE_ADDR, 0);
>  
>  	return tg3_reset_hw(tp, reset_phy);
> 
> 
