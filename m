Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbYATRWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbYATRWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 12:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbYATRWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 12:22:09 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:59595 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbYATRWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 12:22:08 -0500
Date: Sun, 20 Jan 2008 18:21:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, WANG Cong <xiyou.wangcong@gmail.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: build #344 issue for v2.6.24-rc8-74-ga7da60f Section mismatch: reference to .init.text:lguest_entry
Message-ID: <20080120172151.GA22524@uranus.ravnborg.org>
References: <200801201619.01965.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801201619.01965.toralf.foerster@gmx.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2008 at 04:18:58PM +0100, Toralf Förster wrote:
> Hello,
> 
> although I applied the xen-patch:
> 
> ..............................................................................
> tfoerste@n22 ~/devel/linux-2.6 $ git diff
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index f84e772..5e24f67 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -59,7 +59,7 @@ static void xen_idle(void)
>  /*
>   * Set the bit indicating "nosegneg" library variants should be used.
>   */
> -static void fiddle_vdso(void)
> +static void __init fiddle_vdso(void)
>  {
>         extern u32 VDSO_NOTE_MASK; /* See ../kernel/vsyscall-note.S.  */
>         extern char vsyscall_int80_start;
> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> index f8d6937..288d587 100644
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -4,16 +4,18 @@
>  #ifdef CONFIG_XEN
> 
>  #include <linux/elfnote.h>
> +#include <linux/init.h>
>  #include <asm/boot.h>
>  #include <xen/interface/elfnote.h>
> 
> -.pushsection .init.text
> +       __INIT
>  ENTRY(startup_xen)
>         movl %esi,xen_start_info
>         cld
>         movl $(init_thread_union+THREAD_SIZE),%esp
>         jmp xen_start_kernel
> -.popsection
> +
> +       __FINIT
> 
>  .pushsection .bss.page_aligned
>         .align PAGE_SIZE_asm
> ..............................................................................
> 
> 
> I got during make :
> 
>   AS      .tmp_kallsyms3.o
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.data+0x4): Section mismatch: reference to .init.text:lguest_entry (between 'subarch_entries' and 'stack_start')
>   LD      vmlinux
>   SYSMAP  System.map
>   SYSMAP  .tmp_System.map
> 
> The build was made with :
> $> make mrproper && make rndconfig && <tweak config file> && make oldconfig && make

Different issue. Untested patch below.

	Sam
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index fbad51f..f0cacff 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -9,6 +9,7 @@
 
 .text
 #include <linux/threads.h>
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page.h>
@@ -151,7 +152,9 @@ WEAK(xen_entry)
 	/* Unknown implementation; there's really
 	   nothing we can do at this point. */
 	ud2a
-.data
+
+	__INITDATA
+
 subarch_entries:
 	.long default_entry		/* normal x86/PC */
 	.long lguest_entry		/* lguest hypervisor */
