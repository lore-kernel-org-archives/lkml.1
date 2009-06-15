Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbZFOM21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbZFOM21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZFOM2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:28:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53778 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZFOM2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:28:19 -0400
Subject: Re: [tpmdd-devel] TPM drivers support and Linux Integrity Module
 for 2.6.30
From: Eric Paris <eparis@redhat.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: dds =?UTF-8?Q?=28=E2=98=95=29?= <dds@google.com>, seiji.munetoh@gmail.com,
       tpmdd-devel@lists.sourceforge.net,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Shahbaz Khan <shaz.linux@gmail.com>
In-Reply-To: <1245007238.10712.5.camel@blackbox>
References: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com>
	 <1244817141.3401.7.camel@dyn9002018117.watson.ibm.com>
	 <4A3474BD.4000804@linux.vnet.ibm.com>
	 <b8394ab90906140015h793aaf51rb9b105910e61fa1@mail.gmail.com>
	 <1245007238.10712.5.camel@blackbox>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Jun 2009 08:28:14 -0400
Message-Id: <1245068894.3247.22.camel@dhcp231-142.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-14 at 16:20 -0300, Rajiv Andrade wrote:
> Hi David,
> 
> On Sun, 2009-06-14 at 16:15 +0900, dds (☕) wrote:
> > Hello, I'd been meaning to write about this.

I can't seem to find the mail from david in any archive, does anyone
have a pointer?

> > 
> > 
> > On Sun, Jun 14, 2009 at 12:55 PM, Rajiv Andrade
> > <srajiv@linux.vnet.ibm.com> wrote:
> >         Hi Mimi, thanks for copying us.
> >         
> >         Shaz,
> >         
> >         If this is the same chip we find in the GM45 boards, iTPM, the
> >         upstream
> >         driver won't work properly with it.
> >         Mainly because this iTPM returns the wrong status code when
> >         the driver
> >         didn't finish sending all bytes required for a specific
> >         command.
> >         As suggested by Seiji Munetoh in the tpmdd-devel sf mailing
> >         list, you
> >         can modify line 263 of tpm_tis.c as below:
> >         
> >         -               if ((status & TPM_STS_DATA_EXPECT) == 0) {
> >         +               if ((status & TPM_STS_VALID) == 0) {
> >         
> > 
> > This isn't unreasonable. In the block that should be executing there,
> > it's proper to check both, since VALID is an override for DATA_EXPECT.
> > See first patch.
> >  
> > 
> Actually, according to the TIS spec, VALID bit just ensures that the
> DATA_EXPECT bit value is correct, and isn't an override for that bit (if
> I got your point right).Basically you can only trust on DATA_EXPECT bit
> value if VALID bit is 1. What happens with the iTPM is that it says the
> DATA_EXPECT is valid but doesn't set its value to 1 when it should. What
> Seiji suggested was a bypass, since wait_for_stat() right above only
> returns (successfully) when the VALID bit to be set to 1. 'status &
> TPM_STS_VALID == 0' will always be false there. On the other hand we can
> check if it's an iTPM, and in case it's true, bypass that if statement.
> This is in the patch below.
> 
> Unfortunately I don't have such TPM in hands to get its manufacturer_id
> and finish the fix, can you help us here?

I have a Lenovo x200 with with iTPM for which I've been carrying patches
to make it work.  I added a printk (%d) in tpm_tis_init (along with
using the old TPM_STS_DATA_VALID patch instead of this one) to find out:

+#define ITPM_ID 1229870147


> @@ -581,7 +585,11 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>  
>  	tpm_get_timeouts(chip);
>  	tpm_continue_selftest(chip);
> -
> +	rc = tpm_getcap(chip->dev, TPM_CAP_PROP_MANUFACTURER, &cap,
> +			"attempting to determine if it's an Intel iTPM");
> +	

The line above has a tab.

> +	chip->manufacturer_id = (rc ? 0 : be32_to_cpu(cap.manufacturer_id));
> +	

The line above has a tab.

but my real problem is that the patch doesn't work!  We call tpm_getcap
to know if we should work around a tpm bug.

tpm_getcap->transmit_cmd->tpm_transmit->chip->vendor.send

which of course ends up in tpm_tis_send() but we needed that
manufacturer_id before tpm_tis_send can work!

Below is my dmesg output of a failed build.

[root@dhcp231-142 ~]# dmesg | grep -i tpm
[    0.945438] Platform driver 'tpm_tis' needs updating - please use dev_pm_ops
[    0.951161] tpm_tis tpm_tis: 1.2 TPM (device-id 0x1020, rev-id 6)
[    0.957171] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
[    0.963239] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
[    0.969190] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
[    0.975165] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
[    0.975369] tpm_tis_init: chip->manufacturer_id=0
[    1.097287] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5
[    1.097445] No TPM chip found, activating TPM-bypass!
[  110.859305] tpm_tis tpm_tis: tpm_transmit: tpm_send: error -5

See all the failed tpm calls before we set the manufacturer_id at time
0.975369?  (that printk is my own addition in tpm_tis_init)

But at least you know the manucaturer_id if it helps...

-Eric

