Return-Path: <linux-kernel-owner+w=401wt.eu-S1767210AbXCIMbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767210AbXCIMbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767211AbXCIMbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:31:23 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:46394 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767210AbXCIMbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:31:22 -0500
Date: Fri, 9 Mar 2007 13:29:34 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] swsusp: Disable nonboot CPUs before entering platform suspend
Message-ID: <20070309122934.GA8412@osiris.boeblingen.de.ibm.com>
References: <200703072044.12021.rjw@sisk.pl> <20070307210716.GA4913@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307210716.GA4913@ucw.cz>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 09:07:17PM +0000, Pavel Machek wrote:
> Hi!
> 
> > Prevent the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping()
> > from triggering by disabling nonboot CPUs before we finally enter the platform
> > suspend.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  kernel/power/disk.c |    1 +
> >  kernel/power/user.c |    2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6.21-rc2-mm2/kernel/power/disk.c
> > ===================================================================
> > --- linux-2.6.21-rc2-mm2.orig/kernel/power/disk.c
> > +++ linux-2.6.21-rc2-mm2/kernel/power/disk.c
> > @@ -61,6 +61,7 @@ static void power_down(suspend_disk_meth
> >  	switch(mode) {
> >  	case PM_DISK_PLATFORM:
> >  		if (pm_ops && pm_ops->enter) {
> > +			disable_nonboot_cpus();
> >  			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
> >  			pm_ops->enter(PM_SUSPEND_DISK);
> >  			break;
> 
> ...so, if pm_ops is non-null, power_down does nonboot cpu disabling,
> otherwise we proceed with cpus enabled?
> 
> That looks ugly.
> 
> Is the warning bogus? Or maybe we should *always* disable nonboot cpus
> in powerdown path?

Is disable_nonboot_cpus() assuming that first_cpu(cpu_present_map) is
the boot cpu? Just wondering why disable_nonboot_cpus() isn't using just
any_online_cpu(cpu_online_map)...
