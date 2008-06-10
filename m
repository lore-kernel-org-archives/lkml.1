Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbYFJOWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbYFJOWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 10:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYFJOWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 10:22:09 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:46800 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbYFJOWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 10:22:08 -0400
Message-ID: <484E8DD2.5050603@de.ibm.com>
Date: Tue, 10 Jun 2008 16:21:06 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: Jeff Dike <jdike@addtoit.com>, akpm@linuxfoundation.org,
       linux-kernel@vger.kernel.org,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: 2.6.26-rc5-mm1: uml link error
References: <OF61F32674.CE1F9CB0-ONC1257464.004D17DC-C1257464.004DB50E@de.ibm.com>
In-Reply-To: <OF61F32674.CE1F9CB0-ONC1257464.004D17DC-C1257464.004DB50E@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter 1 Oberparleiter wrote:
> Jeff Dike <jdike@addtoit.com> wrote on 10.06.2008 15:57:29:
> 
>> On Tue, Jun 10, 2008 at 01:19:27PM +0200, Miklos Szeredi wrote:
>> > Hmm, uml still doesn't boot with this patch, it dies while calling the
>> > constructors.  So maybe that SORT contruct is still needed?
>> > 
>> > #17 0x08049793 in do_ctors () at init/main.c:706
>> > #18 0x080499cc in do_basic_setup () at init/main.c:789
>> > #19 0x08049a43 in kernel_init (unused=0x0) at init/main.c:897
>> 
>> This doesn't look like it's in do_initcalls.  What happens with
>> "initcall_debug"?
> 
> Constructor calls inside the kernel happen just before any other
> initcall. The problem here is that constructors are called from both
> the host run-time environment as well as from the kernel. I'm
> working on a patch that disables kernel constructor calling for UML.

New try: should be fixed with the patch below (applies on top of
kernel-call-constructors.patch):

--
Subject: kernel: disable constructor calling for uml

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Disable calling of constructor functions from within the kernel for uml
as they are already called by the host run-time environment.

Found-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 include/asm-generic/vmlinux.lds.h |    2 ++
 init/main.c                       |    2 ++
 kernel/module.c                   |    2 ++
 3 files changed, 6 insertions(+)

Index: linux-2.6.26-rc5-mm2/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6.26-rc5-mm2/include/asm-generic/vmlinux.lds.h
@@ -381,7 +381,9 @@
 	}								\
 	__per_cpu_end = .;
 
+#ifndef CONFIG_UML
 #define CONSTRUCTORS							\
 		VMLINUX_SYMBOL(__ctor_start) = .;			\
 		*(.ctors)						\
 		VMLINUX_SYMBOL(__ctor_end) = .;
+#endif /* !CONFIG_UML */
Index: linux-2.6.26-rc5-mm2/init/main.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/init/main.c
+++ linux-2.6.26-rc5-mm2/init/main.c
@@ -699,11 +699,13 @@ asmlinkage void __init start_kernel(void
 
 static void __init do_ctors(void)
 {
+#ifndef CONFIG_UML
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
@@ -2194,10 +2194,12 @@ static struct module *load_module(void _
 
 static void do_mod_ctors(struct module *mod)
 {
+#ifndef CONFIG_UML
 	unsigned long i;
 
 	for (i = 0; i < mod->num_ctors; i++)
 		mod->ctors[i]();
+#endif /* !CONFIG_UML */
 }
 
 /* This is where the real work happens */
