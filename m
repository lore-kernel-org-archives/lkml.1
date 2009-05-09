Return-Path: <linux-kernel-owner+w=401wt.eu-S1751614AbZEIFC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbZEIFC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 01:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZEIFCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 01:02:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:44392 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbZEIFCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 01:02:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gYcXIWVx/DRp5h4ZSzKSAZCjAP34xv3UOTUE7ey1gatw2n0tTZtwYvGKwhYlqWwH+t
         6auKcRsM4fKDmL4VmJbMAXLFwFLZEEj2uQS/I842qZPA78K0nzp6ibG1JveRj9E8Jafr
         PMd+c648MaQLMmfIuIQPpJYmvI6fG4h1Zdz/E=
Date: Sat, 9 May 2009 13:03:35 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/4] kernel: constructor support
Message-ID: <20090509050335.GC18129@hack>
References: <20090508154407.956216094@linux.vnet.ibm.com> <20090508154408.925135176@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508154408.925135176@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 05:44:09PM +0200, Peter Oberparleiter wrote:
>From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
>
>Call constructors (gcc-generated initcall-like functions) during
>kernel start and module load. Constructors are e.g. used for gcov data
>initialization.
>
>Disable constructor support for usermode Linux to prevent conflicts
>with host glibc.
>
>Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
>Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>Cc: Sam Ravnborg <sam@ravnborg.org>
>Cc: Jeff Dike <jdike@addtoit.com>


For UML, Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

A small detail below.


>---
> include/asm-generic/vmlinux.lds.h |   11 ++++++++++-
> include/linux/init.h              |    2 ++
> include/linux/module.h            |    6 ++++++
> init/Kconfig                      |    5 +++++
> init/main.c                       |   13 +++++++++++++
> kernel/module.c                   |   16 ++++++++++++++++
> 6 files changed, 52 insertions(+), 1 deletion(-)
>
>Index: linux-2.6.30-rc4/include/asm-generic/vmlinux.lds.h
>===================================================================
>--- linux-2.6.30-rc4.orig/include/asm-generic/vmlinux.lds.h
>+++ linux-2.6.30-rc4/include/asm-generic/vmlinux.lds.h
>@@ -332,6 +332,14 @@
> /* Section used for early init (in .S files) */
> #define HEAD_TEXT  *(HEAD_TEXT_SECTION)
> 
>+#ifdef CONFIG_CONSTRUCTORS
>+#define KERNEL_CTORS()	VMLINUX_SYMBOL(__ctors_start) = .; \
>+			*(.ctors)			   \
>+			VMLINUX_SYMBOL(__ctors_end) = .;
>+#else
>+#define KERNEL_CTORS()
>+#endif
>+
> /* init and exit section handling */
> #define INIT_DATA							\
> 	*(.init.data)							\
>@@ -340,7 +348,8 @@
> 	CPU_DISCARD(init.data)						\
> 	CPU_DISCARD(init.rodata)					\
> 	MEM_DISCARD(init.data)						\
>-	MEM_DISCARD(init.rodata)
>+	MEM_DISCARD(init.rodata)					\
>+	KERNEL_CTORS()
> 
> #define INIT_TEXT							\
> 	*(.init.text)							\
>Index: linux-2.6.30-rc4/include/linux/init.h
>===================================================================
>--- linux-2.6.30-rc4.orig/include/linux/init.h
>+++ linux-2.6.30-rc4/include/linux/init.h
>@@ -136,6 +136,8 @@ typedef void (*exitcall_t)(void);
> extern initcall_t __con_initcall_start[], __con_initcall_end[];
> extern initcall_t __security_initcall_start[], __security_initcall_end[];
> 
>+typedef void (*ctor_fn_t)(void);
>+
> /* Defined in init/main.c */
> extern int do_one_initcall(initcall_t fn);
> extern char __initdata boot_command_line[];
>Index: linux-2.6.30-rc4/include/linux/module.h
>===================================================================
>--- linux-2.6.30-rc4.orig/include/linux/module.h
>+++ linux-2.6.30-rc4/include/linux/module.h
>@@ -354,6 +354,12 @@ struct module
> 	local_t ref;
> #endif
> #endif
>+
>+#ifdef CONFIG_CONSTRUCTORS
>+	/* Constructor functions. */
>+	ctor_fn_t *ctors;
>+	unsigned int num_ctors;
>+#endif
> };
> #ifndef MODULE_ARCH_INIT
> #define MODULE_ARCH_INIT {}
>Index: linux-2.6.30-rc4/init/main.c
>===================================================================
>--- linux-2.6.30-rc4.orig/init/main.c
>+++ linux-2.6.30-rc4/init/main.c
>@@ -700,6 +700,18 @@ asmlinkage void __init start_kernel(void
> 	rest_init();
> }
> 
>+/* Call all constructor functions linked into the kernel. */
>+static void __init do_ctors(void)
>+{
>+#ifdef CONFIG_CONSTRUCTORS
>+	extern ctor_fn_t __ctors_start[], __ctors_end[];


I would like these to be globally decleared, since they are.


-- 
Live like a child, think like the god.
 
