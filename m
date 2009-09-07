Return-Path: <linux-kernel-owner+w=401wt.eu-S1751461AbZIGHHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbZIGHHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 03:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZIGHHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 03:07:17 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:37084 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751284AbZIGHHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 03:07:16 -0400
Message-ID: <4AA4B104.7040507@snapgear.com>
Date: Mon, 07 Sep 2009 17:06:44 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH] m68knommu: Clean up linker script using new linker script
 macros.
References: <1252293044-13102-1-git-send-email-tabbott@ksplice.com> <4AA49946.2000804@snapgear.com> <alpine.DEB.1.10.0909070135040.17860@dr-wily.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0909070135040.17860@dr-wily.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Abbott wrote:
> On Mon, 7 Sep 2009, Greg Ungerer wrote:
> 
>> This fails for me with:
>>
>>   LD      vmlinux
>> /usr/local/bin/m68k-uclinux-ld:arch/m68knommu/kernel/vmlinux.lds:287: syntax
>> error
>>
>> due to PAGE_SIZE evaluating to:
>>
>>   . = ALIGN((1UL << (12)));
>>
>> The linker doesn't like the 'UL' suffix.
> 
> Yeah, sorry, I didn't have a cross-compiler for this one to test.  The fix 
> is to use _AC(1,UL), like most of the other architectures (including m68k 
> with an mmu) do.

Yep, that fixes that. I'll push this patch into the for-linus
branch of the m68knommu git tree.

Now, back to the original patch. Now fails with another syntax error
at the last line in this:

  .init : {
   . = ALIGN((1 << (12)));
   __init_begin = .;
   . = ALIGN((1 << (12))); .init.text : AT(ADDR(.init.text) - 0) { 
_sinittext = .; *(.init.text) *(.devinit.text) *(.cpuinit.text) 
*(.meminit.text) _einittext = .; }

Regards
Greg



> 	-Tim Abbott
> 
> m68knommu: Make PAGE_SIZE available to assembly files.
> 
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> ---
>  arch/m68k/include/asm/page_no.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
> index 9aa3f90..1f31b06 100644
> --- a/arch/m68k/include/asm/page_no.h
> +++ b/arch/m68k/include/asm/page_no.h
> @@ -1,10 +1,12 @@
>  #ifndef _M68KNOMMU_PAGE_H
>  #define _M68KNOMMU_PAGE_H
>  
> +#include <linux/const.h>
> +
>  /* PAGE_SHIFT determines the page size */
>  
>  #define PAGE_SHIFT	(12)
> -#define PAGE_SIZE	(1UL << PAGE_SHIFT)
> +#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
>  #define PAGE_MASK	(~(PAGE_SIZE-1))
>  
>  #include <asm/setup.h>

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
