Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbYHGDwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbYHGDwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 23:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYHGDwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 23:52:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:35772 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYHGDwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 23:52:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O9gb/OoR0Xn/U3Q0VDtcgoSpOTOXLDvMsgkct8Se6huqEA38kYbj/wgi+3uXARQtUB
         UGkB+jCTFPh+bkPhzyxG7RNGI8IxMnnVHRTbT/ryBr4sKHrNHqejzrDSjxdXLKBPitRj
         VhuMi5aeU59ZBcLj0mX9DIAQzxnHcS59it0LA=
Message-ID: <f17812d70808062052p7943441ax5a70aea0a9d3447f@mail.gmail.com>
Date: Thu, 7 Aug 2008 11:52:13 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Marc Zyngier" <maz@misterjones.org>
Subject: Re: [PATCH 2/5] Add support for the Arcom/Eurotech Viper SBC onboard ethernet.
Cc: linux-kernel@vger.kernel.org,
       "Amit Walambe" <amit.walambe@eurotech-ltd.co.uk>,
       "Dominik Brodowski" <linux@dominikbrodowski.net>,
       "Marc Zyngier" <marc.zyngier@altran.com>
In-Reply-To: <15b4632ba095731c7c6c384de0698e2ef84fa775.1218018637.git.marc.zyngier@altran.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <37f79c8da83c915c5ecc1d81cad9f4f5ae3c2b4a.1218018636.git.marc.zyngier@altran.com>
	 <15b4632ba095731c7c6c384de0698e2ef84fa775.1218018637.git.marc.zyngier@altran.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider merging this to the following code in the front of smc91x.h

#if defined(CONFIG_ARCH_LUBBOCK) ||\
    defined(CONFIG_MACH_MAINSTONE) ||\
    defined(CONFIG_MACH_ZYLONITE) ||\
    defined(CONFIG_MACH_LITTLETON)

#include <asm/mach-types.h>

/* Now the bus width is specified in the platform data
 * pretend here to support all I/O access types
 */
#define SMC_CAN_USE_8BIT        1
#define SMC_CAN_USE_16BIT       1
#define SMC_CAN_USE_32BIT       1
#define SMC_NOWAIT              1

#define SMC_IO_SHIFT            (lp->io_shift)

....
#else

On Wed, Aug 6, 2008 at 9:19 PM, Marc Zyngier <maz@misterjones.org> wrote:
> Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>
> ---
>  drivers/net/smc91x.h |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
> index 22209b6..9481412 100644
> --- a/drivers/net/smc91x.h
> +++ b/drivers/net/smc91x.h
> @@ -185,6 +185,27 @@ static inline void SMC_outw(u16 val, void __iomem *ioaddr, int reg)
>
>  #define SMC_IRQ_FLAGS          (-1)
>
> +#elif defined(CONFIG_ARCH_VIPER)
> +
> +/* We can only do 16-bit reads and writes in the static memory space. */
> +#define SMC_CAN_USE_8BIT       0
> +#define SMC_CAN_USE_16BIT      1
> +#define SMC_CAN_USE_32BIT      0
> +#define SMC_CAN_USE_DATACS     1
> +#define SMC_NOWAIT             1
> +
> +#define SMC_IO_SHIFT           0
> +
> +#define SMC_inw(a, r)          readw((a) + (r))
> +#define SMC_outw(v, a, r)      writew(v, (a) + (r))
> +#define SMC_insw(a, r, p, l)   insw((a) + (r), p, l)
> +#define SMC_outsw(a, r, p, l)  outsw((a) + (r), p, l)
> +
> +#define RPC_LSA_DEFAULT                RPC_LED_100_10
> +#define RPC_LSB_DEFAULT                RPC_LED_TX_RX
> +
> +#define SMC_IRQ_FLAGS          (-1)    /* from resource */
> +
>  #elif defined(CONFIG_SA1100_ASSABET)
>
>  #include <asm/arch/neponset.h>
> --
> 1.5.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
