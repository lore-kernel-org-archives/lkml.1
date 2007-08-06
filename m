Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbXHFPu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbXHFPu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbXHFPuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:50:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:14172 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771AbXHFPuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:50:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JH3hIax+Oxaw0Q2l2mcxY79USe/iQXHi5XApiemwvAk55ysIoxTGzKN5xtUEIvpGZUzEqCU5dehF3b1XwLunh0DT/dqen+q+ToGdx4cd2NpXMh2I4j61o1Jqn6UB5CRuIICxsIZDTShE9AOVlyLPKM3Avu4BaWg7AblOOM2ebNw=
Message-ID: <b25c3fa70708060850p26b7b3e6yb8a523a479c714c0@mail.gmail.com>
Date: Tue, 7 Aug 2007 00:50:13 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] kexec: fix pci device initialization fail after kexec (2.6.23-rc2). (Related to e1000 doesn't resume properly from standby)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Simon Arlott" <simon@fire.lp0.eu>, "Pavel Machek" <pavel@ucw.cz>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <200708061650.16555.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b25c3fa70708060642w1b3a326q792a81fdaa3036c5@mail.gmail.com>
	 <200708061650.16555.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/6, Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday, 6 August 2007 15:42, Joonwoo Park wrote:
> > Hi.
> > I think that the pci_set_power_state() has bug.
> > The specification says that some delays is required.
>
> And they are in place, AFAICS (from drivers/pci/pci.c):
>
>        /* Mandatory power management transition delays */
>        /* see PCI PM 1.1 5.6.1 table 18 */
>        if (state == PCI_D3hot || dev->current_state == PCI_D3hot)
>                msleep(pci_pm_d3_delay);
>        else if (state == PCI_D2 || dev->current_state == PCI_D2)
>                udelay(200);
>

The problem is occurred when state is 'PCI_D0', so those codes can't cover it.
But pci pm specification 5.4.1 says that when programmed to D0 the
equivalent of a warm reset, delay for the duration of the D3hot to D0
Uninitialized state
transition (10ms) to pci signal drivers remain disabled is required.

> > Simon, please can I know whether it works to you?
> > It is seems to the things are related.
> >
> > Joonwoo Park.
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 37c00f6..9f78064 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -493,8 +493,14 @@ pci_set_power_state(struct pci_dev *dev, pci_power_t state)
> >    * restore at least the BARs so that the device will be
> >    * accessible to its driver.
> >    */
> > - if (need_restore)
> > + if (need_restore) {
> > +   /* The specification also says that "Must ensure that all of
> > +    * its PCI signal drivers remain disabled for the duration of
> > +    * the D3hot to D0 Uninitialized state transition".
> > +    */
> > +   msleep(10);
>
> It's too late for the delay.
>

How about this?

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 37c00f6..974dd04 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -471,6 +471,8 @@ pci_set_power_state(struct pci_dev *dev, pci_power_t state)
                msleep(pci_pm_d3_delay);
        else if (state == PCI_D2 || dev->current_state == PCI_D2)
                udelay(200);
+      else if (state == PCI_D0)
+              msleep(10);

        /*
         * Give firmware a chance to be called, such as ACPI _PRx, _PSx


> >     pci_restore_bars(dev);
> > + }
> >
> >   return 0;
> >  }
>
> Greetings,
> Rafael
>
>
> --
> "Premature optimization is the root of all evil." - Donald Knuth
>

Thanks,
Joonwoo Park.
