Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZKZGhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZKZGhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 01:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbZKZGhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 01:37:23 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:59603 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbZKZGhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 01:37:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EM80M7xRK/lugu0AGMHevgPqHIWp8a9LCmL/sLKnuV5u8wRzy7cveTGDOCkkaZlCWc
         YNzjJaKDTw339MbLfcg7+yiGyB33CVACPGIGvKujzL2mjv+Y/5/+HH2BB+SaVtyUII3o
         JI7QYbivOEJU8vs38ESIENMeV0X7TD1/rZBos=
MIME-Version: 1.0
In-Reply-To: <20091125121152.4ccf03dc.akpm@linux-foundation.org>
References: <20091124125531.14957.41264.sendpatchset@rxone.opensource.se>
	 <20091125121152.4ccf03dc.akpm@linux-foundation.org>
Date: Thu, 26 Nov 2009 15:37:28 +0900
Message-ID: <aec7e5c30911252237g73f6af6fg1de6fb802365704c@mail.gmail.com>
Subject: Re: [PATCH] spi: SuperH MSIOF SPI Master driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thu, Nov 26, 2009 at 5:11 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 24 Nov 2009 21:55:31 +0900
> Magnus Damm <magnus.damm@gmail.com> wrote:
>> This patch adds SPI Master support for the SuperH MSIOF
>> --- 0001/drivers/spi/spi.c
>> +++ work/drivers/spi/spi.c    2009-11-24 20:39:48.000000000 +0900
>> @@ -17,7 +17,6 @@
>>   * along with this program; if not, write to the Free Software
>>   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>>   */
>> -
>>  #include <linux/kernel.h>
>>  #include <linux/device.h>
>>  #include <linux/init.h>
>
> whoops?

Yeah, i totally missed that one.

>> --- /dev/null
>> +++ work/drivers/spi/spi_sh_msiof.c   2009-11-24 20:39:49.000000000 +0900
>> @@ -0,0 +1,675 @@
>> +/*
>> + * SuperH MSIOF SPI Master Interface
>> + *
>> + * Copyright (c) 2009 Magnus Damm
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#include <linux/kernel.h>
>
> But not consistently.

Never. =)

>> +#include <linux/init.h>
>> +#include <linux/delay.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/completion.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/gpio.h>
>> +#include <linux/bitmap.h>
>> +#include <linux/clk.h>
>> +#include <linux/io.h>
>> +
>> +#include <linux/spi/spi.h>
>> +#include <linux/spi/spi_bitbang.h>
>> +#include <linux/spi/sh_msiof.h>
>> +
>> +#include <asm/spi.h>
>> +#include <asm/unaligned.h>
>> +
>> +struct sh_msiof_spi_priv {
>> +     struct spi_bitbang bitbang; /* must be first for spi_bitbang.c */
>
> Well if that's the case then spi_bitbang.c needs smacking.  What causes
> this requirement?

The spi_bitbang.c functions spi_bitbang_setup() and
spi_bitbang_transfer() use spi_master_get_devdata() to get the bitbang
data structure. Most drivers want to be able to get a pointer to
private data using spi_master_get_devdata(), so the
bitbang-structure-as-first-member trick is used so the driver code and
the bitbang functions can coexist.

A couple of in-tree drivers do the same thing and store the bitbang
structure as the first member. For instance, have a look at
omap_uwire.c and spi_gpio.c.

Maybe adding a spi_alloc_bitbang_master() function to spi_bitbang.c
that does the bitbang structure allocation behind the scenes would be
a good thing. The bitbang drivers can then use that function instead
of spi_alloc_master(). The bitbang code itself can retrieve the
bitbang structure by doing offset calculations from the master
pointer. That would free up the private pointer.

There may be better ways to do this though...

>> +static void sh_msiof_modify_ctr_wait(struct sh_msiof_spi_priv *p,
>> +                                  unsigned long clr, unsigned long set)
>> +{
>> +     unsigned long mask = clr | set;
>> +     unsigned long data;
>> +
>> +     data = sh_msiof_read(p, CTR);
>> +     data &= ~clr;
>> +     data |= set;
>> +     sh_msiof_write(p, CTR, data);
>> +
>> +     while ((sh_msiof_read(p, CTR) & mask) != set)
>> +             ;
>
> hm, confidence.  No timeout needed here?

Good plan, I'll add some timeout handling code.

>> +static struct {
>> +     unsigned short div;
>> +     unsigned short scr;
>> +} sh_msiof_spi_clk_table[] = {
>> +     { 1, 0x0007 },
>> +     { 2, 0x0000 },
>> +     { 4, 0x0001 },
>> +     { 8, 0x0002 },
>> +     { 16, 0x0003 },
>> +     { 32, 0x0004 },
>> +     { 64, 0x1f00 },
>> +     { 128, 0x1f01 },
>> +     { 256, 0x1f02 },
>> +     { 512, 0x1f03 },
>> +     { 1024, 0x1f04 },
>> +};
>
> Could be const (to save some .data) btu I think the compiler does that
> itself nowadays.

I'll fix that up.

>> +static void sh_msiof_spi_set_clk_regs(struct sh_msiof_spi_priv *p,
>> +                                   unsigned long parent_rate,
>> +                                   unsigned long spi_hz)
>> +{
>> +     unsigned long div = 1024;
>> +     int k;
>> +
>> +     if (!spi_hz || !parent_rate)
>> +             WARN_ON(1);
>> +     else
>> +             div = parent_rate / spi_hz;
>
> This could be more neatly coded as
>
>        if (!WARN_ON(!spi_hz || !parent_rate))
>                div = parent_rate / spi_hz;
>
> also, if this warning ever triggers, you won't know whether it was due
> to !spi_hx or to !parent_rate, which might make you sad.
>
> Can spi_hz and parent_rate ever be zero here anyway?  If not, zap it.
> If so, why?  Programming bug?

I wanted to fail gracefully if the spi layer or the clock framework
handed us zeroes. They are most likely not supposed to do so, but it
probably doesn't hurt to keep the check. This to catch bugs that may
be around - the spi setup code flow is pretty complex and the clock
framework implementation may vary from processor to processor.

>> +     /* TODO: make more fine grained */
>> +
>> +     for (k = 0; k < ARRAY_SIZE(sh_msiof_spi_clk_table); k++) {
>> +             if (sh_msiof_spi_clk_table[k].div >= div)
>> +                     break;
>> +     }
>> +
>> +     k = min_t(int, k, ARRAY_SIZE(sh_msiof_spi_clk_table) - 1);
>
> actually it's pretty obvious from all the above that k should have been
> size_t.

Cool, will fix.

>> +static u32 sh_msiof_spi_txrx_word(struct spi_device *spi, unsigned nsecs,
>> +                               u32 word, u8 bits)
>> +{
>> +     BUG_ON(1); /* unused but needed by bitbang code */
>
>        BUG();

That makes sense. =)

Thanks for your review!

/ magnus
