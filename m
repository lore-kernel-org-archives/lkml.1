Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbYG3OU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbYG3OU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYG3OUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:20:14 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57516 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbYG3OUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:20:12 -0400
Subject: Re: [PATCH 6/7] pm: Config option to disable handling of console
 during suspend/resume
From: Ben Collins <ben.collins@canonical.com>
To: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <20080730044716.GA2954@kroah.com>
References: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
	 <E1KKl4J-00068V-6f@swissweb.swissdisk.com>
	 <20080729033309.GB12085@kroah.com> <200807292315.36511.rjw@sisk.pl>
	 <1217368310.6066.56.camel@cunning>  <20080730044716.GA2954@kroah.com>
Content-Type: text/plain
Organization: Canonical
Date: Wed, 30 Jul 2008 10:20:07 -0400
Message-Id: <1217427607.5976.104.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 21:47 -0700, Greg KH wrote:
> On Tue, Jul 29, 2008 at 05:51:50PM -0400, Ben Collins wrote:
> > On Tue, 2008-07-29 at 23:15 +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, 29 of July 2008, Greg KH wrote:
> > > > On Sun, Jul 20, 2008 at 09:48:28PM -0400, Ben Collins wrote:
> > > > > Config option allows userspace to handle console during suspend/resume
> > > > > instead of the kernel.
> > > > > 
> > > > > Signed-off-by: Ben Collins <ben.collins@canonical.com>
> > > > > ---
> > > > >  kernel/power/Kconfig   |   15 +++++++++++++++
> > > > >  kernel/power/console.c |    4 ++++
> > > > >  2 files changed, 19 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> > > > > index b45da40..6855299 100644
> > > > > --- a/kernel/power/Kconfig
> > > > > +++ b/kernel/power/Kconfig
> > > > > @@ -105,6 +105,21 @@ config SUSPEND_FREEZER
> > > > >  
> > > > >  	  Turning OFF this setting is NOT recommended! If in doubt, say Y.
> > > > >  
> > > > > +config PM_DISABLE_CONSOLE
> > > > > +	bool "Disable Power Management messing with the active console"
> > > > > +	depends on PM
> > > > > +	default n
> > > > > +	---help---
> > > > > +	  By default, PM will take over the active console (generally, this means
> > > > > +	  switching to the console when suspending from X). This can at times cause
> > > > > +	  problems, especially if userspace suspend scripts try to do things with
> > > > > +	  the console before or after suspending (e.g. calling vbestate).
> > > > > +
> > > > > +	  To work around this, enable this option so that PM will not handle the
> > > > > +	  console.
> > > > > +
> > > > > +	  If unsure, say N.
> > > > > +
> > > > >  config HIBERNATION
> > > > >  	bool "Hibernation (aka 'suspend to disk')"
> > > > >  	depends on PM && SWAP && ARCH_HIBERNATION_POSSIBLE
> > > > > diff --git a/kernel/power/console.c b/kernel/power/console.c
> > > > > index b8628be..8b9706f 100644
> > > > > --- a/kernel/power/console.c
> > > > > +++ b/kernel/power/console.c
> > > > > @@ -33,6 +33,7 @@ EXPORT_SYMBOL(pm_set_vt_switch);
> > > > >  
> > > > >  int pm_prepare_console(void)
> > > > >  {
> > > > > +#ifndef CONFIG_PM_DISABLE_CONSOLE
> > > > 
> > > > Can't you do this in a .h file instead?
> > > > 
> > > > And is this really needed?  Why has no other distro needed this change?
> > > > What is so wierd about your suspend setup to require this?
> > > 
> > > Reportedly, some systems have problems with graphics restoration from user
> > > space if the switch is done.
> > > 
> > > Anyway, I'd prefer to use the (already existing) pm_set_vt_switch() thing for
> > > that, maybe with the help of a command line parameter, to adding the .config
> > > option like this.
> > 
> > Ah. I didn't notice pm_set_vt_switch(). Then what I would like better is
> > the config option to set a default. For us, not doing the vt switch is a
> > good default (I don't think we have a case where suspend/resume requires
> > it).
> > 
> > Something like:
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index e7bea3e..6a042f8 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -2247,6 +2247,11 @@ and is between 256 and 4096 characters. It is defined in the file
> >  	vmpoff=		[KNL,S390] Perform z/VM CP command after power off.
> >  			Format: <command>
> >  
> > +	vt_switch=	[PM] Switch vt's during suspend/resume
> > +			Format: { 0 | 1 }
> > +			Default is normally '1', but depends on value of
> > +			the PM_DISABLE_CONSOLE config option.
> > +
> 
> Why a build time config option?  Why not just set the command line
> option if you need this?  And/or make it a sysctrl?
> 
> That way we don't have to add yet-another-config-option for distros and
> users to get wrong.
> 
> thanks,

Sysctl makes sense. I would rather not have to add a cmdline option to
default installs (and on upgrades). I'll redo the patch that way and
resend.

