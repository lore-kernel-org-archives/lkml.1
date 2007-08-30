Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbXH3IWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbXH3IWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 04:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbXH3IWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 04:22:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:15845 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXH3IWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 04:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=dFW+8oEhzfoZKil357yban41JP65YpBCaOQzHzG57iWZ4Fc4hHj+W5MUFhkaBpCXBjVP/oxM96ayCBxAV7aHQDkPqb3TNHlLrtD7Ms+5iPlkwT7W49NPFAFM9WfoEardsOlOXGw5Di7x5u/bqVaFAZ1k9oOn+/IDWQg+bvuedhM=
Message-ID: <46D67E43.9050704@gmail.com>
Date: Thu, 30 Aug 2007 10:22:27 +0200
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch_align_stack() seems useless
References: <46D2DADF.8060505@gmail.com> <20070827071413.736e3dcb@laptopd505.fenrus.org> <46D42057.9090507@gmail.com>
In-Reply-To: <46D42057.9090507@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan,

Franck Bui-Huu wrote:
> Arjan van de Ven wrote:
>> arch_align_stack aligns, on x86, within a 2 page range (this is for
>> cache coloring).
> 
> OK, but for elf case this seems useless since the top of the stack is
> already randomized.
> 
> It seems that the randomization stuff (top of the stack + stack
> pointer inside a page) belongs to the elf binary format whereas it
> could have been part of exec.c. Are there any reasons ?
> 
>> The other thing you missed is that arch_align_stack()
>> is called in 2 locations, binfmt_elf.c is the primary location for
>> inside-the-page randomization.
>>
> 
> Well not really because for mips case, we have:
> 
> 	$ git grep ELF_PLATFORM include/asm-mips
> 	include/asm-mips/elf.h:#define ELF_PLATFORM  (NULL)
> 
> So on mips, the stack pointer won't get the inside the page
> randomization. Is that correct ?
> 
> If so, I'm wondering why this randomization must depend on that string
> to be defined. I must admit that I'm not sure how it's used. I guess
> it's used by ld.so and it could be set to "mips" for now...
> 

Do you think that the diff below would be correct ? I tested it on
mips and it seems to work fine but I can't really say if it's
valid enough to submit it as a patch...

thanks
		Franck

---8<---

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 4482a06..024006e 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -151,6 +151,13 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	struct vm_area_struct *vma;
 
 	/*
+	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
+	 * evictions by the processes running on the same package. One
+	 * thing we can do is to shuffle the initial stack for them.
+	 */
+	p = arch_align_stack(p);
+
+	/*
 	 * If this architecture has a platform capability string, copy it
 	 * to userspace.  In some cases (Sparc), this info is impossible
 	 * for userspace to get any other way, in others (i386) it is
@@ -160,14 +167,6 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	if (k_platform) {
 		size_t len = strlen(k_platform) + 1;
 
-		/*
-		 * In some cases (e.g. Hyper-Threading), we want to avoid L1
-		 * evictions by the processes running on the same package. One
-		 * thing we can do is to shuffle the initial stack for them.
-		 */
-
-		p = arch_align_stack(p);
-
 		u_platform = (elf_addr_t __user *)STACK_ALLOC(p, len);
 		if (__copy_to_user(u_platform, k_platform, len))
 			return -EFAULT;
