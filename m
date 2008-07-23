Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYGWHBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYGWHBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYGWHBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:01:37 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:37409 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYGWHBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OmKXmFmal8k+QcAwQjKf661Cme2C/3jBrsMqVOwjcjJyzXxs2GbATk17x+vpeMwoaY
         kqR5RtylLtL8AAdf7QLYkUEkASKM4q57OJpn32kBoO1gmm+6axiXZA2qytWl2T2ZPghB
         GcBdUUPqQL+pYgBhsfdlMrw480TH9X5v3ACOk=
Message-ID: <74d0deb30807230001x176e375cq9a8060c20596f36f@mail.gmail.com>
Date: Wed, 23 Jul 2008 09:01:34 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 44/47] pxamci: fix byte aligned DMA transfers
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, "Willy Tarreau" <w@1wt.eu>,
       "Rodrigo Rubira Branco" <rbranco@la.checkpoint.com>,
       "Jake Edge" <jake@lwn.net>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Pierre Ossman" <drzeus@drzeus.cx>
In-Reply-To: <20080722231735.GS8282@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080722230208.148102983@mini.kroah.org>
	 <20080722231342.GA8282@suse.de> <20080722231735.GS8282@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 23, 2008 at 1:17 AM, Greg KH <gregkh@suse.de> wrote:
> 2.6.25-stable review patch.  If anyone has any objections, please let us
> know.

There is an ugly typo in the patch below that was fixed by Karl Beldan:
http://git.kernel.org/?p=linux/kernel/git/drzeus/mmc.git;a=commit;h=28bbe535df5c461c25eb57affb30e007072429c3

Not sure how you handle this, maybe this patch should only go in
together with the other.

> ------------------
> From: Philipp Zabel <philipp.zabel@gmail.com>
>
> commit 97f8571e663c808ad2d01a396627235167291556 upstream
>
> The pxa27x DMA controller defaults to 64-bit alignment. This caused
> the SCR reads to fail (and, depending on card type, error out) when
> card->raw_scr was not aligned on a 8-byte boundary.
>
> For performance reasons all scatter-gather addresses passed to
> pxamci_request should be aligned on 8-byte boundaries, but if
> this can't be guaranteed, byte aligned DMA transfers in the
> have to be enabled in the controller to get correct behaviour.
>
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  drivers/mmc/host/pxamci.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> --- a/drivers/mmc/host/pxamci.c
> +++ b/drivers/mmc/host/pxamci.c
> @@ -114,6 +114,7 @@ static void pxamci_setup_data(struct pxa
>        unsigned int nob = data->blocks;
>        unsigned long long clks;
>        unsigned int timeout;
> +       bool dalgn = 0;
>        u32 dcmd;
>        int i;
>
> @@ -152,6 +153,9 @@ static void pxamci_setup_data(struct pxa
>                host->sg_cpu[i].dcmd = dcmd | length;
>                if (length & 31 && !(data->flags & MMC_DATA_READ))
>                        host->sg_cpu[i].dcmd |= DCMD_ENDIRQEN;
> +               /* Not aligned to 8-byte boundary? */
> +               if (sg_dma_address(&data->sg[i]) & 0x7)
> +                       dalgn = 1;
>                if (data->flags & MMC_DATA_READ) {
>                        host->sg_cpu[i].dsadr = host->res->start + MMC_RXFIFO;
>                        host->sg_cpu[i].dtadr = sg_dma_address(&data->sg[i]);
> @@ -165,6 +169,15 @@ static void pxamci_setup_data(struct pxa
>        host->sg_cpu[host->dma_len - 1].ddadr = DDADR_STOP;
>        wmb();
>
> +       /*
> +        * The PXA27x DMA controller encounters overhead when working with
> +        * unaligned (to 8-byte boundaries) data, so switch on byte alignment
> +        * mode only if we have unaligned data.
> +        */
> +       if (dalgn)
> +               DALGN |= (1 << host->dma);
> +       else
> +               DALGN &= (1 << host->dma);
                         ^^^^^ here

>        DDADR(host->dma) = host->sg_dma;
>        DCSR(host->dma) = DCSR_RUN;
>  }
>
> --
>

regards
Philipp
