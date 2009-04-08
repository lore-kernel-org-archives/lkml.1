Return-Path: <linux-kernel-owner+w=401wt.eu-S1764144AbZDHKRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764144AbZDHKRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbZDHKQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:16:45 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:65387 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbZDHKQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:16:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aJXl3O4iP+aCqnZBsyhf5rqPBZpZQb6uS87lp78Mx4OpIGw9M51URhYlCJrHjZl1qM
         k/6yO8Uyba72sxj8HCfCgP888xNr3dytd1sOWkSpmrI1a5ZZp/h2CLkWg8/GxMYvi5J2
         RQ0ASHmWt/zY8AT/raI6q8oEBAFPzkM19fq7k=
MIME-Version: 1.0
In-Reply-To: <1237823287-12734-5-git-send-email-philipp.reisner@linbit.com>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-2-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-3-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-4-git-send-email-philipp.reisner@linbit.com>
	 <1237823287-12734-5-git-send-email-philipp.reisner@linbit.com>
Date: Wed, 8 Apr 2009 15:46:42 +0530
Message-ID: <807b3a220904080316w54426d86jc4ba67ce9275edb8@mail.gmail.com>
Subject: Re: [PATCH 04/12] DRBD: request
From: Nikanth K <nikanth@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Nikanth Karthikesan <knikanth@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n38AHIqu028443

On Mon, Mar 23, 2009 at 9:17 PM, Philipp Reisner<philipp.reisner@linbit.com> wrote:<snip>
> +> +static inline struct drbd_request *drbd_req_new(struct drbd_conf *mdev,> +       struct bio *bio_src)> +{> +       struct bio *bio;> +       struct drbd_request *req => +               mempool_alloc(drbd_request_mempool, GFP_NOIO);> +       if (likely(req)) {> +               bio = bio_clone(bio_src, GFP_NOIO); /* XXX cannot fail?? */
I think, bio_clone can fail.

<snip>


> +#define OVERLAPS overlaps(sector, size, i->sector, i->size)> +               slot = tl_hash_slot(mdev, sector);> +               hlist_for_each_entry(i, n, slot, colision) {> +                       if (OVERLAPS) {> +                               ALERT("LOGIC BUG: completed: %p %llus +%u; "> +                                     "other: %p %llus +%u\n",> +                                     req, (unsigned long long)sector, size,> +                                     i, (unsigned long long)i->sector, i->size);> +                       }> +               }> +> +               /* maybe "wake" those conflicting epoch entries> +                * that wait for this request to finish.> +                *> +                * currently, there can be only _one_ such ee> +                * (well, or some more, which would be pending> +                * DiscardAck not yet sent by the asender...),> +                * since we block the receiver thread upon the> +                * first conflict detection, which will wait on> +                * misc_wait.  maybe we want to assert that?> +                *> +                * anyways, if we found one,> +                * we just have to do a wake_up.  */> +#undef OVERLAPS> +#define OVERLAPS overlaps(sector, size, e->sector, e->size)
These #defines can be removed? Or Can be parameterized and definedonly once. They are being defined and undefined repeatedly.
> +               slot = ee_hash_slot(mdev, req->sector);> +               hlist_for_each_entry(e, n, slot, colision) {> +                       if (OVERLAPS) {> +                               wake_up(&mdev->misc_wait);> +                               break;> +                       }> +               }> +       }> +#undef OVERLAPS> +}> +> +static void _complete_master_bio(struct drbd_conf *mdev,> +       struct drbd_request *req, int error)<snip>
> +> +STATIC int drbd_make_request_common(struct drbd_conf *mdev, struct bio *bio)> +{> +       const int rw = bio_rw(bio);> +       const int size = bio->bi_size;> +       const sector_t sector = bio->bi_sector;> +       struct drbd_barrier *b = NULL;> +       struct drbd_request *req;> +       int local, remote;> +       int err = -EIO;> +> +       /* allocate outside of all locks; */> +       req = drbd_req_new(mdev, bio);> +       if (!req) {> +               dec_ap_bio(mdev);> +               /* only pass the error to the upper layers.> +                * if user cannot handle io errors, thats not our business. */> +               ERR("could not kmalloc() req\n");> +               bio_endio(bio, -ENOMEM);> +               return 0;
Seems to be always returning zero and passing the error through thebio. So this could be changed to return void.
<snip>
> +> +int drbd_make_request_26(struct request_queue *q, struct bio *bio)
Always returns zero again.
<snip>
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)> +                               bio_split_pool,> +#endif
Could be removed for mainline inclusion.

ThanksNikanth���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
