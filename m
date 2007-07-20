Return-Path: <linux-kernel-owner+w=401wt.eu-S938956AbXGTXnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938956AbXGTXnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXGTXnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:43:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:31806 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbXGTXnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:43:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EkmLic6Vdi9GJ02P6Dh3AgdkAf4cGjkx4zuTHcBcXHUxlbxK2UTfoOGAQ1pCkj+F3in27L20lfPJbjbYnYvWevCwusPVwZhjplwyIGviZSv/qf6ES/epLPHSSC3Y1KnskOI4ShxZLv8tH10w3jg6+A0BnPobhA2wocl3CDeKsdc=
Message-ID: <a781481a0707201643l17ea92fajfbc256a7a16a802f@mail.gmail.com>
Date: Sat, 21 Jul 2007 05:13:12 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Cc: "Andrew Morton" <akpm@linux-foundation.org>, rdunlap@xenotime.net,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070720231052.GA19752@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
	 <20070720225047.GA17520@suse.de>
	 <20070720155912.079c5a27.akpm@linux-foundation.org>
	 <20070720231052.GA19752@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Greg KH <gregkh@suse.de> wrote:
> On Fri, Jul 20, 2007 at 03:59:12PM -0700, Andrew Morton wrote:
> > On Fri, 20 Jul 2007 15:50:47 -0700
> > Greg KH <gregkh@suse.de> wrote:
> >
> > > On Fri, Jul 20, 2007 at 06:32:21PM +0200, Michal Piotrowski wrote:
> > > >  Hi Greg,
> > > >
> > > >  This looks like a sysfs bug
> > > >  http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/
> > > >  broken-out-2007-07-20-00-22/00003.jpg
> > > >
> > > >  l *kernel_param_sysfs_setup+0x75
> > > >  0xc13c0894 is in kernel_param_sysfs_setup (kernel/params.c:570).
> > > >  565             mk->mod = THIS_MODULE;
> > > >  566             kobj_set_kset_s(mk, module_subsys);
> > > >  567             kobject_set_name(&mk->kobj, name);
> > > >  568             kobject_init(&mk->kobj);
> > > >  569             ret = kobject_add(&mk->kobj);
> > > >  570             BUG_ON(ret < 0);
> > > >  571             param_sysfs_setup(mk, kparam, num_params, name_skip);
> > > >  572             kobject_uevent(&mk->kobj, KOBJ_ADD);
> > > >  573     }
> > > >  574
> > > >
> > > >  http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-07-20-00-22/mm-config
> > >
> > > What kernel version is this happening on?  The -mm tree?  Can you try
> > > Linus's tree instead?
> > >
> > > It looks like there was some needed information right before the first
> > > stack dump, showing exactly what kobject was trying to be added that was
> > > already present.  Odds are this is a kernel parameter with the same name
> > > as a duplicate one within the same module,

I don't think that's an -EEXIST.

I think what we have here is kobject_add() exiting with -EINVAL.
(kobject attempted to be registered with no name!)

[ The first trace on that screen shows: kobject_shadow_add+0x5b/0x189.
That's the WARN_ON(1) at lib/kobject.c:176. If it was a EEXIST case,
we would've seen an offset in kobject_shadow_add closer to 0x189,
because the dump_stack() for EEXIST is barely 4 instructions before
we return from that function. ]

> > > but the trick is going to be
> > > trying to figure out what module is causing this.

So I'd guess we want to search for a module that's passing a kobject *
to kobject_add() such that !kobj->k_name is true.

> > > So it's not a sysfs bug, but rather a driver issue that this is
> > > catching.
> >
> > In that case a BUG was way too harsh treatment, and in fact directly
> > contributed to our inability to debug the bug!
> >
> > Can we wind that back a bit?  Add some useful printks and then recover
> > in some fashion?
> [...]
> So I'm guessing he was trying to catch something specific here.

Considering that:

(1) This isn't a bug that should bring down the kernel that hard, and,
(2) kobject_shadow_add() seems to be dumping enough stacks and
printing printk's on errors already,

I'd suggest to just get rid of the BUG_ON() in kernel_param_sysfs_setup()


Satyam
