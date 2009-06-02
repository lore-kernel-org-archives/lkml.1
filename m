Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbZFBWQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbZFBWQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZFBWQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:16:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbZFBWQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:16:24 -0400
Date: Tue, 2 Jun 2009 15:15:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl
Subject: Re: [PATCH] Fix floppy hibernation
Message-Id: <20090602151556.5df9167c.akpm@linux-foundation.org>
In-Reply-To: <200906021830.53531.linux@rainbow-software.org>
References: <200905301804.26762.linux@rainbow-software.org>
	<20090601164520.281cc4c8.akpm@linux-foundation.org>
	<200906021830.53531.linux@rainbow-software.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009 18:30:50 +0200
Ondrej Zary <linux@rainbow-software.org> wrote:

> > > +static int floppy_resume(struct platform_device *dev)
> > > +{
> > > +	int i;
> > > +
> > > +	for (i = 0; i < N_FDC; i++)
> > > +		if (FDCS->address != -1)
> > > +			user_reset_fdc(-1, FD_RESET_ALWAYS, 0);
> > > +
> > > +	return 0;
> > > +}
> >
> > hm, how does this work?
> >
> > FDCS is a revolting should-not-exist macro which assumes the presence
> > of a local variable called `fdc'.
> 
> The driver is complete mess - there is also a global static fdc variable.
> So it worked because I have only one floppy controller.
> 
> > So I think the loop control variable here should be called `fdc', not `i'.
> 
> See the v2 patch below. Tested and works too.

OK.

> >
> > It's pretty amazing that something like this still exists in a core
> > driver.  Someone please save us!
> 
> 
> 
> 
> Based on Ingo Molnar's patch from 2006, this makes the floppy work after
> resume from hibernation, at least on my machine.
> 

That's a very skimpy changelog.  The lack of any useful reference to
the referred-to Ingopatch doesn't aid things..

> --- linux-2.6.29.4-orig/drivers/block/floppy.c	2009-05-30 14:38:29.000000000 +0200
> +++ linux/drivers/block/floppy.c	2009-06-02 17:32:56.000000000 +0200
> @@ -4148,6 +4148,24 @@
>  {
>  }
>  
> +static int floppy_resume(struct platform_device *dev)
> +{
> +	int fdc;
> +
> +	for (fdc = 0; fdc < N_FDC; fdc++)
> +		if (FDCS->address != -1)
> +			user_reset_fdc(-1, FD_RESET_ALWAYS, 0);
> +
> +	return 0;
> +}

The patch changes the driver so that it calls user_reset_fdc() for each
device at resume-time.

Why?  What effect does this have on the hardware and why does it fix things?

Thanks.

