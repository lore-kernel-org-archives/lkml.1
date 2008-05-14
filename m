Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbYENVjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbYENVjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYENVjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:39:45 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:53510 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463AbYENVjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:39:43 -0400
Date: Wed, 14 May 2008 22:38:41 +0100
From: Ben Dooks <ben@fluff.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [i2c] [PATCH] I2C: SiByte: Convert the driver to make use of
	interrupts
Message-ID: <20080514213841.GC16881@fluff.org.uk>
References: <Pine.LNX.4.55.0805130353250.535@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0805130353250.535@cliff.in.clinika.pl>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 04:28:25AM +0100, Maciej W. Rozycki wrote:
>  This is a rewrite of large parts of the driver mainly so that it uses 
> SMBus interrupts to offload the CPU from busy-waiting on status inputs.  
> As a part of the overhaul of the init and exit calls, all accesses to the 
> hardware got converted to use accessory functions via an ioremap() cookie.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  This patch depends on patch-2.6.26-rc1-20080505-swarm-i2c-16 -- submitted 
> as a part of the recent set of M41T80 RTC changes.
> 
>  Jean, please let me know if you prefer the ioremap() changes separately.  
> Similarly, how about the -EINVAL/-EIO error codes?  Also please note how I
> hesitated from adding second space after final full stops within comments.
> 
>   Maciej
> 
> patch-2.6.26-rc1-20080505-sibyte-i2c-irq-5
> diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/i2c/busses/i2c-sibyte.c linux-2.6.26-rc1-20080505/drivers/i2c/busses/i2c-sibyte.c
> --- linux-2.6.26-rc1-20080505.macro/drivers/i2c/busses/i2c-sibyte.c	2008-05-11 02:25:56.000000000 +0000
> +++ linux-2.6.26-rc1-20080505/drivers/i2c/busses/i2c-sibyte.c	2008-05-12 06:00:16.000000000 +0000
> @@ -2,6 +2,7 @@
>   * Copyright (C) 2004 Steven J. Hill
>   * Copyright (C) 2001,2002,2003 Broadcom Corporation
>   * Copyright (C) 1995-2000 Simon G. Vogl
> + * Copyright (C) 2008 Maciej W. Rozycki
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
> @@ -18,104 +19,159 @@
>   * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
>   */
>  
> +#include <linux/errno.h>
> +#include <linux/interrupt.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/i2c.h>
> +#include <linux/param.h>
> +#include <linux/spinlock.h>
> +#include <linux/types.h>
> +#include <linux/wait.h>
>  #include <asm/io.h>
> +#include <asm/sibyte/sb1250_int.h>
>  #include <asm/sibyte/sb1250_regs.h>
>  #include <asm/sibyte/sb1250_smbus.h>
>  
>  
>  struct i2c_algo_sibyte_data {
> -	void *data;		/* private data */
> -	int   bus;		/* which bus */
> -	void *reg_base;		/* CSR base */
> +	wait_queue_head_t	wait;		/* IRQ queue */
> +	void __iomem		*csr;		/* mapped CSR handle */
> +	phys_t			base;		/* physical CSR base */
> +	char			*name;		/* IRQ handler name */
> +	spinlock_t		lock;		/* atomiser */
> +	int			irq;		/* IRQ line */
> +	int			status;		/* IRQ status */
>  };
>  
> -/* ----- global defines ----------------------------------------------- */
> -#define SMB_CSR(a,r) ((long)(a->reg_base + r))
>  
> +static irqreturn_t i2c_sibyte_interrupt(int irq, void *dev_id)
> +{
> +	struct i2c_adapter *i2c_adap = dev_id;
> +	struct i2c_algo_sibyte_data *adap = i2c_adap->algo_data;
> +	void __iomem *csr = adap->csr;
> +	u8 status;
> +
> +	/*
> +	 * Ugh, no way to detect the finish interrupt,
> +	 * but if busy it is obviously not one.
> +	 */
> +	status = __raw_readq(csr + R_SMB_STATUS);
> +	if ((status & (M_SMB_ERROR | M_SMB_BUSY)) == M_SMB_BUSY)
> +		return IRQ_NONE;
> +
> +	/*
> +	 * Clear the error interrupt (write 1 to clear);
> +	 * the finish interrupt was cleared by the read above.
> +	 */
> +	__raw_writeq(status, csr + R_SMB_STATUS);
> +
> +	/* Post the status. */
> +	spin_lock_irq(&adap->lock);
> +	adap->status = status & (M_SMB_ERROR_TYPE | M_SMB_ERROR | M_SMB_BUSY);
> +	wake_up(&adap->wait);
> +	spin_unlock_irq(&adap->lock);
> +
> +	return IRQ_HANDLED;
> +}

