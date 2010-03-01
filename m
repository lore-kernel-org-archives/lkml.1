Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0CATSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:18:05 -0500
Received: from be1ssnxpe1.nxp.com ([57.67.164.69]:49293 "EHLO
	be1ssnxpe1.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0CATSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:18:01 -0500
X-Greylist: delayed 2030 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2010 14:18:01 EST
From: Kevin Wells <kevin.wells@nxp.com>
To: Luotao Fu <l.fu@pengutronix.de>, Vitaly Wool <vitalywool@gmail.com>
CC: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
       Julia Lawall <julia@diku.dk>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 1 Mar 2010 19:43:24 +0100
Subject: RE: [PATCH] i2c-pnx: fix setting start/stop condition
Thread-Topic: [PATCH] i2c-pnx: fix setting start/stop condition
Thread-Index: Acq5OinTkiHnRe2HQ465261irqJZTQAMbFJg
Message-ID: <083DF309106F364B939360100EC290F805CCF9294A@eu1rdcrdc1wx030.exi.nxp.com>
References: <1267446264-8446-1-git-send-email-l.fu@pengutronix.de>
In-Reply-To: <1267446264-8446-1-git-send-email-l.fu@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.8161:2.4.5,1.2.40,4.0.166 definitions=2010-03-01_11:2010-02-06,2010-03-01,2010-03-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luotao,

> 
> The start/stop condtions are set in different places repetedly in the i2c-
> pnx
> driver.  Beside in i2c_pnx_start and i2c_pnx_stop the start/stop bit are
> also
> set during the transfer of a i2c message in the master_xmit/rcv calls.
> This is
> wrong since we can't set the start/stop condition during the transaction
> of a
> single message any way. As a matter of fact, the driver will sometimes set
> both
> the start and the stop bits at one time. This can be easily reproduced by
> sending a simple read request like e.g
> struct i2c_msg msgs[] = {
> { addr, 0, 1, buf },
> { addr, I2C_M_RD, offset, buf }
> };
> While processing the first message the i2c_pnx_master_xmit will set both
> the
> start_bit and the stop_bit, which will eventually confuse the slave.
> 
> Fixed by remove setting start/stop condition from the transmit routines.
> 
> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
> ---
>  drivers/i2c/busses/i2c-pnx.c |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
> index 5d1c260..92c0e46 100644
> --- a/drivers/i2c/busses/i2c-pnx.c
> +++ b/drivers/i2c/busses/i2c-pnx.c
> @@ -175,12 +175,6 @@ static int i2c_pnx_master_xmit(struct i2c_adapter
> *adap)
>  		/* We still have something to talk about... */
>  		val = *alg_data->mif.buf++;
> 
> -		if (alg_data->mif.len == 1) {
> -			val |= stop_bit;
> -			if (!alg_data->last)
> -				val |= start_bit;

Removing the start bit assertion here should be ok. The initial start
condition is setup as part of the start of the transfer when the addr
is sent out. The stop bit needs to stay or the I2C transfer will not
correctly terminate on the last byte out and you will end up with a
bus busy failure (clock low, data high) on the next transfer.

The stop_bit is used to indicate the end of the transfer for the I2C
controller. If it isn't used, the clock will stay low at the end
of the transfer after ACK (thinking more data still needs to be
transferred). If stop is enabled, an extra 1/2 clock is used to
reset the clock state back to high and the cycle is terminated
(dat and clk both high).

> -		}
> -
>  		alg_data->mif.len--;
>  		iowrite32(val, I2C_REG_TX(alg_data));
> 
> @@ -252,11 +246,6 @@ static int i2c_pnx_master_rcv(struct i2c_adapter
> *adap)
>  			"Rx-fifo...\n", __func__);
> 
>  		if (alg_data->mif.len == 1) {
> -			/* Last byte, do not acknowledge next rcv. */
> -			val |= stop_bit;

Likewise to TX, the stop bit needs to stay or the I2C transfer will
not correctly terminate on the last byte in.

 -			if (!alg_data->last)
> -				val |= start_bit;
> -
>  			/*
>  			 * Enable interrupt RFDAIE (data in Rx fifo),
>  			 * and disable DRMIE (need data for Tx)
> --
> 1.7.0

thanks,
Kevin
