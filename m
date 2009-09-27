Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbZI0Wjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbZI0Wjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 18:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZI0Wjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 18:39:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:50137 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751431AbZI0Wjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 18:39:45 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX184RTwiI5Q4jffpx1zCXJtHCkuz+bAs2pgS/t9jgU
	DKjRQfZm3ggWTP
Message-ID: <4ABFE9B3.8000000@gmx.de>
Date: Mon, 28 Sep 2009 00:39:47 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: linux-parisc@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH v2 0/2] Linker script cleanup patches for parisc
References: <1253306078-7066-1-git-send-email-tabbott@ksplice.com> <4ABFD2D3.5050606@gmx.de> <alpine.DEB.1.10.0909271719570.14151@dr-wily.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0909271719570.14151@dr-wily.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2009 11:25 PM, Tim Abbott wrote:
> On Sun, 27 Sep 2009, Helge Deller wrote:
>
>>   Tim, thanks for your work!
>>
>> Sadly it broke the parisc build in two places:
>> a) THREAD_SIZE can't be used in the vmlinux.lds.S file
>> b) It generates linker errors like "local symbol 0: discarded in section
>> `.exit.text' from kernel/built-in.o".
>
> Sorry about that -- I should have tried harder to get someone to test this
> one, since parisc is one of the architectures for which I don't have a
> cross-compiler.

No problem. It was on my todo-list to test your patch, but then it
already got merged :-)

>> Attached patch below fixes both issues. Tested with 32- and 64-bit parisc
>> kernel.
>
> The .exit.text change looks fine.

Good.

> [...]
> Rather than adding a new definition in asm-offsets.c, I think it'll be
> better to do something like the following to make the normal THREAD_SIZE
> definition available in the linker script and other assembly files:
>
> 	-Tim Abbott
>
> parisc: Make THREAD_SIZE available to assembly files and linker scripts.
>
> Signed-off-by: Tim Abbott<tabbott@ksplice.com>

Yes, much better.
Acked-by: Helge Deller <deller@gmx.de>

But with this change, the vmlinux.lds.S file needs to include
the <asm/thread_info.h> file as well. I've added the adjusted patch
to vmlinux.lds.S below.

> ---
>   arch/parisc/include/asm/thread_info.h |   10 +++++-----
>   1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/parisc/include/asm/thread_info.h b/arch/parisc/include/asm/thread_info.h
> index ac775a7..51bca20 100644
> --- a/arch/parisc/include/asm/thread_info.h
> +++ b/arch/parisc/include/asm/thread_info.h
> @@ -32,6 +32,11 @@ struct thread_info {
>   #define init_thread_info        (init_thread_union.thread_info)
>   #define init_stack              (init_thread_union.stack)
>
> +/* how to get the thread information struct from C */
> +#define current_thread_info()	((struct thread_info *)mfctl(30))
> +
> +#endif /* !__ASSEMBLY */
> +
>   /* thread information allocation */
>
>   #define THREAD_SIZE_ORDER            2
> @@ -40,11 +45,6 @@ struct thread_info {
>   #define THREAD_SIZE             (PAGE_SIZE<<  THREAD_SIZE_ORDER)
>   #define THREAD_SHIFT            (PAGE_SHIFT + THREAD_SIZE_ORDER)
>
> -/* how to get the thread information struct from C */
> -#define current_thread_info()	((struct thread_info *)mfctl(30))
> -
> -#endif /* !__ASSEMBLY */
> -
>   #define PREEMPT_ACTIVE_BIT	28
>   #define PREEMPT_ACTIVE		(1<<  PREEMPT_ACTIVE_BIT)
>

Adjusted patch to vmlinux.lds.S:

parisc: Fix linker script breakage.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index 775be27..7fc2c3d 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -28,6 +28,7 @@
  #include <asm/cache.h>
  #include <asm/page.h>
  #include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
  	
  /* ld script to make hppa Linux kernel */
  #ifndef CONFIG_64BIT
@@ -135,6 +136,16 @@ SECTIONS
  	INIT_TEXT_SECTION(16384)
  	INIT_DATA_SECTION(16)
  
+	/* we have to discard exit text and such at runtime, not link time */
+	.exit.text :
+	{
+		EXIT_TEXT
+	}
+	.exit.data :
+	{
+		EXIT_DATA
+	}
+
  	PERCPU(PAGE_SIZE)
  	. = ALIGN(PAGE_SIZE);
  	__init_end = .;
