Return-Path: <linux-kernel-owner+w=401wt.eu-S933531AbZHECz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531AbZHECz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 22:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933310AbZHECz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 22:55:57 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52103 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225AbZHECz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 22:55:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hBi6jb8DZulI81DjiBHqBIXth0dEmDW3jqgi+AUDzKe5q6rKGST0ckzhmvlqbc66Cd
         3KgPk8V4qDC7iNrKaOVJANKgo++e5hbsNPaL5FpVo5s6CdcmrqOCd/JdlHfUdMb2Cyvi
         tTq6vs1ZnXNWpiM/MmLtuNg9Rou5gsPbUR2s8=
MIME-Version: 1.0
In-Reply-To: <20090804201032.GB30892@infomag.iguana.be>
References: <4A69CE00.10401@gmail.com>
	 <20090804201032.GB30892@infomag.iguana.be>
Date: Wed, 5 Aug 2009 10:55:55 +0800
Message-ID: <e68bb3470908041955t7e07929bv612a25e0bc0264c1@mail.gmail.com>
Subject: Re: [PATCH] Add watchdog driver for w90p910
From: Wan ZongShun <mcuos.com@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Wim,

 I'm much obliged to you for helping me.
Before resubmitting fixed patch, I think it better to answer you
regarding your questions.

2009/8/5 Wim Van Sebroeck <wim@iguana.be>:
> Hi Wan,
>
> I reviewed your code and have some comments and questions.
>
> ...
>
>> +struct w90p910_wdt {
>> +     struct resource  *res;
>> +     struct clk       *wdt_clock;
>> +     struct platform_device *pdev;
>> +     unsigned int     open_lock;
>> +     unsigned int     wdt_irq;
>> +     void __iomem     *wdt_base;
>> +     char             expect_close;
>> +     spinlock_t       wdt_lock;
>> +};
>
> Where is the spinlock initialized?

Sure, I forget it. sorry.
>
>> +static irqreturn_t w90p910_wdt_irq(int irq, void *dev_id)
>> +{
>> +     w90p910_wdt_keepalive();
>> +     return IRQ_HANDLED;
>> +}
>
> How does the interrupt work? what does the watchdog do when it times out?
> (Is there a datasheet available somewhere?)
>

The mechanism of watchdog of w90p910 is that the interrupt will occur
periodicity every a given time interval.

Hmm, there are only two choices to confirm the system running, one to
clear this WTIF and  WTR bits in handler of interrupt, the other to
reset them in user application before interrupt occurs.


>> +static int w90p910_wdt_settimeout(int new_time_level)
>> +{
>> +     unsigned int val;
>> +
>> +     if ((new_time_level < 0) || (new_time_level > WDT_MAX_TIME_LEVEL))
>> +             return -EINVAL;
>> +
>> +     val = __raw_readl(w90p910_wdt->wdt_base + REG_WTCR);
>> +     val &= ~WTIS;
>> +     val |= new_time_level;
>
> Shouldn't this be val |= (new_time_level << 0x04); ?

sure.

> The read-write cyclus to REG_WTCR should also be guarded with a spinlock.
> Can you incorporate the call to w90p910_wdt_start() in the ioctl code into this function?
>

Do you mean that I should merge the "w90p910_wdt_settimeout" to
"w90p910_wdt_start()"? or contrary?

>
>> +static ssize_t w90p910_wdt_write(struct file *file, const char *data,
>> +                                             size_t len, loff_t *ppos)
>
> should be: ..., const char __user *data, ...
>
sure.
>
>> +static int __devinit w90p910wdt_probe(struct platform_device *pdev)
>> +{
>> +     int ret;
>> +
>> +     w90p910_wdt = kzalloc(sizeof(struct w90p910_wdt), GFP_KERNEL);
>> +     if (!w90p910_wdt)
>> +             return -ENOMEM;
>> +
>> +     w90p910_wdt->pdev = pdev;
>> +
>> +     w90p910_wdt->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     if (w90p910_wdt->res == NULL) {
>> +             dev_err(&pdev->dev, "no memory resource specified\n");
>> +             ret = -ENOENT;
>> +             goto err_get;
>> +     }
>> +
>> +     if (!request_mem_region(w90p910_wdt->res->start,
>> +                             resource_size(w90p910_wdt->res), pdev->name)) {
>> +             dev_err(&pdev->dev, "failed to get memory region\n");
>> +             ret = -ENOENT;
>> +             goto err_req;
>
> This should be: goto err_get;

sure.
> ...
>
>> +
>> +static int __devexit w90p910wdt_remove(struct platform_device *pdev)
>> +{
>
> The misc_deregister(&w90p910wdt_miscdev); should go first. We don't want userspace interactivity when we clean up all reservations.
>
>> +     free_irq(w90p910_wdt->wdt_irq, NULL);
>> +
>> +     clk_disable(w90p910_wdt->wdt_clock);
>> +     clk_put(w90p910_wdt->wdt_clock);
>> +
>> +     iounmap(w90p910_wdt->wdt_base);
>> +
>> +     release_mem_region(w90p910_wdt->res->start,
>> +                                     resource_size(w90p910_wdt->res));
>> +
>> +     kfree(w90p910_wdt);
>> +
>> +     misc_deregister(&w90p910wdt_miscdev);
>
> see comment about misc_deregister above.
>
> For the rest the code looks good to me.
>
> Kind regards,
> Wim.
>
>



-- 
Wan z.s
