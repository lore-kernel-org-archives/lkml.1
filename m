Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbYCIGl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbYCIGl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 01:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYCIGlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 01:41:49 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:16298 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYCIGlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 01:41:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jxDVxWPBII6N5XOpgGwraHG6NSZ3SYoMaEwW5k7wFf6kkvPtNxs9klDJBrQpEvy7QTtQOqdEdlj9BoNscAkMxqWBvY44nl/ndOgsOIt/Ua79wGhOgb4D4hqiMjCP2FbicHFItY+Q8YSU9nND+Akl5hGDvE6O5veVZiK1gMtNwo0=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] Mark kobjects as unitialized
Date: Sun, 9 Mar 2008 12:06:02 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Mikael Pettersson <mikpe@it.uu.se>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <200803062223.18857.balajirrao@gmail.com> <200803090337.16253.balajirrao@gmail.com> <20080309063308.GA5297@suse.de>
In-Reply-To: <20080309063308.GA5297@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803091206.02680.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 March 2008 12:03:08 pm Greg KH wrote:
> On Sun, Mar 09, 2008 at 03:37:16AM +0530, Balaji Rao wrote:
> > On Thursday 06 March 2008 11:35:59 pm Greg KH wrote:
> > > On Thu, Mar 06, 2008 at 11:20:50PM +0530, Balaji Rao wrote:
> > > > On Thursday 06 March 2008 10:35:14 pm Greg KH wrote:
> > > > <snip>
> > > > > Where exactly in the code does that happen?  kobjects should not be
> > > > > "reused" as that implies that they are static, and not dynamically
> > > > > allocated, right?
> > > > >
> > > > > Which kobject is this?
> > > > Yes, its static. Here's the code from virt/kvm_main.c:1269
> > > > 
> > > > static struct sys_device kvm_sysdev = {
> > > >         .id = 0,
> > > >         .cls = &kvm_sysdev_class,
> > > > };
> > > > 
> > > > this sys_device is being registered/unregistered when kvm-intel is 
> > > > loaded/unloaded.
> > > 
> > > Ah, ok.  I'll add this patch then.
> > > 
> > > > > Ugh, is this the sys_device stuff?  I hate that code...
> > > > >
> > > > Yes it is! But, why do you hate it ?
> > > 
> > > For reasons like this :)
> > > 
> > > kobjects should not be static.  the sysdevice stuff was a hack when it
> > > was originally created and never touched since the mid 2.5 days.  It
> > > needs to be fixed up a lot, and is on my TODO list, slowly getting
> > > closer to the top...
> > Hi,
> > 
> > This patch does not fix it all! The problem is in fact more involved. I also get these BUG reports when I reload 
kvm-intel.
> > 
> > BUG kmalloc-8: Object already free
> > [  74.696570] -----------------------------------------------------------------------------
> > [   74.696596] 
> > [   74.697310] INFO: Allocated in strndup_user+0x30/0x62 age=587 cpu=2 pid=1439
> > [   74.697845] INFO: Freed in kobject_set_name_vargs+0x29/0x32 age=559 cpu=3 pid=1439
> > [   74.698008] INFO: Slab 0xc16f93a0 used=10 fp=0xf7c9d2d8 flags=0x10000c3
> > [   74.698008] INFO: Object 0xf7c9d1f8 @offset=504 fp=0xf7c9d578
> > 
> > This happens because, sysdev_class_register assigns a name to the
> > kobject, and kfrees the old name if any. The poisoned 'name' object
> > persists in case of statically allocated kobjects and as its passed to
> > kfree again when re registered, we get the above warning.
> > 
> > So, AFAICS the best way to solve this is by fixing the kobject users
> > (kvm, oprofile etc.) to use dynamic kobjects instead of static ones or
> > memset the kobject to zero before passing it to sysdev_register.
> 
> I like the memset idea, how about this patch instead?
> 
> thanks,
> 
> greg k-h
> 
> --- a/drivers/base/sys.c
> +++ b/drivers/base/sys.c
> @@ -133,6 +133,7 @@ int sysdev_class_register(struct sysdev_
>  	pr_debug("Registering sysdev class '%s'\n",
>  		 kobject_name(&cls->kset.kobj));
>  	INIT_LIST_HEAD(&cls->drivers);
> +	memset(&cls->kset.kobj, 0x00, sizeof(struct kobject));
>  	cls->kset.kobj.parent = &system_kset->kobj;
>  	cls->kset.kobj.ktype = &ktype_sysdev_class;
>  	cls->kset.kobj.kset = system_kset;
> 

This should work.But I am afraid if we zeroed it, the kfree poison test wouldn't catch even the genuine cases. Isn't it ? 
CMIIW.

A better fix according to me would be to zero the kobject in the places where we know it is being re-registered (kvm, 
oprofile) etc. This should do for now. But we should fix the sys_device users later, for the next cycle.

-- 
regards,
balaji rao
3rd year,
Dept. of Mechanical Engineering,
National Institute of Technology, Karnataka
