Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYCJVko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYCJVko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYCJVkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:40:37 -0400
Received: from mail.queued.net ([207.210.101.209]:2552 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbYCJVkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:40:37 -0400
Date: Mon, 10 Mar 2008 17:44:24 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: [PATCH 6/6] PM/FB/gxfb: add config option that allows disabling
 of VT switch during suspend
Message-ID: <20080310174424.29621e62@ephemeral>
In-Reply-To: <20080310141939.ce1169c0.akpm@linux-foundation.org>
References: <20080308204927.73afa56c@ephemeral>
	<20080310141939.ce1169c0.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 14:19:39 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 8 Mar 2008 20:49:27 -0500
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > This is purely for suspend/resume time optimization.
> > 
> > 
> > >From 874aa20022a2501a30704163ed31a7baba7de9e5 Mon Sep 17 00:00:00 2001
> > From: Andres Salomon <dilinger@debian.org>
> > Date: Wed, 5 Mar 2008 16:40:25 -0500
> > Subject: [PATCH] PM: add config option that allows disabling of VT switch during suspend
> > 
> > Prior to suspend, we allocate and switch to a new VT; after suspend, we
> > switch back to the original VT.  This can be slow, and is completely
> > unnecessary if the framebuffer we're using can restore video properly.
> > 
> > This adds CONFIG_DISABLE_SUSPEND_VT_SWITCH which allows the user to
> > select whether or not to do that switch.  This has been tested with the
> > gxfb driver (on a Geode GX dev board and OLPC prototype machines).  In
> > order for the user to even see this option, a framebuffer has to declare
> > support for it (via CONFIG_FBDEV_SUPPORTS_NOSWITCH).
> > 
> > Signed-off-by: Andres Salomon <dilinger@debian.org>
> > ---
> >  drivers/char/Kconfig        |   21 +++++++++++++++++++++
> >  drivers/video/geode/Kconfig |    1 +
> >  include/linux/suspend.h     |    2 +-
> >  kernel/power/console.c      |    2 +-
> >  4 files changed, 24 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> > index 47c6be8..7fe0e85 100644
> > --- a/drivers/char/Kconfig
> > +++ b/drivers/char/Kconfig
> > @@ -58,6 +58,27 @@ config VT_CONSOLE
> >  
> >  	  If unsure, say Y.
> >  
> > +config FBDEV_SUPPORTS_NOSWITCH
> > +	bool
> > +	default n
> > +
> > +config DISABLE_SUSPEND_VT_SWITCH
> > +	bool "Disable the console switch prior to suspend (EXPERIMENTAL)"
> > +	depends on VT_CONSOLE && PM && EXPERIMENTAL && FBDEV_SUPPORTS_NOSWITCH
> > +	default n
> > +	---help---
> > +	  This option disables the automatic switch to VT console that happens
> > +	  prior to Linux going into a suspend/sleep.  Your
> > +	  video card/framebuffer must be able to properly restore the
> > +	  display (even if X is doing something crazy!) in this scenario.
> > +	  This is useful for saving precious milliseconds during suspend and
> > +	  resume; however, if your framebuffer lacks support, it could leave
> > +	  your display in a weird state.  If you're even seeing this option,
> > +	  it means at least one of your selected framebuffer drivers supports
> > +	  restoring the display.
> > +
> > +	  If unsure, say N.
> 
> It would be far preferable to do this via a kernel boot parameter rather
> than via a kernel rebuild.
> 

Well, it shouldn't be supported at _all_ unless the framebuffer driver
supports it; you're asking for it to be converted to something like the
following?



#ifdef CONFIG_FBDEV_SUPPORTS_NOSWITCH
static int no_vt_switch;
#endif

int pm_prepare_console(void)
{
#ifdef CONFIG_FBDEV_SUPPORTS_NOSWITCH
	if (no_vt_switch)
		return 0;
#endif
	...
}

#ifdef CONFIG_FBDEV_SUPPORTS_NOSWITCH
module_param(no_vt_switch, int, 0);
MODULE_PARM_DESC(no_vt_switch, "...");
#endif


If so, that means extra #ifdef's sprinkled throughout the code.  Note
that most framebuffer drivers won't be supporting this, and those that
do will almost certainly always want vt switching turned off..


