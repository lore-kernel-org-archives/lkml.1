Return-Path: <linux-kernel-owner+w=401wt.eu-S1161359AbXECHsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161359AbXECHsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161443AbXECHsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:48:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60225 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161359AbXECHsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:48:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [POWERPC] 8xx: mpc885ads pcmcia support
Date: Thu, 3 May 2007 09:48:03 +0200
User-Agent: KMail/1.9.6
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
References: <20070503065435.4533.64938.stgit@localhost.localdomain>
In-Reply-To: <20070503065435.4533.64938.stgit@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705030948.03984.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/SbtuT/dFyk2twPSeUgf2ZtAV6oMBl3YCHH2W
 OkFDpPS41l8j2G/AzCRai26FWmqLX1v7i79R5xDWZebK6TtjzZ
 ZkYpEeBXfaQ3EoRMQrWhw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2007, Vitaly Bordug wrote:

> Adds support for PowerQuicc on-chip PCMCIA. The driver is implemented as
> of_device, so only arch/powerpc stuff is capable to use it, which now
> implies only mpc885ads reference board.

Very nice, looks much better now than the previous version.

> diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
> index 110bf61..89d585f 100644
> --- a/arch/powerpc/boot/dts/mpc885ads.dts
> +++ b/arch/powerpc/boot/dts/mpc885ads.dts
> @@ -112,6 +112,18 @@
>  			compatible = "CPM";
>  		};
>  
> +               pcmcia@0080 {
> +                       linux,phandle = <0080>;
> +                       #interrupt-cells = <1>;
> +                       #size-cells = <2>;
> +                       compatible = "8xx";
> +                       device_type = "pcmcia";
> +                       reg = <80 80>;
> +                       clock-frequency = <2faf080>;
> +                       interrupt-parent = <ff000000>;
> +                       interrupts = <d 1>;
> +		};
> +
>  		cpm@ff000000 {
>  			linux,phandle = <ff000000>;
>  			#address-cells = <1>;

The compatible property should be a little more specific, imho. Since there
are differences in how things are done depending on the board, it would be
good to tell the exact method from the pcmcia node itself.

For example, you could make this

	compatible = "8xx\0mpc885ads";

Your code doesn't currently use this, I like to have the option.

> +#ifdef CONFIG_PCMCIA_M8XX
> +static void pcmcia_hw_setup(int slot, int enable);
> +static int pcmcia_set_voltage(int slot, int vcc, int vpp);
> +
> +struct mpc8xx_pcmcia_ops m8xx_pcmcia_ops = {
> +	.hw_ctrl = pcmcia_hw_setup,
> +	.voltage_set = pcmcia_set_voltage,
> +};
> +#endif
> +
>  void __init mpc885ads_board_setup(void)
>  {
>  	cpm8xx_t *cp;

If you define the global variable in the board code, you can not have multiple
board implementations in a multiplatform kernel.
In order to make that work, you'd need to have the definition of m8xx_pcmcia_ops
in 8xx common code, and then assign the two function pointers dynamically in the
board initialization.

> +	if (of_address_to_resource(np, 0, &r))
> +		return -EINVAL;
> +
> +	pcmcia = ioremap(r.start, r.end - r.start + 1);
> +	if(pcmcia == NULL)
> +		return -EINVAL;

A new of_iomap() function was recently added that allows you
to do these two steps in one.

> -/* connect interrupt and disable CxOE */
> +	out_be32(M8XX_PGCRX(0), M8XX_PGCRX_CXOE | (mk_int_int_mask(hwirq) << 16));
> +	out_be32(M8XX_PGCRX(1), M8XX_PGCRX_CXOE | (mk_int_int_mask(hwirq) << 16));

I'm not sure why you need to use the hwirq here, it should not be visible to
device drivers normally.

Is this the same as enable_irq(pcmcia_schlvl) ?

	Arnd <><
