Return-Path: <linux-kernel-owner+w=401wt.eu-S1763557AbZFRNnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763557AbZFRNnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 09:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757591AbZFRNna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 09:43:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:47712 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbZFRNn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 09:43:29 -0400
MIME-Version: 1.0
In-Reply-To: <20090618065814.GA12942@pengutronix.de>
References: <20090618025030.12363.69402.stgit@localhost.localdomain> 
	<20090618065814.GA12942@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 18 Jun 2009 07:35:28 -0600
Message-ID: <fa686aa40906180635g45724119x99cd4d1e4ede59f9@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH v4] powerpc/5200: Add mpc5200-spi 
	(non-PSC) device driver
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linuxppc-dev@ozlabs.org, David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jonsmirl@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 12:58 AM, Wolfram Sang<w.sang@pengutronix.de> wrote:
> Hi Grant,
>
> some comments below:

Hi Wolfram.  Thanks for the review.

> On Wed, Jun 17, 2009 at 08:55:01PM -0600, Grant Likely wrote:
>> +#include <linux/spi/mpc52xx_spi.h>
>
> Is this still needed? See last comment...

No, not needed at all.  Will remove.

>> +#include <linux/of_spi.h>
>> +#include <linux/io.h>
>> +#include <asm/time.h>
>
> Really asm?

Yes, really asm.  Needed for get_tlb()

>> +#include <asm/mpc52xx.h>
>> +
>> +MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
>> +MODULE_DESCRIPTION("MPC52xx SPI (non-PSC) Driver");
>> +MODULE_LICENSE("GPL");
>> +
>> +/* Register offsets */
>> +#define SPI_CTRL1    0x00
>> +#define SPI_CTRL1_SPIE               (1 << 7)
>> +#define SPI_CTRL1_SPE                (1 << 6)
>> +#define SPI_CTRL1_MSTR               (1 << 4)
>> +#define SPI_CTRL1_CPOL               (1 << 3)
>> +#define SPI_CTRL1_CPHA               (1 << 2)
>> +#define SPI_CTRL1_SSOE               (1 << 1)
>> +#define SPI_CTRL1_LSBFE              (1 << 0)
>> +
>> +#define SPI_CTRL2    0x01
>> +#define SPI_BRR              0x04
>> +
>> +#define SPI_STATUS   0x05
>> +#define SPI_STATUS_SPIF              (1 << 7)
>> +#define SPI_STATUS_WCOL              (1 << 6)
>> +#define SPI_STATUS_MODF              (1 << 4)
>> +
>> +#define SPI_DATA     0x09
>> +#define SPI_PORTDATA 0x0d
>> +#define SPI_DATADIR  0x10
>> +
>> +/* FSM state return values */
>> +#define FSM_STOP     0       /* Nothing more for the state machine to */
>> +                             /* do.  If something interesting happens */
>> +                             /* then and IRQ will be received */
>
> s/and/an/? Throughout the comments, there is sometimes a double space.

The double spaces at the end of sentences are intentional.  It is
perhaps a bit quaint and old fashioned, but it is my writing style.

>
>> +#define FSM_POLL     1       /* need to poll for completion, an IRQ is */
>> +                             /* not expected */
>> +#define FSM_CONTINUE 2       /* Keep iterating the state machine */
>> +
>> +/* Driver internal data */
>> +struct mpc52xx_spi {
>> +     struct spi_master *master;
>> +     u32 sysclk;
>
> unused?

yes, fixed.

>> +     void __iomem *regs;
>> +     int irq0;       /* MODF irq */
>> +     int irq1;       /* SPIF irq */
>> +     int ipb_freq;
>
> unsigned int will suit it better IMHO.

right.

>> +
>> +     /* Statistics */
>> +     int msg_count;
>> +     int wcol_count;
>> +     int wcol_ticks;
>> +     u32 wcol_tx_timestamp;
>> +     int modf_count;
>> +     int byte_count;
>
> Hmm, there isn't even a debug-printout for those. Putting #ifdef DEBUG around
> them will be ugly. Well, I can't make up if this is just overhead or useful
> debugging aid, so no real objection :)

There used to be a sysfs interface for dumping these, but it was an
ugly misuse.  I'd like to leave these in.  I still have the sysfs bits
in a private patch and I'm going to rework them for debugfs.

> But I wonder more about the usage of the SS pin and if this chipsel is needed
> at all (sadly I cannot test as I don't have any board with SPI connected to
> that device). You define the SS-pin as output, but do not set the SSOE-bit.
> More, you use the MODF-feature, so the SS-pin should be defined as input?
> According to Table 17.3 in the PM, you have that pin defined as generic purpose
> output.

That's right.  The SS handling by the SPI device is completely
useless, so this driver uses it as a GPIO and asserts it manually.
The MODF irq is probably irrelevant, but I'd like to leave it in for
completeness.

>> +     /* initialize the device */
>> +     out_8(regs+SPI_CTRL1, SPI_CTRL1_SPIE | SPI_CTRL1_SPE | SPI_CTRL1_MSTR);
>
> spaces around operator.

Intentional to keep from spilling past column 80; but I'll move the
missing spaces to around the | operators.  I think it is easier to
read that way.

>> diff --git a/include/linux/spi/mpc52xx_spi.h b/include/linux/spi/mpc52xx_spi.h
>> new file mode 100644
>> index 0000000..d1004cf
>> --- /dev/null
>> +++ b/include/linux/spi/mpc52xx_spi.h
>> @@ -0,0 +1,10 @@
>> +
>> +#ifndef INCLUDE_MPC5200_SPI_H
>> +#define INCLUDE_MPC5200_SPI_H
>> +
>> +extern void mpc52xx_spi_set_premessage_hook(struct spi_master *master,
>> +                                         void (*hook)(struct spi_message *m,
>> +                                                      void *context),
>> +                                         void *hook_context);
>> +
>> +#endif
>
> This can be dropped for now and reintroduced when needed, I think.

Yeah, this is cruft.  Removed.

Thanks!
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
