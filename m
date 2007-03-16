Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbXCPHRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbXCPHRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXCPHRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:17:49 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:31383 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbXCPHRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:17:47 -0400
Subject: Re: [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
From: Ian Campbell <Ian.Campbell@XenSource.com>
To: Horms <horms@verge.net.au>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, hbabu@us.ibm.com, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20070315234807.GB10861@verge.net.au>
References: <1173891609.8591.41.camel@localhost.localdomain>
	 <20070315014635.GC28396@verge.net.au> <20070315045536.GA6766@in.ibm.com>
	 <20070315050754.GB22329@verge.net.au> <20070315054726.GC6766@in.ibm.com>
	 <1173961378.8591.63.camel@localhost.localdomain>
	 <20070315132616.GH6766@in.ibm.com>  <20070315234807.GB10861@verge.net.au>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 07:17:43 +0000
Message-Id: <1174029463.28658.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2007 07:17:46.0534 (UTC) FILETIME=[32548460:01C7679B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 08:48 +0900, Horms wrote:
> > > 
> > > Signed-off-by: Ian Campbell <ian.campbell@xensource.com>
> > > 
> > > diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
> > > index d960507..523e109 100644
> > > --- a/fs/proc/vmcore.c
> > > +++ b/fs/proc/vmcore.c
> > > @@ -514,7 +514,7 @@ static int __init parse_crash_elf64_headers(void)
> > >  	/* Do some basic Verification. */
> > >  	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0 ||
> > >  		(ehdr.e_type != ET_CORE) ||
> > > -		!elf_check_arch(&ehdr) ||
> > > +		!vmcore_elf_check_arch(&ehdr) ||
> > >  		ehdr.e_ident[EI_CLASS] != ELFCLASS64 ||
> > >  		ehdr.e_ident[EI_VERSION] != EV_CURRENT ||
> > >  		ehdr.e_version != EV_CURRENT ||
> > > diff --git a/include/asm-i386/kexec.h b/include/asm-i386/kexec.h
> > > index 4dfc9f5..c76737e 100644
> > > --- a/include/asm-i386/kexec.h
> > > +++ b/include/asm-i386/kexec.h
> > > @@ -47,6 +47,9 @@
> > >  /* The native architecture */
> > >  #define KEXEC_ARCH KEXEC_ARCH_386
> > > 
> > > +/* We can also handle crash dumps from 64 bit kernel. */
> > > +#define vmcore_elf_check_arch_cross(x) ((x)->e_machine == EM_X86_64)
> > > +
> > 
> > Ideal place for this probably should have been arch dependent crash_dump.h
> > file. But we don't have one and no point introducing one just for this 
> > macro.
> > 
> > This change looks good to me.
> 
> Won't the above change break non i386 archtectures as
> vmcore_elf_check_arch_cross isn't defined for them?

No, because of this hunk:

diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 3250365..db60dac 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -14,5 +14,13 @@ extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
 extern const struct file_operations proc_vmcore_operations;
 extern struct proc_dir_entry *proc_vmcore;
 
+/* Architecture code defines this if there are other possible ELF
+ * machine types, e.g. on bi-arch capable hardware. */
+#ifndef vmcore_elf_check_arch_cross(x)
+#define vmcore_elf_check_arch_cross(x) 0
+#endif
[snip]

