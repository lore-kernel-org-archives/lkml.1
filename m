Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbZFNOG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbZFNOG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 10:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbZFNOGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 10:06:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36997 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbZFNOGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 10:06:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: andi@lisas.de
Subject: Re: [PATCH] Make e100 suspend handler support PCI cards lacking PM capability
Date: Sun, 14 Jun 2009 16:06:29 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: akpm@linux-foundation.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20081229102515.GA17171@rhlx01.hs-esslingen.de> <200906140028.16025.rjw@sisk.pl> <20090614125128.GA32034@rhlx01.hs-esslingen.de>
In-Reply-To: <20090614125128.GA32034@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141606.29754.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Andreas Mohr wrote:
> Hi,
> 
> On Sun, Jun 14, 2009 at 12:28:15AM +0200, Rafael J. Wysocki wrote:
> > On Saturday 13 June 2009, Andreas Mohr wrote:
> > > Hi all,
> > > 
> > > after having added non-MII PHY card support to e100, I noticed that
> > > the suspend handler rejects power-management non-capable PCI cards,
> > 
> > Well, that means we have a bug somewhere in the PCI PM core.
> 
> I don't know. I had shortly investigated the same thing,
> but it very much seemed that this is by design, pci_set_power_state()
> is documented to reject non-PM cards (in power/pci.txt, and in
> pci.c, too). Thus I didn't work in this area.
> 
> And from a cleanliness point of view pci_set_power_state()
> acting on a non-PM card with no special non-PM ACPI support _should_
> return an error status I guess.
> (especially since docs say that pci_set_power_state() should
> be used for PM cards)
> 
> > > causing a S2R request to immediately get back up to the desktop,
> > > losing network access in the process (rtnl mutex deadlock).
> > 
> > That's bad.
> 
> Indeed, and I have no idea what the problem was.
> rtnl_is_locked() always was false within suspend/resume,
> thus it had to be a userspace-triggered effect sometime
> _after_ (non-)resume happened
> (probably due to the network controller being down and thus inoperable
> after .suspend).
> 
> BTW, after that failed .suspend, .resume was not called. I assume this to
> be correct behaviour.
> 
> > >  static int __e100_power_off(struct pci_dev *pdev, bool wake)
> > >  {
> > > +	/* some older devices don't support PCI PM
> > > +	 * (e.g. mac_82557_D100_B combo card with 80c24 PHY)
> > > +	 * - skip those! (they most likely won't support WoL either)
> > > +	 */
> > > +	if (!pci_find_capability(pdev, PCI_CAP_ID_PM))
> > > +		return 0;
> > 
> > Devices without PCI_CAP_ID_PM may still be power-manageable by ACPI, so
> > returning 0 at this point is not a general solution.
> 
> Oh, interesting.
> 
> BTW, any idea why we have several drivers doing some seemingly useless
> 
>         /* Find power-management capability. */
>         pm_cap = pci_find_capability(pdev, PCI_CAP_ID_PM);
>         if (pm_cap == 0) {
>                 printk(KERN_ERR PFX "Cannot find PowerManagement capability, "
>                        "aborting.\n");
>                 err = -EIO;
>                 goto err_out_free_res;
>         }
> 
> ?
> 
> - it's code bloat
> - it needlessly rejects non-PM cards
> - it annoys the hell out of users of a non-PM card

No idea.

> > > +
> > >  	if (wake) {
> > >  		return pci_prepare_to_sleep(pdev);
> > 
> > pci_prepare_to_sleep() is supposed to return 0 for your device.  I'll have a
> > look at it.
> 
> No, wake is false for my card, thus that's not the branch to
> investigate.

Ah.  The problem is, then, that we try to put the device into D3, which it
cannot do and error code is correctly returned from pci_set_power_state().

I would use the appended patch in that case and the patch sent previously
is necessary for the 'wake = true' case.

Thanks,
Rafael

---
 drivers/net/e100.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/net/e100.c
===================================================================
--- linux-2.6.orig/drivers/net/e100.c
+++ linux-2.6/drivers/net/e100.c
@@ -2763,8 +2763,9 @@ static int __e100_power_off(struct pci_d
 		return pci_prepare_to_sleep(pdev);
 	} else {
 		pci_wake_from_d3(pdev, false);
-		return pci_set_power_state(pdev, PCI_D3hot);
+		pci_set_power_state(pdev, PCI_D3hot);
 	}
+	return 0;
 }
 
 #ifdef CONFIG_PM
