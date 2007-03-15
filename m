Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbXCOMXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbXCOMXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 08:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933537AbXCOMXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 08:23:07 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:48671 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933536AbXCOMXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 08:23:03 -0400
Subject: Re: [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
From: Ian Campbell <Ian.Campbell@XenSource.com>
To: vgoyal@in.ibm.com
Cc: Horms <horms@verge.net.au>, hbabu@us.ibm.com, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20070315054726.GC6766@in.ibm.com>
References: <1173891609.8591.41.camel@localhost.localdomain>
	 <20070315014635.GC28396@verge.net.au> <20070315045536.GA6766@in.ibm.com>
	 <20070315050754.GB22329@verge.net.au>  <20070315054726.GC6766@in.ibm.com>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 12:22:57 +0000
Message-Id: <1173961378.8591.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Mar 2007 12:23:01.0985 (UTC) FILETIME=[ACC6CD10:01C766FC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 11:17 +0530, Vivek Goyal wrote:
> > > But I think changing this macro might run into issues. It is
> > > being used at few places in kernel, for example while loading
> > > module. This will essentially mean that we allow loading 64bit
> > > x86_64 modules on 32bit i386 systems?

Yes, not sure how I missed that fact...

> Kexec will also not allow loading an x86_64 kernel on a 32bit machine.

For crash kernel only or for regular kexec too?

> So how about something like vmcore_elf_allowed_cross_arch()? Vmcore
> code can continue to check elf_check_arch() and if that fails it can
> invoke vmcore_elf_allowed_cross_arch() to find out what cross arch are
> allowed for vmcore. 

Something like this?

Ian.

---  

Allow i386 crash kernels to handle x86_64 dumps.

The specific case I am encountering is kdump under Xen with a 64 bit
hypervisor and 32 bit kernel/userspace. The dump created is a 64 bit
due to the hypervisor but the dump kernel is 32 bit in for maximum
compatibility.

It's possibly less likely to be useful in a purely native scenario but
I see no reason to disallow it.

Signed-off-by: Ian Campbell <ian.campbell@xensource.com>

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index d960507..523e109 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -514,7 +514,7 @@ static int __init parse_crash_elf64_headers(void)
 	/* Do some basic Verification. */
 	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0 ||
 		(ehdr.e_type != ET_CORE) ||
-		!elf_check_arch(&ehdr) ||
+		!vmcore_elf_check_arch(&ehdr) ||
 		ehdr.e_ident[EI_CLASS] != ELFCLASS64 ||
 		ehdr.e_ident[EI_VERSION] != EV_CURRENT ||
 		ehdr.e_version != EV_CURRENT ||
diff --git a/include/asm-i386/kexec.h b/include/asm-i386/kexec.h
index 4dfc9f5..c76737e 100644
--- a/include/asm-i386/kexec.h
+++ b/include/asm-i386/kexec.h
@@ -47,6 +47,9 @@
 /* The native architecture */
 #define KEXEC_ARCH KEXEC_ARCH_386
 
+/* We can also handle crash dumps from 64 bit kernel. */
+#define vmcore_elf_check_arch_cross(x) ((x)->e_machine == EM_X86_64)
+
 #define MAX_NOTE_BYTES 1024
 
 /* CPU does not save ss and esp on stack if execution is already
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
+
+#define vmcore_elf_check_arch(x) (elf_check_arch(x) || vmcore_elf_check_arch_cross(x))
+
 #endif /* CONFIG_CRASH_DUMP */
 #endif /* LINUX_CRASHDUMP_H */


