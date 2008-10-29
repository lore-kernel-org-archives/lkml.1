Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbYJ2CE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbYJ2CE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 22:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYJ2CEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 22:04:20 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:2725 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYJ2CET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 22:04:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pqg/UARbzfQUWlyDZQiicfR8CCX7nb0w0VX8ANKnPszGVuwLxVLidcwjVT54OP3LIj
         QZbgWE34dxGS5u05+lOKs+Ozfk7QXd+lbFSlMyjR63/5iEUYjm3wTJqC7fOWUOGsDzYa
         QW7pdaDAZVyXzYfzPQEJqtNqRcX0DmRKqIB6w=
Message-ID: <7a9b5c320810281904x6b8b3226uaba502146be854a7@mail.gmail.com>
Date: Wed, 29 Oct 2008 15:04:17 +1300
From: "Phillip O'Donnell" <phillip.odonnell@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [PATCH] libata: Avoid overflow in ata_tf_to_lba48() when tf->hba_lbal > 127
Cc: jeff@garzik.org, "Oskar Liljeblad" <oskar@osk.mine.nu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <ada4p2wmg5n.fsf_-_@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081028170105.GA21933@osk.mine.nu>
	 <7a9b5c320810281625kbf8904x9ba432ff0ca8c2f8@mail.gmail.com>
	 <ada4p2wmg5n.fsf_-_@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Roland,

Sure thing - I'll give that a try tonight.

Just had a cursory glance over libata-core.c and I've noticed that
ata_tf_read_block() uses hob_lbal in the same uncast fashion for LBA48
- reckon that one needs patching too?

Only seems to be used in libata-scsi.c within ata_gen_ata_sense()

Cheers,
Phillip

On Wed, Oct 29, 2008 at 12:52 PM, Roland Dreier <rdreier@cisco.com> wrote:
> In ata_tf_to_lba48(), when evaluating
>
>        (tf->hob_lbal & 0xff) << 24
>
> the expression is promoted to signed int (since int can hold all values
> of u8).  However, if hob_lbal is 128 or more, then it is treated as a
> negative signed value and sign-extended when promoted to u64 to | into
> sectors, which leads to the MSB 32 bits of section getting set
> incorrectly.
>
> For example, Phillip O'Donnell <phillip.odonnell@gmail.com> reported
> that a 1.5GB drive caused:
>
>    ata3.00: HPA detected: current 2930277168, native 18446744072344861488
>
> where 2930277168 == 0xAEA87B30 and 18446744072344861488 == 0xffffffffaea87b30
> which shows the problem when hob_lbal is 0xae.
>
> Fix this by adding a cast to u64, just as is used by for hob_lbah and
> hob_lbam in the function.
>
> Reported-by: Phillip O'Donnell <phillip.odonnell@gmail.com>
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
> Phillip, this should fix at least your cosmetic issue; can you test it
> and report back?
>
> Thanks,
>  Roland
>
>  drivers/ata/libata-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index bbb3cae..10424ff 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -1268,7 +1268,7 @@ u64 ata_tf_to_lba48(const struct ata_taskfile *tf)
>
>        sectors |= ((u64)(tf->hob_lbah & 0xff)) << 40;
>        sectors |= ((u64)(tf->hob_lbam & 0xff)) << 32;
> -       sectors |= (tf->hob_lbal & 0xff) << 24;
> +       sectors |= ((u64)(tf->hob_lbal & 0xff)) << 24;
>        sectors |= (tf->lbah & 0xff) << 16;
>        sectors |= (tf->lbam & 0xff) << 8;
>        sectors |= (tf->lbal & 0xff);
>
