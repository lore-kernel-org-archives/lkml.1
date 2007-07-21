Return-Path: <linux-kernel-owner+w=401wt.eu-S1761414AbXGUAEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414AbXGUAEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 20:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbXGUAD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 20:03:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:39368 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbXGUADz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 20:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RIA2mnBDpQu+ZQaGrFmv0B2YaLOqA9c2lsGgEHoiwWSLZI+Z9TD3wqElnSpPfaP3hx//jNHefD47Zb8ejdVx+TjjnUAlWCld4iN8t/y9pIX2hwAbSsLRbs8wG4BlR5fvIXrejUUjLlwCBt8jspab3js2o0ZqgisWA1wnqb91JMM=
Message-ID: <a781481a0707201703h6318fe65td4c5c6f57bb7eb24@mail.gmail.com>
Date: Sat, 21 Jul 2007 05:33:54 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Cc: "Andrew Morton" <akpm@linux-foundation.org>, rdunlap@xenotime.net,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0707201643l17ea92fajfbc256a7a16a802f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
	 <20070720225047.GA17520@suse.de>
	 <20070720155912.079c5a27.akpm@linux-foundation.org>
	 <20070720231052.GA19752@suse.de>
	 <a781481a0707201643l17ea92fajfbc256a7a16a802f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, which means ...


On 7/21/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 7/21/07, Greg KH <gregkh@suse.de> wrote:
> > On Fri, Jul 20, 2007 at 03:59:12PM -0700, Andrew Morton wrote:
> > > On Fri, 20 Jul 2007 15:50:47 -0700
> > > Greg KH <gregkh@suse.de> wrote:
> > >
> > > > On Fri, Jul 20, 2007 at 06:32:21PM +0200, Michal Piotrowski wrote:
> > > > >  Hi Greg,
> > > > >
> > > > >  This looks like a sysfs bug
> > > > >  http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/
> > > > >  broken-out-2007-07-20-00-22/00003.jpg
> > > > >
> > > > >  l *kernel_param_sysfs_setup+0x75
> > > > >  0xc13c0894 is in kernel_param_sysfs_setup (kernel/params.c:570).
> > > > >  565             mk->mod = THIS_MODULE;
> > > > >  566             kobj_set_kset_s(mk, module_subsys);

> > > > >  567             kobject_set_name(&mk->kobj, name);

Shouldn't the return of kobject_set_name() be checked here?

[ Looking at code, and realizing that kobject_set_name() manages to
succeed even when given a null string! ]

> > > > >  568             kobject_init(&mk->kobj);
> > > > >  569             ret = kobject_add(&mk->kobj);
> > > > >  570             BUG_ON(ret < 0);
> > > > >  571             param_sysfs_setup(mk, kparam, num_params, name_skip);
> > > > >  572             kobject_uevent(&mk->kobj, KOBJ_ADD);
> > > > >  573     }
> > > > >  574
> > > > >
> > > > >  http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/
> > > > >  broken-out-2007-07-20-00-22/mm-config
> > > >
> > > > What kernel version is this happening on?  The -mm tree?  Can you try
> > > > Linus's tree instead?
> > > >
> > > > It looks like there was some needed information right before the first
> > > > stack dump, showing exactly what kobject was trying to be added that was
> > > > already present.  Odds are this is a kernel parameter with the same name
> > > > as a duplicate one within the same module,
>
> I don't think that's an -EEXIST.
>
> I think what we have here is kobject_add() exiting with -EINVAL.
> (kobject attempted to be registered with no name!)
>
> [ The first trace on that screen shows: kobject_shadow_add+0x5b/0x189.
> That's the WARN_ON(1) at lib/kobject.c:176. If it was a EEXIST case,
> we would've seen an offset in kobject_shadow_add closer to 0x189,
> because the dump_stack() for EEXIST is barely 4 instructions before
> we return from that function. ]
>
> > > > but the trick is going to be
> > > > trying to figure out what module is causing this.
>
> So I'd guess we want to search for a module that's passing a kobject *
> to kobject_add() such that !kobj->k_name is true.

Oh, that's kernel_param_sysfs_setup itself. So we actually need to
search for a built-in module in Michal's config that ... has an ... empty
"" modname !? Shouldn't that turn up pretty quickly in a grep?

How do I do that, btw?
