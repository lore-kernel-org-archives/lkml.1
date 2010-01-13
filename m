Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007Ab0AMISw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0AMISw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 03:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785Ab0AMISv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 03:18:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:61731 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab0AMISu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 03:18:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=og3sEpm5gQcz5CCclyaDzvlsmqQegG2epaiL0NJMNaovX5+vljtNNA+MYRVkcC+Ob6
         jrw8nAMAWAuTbj/QBfTPGiVqADrfp+cSPOYm46OggUeJrTroPFsqV2I4gkXDXRly9i3P
         IW6ivoWsTvLvtUvBGjV0V9geceuf56800OgXc=
MIME-Version: 1.0
In-Reply-To: <20100113074442.GA10492@sli10-desk.sh.intel.com>
References: <20100113074442.GA10492@sli10-desk.sh.intel.com>
Date: Wed, 13 Jan 2010 09:18:47 +0100
Message-ID: <4e5e476b1001130018n2ad9e830s4a20d922abd4c7bb@mail.gmail.com>
Subject: Re: [PATCH]cfq-iosched: don't stop async queue with async requests 
	pending
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com,
       vgoyal@redhat.com, guijianfeng@cn.fujitsu.com,
       yanmin_zhang@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 8:44 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> My SSD speed of direct write is about 80m/s, while I test page writeback,
> the speed can only go to 68m/s. Below patch fixes this.
> It appears we missused cfq_should_idle in cfq_may_dispatch. cfq_should_idle
> means a queue should idle because it's seekless sync queue or it's the last queue,
> which is to maintain service tree time slice. So it doesn't mean the
> last queue is always a sync queue. If the last queue is asyn queue,
> we definitely shouldn't stop dispatch requests because of pending async
> requests.

An other option is that cfq_should_idle returns false for async
queues, since cfq will never idle on them.

Corrado
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 918c7fd..8198079 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2222,7 +2222,8 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>        /*
>         * Drain async requests before we start sync IO
>         */
> -       if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
> +       if (cfq_cfqq_sync(cfqq) && cfq_should_idle(cfqd, cfqq)
> +               && cfqd->rq_in_driver[BLK_RW_ASYNC])
>                return false;
>
>        /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
