Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbYG2WQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbYG2WQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYG2WQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:16:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44362 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbYG2WQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:16:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ben Collins <ben.collins@canonical.com>
Subject: Re: [PATCH 6/7] pm: Config option to disable handling of console during suspend/resume
Date: Wed, 30 Jul 2008 00:18:34 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <24762.90.138.930.038.1036103001.ben.collins@canonical.com> <200807292315.36511.rjw@sisk.pl> <1217368310.6066.56.camel@cunning>
In-Reply-To: <1217368310.6066.56.camel@cunning>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807300018.35086.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 29 of July 2008, Ben Collins wrote:
> On Tue, 2008-07-29 at 23:15 +0200, Rafael J. Wysocki wrote:
> > On Tuesday, 29 of July 2008, Greg KH wrote:
> > > On Sun, Jul 20, 2008 at 09:48:28PM -0400, Ben Collins wrote:
> > > > Config option allows userspace to handle console during suspend/resume
> > > > instead of the kernel.
> > > > 
> > > > Signed-off-by: Ben Collins <ben.collins@canonical.com>
> > > > ---
> > > >  kernel/power/Kconfig   |   15 +++++++++++++++
> > > >  kernel/power/console.c |    4 ++++
> > > >  2 files changed, 19 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> > > > index b45da40..6855299 100644
> > > > --- a/kernel/power/Kconfig
> > > > +++ b/kernel/power/Kconfig
> > > > @@ -105,6 +105,21 @@ config SUSPEND_FREEZER
> > > >  
> > > >  	  Turning OFF this setting is NOT recommended! If in doubt, say Y.
> > > >  
> > > > +config PM_DISABLE_CONSOLE
> > > > +	bool "Disable Power Management messing with the active console"
> > > > +	depends on PM
> > > > +	default n
> > > > +	---help---
> > > > +	  By default, PM will take over the active console (generally, this means
> > > > +	  switching to the console when suspending from X). This can at times cause
> > > > +	  problems, especially if userspace suspend scripts try to do things with
> > > > +	  the console before or after suspending (e.g. calling vbestate).
> > > > +
> > > > +	  To work around this, enable this option so that PM will not handle the
> > > > +	  console.
> > > > +
> > > > +	  If unsure, say N.
> > > > +
> > > >  config HIBERNATION
> > > >  	bool "Hibernation (aka 'suspend to disk')"
> > > >  	depends on PM && SWAP && ARCH_HIBERNATION_POSSIBLE
> > > > diff --git a/kernel/power/console.c b/kernel/power/console.c
> > > > index b8628be..8b9706f 100644
> > > > --- a/kernel/power/console.c
> > > > +++ b/kernel/power/console.c
> > > > @@ -33,6 +33,7 @@ EXPORT_SYMBOL(pm_set_vt_switch);
> > > >  
> > > >  int pm_prepare_console(void)
> > > >  {
> > > > +#ifndef CONFIG_PM_DISABLE_CONSOLE
> > > 
> > > Can't you do this in a .h file instead?
> > > 
> > > And is this really needed?  Why has no other distro needed this change?
> > > What is so wierd about your suspend setup to require this?
> > 
> > Reportedly, some systems have problems with graphics restoration from user
> > space if the switch is done.
> > 
> > Anyway, I'd prefer to use the (already existing) pm_set_vt_switch() thing for
> > that, maybe with the help of a command line parameter, to adding the .config
> > option like this.
> 
> Ah. I didn't notice pm_set_vt_switch(). Then what I would like better is
> the config option to set a default. For us, not doing the vt switch is a
> good default (I don't think we have a case where suspend/resume requires
> it).

As long as we freeze X, I don't think the switch is really necessary.  I might
be wrong, though.

> Something like:

Well, why not.

[/me makes a note to change disable_vt_switch to 'bool' at some point in
future]


> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index e7bea3e..6a042f8 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2247,6 +2247,11 @@ and is between 256 and 4096 characters. It is defined in the file
>  	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
>  			Format: <command>
>  
> +	vt_switch=	[PM] Switch vt's during suspend/resume
> +			Format: { 0 | 1 }
> +			Default is normally '1', but depends on value of
> +			the PM_DISABLE_CONSOLE config option.
> +
>  	waveartist=	[HW,OSS]
>  			Format: <io>,<irq>,<dma>,<dma2>
>  
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index dcd165f..202f9b3 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -116,6 +116,25 @@ config SUSPEND_FREEZER
>  
>  	  Turning OFF this setting is NOT recommended! If in doubt, say Y.
>  
> +config PM_DISABLE_CONSOLE
> +	bool "Disable Power Management messing with the active console"
> +	depends on PM
> +	default n
> +	---help---
> +	  By default, PM will take over the active console (generally, this means
> +	  switching to the console when suspending from X). This can at times cause
> +	  problems, especially if userspace suspend scripts try to do things with
> +	  the console before or after suspending (e.g. calling vbestate).
> +
> +	  To work around this, enable this option so that PM will not handle the
> +	  console.
> +
> +	  Note, this is the same as passing vt_switch=0 command line option, but
> +	  just hardcodes the default. You can still pass vt_switch=1 with this
> +	  option to get original behavior.
> +
> +	  If unsure, say N.
> +
>  config HIBERNATION
>  	bool "Hibernation (aka 'suspend to disk')"
>  	depends on PM && SWAP && ARCH_HIBERNATION_POSSIBLE
> diff --git a/kernel/power/console.c b/kernel/power/console.c
> index b8628be..db116d8 100644
> --- a/kernel/power/console.c
> +++ b/kernel/power/console.c
> @@ -14,7 +14,11 @@
>  #define SUSPEND_CONSOLE	(MAX_NR_CONSOLES-1)
>  
>  static int orig_fgconsole, orig_kmsg;
> +#ifdef CONFIG_PM_DISABLE_CONSOLE
> +static int disable_vt_switch = 1;
> +#else
>  static int disable_vt_switch;
> +#endif
>  
>  /*
>   * Normally during a suspend, we allocate a new console and switch to it.
> @@ -80,4 +84,17 @@ void pm_restore_console(void)
>  	release_console_sem();
>  	kmsg_redirect = orig_kmsg;
>  }
> +
> +static int __init set_vt_switch(char *str)
> +{
> +	if (str[0] == '0')
> +		disable_vt_switch = 1;
> +	else if (str[0] == '1')
> +		disable_vt_switch = 0;
> +	else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +__setup("vt_switch=", set_vt_switch);
>  #endif
> 
> 
> 
> 


