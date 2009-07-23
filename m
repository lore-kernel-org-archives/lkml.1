Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZGWWLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZGWWLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 18:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZGWWLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 18:11:05 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:41003 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbZGWWLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 18:11:03 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chaithrika U S <chaithrika@ti.com>,
       Manjunath Hadli <mrh@ti.com>, Brijesh Jadav <brijesh.j@ti.com>,
       Hemant Pedanekar <hemantp@ti.com>
Subject: Re: linux-next: manual merge of the v4l-dvb tree with the davinci tree
References: <20090723101121.d21a575d.sfr@canb.auug.org.au>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 23 Jul 2009 15:11:01 -0700
In-Reply-To: <20090723101121.d21a575d.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Thu\, 23 Jul 2009 10\:11\:21 +1000")
Message-ID: <87d47rhwy2.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Mauro,
>
> Today's linux-next merge of the v4l-dvb tree got a conflict in
> arch/arm/mach-davinci/board-dm646x-evm.c between commits
> e94c101ce3ef11bc00f8ea5db4b65c4b01874cf8 ("davinci: ASoC: Add the
> platform devices for ASP") and 4d6c5c3ec7c9b6d0d055da77c406049f7a663a0c
> ("davinci: dm646x-evm: Add support for IDE") from the davinci tree and
> commit be45110fa4525939a32c0509229a1781c5c3da78 ("arch/arm/mach-davinci:
> Platform and board specific setup for DM646x EVM") from the v4l-dvb tree.
>
> I think that these are just overlapping additions (though they my
> actually be implementing similar things).  I fixed it up (see below) and
> can carry the fixes as necessary.

I can confirm that these are just overlapping additions.

Kevin 
(davinci platform maintainer)

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc arch/arm/mach-davinci/board-dm646x-evm.c
> index b1bf18c,eb4bd01..0000000
> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> @@@ -259,35 -220,40 +272,69 @@@ static struct at24_platform_data eeprom
>   	.context	= (void *)0x7f00,
>   };
>   
>  +static u8 dm646x_iis_serializer_direction[] = {
>  +       TX_MODE, RX_MODE, INACTIVE_MODE, INACTIVE_MODE,
>  +};
>  +
>  +static u8 dm646x_dit_serializer_direction[] = {
>  +       TX_MODE,
>  +};
>  +
>  +static struct snd_platform_data dm646x_evm_snd_data[] = {
>  +	{
>  +		.tx_dma_offset  = 0x400,
>  +		.rx_dma_offset  = 0x400,
>  +		.op_mode        = DAVINCI_MCASP_IIS_MODE,
>  +		.num_serializer = ARRAY_SIZE(dm646x_iis_serializer_direction),
>  +		.tdm_slots      = 2,
>  +		.serial_dir     = dm646x_iis_serializer_direction,
>  +		.eventq_no      = EVENTQ_0,
>  +	},
>  +	{
>  +		.tx_dma_offset  = 0x400,
>  +		.rx_dma_offset  = 0,
>  +		.op_mode        = DAVINCI_MCASP_DIT_MODE,
>  +		.num_serializer = ARRAY_SIZE(dm646x_dit_serializer_direction),
>  +		.tdm_slots      = 32,
>  +		.serial_dir     = dm646x_dit_serializer_direction,
>  +		.eventq_no      = EVENTQ_0,
>  +	},
>  +};
>  +
> + static struct i2c_client *cpld_client;
> + 
> + static int cpld_video_probe(struct i2c_client *client,
> + 			const struct i2c_device_id *id)
> + {
> + 	cpld_client = client;
> + 	return 0;
> + }
> + 
> + static int __devexit cpld_video_remove(struct i2c_client *client)
> + {
> + 	cpld_client = NULL;
> + 	return 0;
> + }
> + 
> + static const struct i2c_device_id cpld_video_id[] = {
> + 	{ "cpld_video", 0 },
> + 	{ }
> + };
> + 
> + static struct i2c_driver cpld_video_driver = {
> + 	.driver = {
> + 		.name	= "cpld_video",
> + 	},
> + 	.probe		= cpld_video_probe,
> + 	.remove		= cpld_video_remove,
> + 	.id_table	= cpld_video_id,
> + };
> + 
> + static void evm_init_cpld(void)
> + {
> + 	i2c_add_driver(&cpld_video_driver);
> + }
> + 
>   static struct i2c_board_info __initdata i2c_info[] =  {
>   	{
>   		I2C_BOARD_INFO("24c256", 0x50),
> @@@ -298,8 -264,8 +345,11 @@@
>   		.platform_data	= &pcf_data,
>   	},
>   	{
>  +		I2C_BOARD_INFO("cpld_reg0", 0x3a),
>  +	},
> ++	{
> + 		I2C_BOARD_INFO("cpld_video", 0x3B),
> + 	},
>   };
>   
>   static struct davinci_i2c_platform_data i2c_pdata = {
> @@@ -310,8 -346,8 +430,9 @@@ static struct vpif_config dm646x_vpif_c
>   static void __init evm_init_i2c(void)
>   {
>   	davinci_init_i2c(&i2c_pdata);
>  +	i2c_add_driver(&dm6467evm_cpld_driver);
>   	i2c_register_board_info(1, i2c_info, ARRAY_SIZE(i2c_info));
> + 	evm_init_cpld();
>   }
>   
>   static void __init davinci_map_io(void)
