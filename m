Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbXLDVFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbXLDVFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXLDVFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:05:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbXLDVFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:05:40 -0500
Date: Tue, 4 Dec 2007 13:04:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Sharp <andy.sharp@onstor.com>
Cc: linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com, anemo@mba.ocn.ne.jp,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] Platform real time clock driver for Dallas 1511 chip.
Message-Id: <20071204130458.75f5c90a.akpm@linux-foundation.org>
In-Reply-To: <20071204195958.GA14859@onstor.com>
References: <20071204195958.GA14859@onstor.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 12:00:05 -0800
Andrew Sharp <andy.sharp@onstor.com> wrote:

> 
> Add RTC support for DS1511 RTC/WDT chip.
> 
> ...
>
> +typedef enum ds1511reg {
> +	DS1511_SEC = 0x0,
> +	DS1511_MIN = 0x1,
> +	DS1511_HOUR = 0x2,
> +	DS1511_DOW = 0x3,
> +	DS1511_DOM = 0x4,
> +	DS1511_MONTH = 0x5,
> +	DS1511_YEAR = 0x6,
> +	DS1511_CENTURY = 0x7,
> +	DS1511_AM1_SEC = 0x8,
> +	DS1511_AM2_MIN = 0x9,
> +	DS1511_AM3_HOUR = 0xa,
> +	DS1511_AM4_DATE = 0xb,
> +	DS1511_WD_MSEC = 0xc,
> +	DS1511_WD_SEC = 0xd,
> +	DS1511_CONTROL_A = 0xe,
> +	DS1511_CONTROL_B = 0xf,
> +	DS1511_RAMADDR_LSB = 0x10,
> +	DS1511_RAMDATA = 0x13
> +} ds1511reg_t;

