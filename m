Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYBSNJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYBSNJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYBSNJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:09:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbYBSNJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:09:45 -0500
Subject: Re: 2.6.25-rc1-sha1: WARNING: at lib/kref.c:43 kref_get+0x20/0x30()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
In-Reply-To: <20080219120352.GA8367@localhost.sw.ru>
References: <20080215110853.GH6110@localhost.sw.ru>
	 <20080218045925.40fc5ddb.akpm@linux-foundation.org>
	 <3ae72650802190019u76857e61n4ee543d33fd3c5fc@mail.gmail.com>
	 <20080219120352.GA8367@localhost.sw.ru>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 14:10:02 +0100
Message-Id: <1203426602.4240.10.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+DQ+JzV2VbBtM34xmNA9FWc9Lz/7a6fNiEqJE
 wGPf0tmEHrZDyJlGatHYC++2vVePT1kCIUjFL1NBpkiA2iRVSy
 xMOMnb7/DfB3i/15H0ogFOFqL9gzQoD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-19 at 15:03 +0300, Alexey Dobriyan wrote:
> On Tue, Feb 19, 2008 at 09:19:25AM +0100, Kay Sievers wrote:
> > On Feb 18, 2008 1:59 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Fri, 15 Feb 2008 14:08:53 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > >
> > > > Booting without SYSFS fills dmesg like this

> > Can you enable CONFIG_DEBUG_KOBJECT=y? It might give a hint where we
> > miss to initialization of a kobject when sysfs is not compiled in.
> 
> It looks like this:

> ------------[ cut here ]------------
> WARNING: at lib/kref.c:43 kref_get+0x2d/0x30()
> Modules linked in: battery(+) button dock thermal processor sbs ac sbshc af_packet loop
> Pid: 1642, comm: modprobe Not tainted 2.6.25-rc2 #2
> 
> Call Trace:
>  [<ffffffff8022a8cf>] warn_on_slowpath+0x5f/0x80
>  [<ffffffff8024cb06>] ? mark_held_locks+0x56/0xa0
>  [<ffffffff80282c00>] ? __slab_alloc+0xc0/0x4b0
>  [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
>  [<ffffffff802f7f87>] ? kvasprintf+0x57/0x90
>  [<ffffffff802f5c18>] ? vsnprintf+0x328/0x6e0
>  [<ffffffff802f7fa0>] ? kvasprintf+0x70/0x90
>  [<ffffffff802f1ced>] kref_get+0x2d/0x30
>  [<ffffffff802f0c4a>] kobject_get+0x1a/0x30
>  [<ffffffff802f0d39>] kobject_add_internal+0x59/0x160
>  [<ffffffff802f0f6e>] kobject_add_varg+0x6e/0x80
>  [<ffffffff802f1399>] kobject_add+0x69/0x90
>  [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
>  [<ffffffff802f1c4e>] ? kref_init+0xe/0x10
>  [<ffffffff802f0927>] ? kobject_init+0x37/0xa0
>  [<ffffffff802f09c3>] ? kobject_create+0x33/0x40
>  [<ffffffff802f13fe>] kobject_create_and_add+0x3e/0x80
>  [<ffffffff80255adf>] sys_init_module+0x19df/0x1b30
>  [<ffffffff8024d928>] ? __lock_acquire+0x748/0x10b0
>  [<ffffffff803249a0>] ? acpi_bus_register_driver+0x0/0x40
>  [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
>  [<ffffffff80406122>] ? trace_hardirqs_on_thunk+0x35/0x3a
>  [<ffffffff8020b57b>] system_call_after_swapgs+0x7b/0x80
> 
> ---[ end trace 033c2b23880cf02a ]---
> kobject: 'notes' (ffff81017ec370a8): kobject_add_internal: parent: '<NULL>', set: '<NULL>'

Ok, seems the "notes" directory should not be created if SYSFS is not
configured. The "notes" kobject tries to reference the module kobject as
a parent, which isn't initialized in that case.

Does that fix it?

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: modules: do not try to add sysfs attributes if !CONFIG_SYSFS 

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 module.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 92595ba..2dd60c8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -987,6 +987,7 @@ static unsigned long resolve_symbol(Elf_Shdr *sechdrs,
 	return ret;
 }
 
+#ifdef CONFIG_SYSFS
 
 /*
  * /sys/module/foo/sections stuff
@@ -1169,7 +1170,7 @@ static void remove_notes_attrs(struct module *mod)
 		free_notes_attrs(mod->notes_attrs, mod->notes_attrs->notes);
 }
 
-#else
+#else /* CONFIG_KALLSYMS */
 
 static inline void add_sect_attrs(struct module *mod, unsigned int nsect,
 		char *sectstrings, Elf_Shdr *sechdrs)
@@ -1190,7 +1191,6 @@ static inline void remove_notes_attrs(struct module *mod)
 }
 #endif /* CONFIG_KALLSYMS */
 
-#ifdef CONFIG_SYSFS
 int module_add_modinfo_attrs(struct module *mod)
 {
 	struct module_attribute *attr;
@@ -1231,9 +1231,7 @@ void module_remove_modinfo_attrs(struct module *mod)
 	}
 	kfree(mod->modinfo_attrs);
 }
-#endif
 
-#ifdef CONFIG_SYSFS
 int mod_sysfs_init(struct module *mod)
 {
 	int err;
@@ -1299,7 +1297,7 @@ out_unreg:
 	kobject_put(&mod->mkobj.kobj);
 	return err;
 }
-#endif
+#endif /* CONFIG_SYSFS */
 
 static void mod_kobject_remove(struct module *mod)
 {


