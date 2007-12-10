Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbXLJX0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbXLJX0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 18:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXLJX0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 18:26:41 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16693 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbXLJX0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 18:26:40 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: RFC: PNP: do not stop/start devices in suspend/resume path
Date: Mon, 10 Dec 2007 16:26:34 -0700
User-Agent: KMail/1.9.6
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, matthew@wil.cx,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, drzeus@drzeus.cx,
       linux-acpi@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Matthieu Castet <castet.matthieu@free.fr>, Len Brown <lenb@kernel.org>
References: <4745F77C.7040402@gmail.com> <200712051124.18852.bjorn.helgaas@hp.com> <1197011615.21100.1.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1197011615.21100.1.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712101626.35491.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2007 12:13:35 am Shaohua Li wrote:
> On Thu, 2007-12-06 at 02:24 +0800, Bjorn Helgaas wrote:
> > Index: linux-mm/drivers/pnp/driver.c
> > ===================================================================
> > --- linux-mm.orig/drivers/pnp/driver.c  2007-11-30 13:58:25.000000000
> > -0700
> > +++ linux-mm/drivers/pnp/driver.c       2007-12-03 09:58:35.000000000
> > -0700
> > @@ -161,13 +161,6 @@
> >                         return error;
> >         }
> > 
> > -       if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE) &&
> > -           pnp_can_disable(pnp_dev)) {
> > -               error = pnp_stop_dev(pnp_dev);
> > -               if (error)
> > -                       return error;
> > -       }
> > -
> >         if (pnp_dev->protocol && pnp_dev->protocol->suspend)
> >                 pnp_dev->protocol->suspend(pnp_dev, state);
> >         return 0;
> > @@ -177,7 +170,6 @@
> >  {
> >         struct pnp_dev *pnp_dev = to_pnp_dev(dev);
> >         struct pnp_driver *pnp_drv = pnp_dev->driver;
> > -       int error;
> > 
> >         if (!pnp_drv)
> >                 return 0;
> > @@ -185,12 +177,6 @@
> >         if (pnp_dev->protocol && pnp_dev->protocol->resume)
> >                 pnp_dev->protocol->resume(pnp_dev);
> > 
> > -       if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE)) {
> > -               error = pnp_start_dev(pnp_dev);
> > -               if (error)
> > -                       return error;
> > -       }
> > -
> I'd suggest keep pnp_start_dev here to prevent BIOS not or assign
> different resources after a resume.

The patch I currently have in -mm (http://lkml.org/lkml/2007/10/29/412)
merely requests resources in pnp_start_dev() and releases them in
pnp_stop_dev().  So if we remove pnp_stop_dev() but keep pnp_start_dev(),
I have to fix that patch to deal with things that may already be
reserved.

But I don't see any mention in the spec of running _SRS in the
sleep/wakup path, so I'm not convinced it's really necessary.
Section 7.4 mentions _TTS, _PTS, _GTS, etc., but not _SRS.

For devices, it looks like the intent is that BIOS should generate
notifications that cause OSPM to re-enumerate devices that might
have changed.  I'm pretty sure Linux is missing some of that code,
though, so I could believe that _SRS might help paper over that
deficiency.

What I'd really like to do is figure out how Windows uses _SRS and
do the same thing.

Bjorn