Please remove the typedef and just use `enum ds1511reg' everywhere.

> + static noinline void
> +rtc_write(uint8_t val, uint32_t reg)

It's unusual (unique) to indent the function declaration by a single space
in this way.  Maybe an editor option which needs fixing?

Also, although there are good reasons to always put a newline after the
declaration of the return type, kernel code generally doesn't do that
except as a way of avoiding 80-col wraparound sometimes.

IOW, please use

static noinline void rtc_write(uint8_t val, uint32_t reg)
{


Why was this function declared noinline?


> +{
> +	writeb(val, ds1511_base + (reg * reg_spacing));
> +}
> +
> + static inline void
> +rtc_write_alarm(uint8_t val, ds1511reg_t reg)
> +{
> +	rtc_write((val | 0x80), reg);
> +}
> +
> + static noinline uint8_t
> +rtc_read(ds1511reg_t reg)
> +{
> +	return readb(ds1511_base + (reg * reg_spacing));
> +}
> +
> + static inline void
> +rtc_disable_update(void)
> +{
> +	rtc_write((rtc_read(RTC_CMD) & ~RTC_TE), RTC_CMD);
> +}
> +
> + static noinline void
> +rtc_enable_update(void)
> +{
> +	rtc_write((rtc_read(RTC_CMD) | RTC_TE), RTC_CMD);
> +}
> +
> +//#define DS1511_WDOG_RESET_SUPPORT
> +//#undef DS1511_WDOG_RESET_SUPPORT

c99-style comments will generate checkpatch warnings.

Please run checkpatch.  It detects a lot of coding-style breakage in
this patch.

> +#ifdef DS1511_WDOG_RESET_SUPPORT
> +/*
> + * just enough code to set the watchdog timer so that it
> + * will reboot the system
> + */
> + void
> +ds1511_wdog_set(unsigned long deciseconds)
> +{
> +	/*
> +	 * the wdog timer can take 99.99 seconds
> +	 */
> +	deciseconds %= 10000;
> +	/*
> +	 * set the wdog values in the wdog registers
> +	 */
> +	rtc_write(BIN2BCD(deciseconds % 100), DS1511_WD_MSEC);
> +	rtc_write(BIN2BCD(deciseconds / 100), DS1511_WD_SEC);
> +	/*
> +	 * set wdog enable and wdog 'steering' bit to issue a reset
> +	 */
> +	rtc_write(DS1511_WDE | DS1511_WDS, RTC_CMD);
> +}
> +
> + void
> +ds1511_wdog_disable(void)
> +{
> +	/*
> +	 * clear wdog enable and wdog 'steering' bits
> +	 */
> +	rtc_write(rtc_read(RTC_CMD) & ~(DS1511_WDE | DS1511_WDS), RTC_CMD);
> +	/*
> +	 * clear the wdog counter
> +	 */
> +	rtc_write(0, DS1511_WD_MSEC);
> +	rtc_write(0, DS1511_WD_SEC);
> +}
> +#endif

What's the story here?  This code is permanently disabled?

> + int
> +ds1511_rtc_read_time(struct device *dev, struct rtc_time *rtc_tm)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
> +	unsigned int century;
> +	unsigned int flags;
> +
> +	/*
> +	 * give enough time to update RTC in case of continuous read
> +	 */
> +	if (pdata->last_jiffies == jiffies) {
> +		msleep(1);
> +	}

hm, that could be pretty obnoxious for some applications, I expect. 
They'll run veeeery sloooowly, and inconsistently slowly across different
values of CONFIG_HZ.  And the uninterruptible sleep will contribute to
system load average.

What's going on here?

Do other RTC drivers do things like this?

> +	pdata->last_jiffies = jiffies;
> +
> +	spin_lock_irqsave(&ds1511_lock, flags);
> +	rtc_disable_update();
> +
> +	rtc_tm->tm_sec = rtc_read(RTC_SEC) & 0x7f;
> +	rtc_tm->tm_min = rtc_read(RTC_MIN) & 0x7f;
> +	rtc_tm->tm_hour = rtc_read(RTC_HOUR) & 0x3f;
> +	rtc_tm->tm_mday = rtc_read(RTC_DOM) & 0x3f;
> +	rtc_tm->tm_wday = rtc_read(RTC_DOW) & 0x7;
> +	rtc_tm->tm_mon = rtc_read(RTC_MON) & 0x1f;
> +	rtc_tm->tm_year = rtc_read(RTC_YEAR) & 0x7f;
> +	century = rtc_read(RTC_CENTURY);
> +
> +	rtc_enable_update();
> +	spin_unlock_irqrestore(&ds1511_lock, flags);
> +
> +	rtc_tm->tm_sec = BCD2BIN(rtc_tm->tm_sec);
> +	rtc_tm->tm_min = BCD2BIN(rtc_tm->tm_min);
> +	rtc_tm->tm_hour = BCD2BIN(rtc_tm->tm_hour);
> +	rtc_tm->tm_mday = BCD2BIN(rtc_tm->tm_mday);
> +	rtc_tm->tm_wday = BCD2BIN(rtc_tm->tm_wday);
> +	rtc_tm->tm_mon = BCD2BIN(rtc_tm->tm_mon);
> +	rtc_tm->tm_year = BCD2BIN(rtc_tm->tm_year);
> +	century = BCD2BIN(century) * 100;
> +
> +	/*
> +	 * Account for differences between how the RTC uses the values
> +	 * and how they are defined in a struct rtc_time;
> +	 */
> +	century += rtc_tm->tm_year;
> +	rtc_tm->tm_year = century - 1900;
> +
> +	rtc_tm->tm_mon--;
> +
> +	if (rtc_valid_tm(rtc_tm) < 0) {
> +		dev_err(dev, "retrieved date/time is not valid.\n");
> +		rtc_time_to_tm(0, rtc_tm);
> +	}
> +	return 0;
> +}
> +
> +/*
> + * write the alarm register settings
> + *
> + * we only have the use to interrupt every second, otherwise
> + * known as the update interrupt, or the interrupt if the whole
> + * date/hours/mins/secs matches.  the ds1511 has many more
> + * permutations, but the kernel doesn't.
> + */
> + static void
> +ds1511_rtc_update_alarm(struct rtc_plat_data *pdata)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pdata->rtc->irq_lock, flags);
> +	rtc_write(pdata->alrm_mday < 0 || (pdata->irqen & RTC_UF) ?
> +	       0x80 : BIN2BCD(pdata->alrm_mday) & 0x3f,
> +	       RTC_ALARM_DATE);

hm.  You appear to be a C precedence whizz ;)

> +	rtc_write(pdata->alrm_hour < 0 || (pdata->irqen & RTC_UF) ?
> +	       0x80 : BIN2BCD(pdata->alrm_hour) & 0x3f,
> +	       RTC_ALARM_HOUR);
> +	rtc_write(pdata->alrm_min < 0 || (pdata->irqen & RTC_UF) ?
> +	       0x80 : BIN2BCD(pdata->alrm_min) & 0x7f,
> +	       RTC_ALARM_MIN);
> +	rtc_write(pdata->alrm_sec < 0 || (pdata->irqen & RTC_UF) ?
> +	       0x80 : BIN2BCD(pdata->alrm_sec) & 0x7f,
> +	       RTC_ALARM_SEC);
> +	rtc_write(rtc_read(RTC_CMD) | (pdata->irqen ? RTC_TIE : 0), RTC_CMD);
> +	rtc_read(RTC_CMD1);	/* clear interrupts */
> +	spin_unlock_irqrestore(&pdata->rtc->irq_lock, flags);
> +}
> +

