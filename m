Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbYHEJPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbYHEJPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759504AbYHEJO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:14:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49891 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759486AbYHEJO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:14:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: BUG: scheduling while atomic: ip/23212/0x00000102
Date: Tue, 5 Aug 2008 11:17:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Miller <davem@davemloft.net>, arekm@maven.pl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200808041845.10893.arekm@maven.pl> <200808050153.23537.rjw@sisk.pl> <200808041705.45317.jbarnes@virtuousgeek.org>
In-Reply-To: <200808041705.45317.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051117.28824.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 5 of August 2008, Jesse Barnes wrote:
> On Monday, August 04, 2008 4:53 pm Rafael J. Wysocki wrote:
> > On Tuesday, 5 of August 2008, Jesse Barnes wrote:
> > > On Monday, August 04, 2008 3:10 pm Rafael J. Wysocki wrote:
> > > > > -	pci_read_config_word(tp->pdev,
> > > > > -			     pm + PCI_PM_CTRL,
> > > > > -			     &power_control);
> > > > > -	power_control |= PCI_PM_CTRL_PME_STATUS;
> > > > > -	power_control &= ~(PCI_PM_CTRL_STATE_MASK);
> > > > >  	switch (state) {
> > > > >  	case PCI_D0:
> > > > > -		power_control |= 0;
> > > > > -		pci_write_config_word(tp->pdev,
> > > > > -				      pm + PCI_PM_CTRL,
> > > > > -				      power_control);
> > > > > -		udelay(100);	/* Delay after power state change */
> > > > > +		pci_enable_wake(tp->pdev, state, false);
> > > > > +		pci_set_power_state(tp->pdev, PCI_D0);
> > > >
> > > > Still, I don't think drivers should access the standard PCI PM
> > > > registers directly, so perhaps there should be a version of
> > > > pci_set_power_state() using udelay() instead of msleep() or we can just
> > > > replace the msleep() in pci_set_power_state() with udelay()?
> > >
> > > I think we should get rid of the open coded PCI PM state management,
> > > since otherwise platform related bugs like the Intel PCIe PM quirk that
> > > sets pci_pm_d3_delay to 120ms would have to be duplicated around the
> > > tree.
> > >
> > > That said, waiting for 120ms with a busy wait seems a bit absurd if we
> > > can avoid it.  Either we need to find a way to make drivers only change
> > > states (which can be very slow) in non-atomic context or we'll need to
> > > add a busy wait variant of the power state call...
> >
> > What about this?
> >
> > It fixes the tg3 issue for me.
> >
> > ---
> >  drivers/net/tg3.c   |   19 +++++++++++++++++--
> >  drivers/pci/pci.c   |   24 +++++++++++++++---------
> >  include/linux/pci.h |    2 ++
> >  3 files changed, 34 insertions(+), 11 deletions(-)
> >
> > Index: linux-2.6/drivers/pci/pci.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/pci/pci.c
> > +++ linux-2.6/drivers/pci/pci.c
> > @@ -421,6 +421,7 @@ static inline int platform_pci_sleep_wak
> >   *                           given PCI device
> >   * @dev: PCI device to handle.
> >   * @state: PCI power state (D0, D1, D2, D3hot) to put the device into.
> > + * @delay: if set, time to wait for the device to change the state, in
> > microseconds *
> >   * RETURN VALUE:
> >   * -EINVAL if the requested state is invalid.
> > @@ -429,8 +430,8 @@ static inline int platform_pci_sleep_wak
> >   * 0 if device already is in the requested state.
> >   * 0 if device's power state has been successfully changed.
> >   */
> > -static int
> > -pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state)
> > +int pci_raw_set_power_state(struct pci_dev *dev, pci_power_t state,
> > +                            unsigned int delay)
> >  {
> >  	u16 pmcsr;
> >  	bool need_restore = false;
> > @@ -486,12 +487,16 @@ pci_raw_set_power_state(struct pci_dev *
> >  	/* enter specified state */
> >  	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);
> >
> > -	/* Mandatory power management transition delays */
> > -	/* see PCI PM 1.1 5.6.1 table 18 */
> > -	if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
> > -		msleep(pci_pm_d3_delay);
> > -	else if (state == PCI_D2 || dev->current_state == PCI_D2)
> > -		udelay(200);
> > +	if (delay) {
> > +		udelay(delay);
> > +	} else {
> > +		/* Mandatory power management transition delays */
> > +		/* see PCI PM 1.1 5.6.1 table 18 */
> > +		if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
> > +			msleep(pci_pm_d3_delay);
> > +		else if (state == PCI_D2 || dev->current_state == PCI_D2)
> > +			udelay(200);
> > +	}
> 
> I think this has the issue I mentioned above.  We want to honor platform D3 
> transition delays or we'll see the bugs they're intended to work around.  
> With this API, a driver could pass in a delay of 5us and void both the 
> platform bugs that pci_pm_d3_delay works around and the D2 transition time of 
> 200us that the code already has...

Okay, but tg3 evidently wants to set the power state to D0 under a spinlock
(without the delay required by the PCI PM spec, but well).

So, perhaps we should just change the msleep(pci_pm_d3_delay), in
pci_raw_set_power_state(), to mdelay(pci_pm_d3_delay).  As far as
suspend/resume is concerned, this won't matter, because they both are done
in one thread.  I'm not really sure if there are any other cases in which that
could matter, though.

Thanks,
Rafael
