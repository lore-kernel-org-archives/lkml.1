Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbXKCKrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbXKCKrJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 06:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbXKCKq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 06:46:57 -0400
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:60075 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752650AbXKCKq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 06:46:56 -0400
Date: Sat, 3 Nov 2007 11:46:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 1/4] Blackfin I2C/TWI driver: Add repeat start feature
 to avoid break of a bundle of i2c master xfer operation.
Message-ID: <20071103114653.57e0b479@hyperion.delvare>
In-Reply-To: <1193984664-10609-2-git-send-email-bryan.wu@analog.com>
References: <1193984664-10609-1-git-send-email-bryan.wu@analog.com>
	<1193984664-10609-2-git-send-email-bryan.wu@analog.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan, 

Thanks for splitting the patches as requested. Here's a more complete
review:

On Fri,  2 Nov 2007 14:24:21 +0800, Bryan Wu wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
>  - Create a new mode TWI_I2C_MODE_REPEAT.
>  - No change to smbus operation.

I don't understand the difference between TWI_I2C_MODE_COMBINED and
TWI_I2C_MODE_REPEAT. Both use RSTART to send multiple data chunks at
once. Can you please explain the difference?

> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  drivers/i2c/busses/i2c-bfin-twi.c |  179 +++++++++++++++++++++++--------------
>  1 files changed, 111 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
> index 67224a4..6535852 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -42,6 +42,7 @@
>  #define TWI_I2C_MODE_STANDARD		0x01
>  #define TWI_I2C_MODE_STANDARDSUB	0x02
>  #define TWI_I2C_MODE_COMBINED		0x04
> +#define TWI_I2C_MODE_REPEAT		0x08

This is strange (and possibly confusing) to use values that make the
mode look like a bitfield, when all the modes are actually mutually
exclusive and can't be combined. Admittedly these values are arbitrary
and there's no bug, but it would still make more sense to number the
modes linearly.

