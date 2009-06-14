Return-Path: <linux-kernel-owner+w=401wt.eu-S1762355AbZFNRJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762355AbZFNRJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 13:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZFNRJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 13:09:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37600 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbZFNRJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 13:09:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: andi@lisas.de
Subject: Re: [PATCH] Make e100 suspend handler support PCI cards lacking PM capability
Date: Sun, 14 Jun 2009 19:09:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: akpm@linux-foundation.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20081229102515.GA17171@rhlx01.hs-esslingen.de> <200906141606.29754.rjw@sisk.pl> <20090614164604.GA19746@rhlx01.hs-esslingen.de>
In-Reply-To: <20090614164604.GA19746@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141909.46354.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Andreas Mohr wrote:
> Hi,
> 
> On Sun, Jun 14, 2009 at 04:06:29PM +0200, Rafael J. Wysocki wrote:
> > On Sunday 14 June 2009, Andreas Mohr wrote:
> > > Hi,
> > > 
> > > On Sun, Jun 14, 2009 at 12:28:15AM +0200, Rafael J. Wysocki wrote:
> > > > On Saturday 13 June 2009, Andreas Mohr wrote:
> > > > > +
> > > > >  	if (wake) {
> > > > >  		return pci_prepare_to_sleep(pdev);
> > > > 
> > > > pci_prepare_to_sleep() is supposed to return 0 for your device.  I'll have a
> > > > look at it.
> > > 
> > > No, wake is false for my card, thus that's not the branch to
> > > investigate.
> > 
> > Ah.  The problem is, then, that we try to put the device into D3, which it
> > cannot do and error code is correctly returned from pci_set_power_state().
> > 
> > I would use the appended patch in that case and the patch sent previously
> > is necessary for the 'wake = true' case.
> 
> OK, as said I cannot test this right now, but I'm _damn_ sure it would
> work. Thus I'd say your equivalent patch posted a bit later can be
> committed already.
> 
> But what about the wake = true case?
> I'm not affected by this since my card doesn't have any wake capa,
> thus it's your call of whether that pci core code part really was broken
> and needed fixing.

I think it needs fixing.

> So, for the patch in your next mail:
> Acked-by: Andreas Mohr <andi@lisas.de>
> 
> 
> BTW, that patch was (pasted):
> 
>  static int __e100_power_off(struct pci_dev *pdev, bool wake)
>  {
> -       if (wake) {
> +       if (wake)
>                 return pci_prepare_to_sleep(pdev);
> -       } else {
> -               pci_wake_from_d3(pdev, false);
> -               return pci_set_power_state(pdev, PCI_D3hot);
> -       }
> +
> +       pci_wake_from_d3(pdev, false);
> +       pci_set_power_state(pdev, PCI_D3hot);
> +
> +       return 0;
>  }
> 
> 
> Couple questions still:
> - why do we call pci_wake_from_d3(...false) only!?
>   Wouldn't this break WoL after one iteration back and forth,
>   due to missing 'true' case?

The 'true' case is the 'wake = true' one.

> - why do we call netif_device_detach() _after_ doing hardware shutdown
>   of the network controller? I'd guess this can cause huge issues?
>   Someone told me he had rtnl lock issues upon S2D with e100
>   (very similar to my rtnl issues during aborted .suspend),
>   and that might possibly be the reason?

I think you're right, but I'm not a network driver expert.

Perhaps you can change the ordering and see if that fixes the rtnl issue
(since you're able to reproduce it without my patch, that should be easy to
verify).

Best,
Rafael
