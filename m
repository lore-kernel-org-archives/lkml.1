Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbZIKXeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbZIKXeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 19:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbZIKXeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 19:34:24 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:57983 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbZIKXeY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 19:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FrLv5FT78Ptprf3C8tDG+zz+a4h7mkOBDjL+MlTJYf8NuOZeoiKHzdsKfFFdV20FOM
         WwFMbO1HHsQfyKMeZH0iUCW+cB5zUotCYI8DwM5XP2uXG4AXD1hsAi4jVPPSMBsMhaV1
         nf/B/0jsOXYCy2pKGjmW+CYCOGBJVDEByMCdA=
MIME-Version: 1.0
In-Reply-To: <1252613375.4837.121.camel@blackbox>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	 <1246410255-6839-6-git-send-email-adi@vmware.com>
	 <20090701110136.576a1d14@lxorguk.ukuu.org.uk>
	 <1246455920.9140.28.camel@blackbox>
	 <20090720182732.GL6370@hexapodia.org>
	 <1252609714.4837.87.camel@blackbox>
	 <1252612471.4837.107.camel@blackbox>
	 <1252612709.30578.219.camel@desktop>
	 <1252613375.4837.121.camel@blackbox>
Date: Sat, 12 Sep 2009 08:34:27 +0900
Message-ID: <f02dbbe70909111634q24df8746o8589394f7c30b28@mail.gmail.com>
Subject: Re: [PATCH] tpm_tis: TPM_STS_DATA_EXPECT workaround
From: Seiji Munetoh <seiji.munetoh@gmail.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Andy Isaacson <adi@hexapodia.org>,
       jmorris@namei.org, len.brown@intel.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Isaacson <adi@vmware.com>,
       linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
       dds@google.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 5:09 AM, Rajiv Andrade
<srajiv@linux.vnet.ibm.com> wrote:
> Some newer Lenovo models are shipped with a TPM that doesn't seem to set the TPM_STS_DATA_EXPECT status bit
> when sending it a burst of data, so the code understands it as a failure and doesn't proceed sending the chip
> the intended data. In this patch we bypass this bit check in case the itpm module parameter was set.
>
> This patch is based on Andy Isaacson's one:
>
> http://marc.info/?l=linux-kernel&m=124650185023495&w=2
>
> It was heavily discussed how should we deal with identifying the chip in kernel space, but the required
> patch to do so was NACK'd:
>
> http://marc.info/?l=linux-kernel&m=124650186423711&w=2
>
> This way we let the user choose using this workaround or not based on his
> observations on this code behavior when trying to use the TPM.
>
> Fixed a checkpatch issue present on the previous patch, thanks to Daniel Walker.
>
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

As far as I know, only the intel tpm has this PNP issue, so I'm fine with it.

Tested-by: Seiji Munetoh <seiji.munetoh@gmail.com>

> ---
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index aec1931..c9990db 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -257,6 +257,10 @@ out:
>        return size;
>  }
>
> +static int itpm;
> +module_param(itpm, bool, 0444);
> +MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
> +
>  /*
>  * If interrupts are used (signaled by an irq set in the vendor structure)
>  * tpm.c can skip polling for the data to be available as the interrupt is
> @@ -293,7 +297,7 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
>                wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
>                              &chip->vendor.int_queue);
>                status = tpm_tis_status(chip);
> -               if ((status & TPM_STS_DATA_EXPECT) == 0) {
> +               if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
>                        rc = -EIO;
>                        goto out_err;
>                }
> @@ -467,6 +471,10 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>                 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
>                 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
>
> +       if (itpm)
> +               dev_info(dev, "Intel iTPM workaround enabled\n");
> +
> +
>        /* Figure out the capabilities */
>        intfcaps =
>            ioread32(chip->vendor.iobase +
>
>
>
