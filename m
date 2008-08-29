Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbYH2BuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbYH2BuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 21:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbYH2Btw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 21:49:52 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:13747 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYH2Btv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 21:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=c6cBI2Pj4EChZ1DNVUVg1i5emy2eIH9Y2q8zuRvNqDhXGsL0EXZeH5sQASYcK3+/rg
         VRS6tZIAsXEgpZvmyW5ecobzzYYNXiYkvGfIPImxI15C4uKYtMI5+Gx8Zett2ML6GLc4
         eOjm0ebiMJ4LY+H/5IFGoNPKi3UbfVI1Kx0yE=
Message-ID: <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
Date: Thu, 28 Aug 2008 18:49:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?=" <zajec5@gmail.com>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Hugh Dickens" <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48B701FB.2020905@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
References: <48B701FB.2020905@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7T1oEdq012724

On Thu, Aug 28, 2008 at 12:52 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:> Some BIOSes have been observed to corrupt memory in the low 64k.  This> patch does two things:>  - Reserves all memory which does not have to be in that area, to>   prevent it from being used as general memory by the kernel.  Things>   like the SMP trampoline are still in the memory, however.>  - Clears the reserved memory so we can observe changes to it.>  - Adds a function check_for_bios_corruption() which checks and reports on>   memory becoming unexpectedly non-zero.  Currently it's called in the>   x86 fault handler, and the powermanagement debug output.>> RFC: What other places should we check for corruption in?>> [ Alan, Rafa³: could you check you see:>   1: corruption messages>   2: no crashes>  Thanks -J> ]>> Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>> Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>> Cc: Hugh Dickens <hugh@veritas.com>> Cc: Ingo Molnar <mingo@elte.hu>> Cc: Rafael J. Wysocki <rjw@sisk.pl>> Cc: Rafa³ Mi³ecki <zajec5@gmail.com>> Cc: H. Peter Anvin <hpa@zytor.com>> --->  Documentation/kernel-parameters.txt |    5 ++>  arch/x86/Kconfig                    |    3 +>  arch/x86/kernel/setup.c             |   86 +++++++++++++++++++++++++++++++++++>  arch/x86/mm/fault.c                 |    2>  drivers/base/power/main.c           |    1>  include/linux/kernel.h              |   12 ++++>  6 files changed, 109 insertions(+)>> ===================================================================> --- a/Documentation/kernel-parameters.txt> +++ b/Documentation/kernel-parameters.txt> @@ -359,6 +359,11 @@>                        BayCom Serial Port AX.25 Modem (Half Duplex Mode)>                        Format: <io>,<irq>,<mode>>                        See header of drivers/net/hamradio/baycom_ser_hdx.c.> +> +       bios_corruption_check=0/1 [X86]> +                       Some BIOSes seem to corrupt the first 64k of memory> +                       when doing things like suspend/resume.  Setting this> +                       option will scan the memory looking for corruption.>>        boot_delay=     Milliseconds to delay each printk during boot.>                        Values larger than 10 seconds (10000) are changed to> ===================================================================> --- a/arch/x86/Kconfig> +++ b/arch/x86/Kconfig> @@ -203,6 +203,9 @@>        bool>        depends on X86_SMP || (X86_VOYAGER && SMP) || (64BIT && ACPI_SLEEP)>        default y> +> +config X86_CHECK_BIOS_CORRUPTION> +        def_bool y>>  config KTIME_SCALAR>        def_bool X86_32> ===================================================================> --- a/arch/x86/kernel/setup.c> +++ b/arch/x86/kernel/setup.c> @@ -582,6 +582,88 @@>  struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;>>  /*> + * Some BIOSes seem to corrupt the low 64k of memory during events> + * like suspend/resume and unplugging an HDMI cable.  Reserve all> + * remaining free memory in that area and fill it with a distinct> + * pattern.> + */> +#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION> +#define MAX_SCAN_AREAS 8> +static struct e820entry scan_areas[MAX_SCAN_AREAS];> +static int num_scan_areas;> +> +static void __init setup_bios_corruption_check(void)> +{> +       u64 addr = PAGE_SIZE;   /* assume first page is reserved anyway */> +
can you please not punish systems without this bios problem?
if (!bios_corruption_check)   return;
> +       while(addr < 0x10000 && num_scan_areas < MAX_SCAN_AREAS) {> +               u64 size;> +               addr = find_e820_area_size(addr, &size, PAGE_SIZE);> +> +               if (addr == 0)> +                       break;> +> +               if ((addr + size) > 0x10000)> +                       size = 0x10000 - addr;> +> +               if (size == 0)> +                       break;> +> +               e820_update_range(addr, size, E820_RAM, E820_RESERVED);> +               scan_areas[num_scan_areas].addr = addr;> +               scan_areas[num_scan_areas].size = size;> +               num_scan_areas++;> +> +               /* Assume we've already mapped this early memory */> +               memset(__va(addr), 0, size);> +> +               addr += size;> +       }> +> +       printk(KERN_INFO "scanning %d areas for BIOS corruption\n",> +              num_scan_areas);> +       update_e820();> +}> +> +static int __read_mostly bios_corruption_check = 1;
move earlier andbios_corruption_check = 0;
BTW: SMI evil damaged that area?
YHÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
