Return-Path: <linux-kernel-owner+w=401wt.eu-S1760915AbYJNAaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbYJNAaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 20:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbYJNAaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 20:30:08 -0400
Received: from smtp3.ono.com ([62.42.230.176]:14261 "EHLO resmaa06.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753115AbYJNAaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 20:30:07 -0400
Date: Tue, 14 Oct 2008 02:30:03 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
Message-ID: <20081014023003.07b6d745@werewolf.home>
In-Reply-To: <20081014012429.3f2924e3@werewolf.home>
References: <20081014010202.71d13eaf@werewolf.home>
	<20081013.161228.74135367.davem@davemloft.net>
	<20081014012429.3f2924e3@werewolf.home>
X-Mailer: Claws Mail 3.6.1cvs2 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 01:24:29 +0200, "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Mon, 13 Oct 2008 16:12:28 -0700 (PDT), David Miller <davem@davemloft.net> wrote:
> 
> > From: "J.A. Magallón" <jamagallon@ono.com>
> > Date: Tue, 14 Oct 2008 01:02:02 +0200
> > 
> > > Booting .27-git3 on the Aspire One gave me a couple oopses.
> > 
> > Fixed by:
> > 
> > commit 738e1e694bf6d9e965ba0ce2667a1bec5780a172
> > Author: Petr Vandrovec <petr@vandrovec.name>
> > Date:   Sun Oct 12 20:58:29 2008 -0700
> > 
> >     r8169: NULL pointer dereference on r8169 load
> >     
> >     mmio_addr in r8169 needs to be initialized before use
> >     
> >     Maybe that all tp-> initialization should be moved before rtl_init_mac_address call,
> >     but this is enough to get rid of crash in rtl_rar_set due to mmio_addr being uninitialized.
> >     
> >     Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> > index bdae2c5..c821da2 100644
> > --- a/drivers/net/r8169.c
> > +++ b/drivers/net/r8169.c
> > @@ -2154,6 +2154,8 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >  
> >  	spin_lock_init(&tp->lock);
> >  
> > +	tp->mmio_addr = ioaddr;
> > +
> >  	rtl_init_mac_address(tp, ioaddr);
> >  
> >  	/* Get MAC address */
> > @@ -2186,7 +2188,6 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >  #endif
> >  
> >  	tp->intr_mask = 0xffff;
> > -	tp->mmio_addr = ioaddr;
> >  	tp->align = cfg->align;
> >  	tp->hw_start = cfg->hw_start;
> >  	tp->intr_event = cfg->intr_event;
> >
> 
> Thanks, this cured the rtl8169 part.

Mmm, spoke too fast. It loads, but:

Oct 14 02:27:45 one kernel: r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Oct 14 02:27:45 one kernel: r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Oct 14 02:27:45 one kernel: r8169 0000:02:00.0: setting latency timer to 64
Oct 14 02:27:45 one kernel: eth0: RTL8102e at 0xdfffe000, 00:00:00:00:00:00, XID 24a00000 IRQ 219
Oct 14 02:27:45 one ifplugd(eth0)[5087]: ifplugd 0.28 initializing.
Oct 14 02:27:45 one ifplugd(eth0)[5087]: Using interface eth0/00:00:00:00:00:00 with driver <r8169> (version: 2.3LK-NAPI)
Oct 14 02:27:45 one ifplugd(eth0)[5087]: Using detection mode: SIOCETHTOOL
Oct 14 02:27:45 one ifplugd(eth0)[5087]: Initialization complete, link beat detected.
Oct 14 02:27:45 one ifplugd(eth0)[5087]: Executing '/etc/ifplugd/ifplugd.action eth0 up'.
Oct 14 02:27:46 one ifplugd(eth0)[5087]: client: Determining IP information for eth0...SIOCSIFFLAGS: Cannot assign requested address
Oct 14 02:27:46 one ifplugd(eth0)[5087]: client: SIOCSIFFLAGS: Cannot assign requested address


-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
