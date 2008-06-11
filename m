Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYFKMS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYFKMS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYFKMSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:18:50 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:16761 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYFKMSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:18:49 -0400
Message-ID: <484FC29E.6040507@de.ibm.com>
Date: Wed, 11 Jun 2008 14:18:38 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Peter Oberparleiter <oberparleiter@googlemail.com>,
       Miklos Szeredi <miklos@szeredi.hu>, Jeff Dike <jdike@addtoit.com>,
       akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.26-rc5-mm1: uml link error
References: <OF61F32674.CE1F9CB0-ONC1257464.004D17DC-C1257464.004DB50E@de.ibm.com> <484E8DD2.5050603@de.ibm.com> <20080610172150.GA4728@uranus.ravnborg.org>
In-Reply-To: <20080610172150.GA4728@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Tue, Jun 10, 2008 at 04:21:06PM +0200, Peter Oberparleiter wrote:
>> Peter 1 Oberparleiter wrote:
>> > Jeff Dike <jdike@addtoit.com> wrote on 10.06.2008 15:57:29:
>> > 
>> >> On Tue, Jun 10, 2008 at 01:19:27PM +0200, Miklos Szeredi wrote:
>> >> > Hmm, uml still doesn't boot with this patch, it dies while calling the
>> >> > constructors.  So maybe that SORT contruct is still needed?
>> >> > 
>> >> > #17 0x08049793 in do_ctors () at init/main.c:706
>> >> > #18 0x080499cc in do_basic_setup () at init/main.c:789
>> >> > #19 0x08049a43 in kernel_init (unused=0x0) at init/main.c:897
>> >> 
>> >> This doesn't look like it's in do_initcalls.  What happens with
>> >> "initcall_debug"?
>> > 
>> > Constructor calls inside the kernel happen just before any other
>> > initcall. The problem here is that constructors are called from both
>> > the host run-time environment as well as from the kernel. I'm
>> > working on a patch that disables kernel constructor calling for UML.
>> 
>> New try: should be fixed with the patch below (applies on top of
>> kernel-call-constructors.patch):
>> 
>> --
>> Subject: kernel: disable constructor calling for uml
>> 
>> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> 
>> Disable calling of constructor functions from within the kernel for uml
>> as they are already called by the host run-time environment.
> 
> If this is the right fix then could we please have a less ugly patch.
> First off there is no need for the ifdef in vmlinux.lds.h.

Agreed. In that case the SORT(CONSTRUCTORS) statement in
arch/um/kernel/dyn.lds.S needs to be changed as well though (see my
previous patch in this thread) or we get the linker error detailed
in the original post.

> And we could get away with some flag or something where we 
> call the constructors.

The decision whether constructors should be called or not is made at
configuratiom time - I don't see a variable fitting into this scheme.
The only alternative I could imagine would be to introduce a hidden
config symbol CONFIG_CTORS which would be auto-selected by all archs
except for uml.

> And a comment explaning why UML is different is also missing.

Done. Here comes the modifed patch: applies on top of
kernel-call-constructors.patch, together with the remove-sort-
construct patch:

--
kernel: disable constructor calling for uml

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Disable calling of constructor functions for uml as they are already
called by the host run-time environment.

Found-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 init/main.c     |    4 ++++
 kernel/module.c |    4 ++++
 2 files changed, 8 insertions(+)

Index: linux-2.6.26-rc5-mm2/init/main.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/init/main.c
+++ linux-2.6.26-rc5-mm2/init/main.c
@@ -699,11 +699,15 @@ asmlinkage void __init start_kernel(void
 
 static void __init do_ctors(void)
 {
+#ifndef CONFIG_UML
+	/* Note: constructors on UML are called by the host run-time
+	 * environment. */
 	ctorcall_t *call;
 
 	for (call = (ctorcall_t *) __ctor_start;
 	     call < (ctorcall_t *) __ctor_end; call++)
 		(*call)();
+#endif /* !CONFIG_UML */
 }
 
 static int __initdata initcall_debug;
Index: linux-2.6.26-rc5-mm2/kernel/module.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/kernel/module.c
+++ linux-2.6.26-rc5-mm2/kernel/module.c
@@ -2194,10 +2194,14 @@ static struct module *load_module(void _
 
 static void do_mod_ctors(struct module *mod)
 {
+#ifndef CONFIG_UML
+	/* Note: constructors on UML are called by the host run-time
+	 * environment. */
 	unsigned long i;
 
 	for (i = 0; i < mod->num_ctors; i++)
 		mod->ctors[i]();
+#endif /* !CONFIG_UML */
 }
 
 /* This is where the real work happens */
