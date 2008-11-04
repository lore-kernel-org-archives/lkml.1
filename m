Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbYKDWoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbYKDWoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYKDWoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:44:08 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:11653 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbYKDWoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:44:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X7x4H9Ld52yvqNydEwhszZ0KrIMTV2rEdVyjHLe//mD35d3Hv/y/nVwwaCjUnSMMPq
         o2R6kWh3KNfs1u1/gmzHa/nyUbMQ7Kbyj/2cx2nIyUpsIswTeM//+H3ZFv2WQ1n6Hvh2
         j8tZGpZifGP2/qlpQELfQ4SAOzt0eh4bQSSkE=
Message-ID: <7a9b5c320811041444y7e3e3f3alb85d1e6d046c6a22@mail.gmail.com>
Date: Wed, 5 Nov 2008 11:44:03 +1300
From: "Phillip O'Donnell" <phillip.odonnell@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: Avoid overflow in ata_tf_read_block() when tf->hba_lbal > 127
In-Reply-To: <7a9b5c320811041441q78920938q58ed7ab3cbe97253@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081028170105.GA21933@osk.mine.nu>
	 <7a9b5c320810281625kbf8904x9ba432ff0ca8c2f8@mail.gmail.com>
	 <ada4p2wmg5n.fsf_-_@cisco.com>
	 <7a9b5c320810281904x6b8b3226uaba502146be854a7@mail.gmail.com>
	 <adatzantk53.fsf_-_@cisco.com>
	 <7a9b5c320811041441q78920938q58ed7ab3cbe97253@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Roland,

Right now, my observations indicate that my original fault occurs when
a command (of any type, e.g, read or flush ... ) times out, which
should trigger the sense routines. Next thing I need to do is add some
debug code to identify whether this only occurs if the timeout happens
on a sector above 2^31.

I've identified a reasonably reliable testcase for my fault, so I'll
add that patch and see if it occurs.

I'll let you know how it pans out.

Cheers,
Phillip

On Wed, Nov 5, 2008 at 7:34 AM, Roland Dreier <rdreier@cisco.com> wrote:
>
> Phillip O'Donnell <phillip.odonnell@gmail.com> pointed out that the same
> sign extension bug that was fixed in commit ba14a9c2 ("libata: Avoid
> overflow in ata_tf_to_lba48() when tf->hba_lbal > 127") also appears to
> exist in ata_tf_read_block().  Fix this by adding a cast to u64.
>
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
> I don't have any way to test this -- I guess you would have to get an
> error on a block above 2G (ie data above 1TB)?  But it looks "obviously
> correct" enough to add to -next I guess.
>
>  drivers/ata/libata-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 622350d..a6ad862 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -612,7 +612,7 @@ u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev)
>                if (tf->flags & ATA_TFLAG_LBA48) {
>                        block |= (u64)tf->hob_lbah << 40;
>                        block |= (u64)tf->hob_lbam << 32;
> -                       block |= tf->hob_lbal << 24;
> +                       block |= (u64)tf->hob_lbal << 24;
>                } else
>                        block |= (tf->device & 0xf) << 24;
>
