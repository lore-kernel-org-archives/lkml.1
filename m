Return-Path: <linux-kernel-owner+w=401wt.eu-S1751618AbYCJPwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbYCJPwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYCJPwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:52:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:40661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbYCJPwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:52:14 -0400
Date: Mon, 10 Mar 2008 08:52:00 -0700
From: Greg KH <gregkh@suse.de>
To: Balaji Rao <balajirrao@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Mark kobjects as unitialized
Message-ID: <20080310155200.GA20437@suse.de>
References: <200803062223.18857.balajirrao@gmail.com> <200803091206.02680.balajirrao@gmail.com> <20080309070307.GA6154@suse.de> <200803091251.15428.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803091251.15428.balajirrao@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2008 at 12:51:15PM +0530, Balaji Rao wrote:
> On Sunday 09 March 2008 12:33:07 pm Greg KH wrote:
> <snip>
> > > > > Hi,
> > > > > 
> > > > > This patch does not fix it all! The problem is in fact more involved. I also get these BUG reports when I reload 
> > > kvm-intel.
> > > > > 
> > > > > BUG kmalloc-8: Object already free
> > > > > [  74.696570] -----------------------------------------------------------------------------
> > > > > [   74.696596] 
> > > > > [   74.697310] INFO: Allocated in strndup_user+0x30/0x62 age=587 cpu=2 pid=1439
> > > > > [   74.697845] INFO: Freed in kobject_set_name_vargs+0x29/0x32 age=559 cpu=3 pid=1439
> > > > > [   74.698008] INFO: Slab 0xc16f93a0 used=10 fp=0xf7c9d2d8 flags=0x10000c3
> > > > > [   74.698008] INFO: Object 0xf7c9d1f8 @offset=504 fp=0xf7c9d578
> > > > > 
> > > > > This happens because, sysdev_class_register assigns a name to the
> > > > > kobject, and kfrees the old name if any. The poisoned 'name' object
> > > > > persists in case of statically allocated kobjects and as its passed to
> > > > > kfree again when re registered, we get the above warning.
> > > > > 
> > > > > So, AFAICS the best way to solve this is by fixing the kobject users
> > > > > (kvm, oprofile etc.) to use dynamic kobjects instead of static ones or
> > > > > memset the kobject to zero before passing it to sysdev_register.
> > > > 
> > > > I like the memset idea, how about this patch instead?
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > > --- a/drivers/base/sys.c
> > > > +++ b/drivers/base/sys.c
> > > > @@ -133,6 +133,7 @@ int sysdev_class_register(struct sysdev_
> > > >  	pr_debug("Registering sysdev class '%s'\n",
> > > >  		 kobject_name(&cls->kset.kobj));
> > > >  	INIT_LIST_HEAD(&cls->drivers);
> > > > +	memset(&cls->kset.kobj, 0x00, sizeof(struct kobject));
> > > >  	cls->kset.kobj.parent = &system_kset->kobj;
> > > >  	cls->kset.kobj.ktype = &ktype_sysdev_class;
> > > >  	cls->kset.kobj.kset = system_kset;
> > > > 
> > > 
> > > This should work.But I am afraid if we zeroed it, the kfree poison
> > > test wouldn't catch even the genuine cases. Isn't it ?  CMIIW.
> > 
> > What "genuine cases"?  kobjects should always be initialized to zero
> > before they are registered.
> > 
> The cases in which a freed kobject is passed to the register function ? Probably they will be caught when do a memset..
> > > A better fix according to me would be to zero the kobject in the
> > > places where we know it is being re-registered (kvm, oprofile) etc.
> > > This should do for now. But we should fix the sys_device users later,
> > > for the next cycle.
> > 
> > Are you sure you know all of the sysdev_class objects that can be
> > re-registered?
> > 
> Hmm.. Right. No, I only know that KVM and Oprofile use it.
> > Can you test this patch out?
> > 
> Yes the idea works. One more memset is needed in sysdev_register. Here's the final patch.
> 
> diff --git a/drivers/base/sys.c b/drivers/base/sys.c
> index 2f79c55..7c839d9 100644
> --- a/drivers/base/sys.c
> +++ b/drivers/base/sys.c
> @@ -133,6 +133,7 @@ int sysdev_class_register(struct sysdev_class * cls)
>         pr_debug("Registering sysdev class '%s'\n",
>                  kobject_name(&cls->kset.kobj));
>         INIT_LIST_HEAD(&cls->drivers);
> +       memset(&cls->kset.kobj, 0x00, sizeof(struct kobject));
>         cls->kset.kobj.parent = &system_kset->kobj;
>         cls->kset.kobj.ktype = &ktype_sysdev_class;
>         cls->kset.kobj.kset = system_kset;
> @@ -227,6 +228,7 @@ int sysdev_register(struct sys_device * sysdev)
>  
>         pr_debug("Registering sys device '%s'\n", kobject_name(&sysdev->kobj));
>  
> +       memset(&sysdev->kobj, 0x00, sizeof(struct kobject));
>         /* Make sure the kset is set */
>         sysdev->kobj.kset = &cls->kset;

Yes, you're right.

This also means I can drop the kobject_cleanup() patch from you as well,
as that should no longer be needed, right?

thanks,

greg k-h