>  
>  struct bfin_twi_iface {
>  	int			irq;
> @@ -58,6 +59,9 @@ struct bfin_twi_iface {
>  	struct timer_list	timeout_timer;
>  	struct i2c_adapter	adap;
>  	struct completion	complete;
> +	struct i2c_msg 		*pmsg;
> +	int			msg_num;
> +	int			cur_msg;
>  };
>  
>  static struct bfin_twi_iface twi_iface;
> @@ -76,12 +80,16 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
>  		/* start receive immediately after complete sending in
>  		 * combine mode.
>  		 */
> -		else if (iface->cur_mode == TWI_I2C_MODE_COMBINED) {
> +		else if (iface->cur_mode == TWI_I2C_MODE_COMBINED)
>  			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
>  				| MDIR | RSTART);
> -		} else if (iface->manual_stop)
> +		else if (iface->manual_stop)
>  			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
>  				| STOP);
> +		else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
> +				iface->cur_msg+1 < iface->msg_num)
> +			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
> +				| RSTART);
>  		SSYNC();
>  		/* Clear status */
>  		bfin_write_TWI_INT_STAT(XMTSERV);
> @@ -108,6 +116,11 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
>  			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
>  				| STOP);
>  			SSYNC();
> +		} else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
> +				iface->cur_msg+1 < iface->msg_num) {
> +			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL()
> +				| RSTART);
> +			SSYNC();
>  		}
>  		/* Clear interrupt source */
>  		bfin_write_TWI_INT_STAT(RCVSERV);
> @@ -119,7 +132,7 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
>  		bfin_write_TWI_MASTER_STAT(0x3e);
>  		bfin_write_TWI_MASTER_CTL(0);
>  		SSYNC();
> -		iface->result = -1;
> +		iface->result = -EIO;
>  		/* if both err and complete int stats are set, return proper
>  		 * results.
>  		 */
> @@ -170,6 +183,42 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface)
>  			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() |
>  				MEN | MDIR);
>  			SSYNC();
> +		} else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
> +				iface->cur_msg+1 < iface->msg_num) {
> +			iface->cur_msg++;
> +			iface->transPtr = iface->pmsg[iface->cur_msg].buf;
> +			iface->writeNum = iface->readNum =
> +				iface->pmsg[iface->cur_msg].len;
> +			/* Set Transmit device address */
> +			bfin_write_TWI_MASTER_ADDR(
> +				iface->pmsg[iface->cur_msg].addr);
> +			if (iface->pmsg[iface->cur_msg].flags & I2C_M_RD)
> +				iface->read_write = I2C_SMBUS_READ;
> +			else {
> +				iface->read_write = I2C_SMBUS_WRITE;
> +				/* Transmit first data */
> +				if (iface->writeNum > 0) {
> +					bfin_write_TWI_XMT_DATA8(
> +						*(iface->transPtr++));
> +					iface->writeNum--;
> +					SSYNC();
> +				}
> +			}
> +
> +			if (iface->pmsg[iface->cur_msg].len <= 255)
> +				bfin_write_TWI_MASTER_CTL(
> +				iface->pmsg[iface->cur_msg].len << 6);
> +			else if (iface->pmsg[iface->cur_msg].len > 255) {

This test will always succeed, so a simple "else" is enough.

> +				bfin_write_TWI_MASTER_CTL(0xff << 6);
> +				iface->manual_stop = 1;
> +			}

Does this mean that the Blackfin TWI controller doesn't support
messages of more than 255 bytes? If so, you should return an error
right away when this happens, rather than silently truncating the
message.

> +			/* remove restart bit and enable master receive */
> +			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() &
> +				~RSTART);
> +			bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() |
> +				MEN | ((iface->read_write == I2C_SMBUS_READ) ?
> +				MDIR : 0));
> +			SSYNC();
>  		} else {
>  			iface->result = 1;
>  			bfin_write_TWI_INT_MASK(0);
> @@ -221,7 +270,6 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
>  {
>  	struct bfin_twi_iface *iface = adap->algo_data;
>  	struct i2c_msg *pmsg;
> -	int i, ret;
>  	int rc = 0;
>  
>  	if (!(bfin_read_TWI_CONTROL() & TWI_ENA))
> @@ -231,81 +279,76 @@ static int bfin_twi_master_xfer(struct i2c_adapter *adap,
>  		yield();
>  	}
>  
> -	ret = 0;
> -	for (i = 0; rc >= 0 && i < num; i++) {
> -		pmsg = &msgs[i];
> -		if (pmsg->flags & I2C_M_TEN) {
> -			dev_err(&(adap->dev), "i2c-bfin-twi: 10 bits addr "
> -				"not supported !\n");
> -			rc = -EINVAL;
> -			break;
> -		}
> +	iface->pmsg = msgs;
> +	iface->msg_num = num;
> +	iface->cur_msg = 0;
>  
> -		iface->cur_mode = TWI_I2C_MODE_STANDARD;
> -		iface->manual_stop = 0;
> -		iface->transPtr = pmsg->buf;
> -		iface->writeNum = iface->readNum = pmsg->len;
> -		iface->result = 0;
> -		iface->timeout_count = 10;
> -		/* Set Transmit device address */
> -		bfin_write_TWI_MASTER_ADDR(pmsg->addr);
> -
> -		/* FIFO Initiation. Data in FIFO should be
> -		 *  discarded before start a new operation.
> -		 */
> -		bfin_write_TWI_FIFO_CTL(0x3);
> -		SSYNC();
> -		bfin_write_TWI_FIFO_CTL(0);
> -		SSYNC();
> +	pmsg = &msgs[0];
> +	if (pmsg->flags & I2C_M_TEN) {
> +		dev_err(&adap->dev, "10 bits addr not supported!\n");
> +		return -EINVAL;
> +	}
>  
> -		if (pmsg->flags & I2C_M_RD)
> -			iface->read_write = I2C_SMBUS_READ;
> -		else {
> -			iface->read_write = I2C_SMBUS_WRITE;
> -			/* Transmit first data */
> -			if (iface->writeNum > 0) {
> -				bfin_write_TWI_XMT_DATA8(*(iface->transPtr++));
> -				iface->writeNum--;
> -				SSYNC();
> -			}
> +	iface->cur_mode = TWI_I2C_MODE_REPEAT;
> +	iface->manual_stop = 0;
> +	iface->transPtr = pmsg->buf;
> +	iface->writeNum = iface->readNum = pmsg->len;
> +	iface->result = 0;
> +	iface->timeout_count = 10;
> +	/* Set Transmit device address */
> +	bfin_write_TWI_MASTER_ADDR(pmsg->addr);
> +
> +	/* FIFO Initiation. Data in FIFO should be
> +	 *  discarded before start a new operation.
> +	 */
> +	bfin_write_TWI_FIFO_CTL(0x3);
> +	SSYNC();
> +	bfin_write_TWI_FIFO_CTL(0);
> +	SSYNC();
> +
> +	if (pmsg->flags & I2C_M_RD)
> +		iface->read_write = I2C_SMBUS_READ;
> +	else {
> +		iface->read_write = I2C_SMBUS_WRITE;
> +		/* Transmit first data */
> +		if (iface->writeNum > 0) {
> +			bfin_write_TWI_XMT_DATA8(*(iface->transPtr++));
> +			iface->writeNum--;
> +			SSYNC();
>  		}
> +	}
>  
> -		/* clear int stat */
> -		bfin_write_TWI_INT_STAT(MERR|MCOMP|XMTSERV|RCVSERV);
> +	/* clear int stat */
> +	bfin_write_TWI_INT_STAT(MERR | MCOMP | XMTSERV | RCVSERV);
>  
> -		/* Interrupt mask . Enable XMT, RCV interrupt */
> -		bfin_write_TWI_INT_MASK(MCOMP | MERR |
> -			((iface->read_write == I2C_SMBUS_READ)?
> -			RCVSERV : XMTSERV));
> -		SSYNC();
> +	/* Interrupt mask . Enable XMT, RCV interrupt */
> +	bfin_write_TWI_INT_MASK(MCOMP | MERR | RCVSERV | XMTSERV);
> +	SSYNC();
>  
> -		if (pmsg->len > 0 && pmsg->len <= 255)
> -			bfin_write_TWI_MASTER_CTL(pmsg->len << 6);
> -		else if (pmsg->len > 255) {
> -			bfin_write_TWI_MASTER_CTL(0xff << 6);
> -			iface->manual_stop = 1;
> -		} else
> -			break;
> +	if (pmsg->len <= 255)
> +		bfin_write_TWI_MASTER_CTL(pmsg->len << 6);
> +	else if (pmsg->len > 255) {
> +		bfin_write_TWI_MASTER_CTL(0xff << 6);
> +		iface->manual_stop = 1;
> +	}

Same as above: if you can't achieve the transaction, return an error.

>  
> -		iface->timeout_timer.expires = jiffies + POLL_TIMEOUT;
> -		add_timer(&iface->timeout_timer);
> +	iface->timeout_timer.expires = jiffies + POLL_TIMEOUT;
> +	add_timer(&iface->timeout_timer);
>  
> -		/* Master enable */
> -		bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
> -			((iface->read_write == I2C_SMBUS_READ) ? MDIR : 0) |
> -			((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ>100) ? FAST : 0));
> -		SSYNC();
> +	/* Master enable */
> +	bfin_write_TWI_MASTER_CTL(bfin_read_TWI_MASTER_CTL() | MEN |
> +		((iface->read_write == I2C_SMBUS_READ) ? MDIR : 0) |
> +		((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ > 100) ? FAST : 0));
> +	SSYNC();
>  
> -		wait_for_completion(&iface->complete);
> +	wait_for_completion(&iface->complete);
>  
> -		rc = iface->result;
> -		if (rc == 1)
> -			ret++;
> -		else if (rc == -1)
> -			break;
> -	}
> +	rc = iface->result;
>  
> -	return ret;
> +	if (rc == 1)
> +		return num;
> +	else
> +		return rc;
>  }
>  
>  /*


-- 
Jean Delvare
