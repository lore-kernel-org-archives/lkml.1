Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab0AOTcT (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 14:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080Ab0AOTcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 14:32:19 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:37181 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab0AOTcS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:32:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oJx6T184KeNqe0AQgx1l6KWZ/i2xm+Yf8HwUB+bx7VhpUfx9oxcvfmW3cAv/gYcuI/
         wsN4Fbsuo2wiCmBwYTNBnSLnayG947WXds7bzlYWRsCMaG7T1fbMQpuwdXeZnNG/Tkt6
         2CDFhn5WU8Rbube43A0t1NzHDdh27u1dpPI5M=
MIME-Version: 1.0
In-Reply-To: <1263264218.29897.41.camel@localhost>
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
	 <20091228084659.GA31389@sli10-desk.sh.intel.com>
	 <4e5e476b0912280111s6a977251m3416341b4bd2c272@mail.gmail.com>
	 <20091228092844.GA9710@sli10-desk.sh.intel.com>
	 <x493a2k8d7x.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b1001070544w88a387dkfb48847f4f95a9b1@mail.gmail.com>
	 <x49hbqy3s3m.fsf@segfault.boston.devel.redhat.com>
	 <1263187209.29897.33.camel@localhost>
	 <4e5e476b1001110705y6c3319ducf6a15c2a2be5670@mail.gmail.com>
	 <1263264218.29897.41.camel@localhost>
Date: Fri, 15 Jan 2010 20:32:10 +0100
Message-ID: <4e5e476b1001151132l406054f6xcc47b94e817d3af0@mail.gmail.com>
Subject: Re: [PATCH]cfq-iosched: don't take requests with long distence as 
	close
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 3:43 AM, Zhang, Yanmin
<yanmin_zhang@linux.intel.com> wrote:
> On Mon, 2010-01-11 at 16:05 +0100, Corrado Zoccolo wrote:
> > On Mon, Jan 11, 2010 at 6:20 AM, Zhang, Yanmin
> > <yanmin_zhang@linux.intel.com> wrote:
> > > On Thu, 2010-01-07 at 09:30 -0500, Jeff Moyer wrote:
> > Hi Yanmin,
> > are you testing Jeff's patch with your full fio script, instead of the
> > simplified one?
> Thanks for your reminder. I tested the patch with simplified one.
>
> > Since they are fixing the merging part, that happens only with the
> > full fio script.
> Ok. I tested the full fio script a moment ago and didn't find improvement.
> > >>
> > >> Shaohua Li noticed that cfq currently can merge with seeky queues, which
> > >> causes unwanted merge/unmerge activity.  We already know that the
> > >> cur_cfqq is not seeky, so this patch just makes sure that the non-seeky
> > >> queue is not merged with a seeky one.
> > >>
> > >> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> > >>
> > >> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > >> index 8df4fe5..3db9050 100644
> > >> --- a/block/cfq-iosched.c
> > >> +++ b/block/cfq-iosched.c
> > >> @@ -1677,6 +1677,10 @@ static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> > >>       return cfq_dist_from_last(cfqd, rq) <= sdist;
> > >>  }
> > >>
> > >> +/*
> > >> + * Search for a cfqq that is issuing non-seeky I/Os within the seek
> > >> + * mean of the current cfqq.
> > >> + */
> > >>  static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
> > >>                                   struct cfq_queue *cur_cfqq)
> > >>  {
> > >> @@ -1701,7 +1705,14 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
> > >>        * will contain the closest sector.
> > >>        */
> > >>       __cfqq = rb_entry(parent, struct cfq_queue, p_node);
> > >> -     if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
> > >> +     /*
> > >> +      * If the cfqq does not have enough seek samples, assume it is
> > >> +      * sequential until proven otherwise.  If it is assumed that the
> > >> +      * queue is seeky first, then the close cooperator detection logic
> > >> +      * may never trigger as one queue strays further from the other(s).
> > >> +      */
> > >> +     if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq) &&
> > >> +         (!sample_valid(__cfqq->seek_samples) || !CFQQ_SEEKY(__cfqq)))
> > >>               return __cfqq;
> > >>
> > >>       if (blk_rq_pos(__cfqq->next_rq) < sector)
> > >> @@ -1712,7 +1723,8 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
> > >>               return NULL;
> > >>
> > >>       __cfqq = rb_entry(node, struct cfq_queue, p_node);
> > >> -     if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
> > >> +     if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq) &&
> > >> +         (!sample_valid(__cfqq->seek_samples) || !CFQQ_SEEKY(__cfqq)))
> > >>               return __cfqq;
> > >>
> > >>       return NULL;
Hi Jeff,
I think this patch has the same flaw as Shaohua's.
The seekiness check that you introduce in cfq_rq_close is already
present in its caller, cfq_close_cooperator, so it is not effective.
Up to now, the only patch that improves this situation is the one that
changes the unmerge policy to unmerge after a single time slice.

Thanks,
Corado
