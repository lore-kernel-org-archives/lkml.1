Return-Path: <linux-kernel-owner+w=401wt.eu-S939078AbXGUBDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939078AbXGUBDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938802AbXGUBDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:03:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933505AbXGUBDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:03:36 -0400
Date: Fri, 20 Jul 2007 18:02:57 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, rdunlap@xenotime.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Message-ID: <20070721010257.GA9561@suse.de>
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com> <20070720225047.GA17520@suse.de> <20070720155912.079c5a27.akpm@linux-foundation.org> <20070720231052.GA19752@suse.de> <a781481a0707201643l17ea92fajfbc256a7a16a802f@mail.gmail.com> <a781481a0707201703h6318fe65td4c5c6f57bb7eb24@mail.gmail.com> <6bffcb0e0707201728u6deeccd1j453ff89d0767dccc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0707201728u6deeccd1j453ff89d0767dccc@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 02:28:52AM +0200, Michal Piotrowski wrote:
>  On 21/07/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> > Oh, which means ...
> >
> >
> > On 7/21/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> > > On 7/21/07, Greg KH <gregkh@suse.de> wrote:
> > > > On Fri, Jul 20, 2007 at 03:59:12PM -0700, Andrew Morton wrote:
> > > > > On Fri, 20 Jul 2007 15:50:47 -0700
> > > > > Greg KH <gregkh@suse.de> wrote:
> > > > >
> > > > > > On Fri, Jul 20, 2007 at 06:32:21PM +0200, Michal Piotrowski wrote:
> > > > > > >  Hi Greg,
> > > > > > >
> > > > > > >  This looks like a sysfs bug
> > > > > > >  http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/
> > > > > > >  broken-out-2007-07-20-00-22/00003.jpg
> > > > > > >
> > > > > > >  l *kernel_param_sysfs_setup+0x75
> > > > > > >  0xc13c0894 is in kernel_param_sysfs_setup (kernel/params.c:570).
> > > > > > >  565             mk->mod = THIS_MODULE;
> > > > > > >  566             kobj_set_kset_s(mk, module_subsys);
> >
> > > > > > >  567             kobject_set_name(&mk->kobj, name);
> >
> > Shouldn't the return of kobject_set_name() be checked here?
> >
> > [ Looking at code, and realizing that kobject_set_name() manages to
> > succeed even when given a null string! ]
> >
> > > > > > >  568             kobject_init(&mk->kobj);
> > > > > > >  569             ret = kobject_add(&mk->kobj);
> > > > > > >  570             BUG_ON(ret < 0);
> > > > > > >  571             param_sysfs_setup(mk, kparam, num_params, 
> > name_skip);
> > > > > > >  572             kobject_uevent(&mk->kobj, KOBJ_ADD);
> > > > > > >  573     }
> > > > > > >  574
> > > > > > >
> > > > > > >  http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/
> > > > > > >  broken-out-2007-07-20-00-22/mm-config
> > > > > >
> > > > > > What kernel version is this happening on?  The -mm tree?  Can you 
> > try
> > > > > > Linus's tree instead?
> > > > > >
> > > > > > It looks like there was some needed information right before the 
> > first
> > > > > > stack dump, showing exactly what kobject was trying to be added 
> > that was
> > > > > > already present.  Odds are this is a kernel parameter with the same 
> > name
> > > > > > as a duplicate one within the same module,
> > >
> > > I don't think that's an -EEXIST.
> > >
> > > I think what we have here is kobject_add() exiting with -EINVAL.
> > > (kobject attempted to be registered with no name!)
> > >
> > > [ The first trace on that screen shows: kobject_shadow_add+0x5b/0x189.
> > > That's the WARN_ON(1) at lib/kobject.c:176. If it was a EEXIST case,
> > > we would've seen an offset in kobject_shadow_add closer to 0x189,
> > > because the dump_stack() for EEXIST is barely 4 instructions before
> > > we return from that function. ]
> > >
> > > > > > but the trick is going to be
> > > > > > trying to figure out what module is causing this.
> > >
> > > So I'd guess we want to search for a module that's passing a kobject *
> > > to kobject_add() such that !kobj->k_name is true.
> >
> > Oh, that's kernel_param_sysfs_setup itself. So we actually need to
> > search for a built-in module in Michal's config that ... has an ... empty
> > "" modname !?
> 
>  I'll try to figure out this

Try the patch below to help you boot and figure out what went wrong.

Post the kernel log results and I'll try to help you out.

thanks,

greg k-h

---
 kernel/params.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/params.c
+++ b/kernel/params.c
@@ -567,7 +567,11 @@ static void __init kernel_param_sysfs_se
 	kobject_set_name(&mk->kobj, name);
 	kobject_init(&mk->kobj);
 	ret = kobject_add(&mk->kobj);
-	BUG_ON(ret < 0);
+	if (ret) {
+		printk(KERN_ERR "module '%s' failed to be added to sysfs, "
+			"the system will be unstable now.\n", name);
+		return;
+	}
 	param_sysfs_setup(mk, kparam, num_params, name_skip);
 	kobject_uevent(&mk->kobj, KOBJ_ADD);
 }

