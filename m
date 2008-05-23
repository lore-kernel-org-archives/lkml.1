Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbYEWBfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbYEWBfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 21:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYEWBf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 21:35:29 -0400
Received: from ozlabs.org ([203.10.76.45]:55534 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbYEWBf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 21:35:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 3/4] modules: proper cleanup of kobject without CONFIG_SYSFS
Date: Fri, 23 May 2008 11:34:35 +1000
User-Agent: KMail/1.9.9
Cc: "Denis V. Lunev" <den@openvz.org>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
References: <1211277589-8565-1-git-send-email-den@openvz.org> <200805221920.22920.rusty@rustcorp.com.au> <20080522175415.GD8859@suse.de>
In-Reply-To: <20080522175415.GD8859@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805231134.35462.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2008 03:54:15 Greg KH wrote:
> On Thu, May 22, 2008 at 07:20:22PM +1000, Rusty Russell wrote:
> > On Tuesday 20 May 2008 19:59:48 Denis V. Lunev wrote:
> > > kobject: '<NULL>' (ffffffffa0104050): is not initialized, yet
> > > kobject_put()
> >
> > Thanks Denis.
> >
> > This patch masks a deeper problem; looks like you can't load any modules
> > with CONFIG_SYSFS=n:
> >
> > kernel/module.c:
> > int mod_sysfs_init(struct module *mod)
> > {
> > 	int err;
> > 	struct kobject *kobj;
> >
> > 	if (!module_sysfs_initialized) {
> > 		printk(KERN_ERR "%s: module sysfs not initialized\n",
> > 		       mod->name);
> > 		err = -EINVAL;
> > 		goto out;
> > 	}
> >
> > AFAICT, module_sysfs_initialized is not ever set if !CONFIG_SYSFS.
> >
> > I can't see the point of module_sysfs_initialized.  It was introduced by
> > Greg in commit 823bccfc ("remove "struct subsystem" as it is no longer
> > needed").
> >
> > Greg, what were you trying to do here?  Modules can't be loaded before
> > param_sysfs_init(): are you trying to handle the case where the
> > kset_create_and_add() fails?
>
> Yes.  Previously you were never detecting that if the subsystem was not
> properly created (for whatever reason), we could fail horribly when
> trying to load a module.

Well, my policy is to crash when allocations fail during boot, rather than 
traversing untested code paths.  But since that code already exists, I'm not 
religious enough to argue about it; just wanted to see if there was some 
subtlety I was missing.

> Now we at least detect that problem, is is causing an issue somehow?  I
> think you have now seen that we can load modules with CONFIG_SYSFS=n,
> otherwise people would have complained by now (not that anyone actually
> runs that kind of configuration that I know of...)

Yes, thanks.  But it seems noone has removed a module in such a config since 
April 2007.

The module/sysfs code is messy though: we do most sysfs stuff only under 
CONFIG_SYSFS, which seems overkill since at a glance it should just neatly do 
nothing.  Do you have the cycles and inclination to take a look at it?

Thanks,
Rusty.
