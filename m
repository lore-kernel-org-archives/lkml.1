Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYDHIVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYDHIVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 04:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYDHIVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 04:21:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:28926 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYDHIVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 04:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jctOx/YX3R9Sn929EO1ru7Cx+ZJR8FxLpNEQPzIphvyLgBKV+C9twybmORPRXRe7PW5C0p6579Lh0zkq5lz+4s+dY2zdZGxZGkMAUGrxTvj8liTr8sZzX7VH7ZAh6Vd3Z7OL4ZenJj1t0ewtf5/0VOpnu/UrVpjI3xjciAAZwfY=
Message-ID: <b647ffbd0804080121l2bb1863fmb8ef85ec7d42b118@mail.gmail.com>
Date: Tue, 8 Apr 2008 10:21:34 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] mtd/chips: add missing set_current_state() to cfi_{amdstd,staa}_sync()
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080407161555.3dd540f9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1207251503.6300.9.camel@earth>
	 <20080407161555.3dd540f9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2008, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 03 Apr 2008 21:38:23 +0200
>  Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>
>  > From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
>  > Subject: [mtd/chips] add missing set_current_state() to cfi_{amdstd,staa}_sync()
>  >
>  > cfi_amdstd_sync() and cfi_staa_sync() call schedule() without changing
>  > task's state appropriately.
>  >
>  > In case of e.g. chip->state == FL_ERASING, cfi_*_sync() will be busy-looping
>  > either redundantly for a fixed interval of time (for SCHED_NORMAL tasks) or
>  > possibly endlessly (for RT tasks and UP).
>  >
>  > Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
>  >
>  > ---
>  >
>  > diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
>  > index d072e87..458d477 100644
>  > --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>  > +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>  > @@ -1763,6 +1763,7 @@ static void cfi_amdstd_sync (struct mtd_info *mtd)
>  >
>  >               default:
>  >                       /* Not an idle state */
>  > +                     set_current_state(TASK_UNINTERRUPTIBLE);
>  >                       add_wait_queue(&chip->wq, &wait);
>  >
>  >                       spin_unlock(chip->mutex);
>  > diff --git a/drivers/mtd/chips/cfi_cmdset_0020.c b/drivers/mtd/chips/cfi_cmdset_0020.c
>  > index b344ff8..492e2ab 100644
>  > --- a/drivers/mtd/chips/cfi_cmdset_0020.c
>  > +++ b/drivers/mtd/chips/cfi_cmdset_0020.c
>  > @@ -1015,6 +1015,7 @@ static void cfi_staa_sync (struct mtd_info *mtd)
>  >
>  >               default:
>  >                       /* Not an idle state */
>  > +                     set_current_state(TASK_UNINTERRUPTIBLE);
>  >                       add_wait_queue(&chip->wq, &wait);
>  >
>  >                       spin_unlock_bh(chip->mutex);
>
>
> The change certainly looks correct.  Has it been runtime tested?

It has been tested with an oldish 2.6.8.1 where the problem initially
occured. It was a RT task that happened to close an mtd fd (and
resulting in ->sync() being called) and ran in the middle of the
->erase op... resulting in a "nice" endless loop.

The versions of cfi_{amdstd,staa}_sync() in the mainline look not that
much different from the respective versions in 2.6.8.1.

I guess, it went unnoticed for so long time due to :

(1) apps. don't often directly open/close() fd for mtd partitions;
(2) a race against ->erase() (or smth else) is rare;
(3) if (1) is not true, then an app. is still unlikely to be RT (in
which case, a task just loops until its timeslice is gone).


>
>  Thanks.
>

-- 
Best regards,
Dmitry Adamushko
