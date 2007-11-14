Return-Path: <linux-kernel-owner+w=401wt.eu-S1763051AbXKNSin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763051AbXKNSin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbXKNSie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:38:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:54105 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbXKNSid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:38:33 -0500
Subject: Re: 2.6.24-rc2-mm1
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20071114165906.GB13889@kroah.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	 <a8e1da0711132218h9d944d0p3c22ac313ee667a9@mail.gmail.com>
	 <20071113223802.2ace1a61.akpm@linux-foundation.org>
	 <a8e1da0711132247jd440f8dgc9ac0442e90f2c34@mail.gmail.com>
	 <20071114004129.783fb98b.akpm@linux-foundation.org>
	 <a8e1da0711140136i1e441371j306e7b2888de104e@mail.gmail.com>
	 <20071114165906.GB13889@kroah.com>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 19:38:13 +0100
Message-Id: <1195065493.2168.31.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/Wn7mZAvuGqPvg1D8SHl78om/T0IqIJ4uoIk6
 QTb7OFOC1hwZBFniD5piFpKkcFRblPNPWq82CYoR3PUpte7WmP
 DCSn+qAw+SNq/fz6L2IdR0h/oV0oqDS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-14 at 08:59 -0800, Greg KH wrote:
> On Wed, Nov 14, 2007 at 05:36:48PM +0800, Dave Young wrote:
> > On Nov 14, 2007 4:41 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > On Wed, 14 Nov 2007 14:47:38 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
> > >
> > > > On Nov 14, 2007 2:38 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > >
> > > > > On Wed, 14 Nov 2007 14:18:39 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
> > > > >
> > > > > > Hi,
> > > > > > Boot failed on my machine. hand copy some messages.
> > > > > >
> > > > > > First with BLK_DEV_RAM=y
> > > > > >
> > > > > > BUG kmalloc-64 Poison overwritting:
> > > > > > Alloced in kset_create
> > > > > > Freed in kobject_cleanup
> > > > > >
> > > > > > --cut--
> > > > > > alloc_disk_node
> > > > > > rd_init
> > > > > > kernel_init
> > > > > > --cut--
> > > > > >
> > > > > > Then config ramdisk as module, build and reboot:
> > > > > >
> > > > > > BUG: unable handle paging resuest at 6b6b6b6b
> > > > > > EIP is kobject_add 0xc4/0x150
> > > > > >
> > > > > > --cut--
> > > > > > kobject_set_name
> > > > > > register_disk
> > > > > > add_disk
> > > > > > exact_match
> > > > > > exact_lock
> > > > > > loop_init
> > > > > > --cut--
> > > > > >
> > > > >
> > > > > erp.  Can you send the config over please?
> > > > >
> > > > > And which distro/version is that machine running?
> > > > >
> > > >
> > > > Hi,andrew
> > > >
> > > > slackware 11
> > > >
> > > > config as follows:
> > > > #
> > > > # Automatically generated make config: don't edit
> > > > # Linux kernel version: 2.6.24-rc2-mm1
> > > > # Wed Nov 14 13:50:01 2007
> > > > #
> > >
> > > OK, I can reproduce that on the Vaio, thanks.
> > >
> > > oops: http://userweb.kernel.org/~akpm/dsc00037.jpg
> > > config: (what you sent)
> > > dmesg: http://userweb.kernel.org/~akpm/dmesg-sony.txt
> > >
> > > An inspired guess led me to suspect the driver tree.  The offending patch
> > > is gregkh-driver-kset-convert-block_subsys-to-use-kset_create.patch.
> > >
> > Hi,
> > I do some printk debug, the problem hide in the kobject.c line 256 in
> > kobject_add
> > seems  at
> > list_add_tail(&kobj->entry,&kobj->kset->list);
> 
> That's just wierd.  I'll try to figure this out...
> 
> Kay, any thoughts, I can use any hint anyone has here :)

Hmm, I tried to reproduce, but none of my boxes shows that.

Could it be an init-order problem, where something tries to use the
block subsystem? Before it is initialized with:
  block/genhd.c :: subsys_initcall(genhd_device_init);

If that's the case, we have an old bug that nobody noticed with static
structures, which are zeroed that time, but definitely not properly
initialized.

I'll try to build loop non-modular now, and see if that makes the bug
appear here.

Kay

