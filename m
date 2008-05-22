Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbYEVRze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbYEVRze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbYEVRzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:55:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:37169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbYEVRzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:55:22 -0400
Date: Thu, 22 May 2008 10:54:15 -0700
From: Greg KH <gregkh@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Denis V. Lunev" <den@openvz.org>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 3/4] modules: proper cleanup of kobject without
	CONFIG_SYSFS
Message-ID: <20080522175415.GD8859@suse.de>
References: <1211277589-8565-1-git-send-email-den@openvz.org> <1211277589-8565-3-git-send-email-den@openvz.org> <200805221920.22920.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805221920.22920.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 07:20:22PM +1000, Rusty Russell wrote:
> On Tuesday 20 May 2008 19:59:48 Denis V. Lunev wrote:
> > kobject: '<NULL>' (ffffffffa0104050): is not initialized, yet kobject_put()
> 
> Thanks Denis.
> 
> This patch masks a deeper problem; looks like you can't load any modules with 
> CONFIG_SYSFS=n:
> 
> kernel/module.c:
> int mod_sysfs_init(struct module *mod)
> {
> 	int err;
> 	struct kobject *kobj;
> 
> 	if (!module_sysfs_initialized) {
> 		printk(KERN_ERR "%s: module sysfs not initialized\n",
> 		       mod->name);
> 		err = -EINVAL;
> 		goto out;
> 	}
> 
> AFAICT, module_sysfs_initialized is not ever set if !CONFIG_SYSFS.
> 
> I can't see the point of module_sysfs_initialized.  It was introduced by Greg 
> in commit 823bccfc ("remove "struct subsystem" as it is no longer needed").
> 
> Greg, what were you trying to do here?  Modules can't be loaded before 
> param_sysfs_init(): are you trying to handle the case where the 
> kset_create_and_add() fails?

Yes.  Previously you were never detecting that if the subsystem was not
properly created (for whatever reason), we could fail horribly when
trying to load a module.

Now we at least detect that problem, is is causing an issue somehow?  I
think you have now seen that we can load modules with CONFIG_SYSFS=n,
otherwise people would have complained by now (not that anyone actually
runs that kind of configuration that I know of...)

thanks,

greg k-h
