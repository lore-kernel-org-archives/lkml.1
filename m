Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbYAWKck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbYAWKck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 05:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYAWKcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 05:32:33 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:1493 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751454AbYAWKcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:32:32 -0500
Date: Wed, 23 Jan 2008 11:29:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jon Smirl <jonsmirl@gmail.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCHv2] i2c: adds support for i2c bus on Frescale CPM1/CPM2 
 controllers
Message-ID: <20080123112941.23250948@hyperion.delvare>
In-Reply-To: <20080103104121.58697148.sfr@canb.auug.org.au>
References: <477BEB60.4070703@scram.de>
	<20080103104121.58697148.sfr@canb.auug.org.au>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jochen,

Sorry for the late answer.

On Thu, 3 Jan 2008 10:41:21 +1100, Stephen Rothwell wrote:
> Hi Jochen,
> 
> Just a few trivial things.
> 
> On Wed, 02 Jan 2008 20:52:00 +0100 Jochen Friedrich <jochen@scram.de> wrote:
> >
> > +++ b/drivers/i2c/busses/i2c-cpm.c
> > +
> > +static irqreturn_t cpm_i2c_interrupt(int irq, void *dev_id)
> > +{
> > +	struct i2c_adapter *adap;
> > +	struct cpm_i2c *cpm;
> > +	struct i2c_reg __iomem *i2c_reg;
> > +	int i;
> > +
> > +	adap = (struct i2c_adapter *) dev_id;
> 
> This cast is unnecessary. In fact, you could just pass dev_id to the
> following call to i2c_get_adapdata() and eliminate adap completely.
> 
> > +	/* Get 'me going again.
> > +	 */
> 
> For short comments, just make them one line.  Similarly later as well.
> 
> > +	/* This chip can't do zero length writes. However, the i2c core uses
> > +	   them to scan for devices. The best we can do is to convert them
> > +	   into 1 byte reads */
> 
> For multiline comments, we normally do
> /*
>  * blah ...
>  * more blah
>  */
> 
> > +static int cpm_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
> > +{
> > +
> > +	while (tptr < num) {
> > +		/* Check for outstanding messages */
> > +		dev_dbg(&adap->dev, "test ready.\n");
> > +		if (!(tbdf[tptr].cbd_sc & BD_SC_READY)) {
> > +			dev_dbg(&adap->dev, "ready.\n");
> > +			rmsg = &msgs[tptr];
> > +			ret = cpm_i2c_check_message(adap, rmsg, tptr, rptr);
> > +			tptr++;
> > +			if (rmsg->flags & I2C_M_RD)
> > +				rptr++;
> > +			if (ret) {
> > +				cpm_i2c_force_close(adap);
> > +				mutex_unlock(&cpm->i2c_mutex);
> > +				return ret;
> > +			}
> > +		} else {
> > +			dev_dbg(&adap->dev, "not ready.\n");
> > +			ret = wait_event_interruptible_timeout(cpm->i2c_wait,
> > +				!(tbdf[tptr].cbd_sc & BD_SC_READY), 1 * HZ);
> > +			if (ret == 0) {
> > +				cpm_i2c_force_close(adap);
> > +				dev_dbg(&adap->dev, "I2C read: timeout!\n");
> > +				mutex_unlock(&cpm->i2c_mutex);
> > +				return -EREMOTEIO;
> > +			}
> 
> You might want to consolidate the two error paths above using gotos to an
> error return section below.
> 
> > +static void of_register_i2c_devices(struct i2c_adapter *adap,
> > +				    struct device_node *adap_node)
> > +{
> > +	struct device_node *node = NULL;
> > +
> > +	while ((node = of_get_next_child(adap_node, node))) {
> 
> Use
> 	for_each_child_of_node(adap_node, node) {
> instead and you don't need to initialise "node" above.
> 
> > +static struct of_device_id cpm_i2c_match[] = {
> 
> const?

Do you have an updated patch addressing Stephen's comment?

Note: you'd rather send updates of this patch to the i2c list rather
than LKML.

Thanks,
-- 
Jean Delvare
