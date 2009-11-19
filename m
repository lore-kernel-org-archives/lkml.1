Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbZKSGXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbZKSGXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 01:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbZKSGXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 01:23:44 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:39949 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZKSGXo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 01:23:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rWaggsKiabmLffRpNFoxzgxaewsEfEA7zgrYUlLU7FD9iFcZFMauPk8crEs8vK1oLt
         q7lxBF2LS5aarziFYG2NsgU7YCffKO37bUJWt7VFgG/R7Zcx3AQl+ifK9c0HPWZLGsD4
         zkz8EtS/ANZoAGYt1f1iEBSyouIGzIevbkbfw=
MIME-Version: 1.0
In-Reply-To: <20091118142109.ff2c5ef6.akpm@linux-foundation.org>
References: <4B024748.9080001@gmail.com>
	 <20091118142109.ff2c5ef6.akpm@linux-foundation.org>
Date: Thu, 19 Nov 2009 14:23:49 +0800
Message-ID: <e68bb3470911182223r28e9bac0lf185c1443168ff52@mail.gmail.com>
Subject: Re: [PATCH] ARM: Add spi controller driver support for NUC900
From: Wan ZongShun <mcuos.com@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-spi <spi-devel-general@lists.sourceforge.net>,
       David Brownell-sourceforge <dbrownell@users.sourceforge.net>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew,

Thanks a lot for your help, and I have a question below.

2009/11/19 Andrew Morton <akpm@linux-foundation.org>:
> On Tue, 17 Nov 2009 14:48:40 +0800
> Wan ZongShun <mcuos.com@gmail.com> wrote:
>
>> Dear David,
>>
>> Add winbond/nuvoton NUC900 spi controller driver support,
>> on my evaluation board,there is a winbond w25x16 spi flash,
>> so I test my spi controller driver with m25p80.c.
>>
>>
>> ...
>>
>> +static inline struct w90p910_spi *to_hw(struct spi_device *sdev)
>> +{
>> +     return spi_master_get_devdata(sdev->master);
>> +}
>> +
>> +static void w90p910_slave_seclect(struct spi_device *spi, unsigned int ssr)
>
> I think you meant "select" here?
>
>> +{
>> +     struct w90p910_spi *hw = to_hw(spi);
>> +     unsigned int val;
>> +     unsigned int cs = spi->mode & SPI_CS_HIGH ? 1 : 0;
>> +     unsigned int cpol = spi->mode & SPI_CPOL ? 1 : 0;
>> +
>> +     val = __raw_readl(hw->regs + USI_SSR);
>> +
>> +     if (!cs)
>> +             val &= ~SELECTLEV;
>> +     else
>> +             val |= SELECTLEV;
>> +
>> +     if (!ssr)
>> +             val &= ~SELECTSLAVE;
>> +     else
>> +             val |= SELECTSLAVE;
>> +
>> +     __raw_writel(val, hw->regs + USI_SSR);
>> +
>> +     val = __raw_readl(hw->regs + USI_CNT);
>> +
>> +     if (!cpol)
>> +             val &= ~SELECTPOL;
>> +     else
>> +             val |= SELECTPOL;
>> +
>> +     __raw_writel(val, hw->regs + USI_CNT);
>> +}
>
> That's a read-modify-write operation.  What locking prevents two
> threads of control from altering the USI_SSR and USI_CNT registers at
> the same time, resulting in an indeterminate setting?
>
>> +static void w90p910_spi_chipsel(struct spi_device *spi, int value)
>> +{
>> +     switch (value) {
>> +     case BITBANG_CS_INACTIVE:
>> +             w90p910_slave_seclect(spi, 0);
>> +             break;
>> +
>> +     case BITBANG_CS_ACTIVE:
>> +             w90p910_slave_seclect(spi, 1);
>> +             break;
>> +     }
>> +}
>> +
>> +static void w90p910_spi_setup_txnum(struct w90p910_spi *hw,
>> +                                                     unsigned int txnum)
>> +{
>> +     unsigned int val;
>> +
>> +     val = __raw_readl(hw->regs + USI_CNT);
>> +
>> +     if (!txnum)
>> +             val &= ~TXNUM;
>> +     else
>> +             val |= txnum << 0x08;
>> +
>> +     __raw_writel(val, hw->regs + USI_CNT);
>> +
>> +}
>> +
>> +static void w90p910_spi_setup_txbitlen(struct w90p910_spi *hw,
>> +                                                     unsigned int txbitlen)
>> +{
>> +     unsigned int val;
>> +
>> +     val = __raw_readl(hw->regs + USI_CNT);
>> +
>> +     val |= (txbitlen << 0x03);
>> +
>> +     __raw_writel(val, hw->regs + USI_CNT);
>> +}
>> +
>> +static void w90p910_spi_gobusy(struct w90p910_spi *hw)
>> +{
>> +     unsigned int val;
>> +
>> +     val = __raw_readl(hw->regs + USI_CNT);
>> +
>> +     val |= GOBUSY;
>> +
>> +     __raw_writel(val, hw->regs + USI_CNT);
>> +}
>
> ditto, ditto, ditto.
>
>> +static int w90p910_spi_setupxfer(struct spi_device *spi,
>> +                              struct spi_transfer *t)
>> +{
>> +     return 0;
>> +}
>> +
>> +static int w90p910_spi_setup(struct spi_device *spi)
>> +{
>> +     return 0;
>> +}
>> +
>> +static inline unsigned int hw_txbyte(struct w90p910_spi *hw, int count)
>> +{
>> +     return hw->tx ? hw->tx[count] : 0;
>> +}
>> +
>> +static int w90p910_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
>> +{
>> +     struct w90p910_spi *hw = to_hw(spi);
>> +
>> +     hw->tx = t->tx_buf;
>> +     hw->rx = t->rx_buf;
>> +     hw->len = t->len;
>> +     hw->count = 0;
>> +
>> +     init_completion(&hw->done);
>> +
>> +     __raw_writel(hw_txbyte(hw, 0x0), hw->regs + USI_TX0);
>> +
>> +     w90p910_spi_gobusy(hw);
>> +
>> +     wait_for_completion(&hw->done);
>> +
>> +     return hw->count;
>> +}
>
> The init_completion() should be unneeded?  The structure was
> initialised at setup time and will be left in a reusable state after a
> complete()/wait_for_completion().  Reinitialising the structure all the
> time like this adds risk that it will be scribbled on while in use.
>
>>
>> ...
>>
>> +static int __devexit w90p910_spi_remove(struct platform_device *dev)
>> +{
>> +     struct w90p910_spi *hw = platform_get_drvdata(dev);
>> +
>> +     platform_set_drvdata(dev, NULL);
>> +
>> +     spi_unregister_master(hw->master);
>> +
>> +     clk_disable(hw->clk);
>> +     clk_put(hw->clk);
>
> As far as I can tell, a hardware interrupt could still be pending, or
> be under service while the above code is executing?
>
> If so, I expect bad things will happen?

Do you mean that I should put this 'free_irq()' in the front of
w90p910_spi_remove？

such as:
"
free_irq(hw->irq, hw);

platform_set_drvdata(dev, NULL);

spi_unregister_master(hw->master);

clk_disable(hw->clk);
clk_put(hw->clk);
"

>> +     free_irq(hw->irq, hw);
>> +     iounmap(hw->regs);
>> +
>> +     release_resource(hw->ioarea);
>> +     kfree(hw->ioarea);
>> +
>> +     spi_master_put(hw->master);
>> +     return 0;
>> +}
>> +
>>
>> ...
>>
>
>



-- 
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
