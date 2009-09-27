Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbZI0VZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbZI0VZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 17:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZI0VZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 17:25:30 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54752 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbZI0VZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 17:25:29 -0400
Date: Sun, 27 Sep 2009 17:25:08 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Helge Deller <deller@gmx.de>
cc: linux-parisc@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 0/2] Linker script cleanup patches for parisc
In-Reply-To: <4ABFD2D3.5050606@gmx.de>
Message-ID: <alpine.DEB.1.10.0909271719570.14151@dr-wily.mit.edu>
References: <1253306078-7066-1-git-send-email-tabbott@ksplice.com> <4ABFD2D3.5050606@gmx.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009, Helge Deller wrote:

>  Tim, thanks for your work!
> 
> Sadly it broke the parisc build in two places:
> a) THREAD_SIZE can't be used in the vmlinux.lds.S file
> b) It generates linker errors like "local symbol 0: discarded in section
> `.exit.text' from kernel/built-in.o".

Sorry about that -- I should have tried harder to get someone to test this 
one, since parisc is one of the architectures for which I don't have a 
cross-compiler.

> Attached patch below fixes both issues. Tested with 32- and 64-bit parisc
> kernel.

The .exit.text change looks fine.

[...]
> b/arch/parisc/kernel/asm-offsets.c
> index 699cf8e..7e76f03 100644
> --- a/arch/parisc/kernel/asm-offsets.c
> +++ b/arch/parisc/kernel/asm-offsets.c
> @@ -287,6 +287,8 @@ int main(void)
>  	DEFINE(ASM_PFN_PTE_SHIFT, PFN_PTE_SHIFT);
>  	DEFINE(ASM_PT_INITIAL, PT_INITIAL);
>  	BLANK();
> +	DEFINE(ASM_THREAD_SIZE, THREAD_SIZE);
> +	BLANK();
>  	DEFINE(EXCDATA_IP, offsetof(struct exception_data, fault_ip));
>  	DEFINE(EXCDATA_SPACE, offsetof(struct exception_data, fault_space));
>  	DEFINE(EXCDATA_ADDR, offsetof(struct exception_data, fault_addr));

Rather than adding a new definition in asm-offsets.c, I think it'll be 
better to do something like the following to make the normal THREAD_SIZE 
definition available in the linker script and other assembly files:

	-Tim Abbott

parisc: Make THREAD_SIZE available to assembly files and linker scripts.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/parisc/include/asm/thread_info.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/include/asm/thread_info.h b/arch/parisc/include/asm/thread_info.h
index ac775a7..51bca20 100644
--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -32,6 +32,11 @@ struct thread_info {
 #define init_thread_info        (init_thread_union.thread_info)
 #define init_stack              (init_thread_union.stack)
 
+/* how to get the thread information struct from C */
+#define current_thread_info()	((struct thread_info *)mfctl(30))
+
+#endif /* !__ASSEMBLY */
+
 /* thread information allocation */
 
 #define THREAD_SIZE_ORDER            2
@@ -40,11 +45,6 @@ struct thread_info {
 #define THREAD_SIZE             (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define THREAD_SHIFT            (PAGE_SHIFT + THREAD_SIZE_ORDER)
 
-/* how to get the thread information struct from C */
-#define current_thread_info()	((struct thread_info *)mfctl(30))
-
-#endif /* !__ASSEMBLY */
-
 #define PREEMPT_ACTIVE_BIT	28
 #define PREEMPT_ACTIVE		(1 << PREEMPT_ACTIVE_BIT)
 
-- 
1.6.3.3