My recollection is that the return of ioremap() was meant to be
used with read{b,w,l} and not their __raw_xxx() counterparts.

>  
> -static int smbus_xfer(struct i2c_adapter *i2c_adap, u16 addr,
> -		      unsigned short flags, char read_write,
> -		      u8 command, int size, union i2c_smbus_data * data)
> +static s32 i2c_sibyte_smbus_xfer(struct i2c_adapter *i2c_adap, u16 addr,
> +				 unsigned short cflags,
> +				 char read_write, u8 command, int size,
> +				 union i2c_smbus_data *data)
>  {
>  	struct i2c_algo_sibyte_data *adap = i2c_adap->algo_data;
> +	void __iomem *csr = adap->csr;
> +	unsigned long flags;
>  	int data_bytes = 0;
>  	int error;
>  
> -	while (csr_in32(SMB_CSR(adap, R_SMB_STATUS)) & M_SMB_BUSY)
> -		;
> +	spin_lock_irqsave(&adap->lock, flags);
> +
> +	if (adap->status < 0) {
> +		error = -EIO;
> +		goto out_unlock;
> +	}
>  
>  	switch (size) {
>  	case I2C_SMBUS_QUICK:
> -		csr_out32((V_SMB_ADDR(addr) |
> -			   (read_write == I2C_SMBUS_READ ? M_SMB_QDATA : 0) |
> -			   V_SMB_TT_QUICKCMD), SMB_CSR(adap, R_SMB_START));
> +		__raw_writeq(V_SMB_ADDR(addr) |
> +			     (read_write == I2C_SMBUS_READ ? M_SMB_QDATA : 0) |
> +			     V_SMB_TT_QUICKCMD,
> +			     csr + R_SMB_START);
>  		break;
>  	case I2C_SMBUS_BYTE:
>  		if (read_write == I2C_SMBUS_READ) {
> -			csr_out32((V_SMB_ADDR(addr) | V_SMB_TT_RD1BYTE),
> -				  SMB_CSR(adap, R_SMB_START));
> +			__raw_writeq(V_SMB_ADDR(addr) | V_SMB_TT_RD1BYTE,
> +				     csr + R_SMB_START);
>  			data_bytes = 1;
>  		} else {
> -			csr_out32(V_SMB_CMD(command), SMB_CSR(adap, R_SMB_CMD));
> -			csr_out32((V_SMB_ADDR(addr) | V_SMB_TT_WR1BYTE),
> -				  SMB_CSR(adap, R_SMB_START));
> +			__raw_writeq(V_SMB_CMD(command), csr + R_SMB_CMD);
> +			__raw_writeq(V_SMB_ADDR(addr) | V_SMB_TT_WR1BYTE,
> +				     csr + R_SMB_START);
>  		}
>  		break;
>  	case I2C_SMBUS_BYTE_DATA:
> -		csr_out32(V_SMB_CMD(command), SMB_CSR(adap, R_SMB_CMD));
> +		__raw_writeq(V_SMB_CMD(command), csr + R_SMB_CMD);
>  		if (read_write == I2C_SMBUS_READ) {
> -			csr_out32((V_SMB_ADDR(addr) | V_SMB_TT_CMD_RD1BYTE),
> -				  SMB_CSR(adap, R_SMB_START));
> +			__raw_writeq(V_SMB_ADDR(addr) | V_SMB_TT_CMD_RD1BYTE,
> +				     csr + R_SMB_START);
>  			data_bytes = 1;
>  		} else {
> -			csr_out32(V_SMB_LB(data->byte),
> -				  SMB_CSR(adap, R_SMB_DATA));
> -			csr_out32((V_SMB_ADDR(addr) | V_SMB_TT_WR2BYTE),
> -				  SMB_CSR(adap, R_SMB_START));
> +			__raw_writeq(V_SMB_LB(data->byte), csr + R_SMB_DATA);
> +			__raw_writeq(V_SMB_ADDR(addr) | V_SMB_TT_WR2BYTE,
> +				     csr + R_SMB_START);
>  		}
>  		break;
>  	case I2C_SMBUS_WORD_DATA:
> -		csr_out32(V_SMB_CMD(command), SMB_CSR(adap, R_SMB_CMD));
> +		__raw_writeq(V_SMB_CMD(command), csr + R_SMB_CMD);
>  		if (read_write == I2C_SMBUS_READ) {
> -			csr_out32((V_SMB_ADDR(addr) | V_SMB_TT_CMD_RD2BYTE),
> -				  SMB_CSR(adap, R_SMB_START));
> +			__raw_writeq(V_SMB_ADDR(addr) | V_SMB_TT_CMD_RD2BYTE,
> +				     csr + R_SMB_START);
>  			data_bytes = 2;
>  		} else {
> -			csr_out32(V_SMB_LB(data->word & 0xff),
> -				  SMB_CSR(adap, R_SMB_DATA));
> -			csr_out32(V_SMB_MB(data->word >> 8),
> -				  SMB_CSR(adap, R_SMB_DATA));
> -			csr_out32((V_SMB_ADDR(addr) | V_SMB_TT_WR2BYTE),
> -				  SMB_CSR(adap, R_SMB_START));
> +			__raw_writeq(V_SMB_LB(data->word & 0xff),
> +				     csr + R_SMB_DATA);
> +			__raw_writeq(V_SMB_MB(data->word >> 8),
> +				     csr + R_SMB_DATA);
> +			__raw_writeq(V_SMB_ADDR(addr) | V_SMB_TT_WR2BYTE,
> +				     csr + R_SMB_START);
>  		}
>  		break;
>  	default:
> -		return -1;      /* XXXKW better error code? */
> +		error = -EINVAL;
> +		goto out_unlock;
>  	}
> +	mmiowb();
> +	__raw_readq(csr + R_SMB_START);
> +	adap->status = -1;
> +
> +	spin_unlock_irqrestore(&adap->lock, flags);
>  
> -	while (csr_in32(SMB_CSR(adap, R_SMB_STATUS)) & M_SMB_BUSY)
> -		;
> +	wait_event_timeout(adap->wait, (adap->status >= 0), HZ);
>  
> -	error = csr_in32(SMB_CSR(adap, R_SMB_STATUS));
> -	if (error & M_SMB_ERROR) {
> -		/* Clear error bit by writing a 1 */
> -		csr_out32(M_SMB_ERROR, SMB_CSR(adap, R_SMB_STATUS));
> -		return -1;      /* XXXKW better error code? */
> +	spin_lock_irqsave(&adap->lock, flags);
> +
> +	if (adap->status < 0 || (adap->status & (M_SMB_ERROR | M_SMB_BUSY))) {
> +		error = -EIO;
> +		goto out_unlock;
>  	}
>  
>  	if (data_bytes == 1)
> -		data->byte = csr_in32(SMB_CSR(adap, R_SMB_DATA)) & 0xff;
> +		data->byte = __raw_readq(csr + R_SMB_DATA) & 0xff;
>  	if (data_bytes == 2)
> -		data->word = csr_in32(SMB_CSR(adap, R_SMB_DATA)) & 0xffff;
> +		data->word = __raw_readq(csr + R_SMB_DATA) & 0xffff;
>  
> -	return 0;
> +	error = 0;
> +
> +out_unlock:
> +	spin_unlock_irqrestore(&adap->lock, flags);
> +
> +	return error;
>  }
>  
> -static u32 bit_func(struct i2c_adapter *adap)
> +static u32 i2c_sibyte_bit_func(struct i2c_adapter *adap)
>  {
>  	return (I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE |
>  		I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA);
> @@ -125,8 +181,8 @@ static u32 bit_func(struct i2c_adapter *
>  /* -----exported algorithm data: -------------------------------------	*/
>  
>  static const struct i2c_algorithm i2c_sibyte_algo = {
> -	.smbus_xfer	= smbus_xfer,
> -	.functionality	= bit_func,
> +	.smbus_xfer	= i2c_sibyte_smbus_xfer,
> +	.functionality	= i2c_sibyte_bit_func,
>  };
>  
>  /*
> @@ -135,30 +191,101 @@ static const struct i2c_algorithm i2c_si
>  static int __init i2c_sibyte_add_bus(struct i2c_adapter *i2c_adap, int speed)
>  {
>  	struct i2c_algo_sibyte_data *adap = i2c_adap->algo_data;
> +	void __iomem *csr;
> +	int err;
>  
> -	/* Register new adapter to i2c module... */
> -	i2c_adap->algo = &i2c_sibyte_algo;
> +	adap->status = 0;
> +	init_waitqueue_head(&adap->wait);
> +	spin_lock_init(&adap->lock);
> +
> +	csr = ioremap(adap->base, R_SMB_PEC + SMB_REGISTER_SPACING);
> +	if (!csr) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +	adap->csr = csr;
>  
>  	/* Set the requested frequency. */
> -	csr_out32(speed, SMB_CSR(adap,R_SMB_FREQ));
> -	csr_out32(0, SMB_CSR(adap,R_SMB_CONTROL));
> +	__raw_writeq(speed, csr + R_SMB_FREQ);
> +
> +	/* Clear any pending error interrupt. */
> +	__raw_writeq(__raw_readq(csr + R_SMB_STATUS), csr + R_SMB_STATUS);
> +	/* Disable interrupts. */
> +	__raw_writeq(0, csr + R_SMB_CONTROL);
> +	mmiowb();
> +	__raw_readq(csr + R_SMB_CONTROL);
> +
> +	err = request_irq(adap->irq, i2c_sibyte_interrupt, IRQF_SHARED,
> +			  adap->name, i2c_adap);
> +	if (err < 0)
> +		goto out_unmap;
>  
> -	return i2c_add_numbered_adapter(i2c_adap);
> +	/* Enable finish and error interrupts. */
> +	__raw_writeq(M_SMB_FINISH_INTR | M_SMB_ERR_INTR, csr + R_SMB_CONTROL);
> +
> +	/* Register new adapter to i2c module... */
> +	err = i2c_add_numbered_adapter(i2c_adap);
> +	if (err < 0)
> +		goto out_unirq;
> +
> +	return 0;
> +
> +out_unirq:
> +	/* Disable interrupts. */
> +	__raw_writeq(0, csr + R_SMB_CONTROL);
> +	mmiowb();
> +	__raw_readq(csr + R_SMB_CONTROL);
> +
> +	free_irq(adap->irq, i2c_adap);
> +
> +	/* Clear any pending error interrupt. */
> +	__raw_writeq(__raw_readq(csr + R_SMB_STATUS), csr + R_SMB_STATUS);
> +out_unmap:
> +	iounmap(csr);
> +out:
> +	return err;
>  }
>  
> +static void i2c_sibyte_remove_bus(struct i2c_adapter *i2c_adap)
> +{
> +	struct i2c_algo_sibyte_data *adap = i2c_adap->algo_data;
> +	void __iomem *csr = adap->csr;
> +
> +	i2c_del_adapter(i2c_adap);
> +
> +	/* Disable interrupts. */
> +	__raw_writeq(0, csr + R_SMB_CONTROL);
> +	mmiowb();
> +	__raw_readq(csr + R_SMB_CONTROL);
> +
> +	free_irq(adap->irq, i2c_adap);
> +
> +	/* Clear any pending error interrupt. */
> +	__raw_writeq(__raw_readq(csr + R_SMB_STATUS), csr + R_SMB_STATUS);
> +
> +	iounmap(csr);
> +}
>  
> -static struct i2c_algo_sibyte_data sibyte_board_data[2] = {
> -	{ NULL, 0, (void *) (CKSEG1+A_SMB_BASE(0)) },
> -	{ NULL, 1, (void *) (CKSEG1+A_SMB_BASE(1)) }
> +static struct i2c_algo_sibyte_data i2c_sibyte_board_data[2] = {
> +	{
> +		.name	= "sb1250-smbus-0",
> +		.base	= A_SMB_0,
> +		.irq	= K_INT_SMB_0,
> +	},
> +	{
> +		.name	= "sb1250-smbus-1",
> +		.base	= A_SMB_1,
> +		.irq	= K_INT_SMB_1,
> +	}
>  };
>  
> -static struct i2c_adapter sibyte_board_adapter[2] = {
> +static struct i2c_adapter i2c_sibyte_board_adapter[2] = {
>  	{
>  		.owner		= THIS_MODULE,
>  		.id		= I2C_HW_SIBYTE,
>  		.class		= I2C_CLASS_HWMON,
> -		.algo		= NULL,
> -		.algo_data	= &sibyte_board_data[0],
> +		.algo		= &i2c_sibyte_algo,
> +		.algo_data	= &i2c_sibyte_board_data[0],
>  		.nr		= 0,
>  		.name		= "SiByte SMBus 0",
>  	},
> @@ -166,8 +293,8 @@ static struct i2c_adapter sibyte_board_a
>  		.owner		= THIS_MODULE,
>  		.id		= I2C_HW_SIBYTE,
>  		.class		= I2C_CLASS_HWMON,
> -		.algo		= NULL,
> -		.algo_data	= &sibyte_board_data[1],
> +		.algo		= &i2c_sibyte_algo,
> +		.algo_data	= &i2c_sibyte_board_data[1],
>  		.nr		= 1,
>  		.name		= "SiByte SMBus 1",
>  	},
> @@ -175,21 +302,32 @@ static struct i2c_adapter sibyte_board_a
>  
>  static int __init i2c_sibyte_init(void)
>  {
> +	int err;
> +
>  	pr_info("i2c-sibyte: i2c SMBus adapter module for SiByte board\n");
> -	if (i2c_sibyte_add_bus(&sibyte_board_adapter[0], K_SMB_FREQ_100KHZ) < 0)
> -		return -ENODEV;
> -	if (i2c_sibyte_add_bus(&sibyte_board_adapter[1],
> -			       K_SMB_FREQ_400KHZ) < 0) {
> -		i2c_del_adapter(&sibyte_board_adapter[0]);
> -		return -ENODEV;
> -	}
> +
> +	err = i2c_sibyte_add_bus(&i2c_sibyte_board_adapter[0],
> +				 K_SMB_FREQ_100KHZ);
> +	if (err < 0)
> +		goto out;
> +
> +	err = i2c_sibyte_add_bus(&i2c_sibyte_board_adapter[1],
> +				 K_SMB_FREQ_400KHZ);
> +	if (err < 0)
> +		goto out_remove;
> +
>  	return 0;
> +
> +out_remove:
> +	i2c_sibyte_remove_bus(&i2c_sibyte_board_adapter[0]);
> +out:
> +	return err;
>  }
>  
>  static void __exit i2c_sibyte_exit(void)
>  {
> -	i2c_del_adapter(&sibyte_board_adapter[0]);
> -	i2c_del_adapter(&sibyte_board_adapter[1]);
> +	i2c_sibyte_remove_bus(&i2c_sibyte_board_adapter[1]);
> +	i2c_sibyte_remove_bus(&i2c_sibyte_board_adapter[0]);
>  }
>  
>  module_init(i2c_sibyte_init);
> 
> _______________________________________________
> i2c mailing list
> i2c@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/i2c

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
