Return-Path: <linux-kernel-owner+w=401wt.eu-S1423105AbXEDTgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423105AbXEDTgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423028AbXEDTgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:36:00 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423105AbXEDTf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:35:58 -0400
Date: Fri, 4 May 2007 12:35:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: linux-pcmcia@lists.infradead.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] 8xx: mpc885ads pcmcia support
Message-Id: <20070504123543.5e3fd908.akpm@linux-foundation.org>
In-Reply-To: <20070503235747.29275.37271.stgit@localhost.localdomain>
References: <20070503235747.29275.37271.stgit@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007 03:57:51 +0400
Vitaly Bordug <vitb@kernel.crashing.org> wrote:

> 
> Adds support for PowerQuicc on-chip PCMCIA. The driver is implemented as
> of_device, so only arch/powerpc stuff is capable to use it, which now
> implies only mpc885ads reference board.
> 
> To cope with the code that should be hooked inside driver, but is really
> board specific (like set_voltage), global structure mpc8xx_pcmcia_ops
> holds necessary function pointers that are filled in the BSP code.
> 

argh.

akpm:/home/akpm> grep '^.*        ' x | wc -l 
72

please, Linux uses hard-tabs, not spacespacespacespacespacespacespacespace
everywhere.

> +
>  		cpm@ff000000 {
>  			linux,phandle = <ff000000>;
>  			#address-cells = <1>;
> diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
> index 0901dba..f169355 100644
> --- a/arch/powerpc/platforms/8xx/m8xx_setup.c
> +++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
> @@ -32,6 +32,7 @@
>  #include <linux/root_dev.h>
>  #include <linux/time.h>
>  #include <linux/rtc.h>
> +#include <linux/fsl_devices.h>
>  
>  #include <asm/mmu.h>
>  #include <asm/reg.h>
> @@ -49,6 +50,10 @@
>  
>  #include "sysdev/mpc8xx_pic.h"
>  
> +#ifdef CONFIG_PCMCIA_M8XX
> +struct mpc8xx_pcmcia_ops m8xx_pcmcia_ops;
> +#endif

Please declare this in a header file.

> +/* Some internal interrupt registers use an 8-bit mask for the interrupt
> + * level instead of a number.
> + */

Standard Linux commenting style is:

/*
 * Some internal interrupt registers use an 8-bit mask for the interrupt
 * level instead of a number.
 */

> +#define mk_int_int_mask(IL) (1 << (7 - (IL/2)))

Insufficiently parenthesised?

static inline functions are preferred.

> +#ifdef CONFIG_PCMCIA_M8XX
> +extern struct mpc8xx_pcmcia_ops m8xx_pcmcia_ops;

Please don't ever put extern declarations in C files.  Declare it in a
header, include that header in the C file which contains the definition as
well as within all C files which use the symbol.

> +static void pcmcia_hw_setup(int slot, int enable);
> +static int pcmcia_set_voltage(int slot, int vcc, int vpp);
> +#endif
> +
>  void __init mpc885ads_board_setup(void)
>  {
>  	cpm8xx_t *cp;
> @@ -115,6 +122,12 @@ void __init mpc885ads_board_setup(void)
>  	immr_unmap(io_port);
>  
>  #endif
> +
> +#ifdef CONFIG_PCMCIA_M8XX
> +	/*Set up board specific hook-ups*/
> +	m8xx_pcmcia_ops.hw_ctrl = pcmcia_hw_setup;
> +	m8xx_pcmcia_ops.voltage_set = pcmcia_set_voltage;
> +#endif
>  }
>  
>  
> @@ -322,6 +335,70 @@ void init_smc_ioports(struct fs_uart_platform_info *data)
>  	}
>  }
>  
> +#ifdef CONFIG_PCMCIA_M8XX
> +static void pcmcia_hw_setup(int slot, int enable)
> +{
> +	unsigned *bcsr_io;
> +
> +	bcsr_io = ioremap(BCSR1, sizeof(unsigned long));
> +	if (enable)
> +	clrbits32(bcsr_io, BCSR1_PCCEN);
> +	else
> +		setbits32(bcsr_io, BCSR1_PCCEN);

Missing a tab.

> +	iounmap(bcsr_io);
> +}
> +
> +static int pcmcia_set_voltage(int slot, int vcc, int vpp)
> +{
> +        u32 reg = 0;
> +        unsigned *bcsr_io;
> +
> +        bcsr_io = ioremap(BCSR1, sizeof(unsigned long));
> +
> +        switch(vcc) {
> +                case 0:
> +                        break;
> +                case 33:
> +                        reg |= BCSR1_PCCVCC0;
> +                        break;
> +                case 50:
> +                        reg |= BCSR1_PCCVCC1;
> +                        break;
> +                default:
> +                        return 1;
> +        }

Standard Linux layout for switch statements is:

        switch(vcc) {
	case 0:
		break;
	case 33:
		reg |= BCSR1_PCCVCC0;
		break;
	case 50:
		reg |= BCSR1_PCCVCC1;
		break;
	default:
		return 1;
        }


> +        switch(vpp) {
> +                case 0:
> +                        break;
> +                case 33:
> +                case 50:
> +                        if(vcc == vpp)
> +                                reg |= BCSR1_PCCVPP1;
> +                        else
> +                                return 1;
> +                        break;
> +                case 120:
> +                        if ((vcc == 33) || (vcc == 50))
> +                                reg |= BCSR1_PCCVPP0;
> +                        else
> +                                return 1;
> +                default:
> +                        return 1;
> +        }

Ditto.

> +        /* first, turn off all power */
> +        clrbits32(bcsr_io, 0x00610000);
> +
> +        /* enable new powersettings */
> +        setbits32(bcsr_io, reg);
> +
> +        iounmap(bcsr_io);
> +        return 0;
> +}
> +#endif
> +
>  int platform_device_skip(const char *model, int id)
>  {
>  #ifdef CONFIG_MPC8xx_SECOND_ETH_SCC3
> diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
> index 8a123c7..01e4a40 100644
> --- a/arch/powerpc/sysdev/fsl_soc.c
> +++ b/arch/powerpc/sysdev/fsl_soc.c
> @@ -1028,6 +1028,18 @@ err:
>  
>  arch_initcall(fs_enet_of_init);
>  
> +static int __init fsl_pcmcia_of_init(void)
> +{
> +	struct device_node *np = NULL;
> +	/*
> +	 * Register all the devices which type is "pcmcia"
> +	 */
> +	while ((np = of_find_compatible_node(np, "pcmcia", "fsl,pq-pcmcia")) != NULL)
> +		of_platform_device_create(np, "m8xx-pcmcia", NULL);

please try to fit code into 80 columns.

>  
> -static DEFINE_SPINLOCK(events_lock);
> +static spinlock_t events_lock = SPIN_LOCK_UNLOCKED;

This is wrong.  DEFINE_SPINLOCK is required for correct lockdep operation.

> +#define hardware_enable(_slot_) m8xx_pcmcia_ops.hw_ctrl(_slot_, 1)
> +#define hardware_disable(_slot_) m8xx_pcmcia_ops.hw_ctrl(_slot_, 0)
> +#define voltage_set(slot, vcc, vpp) m8xx_pcmcia_ops.voltage_set(slot, vcc, vpp)

static inline functions are preferred.  One reason is that people are more
inclined to add comments to them than to macros.

> -static DEFINE_SPINLOCK(pending_event_lock);
> +static spinlock_t pending_event_lock = SPIN_LOCK_UNLOCKED;

again, you added a bug.

> +	for(i = 0; i < PCMCIA_SOCKETS_NO; i++){

No, we format `for' statements as:

	for (i = 0; i < PCMCIA_SOCKETS_NO; i++) {

> +		w = (void *) &pcmcia->pcmc_pbr0;
>  
> +		out_be32(&pcmcia->pcmc_pscr, M8XX_PCMCIA_MASK(i));
> +		out_be32(&pcmcia->pcmc_per, in_be32(&pcmcia->pcmc_per) & ~M8XX_PCMCIA_MASK(i));

80-cols

> +
> +		/* turn off interrupt and disable CxOE */
> +		out_be32(M8XX_PGCRX(i), M8XX_PGCRX_CXOE);
> +
> +		/* turn off memory windows */
> +		for(m = 0; m < PCMCIA_MEM_WIN_NO; m++) {

formatting

> +			out_be32(&w->or, 0); /* set to not valid */
> +			w++;
> +		}
> +
> +		/* turn off voltage */
> +		voltage_set(i, 0, 0);
> +
> +		/* disable external hardware */
> +		hardware_disable(i);
> +	}
>  	for (i = 0; i < PCMCIA_SOCKETS_NO; i++)
>  		pcmcia_unregister_socket(&socket[i].socket);
>  
> -	m8xx_shutdown();
> +	free_irq(pcmcia_schlvl, NULL);
> +
> +	return 0;
> +}


> -	platform_device_unregister(&m8xx_device);
> -	driver_unregister(&m8xx_driver);
> +#ifdef CONFIG_PM
> +static int m8xx_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +        return pcmcia_socket_dev_suspend(&pdev->dev, state);
> +}
> +
> +static int m8xx_resume(struct platform_device *pdev)
> +{
> +        return pcmcia_socket_dev_resume(&pdev->dev);
> +}
> +#endif

Here, use

#else
#define m8xx_suspend NULL
#define m8xx_resume NULL
#endif

> +static struct of_device_id m8xx_pcmcia_match[] = {
> +	{
> +		.type = "pcmcia",
> +		.compatible = "fsl,pq-pcmcia",
> +	},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, m8xx_pcmcia_match);
> +
> +static struct of_platform_driver m8xx_pcmcia_driver = {
> +	.name		= (char *) driver_name,
> +	.match_table	= m8xx_pcmcia_match,
> +	.probe		= m8xx_probe,
> +	.remove		= m8xx_remove,
> +#ifdef CONFIG_PM
> +	.suspend	= m8xx_suspend,
> +	.resume		= m8xx_resume,
> +#endif

then remove this ifdef.


