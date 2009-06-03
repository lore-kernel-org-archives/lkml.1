Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZFCGNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZFCGNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbZFCGNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:13:31 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:33418 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbZFCGNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:13:31 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix floppy hibernation
Date: Wed, 3 Jun 2009 08:13:26 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl
References: <200905301804.26762.linux@rainbow-software.org> <200906021830.53531.linux@rainbow-software.org> <20090602151556.5df9167c.akpm@linux-foundation.org>
In-Reply-To: <20090602151556.5df9167c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906030813.27625.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 June 2009, Andrew Morton wrote:
> On Tue, 2 Jun 2009 18:30:50 +0200
>
> Ondrej Zary <linux@rainbow-software.org> wrote:
> > > > +static int floppy_resume(struct platform_device *dev)
> > > > +{
> > > > +	int i;
> > > > +
> > > > +	for (i = 0; i < N_FDC; i++)
> > > > +		if (FDCS->address != -1)
> > > > +			user_reset_fdc(-1, FD_RESET_ALWAYS, 0);
> > > > +
> > > > +	return 0;
> > > > +}
> > >
> > > hm, how does this work?
> > >
> > > FDCS is a revolting should-not-exist macro which assumes the presence
> > > of a local variable called `fdc'.
> >
> > The driver is complete mess - there is also a global static fdc variable.
> > So it worked because I have only one floppy controller.
> >
> > > So I think the loop control variable here should be called `fdc', not
> > > `i'.
> >
> > See the v2 patch below. Tested and works too.
>
> OK.
>
> > > It's pretty amazing that something like this still exists in a core
> > > driver.  Someone please save us!
> >
> > Based on Ingo Molnar's patch from 2006, this makes the floppy work after
> > resume from hibernation, at least on my machine.
>
> That's a very skimpy changelog.  The lack of any useful reference to
> the referred-to Ingopatch doesn't aid things..
>
> > --- linux-2.6.29.4-orig/drivers/block/floppy.c	2009-05-30
> > 14:38:29.000000000 +0200 +++ linux/drivers/block/floppy.c	2009-06-02
> > 17:32:56.000000000 +0200 @@ -4148,6 +4148,24 @@
> >  {
> >  }
> >
> > +static int floppy_resume(struct platform_device *dev)
> > +{
> > +	int fdc;
> > +
> > +	for (fdc = 0; fdc < N_FDC; fdc++)
> > +		if (FDCS->address != -1)
> > +			user_reset_fdc(-1, FD_RESET_ALWAYS, 0);
> > +
> > +	return 0;
> > +}
>
> The patch changes the driver so that it calls user_reset_fdc() for each
> device at resume-time.
>
> Why?  What effect does this have on the hardware and why does it fix
> things?

I don't know at all, it's complete guesswork. The first thing I tested was 
rmmod floppy && modprobe floppy after resume - it worked. Narrowing the 
initialization code down resulted in this patch.

-- 
Ondrej Zary
