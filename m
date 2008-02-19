Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbYBSP4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbYBSP4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYBSP4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:56:37 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:31264 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYBSP4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:56:36 -0500
Date: Tue, 19 Feb 2008 18:56:16 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.25-rc1-sha1: WARNING: at lib/kref.c:43 kref_get+0x20/0x30()
Message-ID: <20080219155616.GC8367@localhost.sw.ru>
References: <20080215110853.GH6110@localhost.sw.ru> <20080218045925.40fc5ddb.akpm@linux-foundation.org> <3ae72650802190019u76857e61n4ee543d33fd3c5fc@mail.gmail.com> <20080219120352.GA8367@localhost.sw.ru> <1203426602.4240.10.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203426602.4240.10.camel@lov.site>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 02:10:02PM +0100, Kay Sievers wrote:
> On Tue, 2008-02-19 at 15:03 +0300, Alexey Dobriyan wrote:
> > On Tue, Feb 19, 2008 at 09:19:25AM +0100, Kay Sievers wrote:
> > > On Feb 18, 2008 1:59 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > On Fri, 15 Feb 2008 14:08:53 +0300 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > > >
> > > > > Booting without SYSFS fills dmesg like this
> 
> > > Can you enable CONFIG_DEBUG_KOBJECT=y? It might give a hint where we
> > > miss to initialization of a kobject when sysfs is not compiled in.
> > 
> > It looks like this:
> 
> > ------------[ cut here ]------------
> > WARNING: at lib/kref.c:43 kref_get+0x2d/0x30()
> > Modules linked in: battery(+) button dock thermal processor sbs ac sbshc af_packet loop
> > Pid: 1642, comm: modprobe Not tainted 2.6.25-rc2 #2
> > 
> > Call Trace:
> >  [<ffffffff8022a8cf>] warn_on_slowpath+0x5f/0x80
> >  [<ffffffff8024cb06>] ? mark_held_locks+0x56/0xa0
> >  [<ffffffff80282c00>] ? __slab_alloc+0xc0/0x4b0
> >  [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
> >  [<ffffffff802f7f87>] ? kvasprintf+0x57/0x90
> >  [<ffffffff802f5c18>] ? vsnprintf+0x328/0x6e0
> >  [<ffffffff802f7fa0>] ? kvasprintf+0x70/0x90
> >  [<ffffffff802f1ced>] kref_get+0x2d/0x30
> >  [<ffffffff802f0c4a>] kobject_get+0x1a/0x30
> >  [<ffffffff802f0d39>] kobject_add_internal+0x59/0x160
> >  [<ffffffff802f0f6e>] kobject_add_varg+0x6e/0x80
> >  [<ffffffff802f1399>] kobject_add+0x69/0x90
> >  [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
> >  [<ffffffff802f1c4e>] ? kref_init+0xe/0x10
> >  [<ffffffff802f0927>] ? kobject_init+0x37/0xa0
> >  [<ffffffff802f09c3>] ? kobject_create+0x33/0x40
> >  [<ffffffff802f13fe>] kobject_create_and_add+0x3e/0x80
> >  [<ffffffff80255adf>] sys_init_module+0x19df/0x1b30
> >  [<ffffffff8024d928>] ? __lock_acquire+0x748/0x10b0
> >  [<ffffffff803249a0>] ? acpi_bus_register_driver+0x0/0x40
> >  [<ffffffff8024cc9f>] ? trace_hardirqs_on+0xbf/0x150
> >  [<ffffffff80406122>] ? trace_hardirqs_on_thunk+0x35/0x3a
> >  [<ffffffff8020b57b>] system_call_after_swapgs+0x7b/0x80
> > 
> > ---[ end trace 033c2b23880cf02a ]---
> > kobject: 'notes' (ffff81017ec370a8): kobject_add_internal: parent: '<NULL>', set: '<NULL>'
> 
> Ok, seems the "notes" directory should not be created if SYSFS is not
> configured. The "notes" kobject tries to reference the module kobject as
> a parent, which isn't initialized in that case.
> 
> Does that fix it?

Idea was good and below is patch which compiles and works. BTW, all noises
about improper ifdefs or more core than necessary should be ignored for
now -- sysfs stuff really wants to be separated into module-sysfs.c

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -992,7 +992,7 @@ static unsigned long resolve_symbol(Elf_Shdr *sechdrs,
  * /sys/module/foo/sections stuff
  * J. Corbet <corbet@lwn.net>
  */
-#ifdef CONFIG_KALLSYMS
+#if defined(CONFIG_KALLSYMS) && defined(CONFIG_SYSFS)
 static ssize_t module_sect_show(struct module_attribute *mattr,
 				struct module *mod, char *buf)
 {

