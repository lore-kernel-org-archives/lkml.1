Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbZLOH3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbZLOH3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbZLOH3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:29:22 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33350 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbZLOH3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:29:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=STBP2OSlNIkEwVDNre6PpKU9z4ZO2MSOix1EyNtpkSQD8tb5Uh0TPY7m97VUg23O9U
         r9dU/ImCrtGobaR0sLEDhZl1aq2eHu7/R/s5GPcmSPQkYC6OFHU9FhXxetKO7n27Tt5D
         aqcFlsh0XYuuf+3+tUSpcADAtCkLSJv+ykXJs=
MIME-Version: 1.0
In-Reply-To: <1260797602-7476-1-git-send-email-Vishnu@freescale.com>
References: <1260797602-7476-1-git-send-email-Vishnu@freescale.com>
Date: Tue, 15 Dec 2009 00:29:20 -0700
X-Google-Sender-Auth: 8e63984068ea036a
Message-ID: <e9c3a7c20912142329j6603402ah2963d075419efa1c@mail.gmail.com>
Subject: Re: [PATCH v0] Crypto: Talitos: re-initialize async_tx descriptors
From: Dan Williams <dan.j.williams@intel.com>
To: Vishnu Suresh <Vishnu@freescale.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
       herbert@gondor.apana.org.au, B04825@freescale.com, R58472@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 6:33 AM, Vishnu Suresh <Vishnu@freescale.com> wrote:
> The async_tx descriptors contains dangling pointers.
> Hence, re-initialize them to NULL before use.
>
> Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> ---
> o. Rebased to linux-next as of 20091214
>
>  drivers/crypto/talitos.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 87f06be..9e261c6 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -952,6 +952,9 @@ static struct dma_async_tx_descriptor * talitos_prep_dma_xor(
>                return NULL;
>        }
>        dma_async_tx_descriptor_init(&new->async_tx, &xor_chan->common);
> +       new->async_tx.parent = NULL;
> +       new->async_tx.next = NULL;
> +
>
>        desc = &new->hwdesc;
>        /* Set destination: Last pointer pair */

These two values are owned by the async_tx api, drivers are not
supposed to touch them.  Both iop_adma and the new ppx4xx driver
(which use the async_tx channel switching capability) get away without
touching these fields which makes me suspect there is a
misunderstanding/bug somewhere else in the talitos implementation.
Also that dma_async_tx_descriptor_init() is unexpected in the hot
path, it's only needed at initial descriptor allocation.  End result I
think this driver needs some more time to brew.

--
Dan
