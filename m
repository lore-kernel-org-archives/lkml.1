Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbZFEPwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbZFEPwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZFEPw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:52:28 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:54967 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZFEPw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:52:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YT4RvdILV9yD35v3hIKB6cOwA6IydOG6kyA/6M/YMkwUG4O0vIWbdU8LkyFJQ7jvde
         CHRXjbS3FuTB2d4qBzcBy1M/7koDkLn4n/I2upQ49uP5qJriYRFCqoOiHftLW89dcjfZ
         5U3FOb0l399Xa/TaMkbgxGyr6iUBzQOzfygKE=
MIME-Version: 1.0
In-Reply-To: <20090605104132.GE24836@amd.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	 <20090605104132.GE24836@amd.com>
Date: Fri, 5 Jun 2009 17:52:27 +0200
Message-ID: <64bb37e0906050852g2be64c7elb2872a6129d13f56@mail.gmail.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com,
       bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 12:41 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> From c0baa4d43a674c9cc321af3b23a6d5c9b46d65bd Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Fri, 5 Jun 2009 12:01:35 +0200
> Subject: [PATCH] dma-debug: change hash_bucket_find from first-fit to best-fit
>
> Some device drivers map the same physical address multiple times to a
> dma address. Without an IOMMU this results in the same dma address being
> put into the dma-debug hash multiple times. With a first-fit match in
> hash_bucket_find() this function may return the wrong dma_debug_entry.
> This can result in false positive warnings. This patch fixes it by
> changing the first-fit behavior of hash_bucket_find() into a best-fit
> algorithm.
>
> Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> Reported-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  lib/dma-debug.c |   43 +++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 39 insertions(+), 4 deletions(-)
>
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 69da09a..2b16536 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -185,15 +185,50 @@ static void put_hash_bucket(struct hash_bucket *bucket,
>  static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
>                                                struct dma_debug_entry *ref)
>  {
> -       struct dma_debug_entry *entry;
> +       struct dma_debug_entry *entry, *ret = NULL;
> +       int matches = 0, match_lvl, last_lvl = 0;
>
>        list_for_each_entry(entry, &bucket->list, list) {
> -               if ((entry->dev_addr == ref->dev_addr) &&
> -                   (entry->dev == ref->dev))
> +               if ((entry->dev_addr != ref->dev_addr) ||
> +                   (entry->dev != ref->dev))
> +                       continue;
> +
> +               /*
> +                * Some drivers map the same physical address multiple
> +                * times. Without a hardware IOMMU this results in the
> +                * same device addresses being put into the dma-debug
> +                * hash multiple times too. This can result in false
> +                * positives being reported. Therfore we implement a
> +                * best-fit algorithm here which returns the entry from
> +                * the hash which fits best to the reference value
> +                * instead of the first-fit.
> +                */
> +               matches += 1;
> +               match_lvl = 0;
> +               entry->size      == ref->size      ? ++match_lvl : match_lvl;
> +               entry->type      == ref->type      ? ++match_lvl : match_lvl;
> +               entry->direction == ref->direction ? ++match_lvl : match_lvl;
> +
> +               if (match_lvl == 3) {
> +                       /* perfect-fit - return the result */
>                        return entry;
> +               } else if (match_lvl > last_lvl) {
> +                       /*
> +                        * We found an entry that fits better then the
> +                        * previous one
> +                        */
> +                       last_lvl = match_lvl;
> +                       ret      = entry;
> +               }
>        }
>
> -       return NULL;
> +       /*
> +        * If we have multiple matches but no perfect-fit, just return
> +        * NULL.
> +        */
> +       ret = (matches == 1) ? ret : NULL;

This doesn't look right to me.
The comment above says "returns the entry from the hash which fits
best", but this will always return NULL, if there are are multiple
entrys, but no perfect match.

On a wrong unmap that would result in "DMA-API: device driver tries to
free DMA memory it has not allocated" instead of a report what kind of
mismatches happend.

Or did you mean to return NULL if there are more then one matches at
the last_lvl? Then a matches=1; is missing from the "found an entry"
block.

Should there be a warning if more then one possible match were found?

* driver maps address 'a' with size 1
* driver maps same address 'a' with size 2
* driver wrongly unmaps the second allocation with size 1
  -> no warning, because the first allocation is returned
* driver wants to correctly unmap the first allocation
  -> wrong warning about this unmap because size mismatch

Also what about sg_call_ents and sg_mapped_ents?
Could it be possible to get the same address/size with different sg-counts.

As in my case most of the warnings where about a wrong unmap count and
only a few about the memory size, that seems possible.

For reference, here part of the warnings from my system:

Wrong count:
Jun  5 03:32:58 treogen [   51.469720] sata_sil24 0000:04:00.0:
DMA-API: device driver frees DMA sg list with different entry count
[map count=1] [unmap count=2]
Jun  5 03:32:58 treogen [   51.469725] Modules linked in: msp3400
tuner tea5767 tda8290 tuner_xc2028 xc
5000 tda9887 tuner_simple tuner_types mt20xx tea5761 bttv ir_common
v4l2_common videodev v4l1_compat v4
l2_compat_ioctl32 videobuf_dma_sg videobuf_core btcx_risc tveeprom sg pata_amd
Jun  5 03:32:58 treogen [   51.469771] Pid: 0, comm: swapper Not
tainted 2.6.30-rc7 #1
Jun  5 03:32:58 treogen [   51.469775] Call Trace:
Jun  5 03:32:58 treogen [   51.469779]  <IRQ>  [<ffffffff8041755e>] ?
check_unmap+0x65e/0x6a0
Jun  5 03:32:58 treogen [   51.469797]  [<ffffffff802432d8>]
warn_slowpath_common+0x78/0xd0
Jun  5 03:32:58 treogen [   51.469804]  [<ffffffff802433b4>]
warn_slowpath_fmt+0x64/0x70
Jun  5 03:32:58 treogen [   51.469816]  [<ffffffff8028dd42>] ?
mempool_free_slab+0x12/0x20
Jun  5 03:32:58 treogen [   51.469828]  [<ffffffff8068d74d>] ?
_spin_lock_irqsave+0x1d/0x40
Jun  5 03:32:58 treogen [   51.469835]  [<ffffffff8041755e>]
check_unmap+0x65e/0x6a0
Jun  5 03:32:58 treogen [   51.469842]  [<ffffffff804176ae>]
debug_dma_unmap_sg+0x10e/0x1b0

Wrong size:
Jun  3 06:50:33 treogen [  276.421432] sata_sil24 0000:04:00.0:
DMA-API: device driver frees DMA memory with different size [device
address=0x000000007b590000] [map size=16384 bytes] [unmap size=12288
bytes]
                                     Jun  3 06:50:33 treogen [
276.421438] Modules linked in: msp3400 tuner tea5767 tda8290
tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761
bttv ir_common v4l2_common videodev v4l1_compat v4l2_compat_ioctl32
videobuf_dma_sg videobuf_core btcx_risc sg pata_amd tveeprom
Jun  3 06:50:33 treogen [  276.421480] Pid: 1301, comm: kcryptd Not
tainted 2.6.30-rc7 #1
Jun  3 06:50:33 treogen [  276.421485] Call Trace:
Jun  3 06:50:33 treogen [  276.421490]  <IRQ>  [<ffffffff80417355>] ?
check_unmap+0x455/0x6a0
Jun  3 06:50:33 treogen [  276.421507]  [<ffffffff802432d8>]
warn_slowpath_common+0x78/0xd0
Jun  3 06:50:33 treogen [  276.421514]  [<ffffffff802433b4>]
warn_slowpath_fmt+0x64/0x70
Jun  3 06:50:33 treogen [  276.421524]  [<ffffffff8028dd42>] ?
mempool_free_slab+0x12/0x20
Jun  3 06:50:33 treogen [  276.421535]  [<ffffffff8068d74d>] ?
_spin_lock_irqsave+0x1d/0x40
Jun  3 06:50:33 treogen [  276.421542]  [<ffffffff80417355>]
check_unmap+0x455/0x6a0
Jun  3 06:50:33 treogen [  276.421549]  [<ffffffff804176ae>]
debug_dma_unmap_sg+0x10e/0x1b0

> +
> +       return ret;
>  }
>
>  /*
> --
> 1.6.3.1
>
>
>
>
> --
>           | Advanced Micro Devices GmbH
>  Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
>  System    |
>  Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
>  Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
>           | Registergericht München, HRB Nr. 43632
>
>
