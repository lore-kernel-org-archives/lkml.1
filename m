Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbYAZEwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbYAZEwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 23:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYAZEwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 23:52:05 -0500
Received: from ozlabs.org ([203.10.76.45]:41118 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbYAZEwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 23:52:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@suse.de>
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
Date: Sat, 26 Jan 2008 15:50:57 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org> <20080125194219.GA4596@suse.de>
In-Reply-To: <20080125194219.GA4596@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801261550.58337.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 January 2008 06:42:19 Greg KH wrote:
> On Fri, Jan 25, 2008 at 10:44:59AM -0800, Linus Torvalds wrote:
> > On Thu, 24 Jan 2008, Greg KH wrote:
> > > Here are a pretty large number of kobject, documentation, and driver
> > > core patches against your 2.6.24 git tree.
> >
> > I've merged it all, but it causes lots of scary warnings:
> >
> >  - from the purely broken ones:
> >
> > 	ehci_hcd: no version for "struct_module" found: kernel tainted.
>
> Ok, in looking at the code, this should also be showing up for you on a
> "clean" 2.6.24 release, I didn't change anything in this code path.
>
> That is what taints your kernel with the "F" flag.
>
> >  - to the scary ones:
> >
> > 	sysfs: duplicate filename 'ehci_hcd' can not be created
> > 	WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > 	Pid: 610, comm: insmod Tainted: GF       2.6.24-gb47711bf #28
> >
> > 	Call Trace:
> > 	 [<ffffffff802bd63c>] sysfs_add_one+0x54/0xbd
> > 	 [<ffffffff802bdbc0>] create_dir+0x4f/0x87
> > 	 [<ffffffff802bdc2d>] sysfs_create_dir+0x35/0x4a
> > 	 [<ffffffff803154c8>] kobject_get+0x12/0x17
> > 	 [<ffffffff80315607>] kobject_add_internal+0xd9/0x194
> > 	 [<ffffffff8031579c>] kobject_add_varg+0x54/0x61
> > 	 [<ffffffff80261efe>] __alloc_pages+0x66/0x2ee
> > 	 [<ffffffff80315321>] kobject_init+0x42/0x82
> > 	 [<ffffffff80315843>] kobject_init_and_add+0x9a/0xa7
> > 	 [<ffffffff802722c0>] __vmalloc_area_node+0x111/0x135
> > 	 [<ffffffff8025546b>] mod_sysfs_init+0x6e/0x83
> > 	 [<ffffffff802561e8>] sys_init_module+0xa3d/0x1833
> > 	 [<ffffffff8028ebd5>] dput+0x1c/0x10b
> > 	 [<ffffffff8020b3be>] system_call+0x7e/0x83
>
> This is the sysfs core telling you that someone did something stupid :)
>
> Yes, that's new, but the "error" was always there, I just made the
> warning more visible to get people to pay attention to it, and find the
> real errors where this happens (and it has found them, which is a good
> thing.)
>
> But in this case, it doesn't look like the module loading code will
> detect that we are trying to load a module that is already present until
> the kobjects are set up here.  It's been this way for a long time :(
>
> Rusty, any ideas of us adding a different check for "duplicate" modules
> like this earlier in the load_module() function, so we don't spend so
> much effort in building everything up when we don't need to?

module.c:1832 (in load_module)

	if (find_module(mod->name)) {
		err = -EEXIST;
		goto free_mod;
	}

That's pretty early, and before this backtrace.

Even for simultaneous loads, there's a mutex which protects from here to the 
list insertion.

Puzzled,
Rusty.
