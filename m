Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbYBYWUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbYBYWUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760729AbYBYWUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:20:03 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57551 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760705AbYBYWUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:20:00 -0500
Date: Mon, 25 Feb 2008 23:20:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: broken suspend in .2.6.25-rc3 on T61p (was Re: new regression
	in 2.6.25-rc3: no keyboard/lid acpi events on thinkpad T61p)
Message-ID: <20080225222023.GK2659@elf.ucw.cz>
References: <8f53421d0802251119q470a79c1p31048ef136271f84@mail.gmail.com> <20080225114611.d91791f6.akpm@linux-foundation.org> <8f53421d0802251245j5439b37die840e34bb293f995@mail.gmail.com> <200802252157.10412.rjw@sisk.pl> <20080225212615.GA2659@elf.ucw.cz> <8f53421d0802251331n31b37db8gb644dc9aa2d553d4@mail.gmail.com> <20080225215049.GD2659@elf.ucw.cz> <8f53421d0802251415g2033ca6bqd4e6ea9e2d93f097@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f53421d0802251415g2033ca6bqd4e6ea9e2d93f097@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  > >  > commit 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2
> >  > >  > Author: Pavel Machek <pavel@ucw.cz>
> >  > >  > Date:   Thu Feb 21 13:56:55 2008 +0100
> >  > >  >
> >  > >  >     power_state: get rid of write-only variable in SATA
> >  > >
> >  > >  This is pretty unlikely to be it. Can you double check that this patch
> >  > >  really breaks something?
> >  >
> >  > I did and it seems to: just reverting
> >  > 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2 fixes resume for me.
> >  > 635adc28087ced0c843d2ecb6d4ae474d0e611cd which is
> >  > 559bbe6cbd0d8c68d40076a5f7dc98e3bf5864b2~1
> >  > also resumes fine.
> >
> >  Hmm, I guess that should teach me about "simple cleanups".
> >
> >  Do you use any of:
> >
> >  ata/sata_inic162x.c
> >  ata/sata_nv.c
> >  ata/sata_sil24.c
> >
> >  by chance?
> 
> I don't think so.
> Here are the only 3 ata modules I have built:
> drivers/ata/ahci.ko
> drivers/ata/ata_piix.ko
> drivers/ata/libata.ko
> 
> 
> ahci.c seems to look at power_state.
> 
> static int ahci_pci_device_resume(struct pci_dev *pdev)
> {
>         struct ata_host *host = dev_get_drvdata(&pdev->dev);
>         int rc;
> 
>         rc = ata_pci_device_do_resume(pdev);
>         if (rc)
>                 return rc;
> 
>         if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
>                 rc = ahci_reset_controller(host);
>                 if (rc)
>                         return rc;
> 
>                 ahci_init_controller(host);
>         }

> Right?

Hmm, mystery partly solved... as you guessed it, this piece of code
was not in my tree.

(still, how can this cause autoresume after 5 seconds is a mystery to
me).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
