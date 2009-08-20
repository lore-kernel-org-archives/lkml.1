Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZHTLxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZHTLxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZHTLxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:53:50 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:40098 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZHTLxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f4yycm62/1i7R7ooCybSexZfoIMjS6qfHhpV22pBwgv1IT46LF8O0BtDqJcrgNOOxS
         vq2OsubUsEOuo8Lkrr+X+WFJpAodZgI5jchJUqRLSB/8K4H5JwGL6OmNY/TVlvrdhIBo
         IoFW46j6U+bROB5iDb6BH6D9dCQdpdqFZA3N8=
MIME-Version: 1.0
In-Reply-To: <200908182159.n7ILxX3d013229@hera.kernel.org>
References: <200908182159.n7ILxX3d013229@hera.kernel.org>
Date: Thu, 20 Aug 2009 13:53:51 +0200
X-Google-Sender-Auth: 50a87bafba92640e
Message-ID: <10f740e80908200453p726acd5bpac49068f0492249a@mail.gmail.com>
Subject: Re: zorro8390: Fix read buffer overflow in zorro8390_init_one()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 23:59, Linux Kernel Mailing
List<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/be12159b24c532b4b48bdec5a543336438faa132
> Commit:     be12159b24c532b4b48bdec5a543336438faa132
> Parent:     5e33b719c8fcccfedc1d25167826a0f93fe6c5a1
> Author:     roel kluin <roel.kluin@gmail.com>
> AuthorDate: Sun Aug 9 04:00:25 2009 +0000
> Committer:  David S. Miller <davem@davemloft.net>
> CommitDate: Sun Aug 9 21:46:53 2009 -0700
>
>    zorro8390: Fix read buffer overflow in zorro8390_init_one()
>
>    Prevent read from cards[-1] when no card was found.
>
>    Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/zorro8390.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/zorro8390.c b/drivers/net/zorro8390.c
> index 37c84e3..81c753a 100644
> --- a/drivers/net/zorro8390.c
> +++ b/drivers/net/zorro8390.c
> @@ -120,6 +120,9 @@ static int __devinit zorro8390_init_one(struct zorro_dev *z,
>     for (i = ARRAY_SIZE(cards)-1; i >= 0; i--)
>        if (z->id == cards[i].id)
>            break;
> +    if (i < 0)
> +        return -ENODEV;
> +
>     board = z->resource.start;
>     ioaddr = board+cards[i].offset;
>     dev = alloc_ei_netdev();

That case can never happen, as zorro8390_init_one() won't be called
without a matching ID.

But probably the information in struct card_info should be stored in
zorro8390_zorro_tbl[].driver_data,
so we can remove cards[] and the look up.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
