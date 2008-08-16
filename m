Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYHPCgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYHPCgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 22:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbYHPCgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 22:36:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61340 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYHPCgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 22:36:21 -0400
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
       ak@linux.intel.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
In-Reply-To: <20080815085836.67e420f1.randy.dunlap@oracle.com>
References: <20080814172945.250a27f2.sfr@canb.auug.org.au>
	 <20080814083828.d10e126d.randy.dunlap@oracle.com>
	 <3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com>
	 <20080815085836.67e420f1.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 16 Aug 2008 04:36:59 +0200
Message-Id: <1218854219.3629.30.camel@lgn.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX19t3hAw+HQDa575LcAJfiRAH9/Wdbmu1IBwZD6
 Av88VuIyuDnMNAUcOB8lCBJ+iIYCipU+ccOrmu4fKIGldph5Sl
 nQ/c/PFDspZlPtVjsbxq2f6GB7bJy8M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-15 at 08:58 -0700, Randy Dunlap wrote:
> On Fri, 15 Aug 2008 13:27:00 +0200 Kay Sievers wrote:
> 
> > On Thu, Aug 14, 2008 at 17:38, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > calling  param_sysfs_init+0x0/0x1e7
> > > ------------[ cut here ]------------
> > > WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x35/0x3d()
> > > sysfs: duplicate filename 'acpi' can not be created
> > 
> > Hi Randy,
> > care to add a printk to the module sysfs setup, and post dmesg again?
> > 
> > --- a/kernel/params.c
> > +++ b/kernel/params.c
> > @@ -603,6 +603,8 @@ static void __init param_sysfs_builtin(void)
> >  		}
> >  		name_len = dot - kp->name;
> > 
> > +		printk("XXX adding modparam:'%s' %i (%p)\n", kp->name, i, kp);
> > +
> >   		/* new kbuild_modname? */
> >  		if (strlen(modname) != name_len
> >  		    || strncmp(modname, kp->name, name_len) != 0) {
> > 
> > I might show the order of registering the /sys/modules/ directory, and
> > if there is possibly another "acpi" section, which tries to add
> > parameter names.

> Extract is:
> 
> XXX adding modparam:'acpi.power_nocheck' 34 (ffffffff806a4cf0)
...
> XXX adding modparam:'acpi.acpica_version' 45 (ffffffff806a4ea8)

Two different "modules" use the same prefix, which does not work with
the current logic, they need to live next to each other in the sequence
of options.

This adds a new option:
  http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=1382827e93799ec07790849e361267993cfe549e
﻿which specifies ﻿MODULE_PARAM_PREFIX="acpi." in:
  drivers/acpi/power.c
In the same way as:
  drivers/acpi/system.c

Seems, two different modules should not declare parameters in different
locations, and use the same MODULE_PARAM_PREFIX.

Thanks,
Kay

