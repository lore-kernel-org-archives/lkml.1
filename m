Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZG0Shm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZG0Shm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZG0Shm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:37:42 -0400
Received: from mail-fx0-f214.google.com ([209.85.220.214]:35869 "EHLO
	mail-fx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbZG0Shl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ukTKSdiZuaQyilRWMfyOdNt7JU5fVO1RkggObiBI5mzQYdwii+HLID83YryTufVa4D
         qlvdx4EzeRQiIo0QCWRg+eDhLV2TY/2QFZbnEKkfCfy8We/veOi+RPKfG0xyiLAttsAJ
         Vi6hRBYsYV5i5m0OuSs78Ww345bfWCJKwcjOY=
Date: Mon, 27 Jul 2009 20:37:33 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Peter Feuerer <peter@piie.net>, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
Message-ID: <20090727183733.GB3044@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Peter Feuerer <peter@piie.net>, lenb@kernel.org,
	linux-kernel@vger.kernel.org
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com>
 <cone.1247683003.40459.21332.1000@deskpiie>
 <20090723082904.GE3997@dtor-d630.eng.vmware.com>
 <cone.1248339143.133822.15136.1000@arca>
 <9ea470500907230221m1664be8ft2aaf63d2550de6f8@mail.gmail.com>
 <9ea470500907230553h3ae169c0nc6abaeedb08bef1e@mail.gmail.com>
 <20090727162940.DA90C526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090727162940.DA90C526EC9@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 08:55:51AM -0700, Dmitry Torokhov wrote:
> On Thu, Jul 23, 2009 at 02:53:17PM +0200, Borislav Petkov wrote:
> > > Dmitry's right, suspend() and resume() are used only for S2R. Since
> > > the only thing we do when suspending/hibernating is set fan speed to
> > > auto, we might just as well replicate those functions to .freeze() and
> > > .thaw().
> > 
> > here's a fix:
> > 
> > --
> > From: Borislav Petkov <petkovbb@gmail.com>
> > Date: Wed, 15 Jul 2009 17:33:32 +0200
> > Subject: [PATCH] acerhdf: convert to dev_pm_ops
> > 
> > v 1.1:
> > Add .freeze/.thaw func ptrs to support
> > suspend-to-disk, as suggested by Dmitry Torokhov.
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > ---
> >  drivers/platform/x86/acerhdf.c |   16 +++++++++++-----
> >  1 files changed, 11 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> > index aa298d6..8cd7a7b 100644
> > --- a/drivers/platform/x86/acerhdf.c
> > +++ b/drivers/platform/x86/acerhdf.c
> > @@ -435,7 +435,7 @@ struct thermal_cooling_device_ops acerhdf_cooling_ops = {
> >  };
> > 
> >  /* suspend / resume functionality */
> > -static int acerhdf_suspend(struct platform_device *dev, pm_message_t state)
> > +static int acerhdf_suspend(struct device *dev)
> >  {
> >  	if (kernelmode)
> >  		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
> > @@ -446,7 +446,7 @@ static int acerhdf_suspend(struct platform_device
> > *dev, pm_message_t state)
> >  	return 0;
> >  }
> > 
> > -static int acerhdf_resume(struct platform_device *device)
> > +static int acerhdf_resume(struct device *dev)
> >  {
> >  	if (verbose)
> >  		pr_notice("resuming\n");
> > @@ -464,15 +464,21 @@ static int acerhdf_remove(struct platform_device *device)
> >  	return 0;
> >  }
> > 
> > +static struct dev_pm_ops acerhdf_pm_ops = {
> > +	.suspend = acerhdf_suspend,
> > +	.resume  = acerhdf_resume,
> > +	.freeze  = acerhdf_suspend,
> > +	.thaw	 = acerhdf_resume,
> > +};
> > +
> 
> Hmm, looking at the driver I think the only function that actually is
> needed is poweroff() that would turn the fan in automatic mode before
> shutting down. The driver does not perform any actions when resuming so
> why bother?

Agreed.

Also, the fan comes out of warm and cold reboot in mode AUTO and
when the driver is enabled, the fan is turned off on the next run of
thermal_zone_device_update() when the read out temperature is within
limits.

Correct me if I'm wrong, but the only reason I see for setting the
fan to mode AUTO before suspending/hibernating/etc is if it is taking
a really long time to hibernate and write RAM image to disk and the
machine is getting hot during that process. Otherwise, we might just
as well do _nothing_ when suspending and remove all suspend/resume
functionality altogether, no?

-- 
Regards/Gruss,
    Boris.
