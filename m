Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZFEQZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZFEQZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZFEQZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:25:35 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41793 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZFEQZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XgYPebpOxXd6vfYMCHidlX7GWltpOZk+SDlU1D813zRQr87SgqbT5yxl8MdexjOauH
         N/+Xz7uzPRfyx4ntv5SIwlbL489BfC+cCOXB1K8EVqFkABrIVK75cqxqAU6A5KXXp9/U
         GNFp3bClEsxs3MTgIeq4lfSxx2b7PHreF0y6M=
MIME-Version: 1.0
In-Reply-To: <20090604234625.GB5460@sortiz.org>
References: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com>
	 <1244140576-18006-2-git-send-email-philipp.zabel@gmail.com>
	 <20090604234625.GB5460@sortiz.org>
Date: Fri, 5 Jun 2009 18:25:34 +0200
Message-ID: <74d0deb30906050925va48d17bq9edd4953846ee17d@mail.gmail.com>
Subject: Re: [PATCH 1/7] MFD: ASIC3: add API for EXTCF and SDHWCTRL register 
	manipulation
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Fri, Jun 5, 2009 at 1:46 AM, Samuel Ortiz<sameo@openedhand.com> wrote:
> Hi Philipp
>
> On Thu, Jun 04, 2009 at 08:36:10PM +0200, Philipp Zabel wrote:
>> Those registers are needed for PCMCIA and MMC/SDIO operation as
>> well as for the DS1WM.
>>
>> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
>> ---
>>  drivers/mfd/asic3.c       |   48 +++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/mfd/asic3.h |   13 +++++++----
>>  2 files changed, 56 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
>> index 9e48545..8e1653a 100644
>> --- a/drivers/mfd/asic3.c
>> +++ b/drivers/mfd/asic3.c
>> @@ -52,6 +52,54 @@ static inline u32 asic3_read_register(struct asic3 *asic,
>>                       (reg >> asic->bus_shift));
>>  }
>>
>> +void asic3_set_extcf_select(struct device *dev, u32 bits, int value)
> 2 remarks here:
> - The "value" parameter could be a bool, and could use a better name, e.g.
> "set".
> - Those 3 routines are basically doing the same thing. Why not having a
> generic:
> void asic3_set_register(struct device *dev, u32 reg, u32 bits, bool set) ?

Thanks. The reasoning behind this split (besides the fact that the
hh.org driver did it this way) was that only asic3_set_extcf_select
has to be exported for the pcmcia driver and I'd like to move the
register addresses from the public header into asic3.c or into a
private header some time.

I think it is better to have one (unexported) function as you suggest
and then export a custom function to handle the EXTCF
SLEEP_MODE/BUF_EN/PWAIT_EN bits in the future.

Will combine and resend.

> Cheers,
> Samuel.
>
>> +{
>> +     struct asic3 *asic = dev->driver_data;
>> +     unsigned long flags;
>> +     u32 v;
>> +
>> +     spin_lock_irqsave(&asic->lock, flags);
>> +     v = asic3_read_register(asic, ASIC3_OFFSET(EXTCF, SELECT));
>> +     if (value)
>> +             v |= bits;
>> +     else
>> +             v &= ~bits;
>> +     asic3_write_register(asic, ASIC3_OFFSET(EXTCF, SELECT), v);
>> +     spin_unlock_irqrestore(&asic->lock, flags);
>> +}
>> +EXPORT_SYMBOL(asic3_set_extcf_select);
>> +
>> +void asic3_set_extcf_reset(struct device *dev, u32 bits, int value)
>> +{
>> +     struct asic3 *asic = dev->driver_data;
>> +     unsigned long flags;
>> +     u32 v;
>> +
>> +     spin_lock_irqsave(&asic->lock, flags);
>> +     v = asic3_read_register(asic, ASIC3_OFFSET(EXTCF, RESET));
>> +     if (value)
>> +             v |= bits;
>> +     else
>> +             v &= ~bits;
>> +     asic3_write_register(asic, ASIC3_OFFSET(EXTCF, RESET), v);
>> +     spin_unlock_irqrestore(&asic->lock, flags);
>> +}
>> +
>> +void asic3_set_sdhwctrl(struct asic3 *asic, u32 bits, int value)
>> +{
>> +     unsigned long flags;
>> +     u32 v;
>> +
>> +     spin_lock_irqsave(&asic->lock, flags);
>> +     v = asic3_read_register(asic, ASIC3_OFFSET(SDHWCTRL, SDCONF));
>> +     if (value)
>> +             v |= bits;
>> +     else
>> +             v &= ~bits;
>> +     asic3_write_register(asic, ASIC3_OFFSET(SDHWCTRL, SDCONF), v);
>> +     spin_unlock_irqrestore(&asic->lock, flags);
>> +}
>> +
>>  /* IRQs */
>>  #define MAX_ASIC_ISR_LOOPS    20
>>  #define ASIC3_GPIO_BASE_INCR \
>> diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
>> index 322cd6d..cd02d20 100644
>> --- a/include/linux/mfd/asic3.h
>> +++ b/include/linux/mfd/asic3.h
>> @@ -16,6 +16,9 @@
>>
>>  #include <linux/types.h>
>>
>> +/* for PCMCIA */
>> +extern void asic3_set_extcf_select(struct device *dev, u32 bits, int value);
>> +
>>  struct asic3_platform_data {
>>       u16 *gpio_config;
>>       unsigned int gpio_config_num;
>> @@ -227,8 +230,8 @@ struct asic3_platform_data {
>>
>>
>>  /* Basic control of the SD ASIC */
>> -#define ASIC3_SDHWCTRL_Base  0x0E00
>> -#define ASIC3_SDHWCTRL_SDConf    0x00
>> +#define ASIC3_SDHWCTRL_BASE     0x0E00
>> +#define ASIC3_SDHWCTRL_SDCONF     0x00
>>
>>  #define ASIC3_SDHWCTRL_SUSPEND    (1 << 0)  /* 1=suspend all SD operations */
>>  #define ASIC3_SDHWCTRL_CLKSEL     (1 << 1)  /* 1=SDICK, 0=HCLK */
>> @@ -242,10 +245,10 @@ struct asic3_platform_data {
>>  /* SD card power supply ctrl 1=enable */
>>  #define ASIC3_SDHWCTRL_SDPWR      (1 << 6)
>>
>> -#define ASIC3_EXTCF_Base             0x1100
>> +#define ASIC3_EXTCF_BASE        0x1100
>>
>> -#define ASIC3_EXTCF_Select         0x00
>> -#define ASIC3_EXTCF_Reset          0x04
>> +#define ASIC3_EXTCF_SELECT        0x00
>> +#define ASIC3_EXTCF_RESET         0x04
>>
>>  #define ASIC3_EXTCF_SMOD0             (1 << 0)  /* slot number of mode 0 */
>>  #define ASIC3_EXTCF_SMOD1             (1 << 1)  /* slot number of mode 1 */
>> --
>> 1.6.3.1
>>
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
>
