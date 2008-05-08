Return-Path: <linux-kernel-owner+w=401wt.eu-S933151AbYEHTbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbYEHTbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbYEHTbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:31:11 -0400
Received: from homer.mvista.com ([63.81.120.155]:34886 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755766AbYEHTbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:31:00 -0400
Message-ID: <482354D0.9040304@ru.mvista.com>
Date: Thu, 08 May 2008 23:30:24 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] Alchemy: db1200/pb1200: register mmc platform	device
 and board specific functions
References: <20080507160154.GA17806@roarinelk.homelinux.net> <20080507160634.GE17806@roarinelk.homelinux.net> <4822F4FC.5040107@ru.mvista.com> <20080508130833.GA25971@roarinelk.homelinux.net>
In-Reply-To: <20080508130833.GA25971@roarinelk.homelinux.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Lauss wrote:

>>>diff --git a/arch/mips/au1000/common/platform.c 
>>>b/arch/mips/au1000/common/platform.c
>>>index 31d2a22..08a5900 100644
>>>--- a/arch/mips/au1000/common/platform.c
>>>+++ b/arch/mips/au1000/common/platform.c
>>>-
>>>-static struct platform_device au1xxx_mmc_device = {
>>>-	.name = "au1xxx-mmc",
>>>-	.id = 0,
>>>-	.dev = {
>>>-		.dma_mask               = &au1xxx_mmc_dmamask,
>>>-		.coherent_dma_mask      = 0xffffffff,
>>>-	},
>>>-	.num_resources  = ARRAY_SIZE(au1xxx_mmc_resources),
>>>-	.resource       = au1xxx_mmc_resources,
>>>-};
>>> #endif /* #ifdef CONFIG_SOC_AU1200 */
>>
>>   What board-specific was here?

> Nothing in here per se, but a) I don't like this file, it registers
> stuff some boards don't need/want,  b) this part is only interesting
> for pb1200 board anyway.

    Sigh. Do you know that Au1100 also has the same MMC controllers? The 
platform device is not registered in this case though and the driver (however 
small it now actually uses the platform device per se) is therefore unable to 
control it (well, I'm not sure it can do that since it seems to be Au1200 
centered now (using DBDMA), however it was initially written for Au1100 as it 
seems.

> I moved it to the pb1200 platform.c because
> of the function pointers for au1xmmc platdata.

    I'm sure that can be handled without moving the device itself...

>>>diff --git a/arch/mips/au1000/pb1200/platform.c 
>>>b/arch/mips/au1000/pb1200/platform.c
>>>index 5930110..bee2bf7 100644
>>>--- a/arch/mips/au1000/pb1200/platform.c
>>>+++ b/arch/mips/au1000/pb1200/platform.c
>>>@@ -20,8 +20,17 @@
>>>  #include <linux/init.h>
>>> #include <linux/platform_device.h>
>>>+#include <linux/mmc/host.h>
>>>  #include <asm/mach-au1x00/au1xxx.h>
>>>+#include <asm/mach-au1x00/au1xxx_dbdma.h>
>>>+#include <asm/mach-au1x00/au1100_mmc.h>
>>>+
>>>+#if defined(CONFIG_MIPS_PB1200)
>>>+#include <asm/mach-pb1x00/pb1200.h>
>>>+#elif defined(CONFIG_MIPS_DB1200)
>>>+#include <asm/mach-db1x00/db1200.h>
>>>+#endif

>>#include <asm/mach-au1x00/au1xxx.h> does all that already -- you don't need 
>>to include the board specific headers one more time.  Drop this part please.

> Done.  I originally put it in because of compile errors wrt. BCSR register.

    Hm, why would there be any if au1xxx.h resolves the right board #include?

>>>+	return (bcsr->sig_status & au1xmmc_card_table[host->id].bcsrstatus)
>>>+		? 1 : 0;
>>>+}
>>>+
>>>+static struct au1xmmc_platdata db1xmmcpd = {
>>>+	.set_power	= pb1200mmc_set_power,
>>>+	.card_inserted	= pb1200mmc_card_inserted,
>>>+	.card_readonly	= pb1200mmc_card_readonly,
>>>+	.cd_setup	= NULL,		/* use poll-timer in driver */

>>   Function ptrs in the platform data?  That's something new -- though why 
>> not? :-)

> Is this an accepted way of doing things in the kernel?  If not, I'm open to
> suggestions!

    I really don't know -- never seen such trick before.

> (I prefer this to globally-visible methods called by the
> driver.  I like it when related things are neatly grouped together).

    Yes, this indeed looks better.

>>>+};
>>>+
>>>+static u64 au1xxx_mmc_dmamask =  ~(u32)0;
>>>+
>>>+struct resource au1200sd0_res[] = {
>>>+	[0] = {
>>>+		.start	= CPHYSADDR(SD0_BASE),

>>   Why not just use SD0_PHYS_ADDR?

>>>+		.end	= CPHYSADDR(SD0_BASE) + 0x40,

>>   You've missed "- 1" here. Though it's alos not clear why 0x40 and not 
>>0x3c (there's not register at 0x3c) or 0x80000 -- the range used according 
>>to the memory map...

> I'll add the whole 0x80000 range ;-)

    I've just posted a patch to fix this in the current code. Well, not that 
it matters much but I'm kind of pedantic. :-)

>>>+	[3] = {
>>>+		.start	= DSCR_CMD0_SDMS_TX0,
>>>+		.flags	= IORESOURCE_DMA,
>>>+	},
>>>+	[4] = {
>>>+		.start	= DSCR_CMD0_SDMS_RX0,
>>>+		.flags	= IORESOURCE_DMA,
>>>+	},
>>>+};

>>   Humm. The other devices (like IDE) should also claim DMA resources...

> It was a convenient way to pass DDMA IDs without having to use 
> a lookup table in the driver ;-)

    Humm, the DBDMA code seems to mean by "DMA channel" something different, 
see au1xxx_dbdma_chan_alloc()...

>>>+static struct platform_device au1200_sd0_device = {
>>>+	.name = "au1xxx-mmc",
>>>+	.id = 0,	/* index into au1xmmc_card_table[] */
>>>+	.dev = {
>>>+		.dma_mask               = &au1xxx_mmc_dmamask,
>>>+		.coherent_dma_mask      = 0xffffffff,
>>>+		.platform_data		= &db1xmmcpd,

>>   Can't we leave the MMC platform device where it is but define the 
>>platform data structure per board with some starndard name? Since IMO it 
>>doesn't make sense to move the platform device itself.

> I like my device setup data in one file (preferably living in the board
> subdir), but for mainline inclusion I can move it back to its original
> place if you and others prefer so.

    I'd definitely prefer to leave the SOC device where they were...

>>>+	},
>>>+	.num_resources  = ARRAY_SIZE(au1200sd0_res),
>>>+	.resource       = au1200sd0_res,
>>>+};
>>>+
>>>+#ifndef CONFIG_MIPS_DB1200

>>   Wait, SD controller 1 is there regardless of the board, so should be 
>>registerred regardless. If however the board doesn't have the necessary 
>>resources to support the driver functionality, I think it can be indicated 
>>by the board-level platform data, so that the driver could decide whether 
>>it wants to support that controller or not.

> Won't this cause problems if e.g. you are using PCMCIA (since SD1 pins are
> muxed with pcmcia signals)? 

    Good point.  I think that the code in arch/mips/au1000/common/platform.c 
should check the sys_pinfunc register, and not blindly register all devices.

> In any case, I just followed the original code, which also disabled the 2nd
> controller for the db1200.

    Indeed...

WBR, Sergei
