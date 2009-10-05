Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZJETkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZJETkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZJETkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:40:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48550 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbZJETkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:40:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] Wireless / ath5k: Simplify suspend and resume callbacks
Date: Mon, 5 Oct 2009 21:40:47 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: netdev@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200910050052.09085.rjw@sisk.pl> <43e72e890910050921q7f516c67ofe17603d6d873c4@mail.gmail.com>
In-Reply-To: <43e72e890910050921q7f516c67ofe17603d6d873c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910052140.47372.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009, Luis R. Rodriguez wrote:
> On Sun, Oct 4, 2009 at 10:52 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Simplify the suspend and resume callbacks of ath5k by converting the
> > driver to struct dev_pm_ops and allowing the PCI PM core to do the
> > PCI-specific suspend/resume handling.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Do you happen to know if the new dev_pm_ops thing handle WOL / WoW [1]?
> 
> [1] http://wireless.kernel.org/en/users/Documentation/WoW

It does enable wake-up at the PCI level if so configured, so in principle it
should handle it.  However, for WoL to work there are some things that the
drivers is reponsible for, so I guess it will be analogous for WoW.

Anyway, the PCI-specific mechanics is there.

> >  #ifdef CONFIG_PM
> > -static int
> > -ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
> > +static int ath5k_pci_suspend(struct device *dev)
> >  {
> > -       struct ieee80211_hw *hw = pci_get_drvdata(pdev);
> > +       struct ieee80211_hw *hw = pci_get_drvdata(to_pci_dev(dev));
> >        struct ath5k_softc *sc = hw->priv;
> >
> >        ath5k_led_off(sc);
> > -
> > -       pci_save_state(pdev);
> > -       pci_disable_device(pdev);
> 
> For WoW right here we'd do
> 
> pci_prepare_to_sleep(pdev) and bail out.
> 
> > -       pci_set_power_state(pdev, PCI_D3hot);
> 
> And here we'd call something like this:
> 
> pci_wake_from_d3(pdev, !!sc->wow_triggers_enabled);

All of this is unnecessary, the PCI PM core should take care of this just
fine.  In case it doesn't, it has to be fixed.

> > -
> >        return 0;
> >  }
> 
> Are all drivers being converted?

Generally, yes, but that's not a priority work for me.  I've just happened to
have the patch ready, so here it goes.

They should be converted, though, to be able to support PCI run-time PM.

> It'll be a while before we get WoW enabled on ath5k but it is
> technically possible, the work was tested for ath9k back in July [2]
> but I never submitted this to be merged due to some inconsistent
> issues I was noticing with the hardware.
> 
> [2] http://kernel.org/pub/linux/kernel/people/mcgrof/patches/wow-07-21.patch

Thanks,
Rafael
