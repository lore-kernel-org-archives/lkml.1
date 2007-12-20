Return-Path: <linux-kernel-owner+w=401wt.eu-S1764475AbXLTWGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764475AbXLTWGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764123AbXLTWGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:06:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763586AbXLTWGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:06:09 -0500
Date: Thu, 20 Dec 2007 14:04:56 -0800
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Greg KH <greg@kroah.com>,
       Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: kobject ->k_name memory leak
Message-ID: <20071220220456.GA16307@suse.de>
References: <20071203092607.GA22477@localhost.sw.ru> <20071203204716.GA9734@suse.de> <20071203210959.GA1725@martell.zuzino.mipt.ru> <20071203212551.GA11962@suse.de> <20071214214823.GA10305@kroah.com> <20071215133428.GA1732@martell.zuzino.mipt.ru> <1197731956.19869.22.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1197731956.19869.22.camel@lov.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2007 at 04:19:16PM +0100, Kay Sievers wrote:
> On Sat, 2007-12-15 at 16:34 +0300, Alexey Dobriyan wrote:
> > On Fri, Dec 14, 2007 at 01:48:23PM -0800, Greg KH wrote:
> > > On Mon, Dec 03, 2007 at 01:25:51PM -0800, Greg KH wrote:
> > > > On Tue, Dec 04, 2007 at 12:09:59AM +0300, Alexey Dobriyan wrote:
> > > > > On Mon, Dec 03, 2007 at 12:47:16PM -0800, Greg KH wrote:
> > > > > > On Mon, Dec 03, 2007 at 12:26:07PM +0300, Alexey Dobriyan wrote:
> > > > > > > Hi, Greg!
> > > > > > > 
> > > > > > > Commit ce2c9cb0259acd2aed184499ebe41ab00da13b25 aka
> > > > > > > "kobject: remove the static array for the name" introduced memory leak
> > > > > > > of a module name after modprobe/rmmod. Apparently for modules ->release
> > > > > > > callback is NULL.
> > > > > > > 
> > > > > > > kobject_cleanup: ->release = 00000000, name = 'foo_sysctl'
> > > > > > > Pid: 1927, comm: rmmod Not tainted 2.6.24-rc3-e1cca7e8d484390169777b423a7fe46c7021fec1 #5
> > > > > > >  [<c10d4a58>] kobject_cleanup+0xb8/0xc0
> > > > > > >  [<c10d4a60>] kobject_release+0x0/0x10
> > > > > > >  [<c10d587b>] kref_put+0x2b/0xa0
> > > > > > >  [<c11dbe85>] _spin_unlock+0x25/0x40
> > > > > > >  [<c1045b78>] free_module+0x78/0xd0
> > > > > > >  [<c104773f>] sys_delete_module+0x12f/0x1a0
> > > > > > 
> > > > > > Hm, _which_ kobject associated with a module, there are 3 of them I
> > > > > > think :)
> > > > > 
> > > > > Ouch!
> > > > > 
> > > > > > They should all have a release function, and if they do not, we think
> > > > > > it's a "static" kobject and it is not safe to free that name.
> > > > > > 
> > > > > > I've been working on cleaning this up a lot in the -mm tree with over 80
> > > > > > patches for the kset/kobject apis and interfaces.
> > > > > > 
> > > > > > But if we have a dynamic kobject, and we aren't freeing it properly,
> > > > > > please let me know which one it is and I'll work to fix it for 2.6.24.
> > > > > 
> > > > > The one which is passed to kobject_set_name() in mod_sysfs_init()..
> > > > 
> > > > That one should be set to the module_ktype, which is in kernel/params.c,
> > > > so the release function there should... oh crap, there is no release
> > > > function.  That's a bug.  After I get out of meetings tonight I'll write
> > > > up a patch for that, unless someone beats me to it :)
> > > 
> > > Ok, this is a mess.  We can't really have a release function for this
> > > kobject, as the structure it is embedded it has it's own memory
> > > management issues.
> > > 
> > > To fix this properly is going to take some major kobject/module surgery,
> > > it's not a simple fix at all.  I'll tackle it for 2.6.25, as it fits in
> > > nicely with the other kobject rework that I've already done in the -mm
> > > tree.
> > > 
> > > So, for now, can we just live with this tiny memory leak on module
> > > unload?
> > 
> > For the record, this leak screws any testing one can do wrt module
> > unload races. You can't really leave box overnight running
> > modprobe/rmmod in a loop, because OOM killer will finally kick in.
> > Hey, this is exactly how it was noticed at all.
> > 
> > > Or is the above trace something that users will see when unloading
> > > modules?
> > 
> > No, it's added debugging.
> 
> Can't we add an empty release function? It would free the name with the
> current logic, right?

Doh, that should be easy.

Alexey, can you see if the patch below fixes this issue for you?

thanks,

greg k-h

-------------------

---
 kernel/params.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/params.c
+++ b/kernel/params.c
@@ -697,8 +697,18 @@ static struct kset_uevent_ops module_uev
 decl_subsys(module, &module_ktype, &module_uevent_ops);
 int module_sysfs_initialized;
 
+static void module_release(struct kobject *kobj)
+{
+	/*
+	 * Stupid empty release function to allow the memory for the kobject to
+	 * be properly cleaned up.  This will not need to be present for 2.6.25
+	 * with the upcoming kobject core rework.
+	 */
+}
+
 static struct kobj_type module_ktype = {
 	.sysfs_ops =	&module_sysfs_ops,
+	.release = module_release,
 };
 
 /*
