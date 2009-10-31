Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbZJaOYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbZJaOYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 10:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbZJaOYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 10:24:31 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:35998 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799AbZJaOYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 10:24:31 -0400
MIME-Version: 1.0
In-Reply-To: <b8394ab90910271945j10bd0aduda01cdc0610271f4@mail.gmail.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	 <1246455920.9140.28.camel@blackbox>
	 <20090720182732.GL6370@hexapodia.org>
	 <1252609714.4837.87.camel@blackbox>
	 <1252612471.4837.107.camel@blackbox>
	 <1252612709.30578.219.camel@desktop>
	 <1252613375.4837.121.camel@blackbox>
	 <f02dbbe70909111634q24df8746o8589394f7c30b28@mail.gmail.com>
	 <1253817781.8653.3.camel@dyn531367.br.ibm.com>
	 <b8394ab90910271945j10bd0aduda01cdc0610271f4@mail.gmail.com>
Date: Sat, 31 Oct 2009 10:24:34 -0400
Message-ID: <7e0fb38c0910310724i6f440b3dmc2a16920d2ef4900@mail.gmail.com>
Subject: Re: [PATCH] tpm_tis: TPM_STS_DATA_EXPECT workaround
From: Eric Paris <eparis@parisplace.org>
To: David Smith <david.daniel.smith@gmail.com>
Cc: tpmdd-devel@lists.sourceforge.net, Seiji Munetoh <seiji.munetoh@gmail.com>,
       akpm@linux-foundation.org, Daniel Walker <dwalker@fifo99.com>,
       Andy Isaacson <adi@hexapodia.org>, jmorris@namei.org,
       len.brown@intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andy Isaacson <adi@vmware.com>, linux-kernel@vger.kernel.org,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 10:45 PM, David Smith
<david.daniel.smith@gmail.com> wrote:
> Hi, can this be merged, please? Using the module parameter is not
> optimal but it's better than the complete lack of support today.
>
> On Fri, Sep 25, 2009 at 3:43 AM, Rajiv Andrade
> <srajiv@linux.vnet.ibm.com> wrote:
>> This was already tested and, given no more comments on it, finally
>> reviewed. Can it already be merged?

James can we get this merged?

Acked-by: Eric Paris <eparis@redhat.com>

>>
>> Thanks,
>> Rajiv
>>
>> On Sat, 2009-09-12 at 08:34 +0900, Seiji Munetoh wrote:
>>> On Fri, Sep 11, 2009 at 5:09 AM, Rajiv Andrade
>>> <srajiv@linux.vnet.ibm.com> wrote:
>>> > Some newer Lenovo models are shipped with a TPM that doesn't seem to set the TPM_STS_DATA_EXPECT status bit
>>> > when sending it a burst of data, so the code understands it as a failure and doesn't proceed sending the chip
>>> > the intended data. In this patch we bypass this bit check in case the itpm module parameter was set.
>>> >
>>> > This patch is based on Andy Isaacson's one:
>>> >
>>> > http://marc.info/?l=linux-kernel&m=124650185023495&w=2
>>> >
>>> > It was heavily discussed how should we deal with identifying the chip in kernel space, but the required
>>> > patch to do so was NACK'd:
>>> >
>>> > http://marc.info/?l=linux-kernel&m=124650186423711&w=2
>>> >
>>> > This way we let the user choose using this workaround or not based on his
>>> > observations on this code behavior when trying to use the TPM.
>>> >
>>> > Fixed a checkpatch issue present on the previous patch, thanks to Daniel Walker.
>>> >
>>> > Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
>>>
>>> As far as I know, only the intel tpm has this PNP issue, so I'm fine with it.
>>>
>>> Tested-by: Seiji Munetoh <seiji.munetoh@gmail.com>
>>>
>>> > ---
>>> > diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
>>> > index aec1931..c9990db 100644
>>> > --- a/drivers/char/tpm/tpm_tis.c
>>> > +++ b/drivers/char/tpm/tpm_tis.c
>>> > @@ -257,6 +257,10 @@ out:
>>> >        return size;
>>> >  }
>>> >
>>> > +static int itpm;
>>> > +module_param(itpm, bool, 0444);
>>> > +MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
>>> > +
>>> >  /*
>>> >  * If interrupts are used (signaled by an irq set in the vendor structure)
>>> >  * tpm.c can skip polling for the data to be available as the interrupt is
>>> > @@ -293,7 +297,7 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
>>> >                wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
>>> >                              &chip->vendor.int_queue);
>>> >                status = tpm_tis_status(chip);
>>> > -               if ((status & TPM_STS_DATA_EXPECT) == 0) {
>>> > +               if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
>>> >                        rc = -EIO;
>>> >                        goto out_err;
>>> >                }
>>> > @@ -467,6 +471,10 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>>> >                 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
>>> >                 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
>>> >
>>> > +       if (itpm)
>>> > +               dev_info(dev, "Intel iTPM workaround enabled\n");
>>> > +
>>> > +
>>> >        /* Figure out the capabilities */
>>> >        intfcaps =
>>> >            ioread32(chip->vendor.iobase +
>>> >
>>> >
>>> >
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
