Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbYAZFhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbYAZFhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbYAZFgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:36:44 -0500
Received: from ns1.suse.de ([195.135.220.2]:60003 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbYAZFgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:36:42 -0500
Date: Fri, 25 Jan 2008 21:35:09 -0800
From: Greg KH <gregkh@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
Message-ID: <20080126053509.GC27403@suse.de>
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org> <20080125194219.GA4596@suse.de> <200801261550.58337.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801261550.58337.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 03:50:57PM +1100, Rusty Russell wrote:
> On Saturday 26 January 2008 06:42:19 Greg KH wrote:
> > On Fri, Jan 25, 2008 at 10:44:59AM -0800, Linus Torvalds wrote:
> > > On Thu, 24 Jan 2008, Greg KH wrote:
> > > > Here are a pretty large number of kobject, documentation, and driver
> > > > core patches against your 2.6.24 git tree.
> > >
> > > I've merged it all, but it causes lots of scary warnings:
> > >
> > >  - from the purely broken ones:
> > >
> > > 	ehci_hcd: no version for "struct_module" found: kernel tainted.
> >
> > Ok, in looking at the code, this should also be showing up for you on a
> > "clean" 2.6.24 release, I didn't change anything in this code path.
> >
> > That is what taints your kernel with the "F" flag.
> >
> > >  - to the scary ones:
> > >
> > > 	sysfs: duplicate filename 'ehci_hcd' can not be created
> > > 	WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > 	Pid: 610, comm: insmod Tainted: GF       2.6.24-gb47711bf #28
> > >
> > > 	Call Trace:
> > > 	 [<ffffffff802bd63c>] sysfs_add_one+0x54/0xbd
> > > 	 [<ffffffff802bdbc0>] create_dir+0x4f/0x87
> > > 	 [<ffffffff802bdc2d>] sysfs_create_dir+0x35/0x4a
> > > 	 [<ffffffff803154c8>] kobject_get+0x12/0x17
> > > 	 [<ffffffff80315607>] kobject_add_internal+0xd9/0x194
> > > 	 [<ffffffff8031579c>] kobject_add_varg+0x54/0x61
> > > 	 [<ffffffff80261efe>] __alloc_pages+0x66/0x2ee
> > > 	 [<ffffffff80315321>] kobject_init+0x42/0x82
> > > 	 [<ffffffff80315843>] kobject_init_and_add+0x9a/0xa7
> > > 	 [<ffffffff802722c0>] __vmalloc_area_node+0x111/0x135
> > > 	 [<ffffffff8025546b>] mod_sysfs_init+0x6e/0x83
> > > 	 [<ffffffff802561e8>] sys_init_module+0xa3d/0x1833
> > > 	 [<ffffffff8028ebd5>] dput+0x1c/0x10b
> > > 	 [<ffffffff8020b3be>] system_call+0x7e/0x83
> >
> > This is the sysfs core telling you that someone did something stupid :)
> >
> > Yes, that's new, but the "error" was always there, I just made the
> > warning more visible to get people to pay attention to it, and find the
> > real errors where this happens (and it has found them, which is a good
> > thing.)
> >
> > But in this case, it doesn't look like the module loading code will
> > detect that we are trying to load a module that is already present until
> > the kobjects are set up here.  It's been this way for a long time :(
> >
> > Rusty, any ideas of us adding a different check for "duplicate" modules
> > like this earlier in the load_module() function, so we don't spend so
> > much effort in building everything up when we don't need to?
> 
> module.c:1832 (in load_module)
> 
> 	if (find_module(mod->name)) {
> 		err = -EEXIST;
> 		goto free_mod;
> 	}
> 
> That's pretty early, and before this backtrace.

But that doesn't catch the case here, of trying to load a module when
the code itself is already built into the kernel.  For that we are
relying on the sysfs core to tell us we have a duplicate name problem,
which happens much later.

Is there any test you can do sooner, or is relying on the sysfs test
acceptable?

thanks,

greg k-h
