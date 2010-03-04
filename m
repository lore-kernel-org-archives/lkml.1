Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab0CDTUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:20:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:46767 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134Ab0CDTUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:20:39 -0500
Message-ID: <4B90079C.7080404@kernel.org>
Date: Thu, 04 Mar 2010 11:18:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take
 desc
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org> <1267697339-5491-7-git-send-email-yinghai@kernel.org> <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 06:31 AM, Thomas Gleixner wrote:
> On Thu, 4 Mar 2010, Yinghai Lu wrote:
> 
>>  /*
>>   * Fixup enable/disable function pointers
>>   */
>>  void irq_chip_set_defaults(struct irq_chip *chip)
>>  {
>> +	if (!chip->desc_enable)
>> +		chip->desc_enable = default_enable_desc;
>> +	if (!chip->desc_disable)
>> +		chip->desc_disable = default_disable_desc;
>> +	if (!chip->desc_startup)
>> +		chip->desc_startup = default_startup_desc;
> 
>   This will break all irq_chips which implement enable, disable or
>   startup. so the check needs to be:
> 
>   	   if (!chip->enable && !chip->desc_enable) 
> 
>> +	/*
>> +	 * We use chip->disable, when the user provided its own. When
>> +	 * we have default_disable set for chip->disable, then we need
>> +	 * to use default_shutdown, otherwise the irq line is not
>> +	 * disabled on free_irq():
>> +	 */
>> +	if (!chip->desc_shutdown)
>> +		chip->desc_shutdown = chip->desc_disable != default_disable_desc ?
>> +			chip->desc_disable : default_shutdown_desc;
>> +	if (!chip->desc_end)
>> +		chip->desc_end = dummy_irq_chip.desc_end;
> 
>   Same  here.

should be:

/*
 * Fixup enable/disable function pointers
 */
static void irq_chip_set_defaults_desc(struct irq_chip *chip)
{
        if (!chip->desc_enable && !chip->enable)
                chip->desc_enable = default_enable_desc;
        if (!chip->desc_disable)
                chip->desc_disable = default_disable_desc;
        if (!chip->desc_startup)
                chip->desc_startup = default_startup_desc;
        /*
         * We use chip->disable, when the user provided its own. When
         * we have default_disable set for chip->disable, then we need
         * to use default_shutdown, otherwise the irq line is not
         * disabled on free_irq():
         */
        if (!chip->desc_shutdown)
                chip->desc_shutdown = chip->desc_disable != default_disable_desc ?
                        chip->desc_disable : default_shutdown_desc;
        if (!chip->desc_end)
                chip->desc_end = dummy_irq_chip.desc_end;
}
static void irq_chip_set_defaults_irq(struct irq_chip *chip)
{
        if (!chip->enable)
                chip->enable = default_enable;
        if (!chip->disable)
                chip->disable = default_disable;
        if (!chip->startup)
                chip->startup = default_startup;
        /*
         * We use chip->disable, when the user provided its own. When
         * we have default_disable set for chip->disable, then we need
         * to use default_shutdown, otherwise the irq line is not
         * disabled on free_irq():
         */
        if (!chip->shutdown)
                chip->shutdown = chip->disable != default_disable ?
                        chip->disable : default_shutdown;
        if (!chip->end)
                chip->end = dummy_irq_chip.end;
}
void irq_chip_set_defaults(struct irq_chip *chip)
{
        if (chip->desc_mask && chip->desc_unmask)
                irq_chip_set_defaults_desc(chip);
        else
                irq_chip_set_defaults_irq(chip);

        if (!chip->name)
                chip->name = chip->typename;
}
