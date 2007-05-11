Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbXEKIMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbXEKIMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXEKIMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:12:08 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:1379 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751998AbXEKIMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:12:06 -0400
Date: Fri, 11 May 2007 10:12:31 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: adds support for i2c bus on 8xx
Message-ID: <20070511101231.241e3a30@hyperion.delvare>
In-Reply-To: <20070510143554.16c5df6a@localhost.localdomain>
References: <20070508063131.19179.47548.stgit@localhost.localdomain>
	<20070510112835.60fb1c2a@hyperion.delvare>
	<20070510143554.16c5df6a@localhost.localdomain>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

On Thu, 10 May 2007 14:35:54 +0400, Vitaly Bordug wrote:
> On Thu, 10 May 2007 11:28:35 +0200 Jean Delvare wrote:
> > On Tue, 08 May 2007 10:31:31 +0400, Vitaly Bordug wrote:
> > > Interface has been reworked to of_device as well as other feedback
> > > addressed. Repeated start ability is missing from the
> > > implementation.
> > 
> > Did you check the hardware documentation? Is it a hardware limitation?
> > It is likely to cause problems, so it should be investigated, and if
> > it really cannot be fixed, then this must be clearly documented (in
> > Kconfig and in the driver) and the advertised functionalities  of the
> > driver should be reduced accordingly (most SMBus transactions include
> > a repeated start.)
>
> Yes, I've checked RM about I2C controller, and cannot find anything about repeated
> start. There are a few words about multi-master considerations, that SoC features bus arbitration,
> but to avoid collisions, "higher-level handshake protocol must be used" (MPC885 RM, p. 32-6).

After reading the MPC885 RM datasheet, I think the device supports
repeated start. I guess that you simply need to _only_ set the
BD_SC_LAST flag for the last message of the transaction, not all of
them as the driver does. If I am correct, this should be fairly easy to
fix. Please try, test and report.

> > > +static int cpm_iic_init(struct i2c_adapter *adap)
> > > +{
> > > (...)
> > > +	/* Initialize Tx/Rx parameters.
> > > +	 */
> > > +	if (cpm->reloc == 0) {
> > > +		cpm8xx_t *cp = cpm->cp;
> > > +		int res;
> > > +
> > > +		u16 v = mk_cr_cmd(CPM_CR_CH_I2C, CPM_CR_INIT_TRX) | CPM_CR_FLG;
> > > +
> > > +		out_be16(&cp->cp_cpcr, v);
> > > +		res = wait_event_timeout(iic_wait,
> > > +					 !(in_be16(&cp->cp_cpcr) & CPM_CR_FLG),
> > > +					 HZ * 10);
> > 
> > This is a pretty long timeout. Can it realistically take that long?
>
> In fact, it can. Especially when CPM is loaded with Ethernet/UART/Etc
> transactions. If you feel it is overkill and I2C shouldn't do that,
> I'll trim it down though.

No, if you think it's reasonable, fine with me.

-- 
Jean Delvare
