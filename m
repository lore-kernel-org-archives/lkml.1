Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbZIHGy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbZIHGy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 02:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZIHGy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 02:54:57 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:57164 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753408AbZIHGy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 02:54:56 -0400
Message-ID: <4AA5FF9D.10703@snapgear.com>
Date: Tue, 08 Sep 2009 16:54:21 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH] m68knommu: Clean up linker script using new linker script
 macros.
References: <1252293044-13102-1-git-send-email-tabbott@ksplice.com> <4AA49946.2000804@snapgear.com> <alpine.DEB.1.10.0909070135040.17860@dr-wily.mit.edu> <4AA4B104.7040507@snapgear.com> <alpine.DEB.1.10.0909071017001.17860@dr-wily.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0909071017001.17860@dr-wily.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Abbott wrote:
> On Mon, 7 Sep 2009, Greg Ungerer wrote:
> 
>> Now, back to the original patch. Now fails with another syntax error
>> at the last line in this:
>>
>>  .init : {
>>   . = ALIGN((1 << (12)));
>>   __init_begin = .;
>>   . = ALIGN((1 << (12))); .init.text : AT(ADDR(.init.text) - 0) { _sinittext =
>> .; *(.init.text) *(.devinit.text) *(.cpuinit.text) *(.meminit.text) _einittext
>> = .; }
> 
> Oops.  The ".init : { }" wrapping the new macros there should have been 
> removed.
> 
> The following patch should fix this issue (obviously, you'll want to 
> squash it with the original patch, but I figure sending the diff will be 
> easier to review).

Ok, yes, that fixes that problem. I had to also make THREAD_SIZE
available to the linker with:

diff --git a/arch/m68k/include/asm/thread_info_no.h 
b/arch/m68k/include/asm/thre
index c2bde5e..a6512bf 100644
--- a/arch/m68k/include/asm/thread_info_no.h
+++ b/arch/m68k/include/asm/thread_info_no.h
@@ -12,8 +12,6 @@

  #ifdef __KERNEL__

-#ifndef __ASSEMBLY__
-
  /*
   * Size of kernel stack for each process. This must be a power of 2...
   */
@@ -28,6 +26,8 @@
   */
  #define THREAD_SIZE (PAGE_SIZE<<THREAD_SIZE_ORDER)

+#ifndef __ASSEMBLY__
+
  /*
   * low level task data.
   */


But now the bss section doesn't looked properly aligned (at
least it is not on a page boundary any longer after the init.data):

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
   0 .text         00124ab8  40020000  40020000  00002000  2**4
                   CONTENTS, ALLOC, LOAD, READONLY, CODE
   1 .data         00011540  40144ac0  40144ac0  00126ac0  2**4
                   CONTENTS, ALLOC, LOAD, DATA
   2 .init.text    0000a96c  40156000  40156000  00138000  2**2
                   CONTENTS, ALLOC, LOAD, READONLY, CODE
   3 .init.data    00000b7c  4016096c  4016096c  0014296c  2**2
                   CONTENTS, ALLOC, LOAD, DATA
   4 .bss          0000a9e8  401614f0  401614f0  001434e8  2**4
                   ALLOC
   5 .comment      00001c8c  00000000  00000000  001434e8  2**0
                   CONTENTS, READONLY

Seems kind of odd because:

40156000 A __init_begin
40162000 A __init_end
401614f0 B _sbss

The resulting kernels don't boot.

Regards
Greg



> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> ---
>  arch/m68knommu/kernel/vmlinux.lds.S |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
> index 979acb5..c380040 100644
> --- a/arch/m68knommu/kernel/vmlinux.lds.S
> +++ b/arch/m68knommu/kernel/vmlinux.lds.S
> @@ -154,14 +154,12 @@ SECTIONS {
>  		_edata = . ;
>  	} > DATA
>  
> -	.init : {
> -		. = ALIGN(PAGE_SIZE);
> -		__init_begin = .;
> -		INIT_TEXT_SECTION(PAGE_SIZE)
> -		INIT_DATA_SECTION(16)
> -		. = ALIGN(PAGE_SIZE);
> -		__init_end = .;
> -	} > INIT
> +	. = ALIGN(PAGE_SIZE);
> +	__init_begin = .;
> +	INIT_TEXT_SECTION(PAGE_SIZE) > INIT
> +	INIT_DATA_SECTION(16) > INIT
> +	. = ALIGN(PAGE_SIZE);
> +	__init_end = .;
>  
>  	/DISCARD/ : {
>  		EXIT_TEXT

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
