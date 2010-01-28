Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204Ab0A1Uuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab0A1Uuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514Ab0A1Uuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:50:39 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:55622 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0A1Uuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:50:37 -0500
Date: Thu, 28 Jan 2010 12:48:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-01-28-01-36 uploaded (elfcore/compat_binfmt_elf)
Message-Id: <20100128124829.cb4bccb9.randy.dunlap@oracle.com>
In-Reply-To: <201001281002.o0SA2G0k002220@imap1.linux-foundation.org>
References: <201001281002.o0SA2G0k002220@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B61F861.0150:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010 01:36:55 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-01-28-01-36 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.33-rc5:


> elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
> elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
> elf-coredump-add-extended-numbering-support.patch


These patches can cause build errors.  See arch/x86/Kconfig:

config IA32_EMULATION
	bool "IA32 Emulation"
	depends on X86_64
	select COMPAT_BINFMT_ELF

COMPAT_BINFMT_ELF can be enabled (selected) even when BINFMT_ELF is not
enabled (due to "select" not looking at dependencies).

That causes the kernel/Makefile of elfcore not to be built:

diff -puN arch/ia64/kernel/Makefile~elf-coredump-replace-elf_core_extra_-macros-by-functions arch/ia64/kernel/Makefile
--- a/arch/ia64/kernel/Makefile~elf-coredump-replace-elf_core_extra_-macros-by-functions
+++ a/arch/ia64/kernel/Makefile
@@ -47,6 +47,8 @@ endif
 obj-$(CONFIG_DMAR)		+= pci-dma.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
 
+obj-$(CONFIG_BINFMT_ELF)	+= elfcore.o

since only COMPAT_BINFMT_ELF is enabled but not BINFMT_ELF.

So then the errors are:

fs/built-in.o: In function `elf_core_dump':
compat_binfmt_elf.c:(.text+0x551e8): undefined reference to `elf_core_extra_phdrs'
compat_binfmt_elf.c:(.text+0x55413): undefined reference to `elf_core_extra_data_size'
compat_binfmt_elf.c:(.text+0x556c4): undefined reference to `elf_core_write_extra_phdrs'
compat_binfmt_elf.c:(.text+0x559fd): undefined reference to `elf_core_write_extra_data'



---
~Randy
