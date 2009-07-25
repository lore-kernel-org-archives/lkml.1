Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbZGYTj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbZGYTj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 15:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZGYTj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 15:39:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55221 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbZGYTj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 15:39:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH V2] au1xmmc: dev_pm_ops conversion
Date: Sat, 25 Jul 2009 21:39:30 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Manuel Lauss <manuel.lauss@gmail.com>
References: <1248275919-3296-1-git-send-email-manuel.lauss@gmail.com> <200907252019.01266.elendil@planet.nl> <20090725191037.GE14062@dtor-d630.eng.vmware.com>
In-Reply-To: <20090725191037.GE14062@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907252139.30674.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 July 2009, Dmitry Torokhov wrote:
> On Sat, Jul 25, 2009 at 08:18:58PM +0200, Frans Pop wrote:
> > On Saturday 25 July 2009, Dmitry Torokhov wrote:
> > > On Wed, Jul 22, 2009 at 05:18:39PM +0200, Manuel Lauss wrote:
> > > > Cc: Frans Pop <elendil@planet.nl>
> > > > Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
> > > >
> > > > +
> > > > +static struct dev_pm_ops au1xmmc_pmops = {
> > > > +	.resume		= au1xmmc_resume,
> > > > +	.suspend	= au1xmmc_suspend,
> > > > +};
> > > > +
> > >
> > > Was suspend to disk tested? It requires freeze()/thaw().
> > 
> > Is that a regression introduced by this patch then? If so, many more of 
> > the recent dev_pm_ops conversion patches would need to be revisited.
> 
> Yes, as far as I understand they would. Let's ask Rafael to confirm...

Yes, they would.  In general, you'd probably want to do something like this:

static struct dev_pm_ops au1xmmc_pmops = {
	.resume		= au1xmmc_resume,
	.suspend		= au1xmmc_suspend,
	.freeze		= au1xmmc_resume,
	.thaw		= au1xmmc_suspend,
	.restore		= au1xmmc_resume,
	.poweroff	= au1xmmc_suspend,
};

but in this particular case it's probably better to define separate callbacks
for .freeze() and .thaw() at least.

During hibernation we call .freeze() and .thaw() before and after creating
the image, respectively, and then .poweroff() is called right after the image
has been saved.  During resume .freeze() is called after the image has been
loaded and before the control goes to the image kernel, which then calls
.restore().

HTH

I see I forgot about that myself.  I'll fix up the floppy and hp-wmi patches.

Best,
Rafael
