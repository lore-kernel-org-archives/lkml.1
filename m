Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbYLTGAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbYLTGAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 01:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYLTGAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 01:00:03 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:43446 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbYLTGAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 01:00:00 -0500
Date: Sat, 20 Dec 2008 06:59:55 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Eric Anholt <eric@anholt.net>
Cc: Dave Airlie <airlied@gmail.com>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers/gpu/drm: Move a dereference below a NULL
 test
In-Reply-To: <1229728328.6544.10.camel@gaiman.anholt.net>
Message-ID: <Pine.LNX.4.64.0812200659430.23348@ask.diku.dk>
References: <Pine.LNX.4.64.0812191809490.11217@ask.diku.dk> 
 <21d7e9970812191435g645c03ebqdcd53930d52f4830@mail.gmail.com>
 <1229728328.6544.10.camel@gaiman.anholt.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK

julia

On Fri, 19 Dec 2008, Eric Anholt wrote:

> On Sat, 2008-12-20 at 08:35 +1000, Dave Airlie wrote:
> > On Sat, Dec 20, 2008 at 3:10 AM, Julia Lawall <julia@diku.dk> wrote:
> > > From: Julia Lawall <julia@diku.dk>
> > >
> > > If the NULL test is necessary, then the dereference should be moved below
> > > the NULL test.
> > >
> > > The semantic patch that makes this change is as follows:
> > > (http://www.emn.fr/x-info/coccinelle/).  The result has been modified to
> > > move the initialization of driver down closer to where it is used.
> > >
> > > // <smpl>
> > > @@
> > > type T;
> > > expression E;
> > > identifier i,fld;
> > > statement S;
> > > @@
> > >
> > > - T i = E->fld;
> > > + T i;
> > >  ... when != E
> > >      when != i
> > >  if (E == NULL) S
> > > + i = E->fld;
> > > // </smpl>
> > >
> > > Signed-off-by: Julia Lawall <julia@diku.dk>
> > >
> > > ---
> > >  drivers/gpu/drm/drm_drv.c |    7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
> > > index 0b9f316..4bdfc98 100644
> > > --- a/drivers/gpu/drm/drm_drv.c
> > > +++ b/drivers/gpu/drm/drm_drv.c
> > > @@ -297,7 +297,7 @@ EXPORT_SYMBOL(drm_init);
> > >  */
> > >  static void drm_cleanup(struct drm_device * dev)
> > >  {
> > > -       struct drm_driver *driver = dev->driver;
> > > +       struct drm_driver *driver;
> > >
> > >        DRM_DEBUG("\n");
> > >
> > > @@ -324,8 +324,9 @@ static void drm_cleanup(struct drm_device * dev)
> > >                dev->agp = NULL;
> > >        }
> > >
> > > -       if (dev->driver->unload)
> > > -               dev->driver->unload(dev);
> > > +       driver = dev->driver;
> > > +       if (driver->unload)
> > > +               driver->unload(dev);
> > 
> > Huh?
> > 
> > The original test is to check it dev->driver->unload exists, not it
> > dev->driver exists.
> > 
> > I think your test  parameters are wrong.
> 
> No, it was valid, but I think the better patch is:
> 
> From 1e0a24cfe75a328db5a50dbcdaaf0eb461638b6b Mon Sep 17 00:00:00 2001
> From: Eric Anholt <eric@anholt.net>
> Date: Fri, 19 Dec 2008 15:07:11 -0800
> Subject: [PATCH] drm: Avoid use-before-null-test on dev in drm_cleanup().
> 
> Signed-off-by: Eric Anholt <eric@anholt.net>
> 
> ---
>  drivers/gpu/drm/drm_drv.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
> index 373e3de..febb517 100644
> --- a/drivers/gpu/drm/drm_drv.c
> +++ b/drivers/gpu/drm/drm_drv.c
> @@ -294,8 +294,6 @@ EXPORT_SYMBOL(drm_init);
>   */
>  static void drm_cleanup(struct drm_device * dev)
>  {
> -	struct drm_driver *driver = dev->driver;
> -
>  	DRM_DEBUG("\n");
>  
>  	if (!dev) {
> @@ -330,7 +328,7 @@ static void drm_cleanup(struct drm_device * dev)
>  	if (drm_core_check_feature(dev, DRIVER_MODESET))
>  		drm_put_minor(&dev->control);
>  
> -	if (driver->driver_features & DRIVER_GEM)
> +	if (dev->driver->driver_features & DRIVER_GEM)
>  		drm_gem_destroy(dev);
>  
>  	drm_put_minor(&dev->primary);
> -- 
> 1.5.6.5
> 
> 
> -- 
> Eric Anholt
> eric@anholt.net                         eric.anholt@intel.com
> 
> 
> 
