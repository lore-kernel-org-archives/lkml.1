Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbZFCGqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbZFCGqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZFCGqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:46:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35143 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZFCGqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:46:11 -0400
From: "Singh, Vimal" 
	<IMCEAEX-_O=TI_OU=BD_CN=RECIPIENTS_CN=X0094262@dlee86.itg.ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "dedekind@infradead.org" <dedekind@infradead.org>,
       "david-b@pacbell.net" <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 3 Jun 2009 12:15:52 +0530
Subject: RE: [PATCH] [MTD] [NAND] Add prefetch and dma support for omap2/3
	NAND driver
Thread-Topic: [PATCH] [MTD] [NAND] Add prefetch and dma support for omap2/3
	NAND driver
Thread-Index: Acnjwd1OUchDHds/Sy6KeWueBqjENgAUuoKq
Message-ID: <19F8576C6E063C45BE387C64729E739404321C6096@dbde02.ent.ti.com>
References: <54851.192.168.10.89.1243946276.squirrel@dbdmail.itg.ti.com>,<20090602203629.GM27332@atomide.com>
In-Reply-To: <20090602203629.GM27332@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Jun 3, 2009 at 2:06 AM, Tony Lindgren <tony@atomide.com> wrote:
> * vimal singh <vimalsingh@ti.com> [090602 05:40]:
>> This patch adds prefetch support to access nand flash in both mpu and dma mode.
>> This patch also adds 8-bit nand support (omap_read/write_buf8).
>> Prefetch can be used for both 8- and 16-bit devices.
>
> This should be reviewed on the linux-omap@vger.kernel.org list for sure.
> One other comment below.
>
>> Signed-off-by: Vimal Singh <vimalsingh@ti.com>
>> ---
>> I prepared this patch on top of "OMAP2 / OMAP3 NAND driver" patch:
>> http://lists.infradead.org/pipermail/linux-mtd/2009-May/025562.html
>>
>> ---
>>  arch/arm/mach-omap2/gpmc.c             |  102 ++++++++++
>>  arch/arm/plat-omap/include/mach/gpmc.h |    4
>>  drivers/mtd/nand/Kconfig               |   17 +
>>  drivers/mtd/nand/omap2.c               |  308 ++++++++++++++++++++++++++++++++-
>>  4 files changed, 422 insertions(+), 9 deletions(-)
>>
>> Index: mtd-2.6/arch/arm/mach-omap2/gpmc.c
>> ===================================================================
>> --- mtd-2.6.orig/arch/arm/mach-omap2/gpmc.c
>> +++ mtd-2.6/arch/arm/mach-omap2/gpmc.c
>> @@ -54,6 +54,12 @@
>>  #define GPMC_CHUNK_SHIFT     24              /* 16 MB */
>>  #define GPMC_SECTION_SHIFT   28              /* 128 MB */
>>
>> +#ifdef CONFIG_MTD_NAND_OMAP_PREFETCH
>> +#define CS_NUM_SHIFT         24
>> +#define ENABLE_PREFETCH              7
>> +#define DMA_MPU_MODE         2
>> +#endif
>> +
>>  static struct resource       gpmc_mem_root;
>>  static struct resource       gpmc_cs_mem[GPMC_CS_NUM];
>>  static DEFINE_SPINLOCK(gpmc_mem_lock);
>> @@ -383,6 +389,99 @@ void gpmc_cs_free(int cs)
>>  }
>>  EXPORT_SYMBOL(gpmc_cs_free);
>>
>> +#ifdef CONFIG_MTD_NAND_OMAP_PREFETCH
>> +/**
>> + * gpmc_prefetch_init - configures default configuration for prefetch engine
>> + */
>> +static void gpmc_prefetch_init(void)
>> +{
>> +     /* Setting the default threshold to 64 */
>> +     gpmc_write_reg(GPMC_PREFETCH_CONTROL, 0x0);
>> +     gpmc_write_reg(GPMC_PREFETCH_CONFIG1, 0x40  << 8);
>> +     gpmc_write_reg(GPMC_PREFETCH_CONFIG2, 0x0);
>> +}
>
> Why would you want to have NAND specific init code int gpmc.c?
>
> The purpose if gpmc.c is to provide access to configuring the
> General Purpose Memory Controller (GPMC). You should just provide
> functions in gpmc.c for the platform init code to use, and then
> the drivers can stay platform independent.

In my understanding, this 'prefetch' engine is part of GPMC itself, it is a
kind of feature provided by GPMC which can be utilized by NAND driver.
So, to me, it makes sens to get initialized prefetch by GPMC itself so that 
NAND driver can use it.

Another reason was that all read / write to GPMC register are done by 
functions 'gpmc_read_reg' / 'gpmc_write_reg', which have been made
'static' in nature.

Regards,
vimal