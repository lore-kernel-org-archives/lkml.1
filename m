Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYICAyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYICAyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 20:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbYICAyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 20:54:13 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:11282 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbYICAyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 20:54:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tZiYjUIPw7FufZNdECxYfbkIIFPhBNUMsHebTOhnlkWYJL9erZDU80/SD7nZLQr53l
         JhksUXIdAVGcNDprAOH/OcsMptIREz4LJc85IBQ/F5ikpTNlEX34IyzVd4ACHMv7UxIB
         Mcp3rN20vfe31OHr9PtTxVsj3npTnAtumJjo0=
Message-ID: <86802c440809021754s7cd5ad5dy30a46ff65f9f2e5c@mail.gmail.com>
Date: Tue, 2 Sep 2008 17:54:10 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: gregkh@suse.de
Subject: Re: patch x86-work-around-mtrr-mask-setting.patch added to 2.6.26-stable tree
Cc: mingo@elte.hu, stable@kernel.org, stable-commits@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080903003208.7682214543E0@imap.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808221740.m7MHe5ud013727@hera.kernel.org>
	 <20080903003208.7682214543E0@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2008 at 5:26 PM,  <gregkh@suse.de> wrote:
>
> This is a note to let you know that we have just queued up the patch titled
>
>    Subject: x86: work around MTRR mask setting
>
> to the 2.6.26-stable tree.  Its filename is
>
>    x86-work-around-mtrr-mask-setting.patch
>
> A git repo of this tree can be found at
>    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
>
> From jejb@kernel.org  Tue Sep  2 17:14:12 2008
> From: Yinghai Lu <yhlu.kernel@gmail.com>
> Date: Fri, 22 Aug 2008 17:40:05 GMT
> Subject: x86: work around MTRR mask setting
> To: jejb@kernel.org, stable@kernel.org
> Message-ID: <200808221740.m7MHe5ud013727@hera.kernel.org>
>
> From: Yinghai Lu <yhlu.kernel@gmail.com>
>
> commit 38cc1c3df77c1bb739a4766788eb9fa49f16ffdf upstream
>
> Joshua Hoblitt reported that only 3 GB of his 16 GB of RAM is
> usable. Booting with mtrr_show showed us the BIOS-initialized
> MTRR settings - which are all wrong.
>
> So the root cause is that the BIOS has not set the mask correctly:
>
>>               [    0.429971]  MSR00000200: 00000000d0000000
>>               [    0.433305]  MSR00000201: 0000000ff0000800
>> should be ==> [    0.433305]  MSR00000201: 0000003ff0000800
>>
>>               [    0.436638]  MSR00000202: 00000000e0000000
>>               [    0.439971]  MSR00000203: 0000000fe0000800
>> should be ==> [    0.439971]  MSR00000203: 0000003fe0000800
>>
>>               [    0.443304]  MSR00000204: 0000000000000006
>>               [    0.446637]  MSR00000205: 0000000c00000800
>> should be ==> [    0.446637]  MSR00000205: 0000003c00000800
>>
>>               [    0.449970]  MSR00000206: 0000000400000006
>>               [    0.453303]  MSR00000207: 0000000fe0000800
>> should be ==> [    0.453303]  MSR00000207: 0000003fe0000800
>>
>>               [    0.456636]  MSR00000208: 0000000420000006
>>               [    0.459970]  MSR00000209: 0000000ff0000800
>> should be ==> [    0.459970]  MSR00000209: 0000003ff0000800
>
> So detect this borkage and add the prefix 111.
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  arch/x86/kernel/cpu/mtrr/generic.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> --- a/arch/x86/kernel/cpu/mtrr/generic.c
> +++ b/arch/x86/kernel/cpu/mtrr/generic.c
> @@ -365,6 +365,7 @@ static void generic_get_mtrr(unsigned in
>                             unsigned long *size, mtrr_type *type)
>  {
>        unsigned int mask_lo, mask_hi, base_lo, base_hi;
> +       unsigned int tmp, hi;
>
>        rdmsr(MTRRphysMask_MSR(reg), mask_lo, mask_hi);
>        if ((mask_lo & 0x800) == 0) {
> @@ -378,8 +379,18 @@ static void generic_get_mtrr(unsigned in
>        rdmsr(MTRRphysBase_MSR(reg), base_lo, base_hi);
>
>        /* Work out the shifted address mask. */
> -       mask_lo = size_or_mask | mask_hi << (32 - PAGE_SHIFT)
> -           | mask_lo >> PAGE_SHIFT;
> +       tmp = mask_hi << (32 - PAGE_SHIFT) | mask_lo >> PAGE_SHIFT;
> +       mask_lo = size_or_mask | tmp;
> +       /* Expand tmp with high bits to all 1s*/
> +       hi = fls(tmp);
> +       if (hi > 0) {
> +               tmp |= ~((1<<(hi - 1)) - 1);
> +
> +               if (tmp != mask_lo) {
> +                       WARN_ON("mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
> +                       mask_lo = tmp;
> +               }
> +       }
>
>        /* This works correctly if size is a power of two, i.e. a
>           contiguous range. */
>
>
> Patches currently in stable-queue which might be from yhlu.kernel@gmail.com are
>
> queue-2.6.26/x86-work-around-mtrr-mask-setting.patch


please put

commit 9754a5b840a209bc1f192d59f63e81b698a55ac8
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Aug 22 08:22:23 2008 +0200

    x86: work around MTRR mask setting, v2

    improve the debug printout:

    - make it actually display something
    - print it only once

    would be nice to have a WARN_ONCE() facility, to feed such things to
    kerneloops.org.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c
b/arch/x86/kernel/cpu/mtrr/generic.c
index 43102e0..cb7d3b6 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -401,7 +401,12 @@ static void generic_get_mtrr(unsigned int reg,
unsigned long *base,
                tmp |= ~((1<<(hi - 1)) - 1);

                if (tmp != mask_lo) {
-                       WARN_ON("mtrr: your BIOS has set up an
incorrect mask, fixing it up.\n");
+                       static int once = 1;
+
+                       if (once) {
+                               printk(KERN_INFO "mtrr: your BIOS has
set up an incorrect mask, fixing it up.\n");
+                               once = 0;
+                       }
                        mask_lo = tmp;
                }
        }

into stable too....
otherwise WARN_ON will keep dump calling stack..

YH
