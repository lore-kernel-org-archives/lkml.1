Return-Path: <linux-kernel-owner+w=401wt.eu-S936221AbXGTXLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936221AbXGTXLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbXGTXL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:11:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477AbXGTXL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:11:27 -0400
Date: Fri, 20 Jul 2007 16:10:52 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, rdunlap@xenotime.net
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Message-ID: <20070720231052.GA19752@suse.de>
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com> <20070720225047.GA17520@suse.de> <20070720155912.079c5a27.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720155912.079c5a27.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 03:59:12PM -0700, Andrew Morton wrote:
> On Fri, 20 Jul 2007 15:50:47 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Fri, Jul 20, 2007 at 06:32:21PM +0200, Michal Piotrowski wrote:
> > >  Hi Greg,
> > > 
> > >  This looks like a sysfs bug
> > >  http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-07-20-00-22/00003.jpg
> > > 
> > >  l *kernel_param_sysfs_setup+0x75
> > >  0xc13c0894 is in kernel_param_sysfs_setup (kernel/params.c:570).
> > >  565             mk->mod = THIS_MODULE;
> > >  566             kobj_set_kset_s(mk, module_subsys);
> > >  567             kobject_set_name(&mk->kobj, name);
> > >  568             kobject_init(&mk->kobj);
> > >  569             ret = kobject_add(&mk->kobj);
> > >  570             BUG_ON(ret < 0);
> > >  571             param_sysfs_setup(mk, kparam, num_params, name_skip);
> > >  572             kobject_uevent(&mk->kobj, KOBJ_ADD);
> > >  573     }
> > >  574
> > > 
> > >  http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-07-20-00-22/mm-config
> > 
> > What kernel version is this happening on?  The -mm tree?  Can you try
> > Linus's tree instead?
> > 
> > It looks like there was some needed information right before the first
> > stack dump, showing exactly what kobject was trying to be added that was
> > already present.  Odds are this is a kernel parameter with the same name
> > as a duplicate one within the same module, but the trick is going to be
> > trying to figure out what module is causing this.
> > 
> > So it's not a sysfs bug, but rather a driver issue that this is
> > catching.
> 
> In that case a BUG was way too harsh treatment, and in fact directly
> contributed to our inability to debug the bug!
> 
> Can we wind that back a bit?  Add some useful printks and then recover
> in some fashion?

Sure, I don't mind doing that at all.

Hm, it looks like Randy added this back in September last year with:
	commit d8c7649e99e4b081b624aefe1e77caa30b53cb18
	Author: Randy Dunlap <rdunlap@xenotime.net>
	Date:   Fri Sep 29 01:58:55 2006 -0700

	    [PATCH] kernel/params: driver layer error checking

	    Check driver layer return values in kernel/params.c

	    Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
	    Signed-off-by: Andrew Morton <akpm@osdl.org>
	    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

(wow, I love git and the signed-off-tree for things like this, it's
trivial to find this information out.)

So I'm guessing he was trying to catch something specific here.

Randy, any objection to changing that BUG_ON to a printk warning instead
telling the user exactly what needs to be fixed and that the system is
now going to be unstable when any module is unloaded?

thanks,

greg k-h
