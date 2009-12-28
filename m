Return-Path: <linux-kernel-owner+w=401wt.eu-S1751454AbZL1JLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbZL1JLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbZL1JLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:11:30 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44746 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZL1JLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:11:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=loxonYEcGn0XhYDI8+Q7OK7gdc8WRYqLU2R1LC19Rtl5WKiRhQwrfBDAF9E8cUtBHE
         cSVZlVGot/GR/011I3iP2ULJjkEYOeii9Sjct73Ax089a9U7DVDqG5LdAisONAIgIGFV
         n5tpdkBxzZWPdCDIiMoRVzp57OrRBVnLOFQG0=
MIME-Version: 1.0
In-Reply-To: <20091228084659.GA31389@sli10-desk.sh.intel.com>
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
	 <4e5e476b0912250216n2b4aceacyf22a0e73425efd3a@mail.gmail.com>
	 <20091228020348.GB28115@sli10-desk.sh.intel.com>
	 <4e5e476b0912280036r6e55587dj66952fcd6ff4d08b@mail.gmail.com>
	 <20091228084659.GA31389@sli10-desk.sh.intel.com>
Date: Mon, 28 Dec 2009 10:11:25 +0100
Message-ID: <4e5e476b0912280111s6a977251m3416341b4bd2c272@mail.gmail.com>
Subject: Re: [PATCH]cfq-iosched: don't take requests with long distence as 
	close
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua,
On Mon, Dec 28, 2009 at 9:46 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Mon, Dec 28, 2009 at 04:36:39PM +0800, Corrado Zoccolo wrote:
>> Hi Shaohua,
>> On Mon, Dec 28, 2009 at 3:03 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > On Fri, Dec 25, 2009 at 06:16:27PM +0800, Corrado Zoccolo wrote:
>> >> Hi Shaohua,
>> >> On Thu, Dec 24, 2009 at 1:55 AM, Shaohua Li <shaohua.li@intel.com> wrote:
>> >> > df5fe3e8e13883f58dc97489076bbcc150789a21
>> >> > b3b6d0408c953524f979468562e7e210d8634150
>> >> > The coop merge is too aggressive. For example, if two tasks are reading two
>> >> > files where the two files have some adjecent blocks, cfq will immediately
>> >> > merge them. cfq_rq_close() also has trouble, sometimes the seek_mean is very
>> >> > big. I did a test to make cfq_rq_close() always checks the distence according
>> >> > to CIC_SEEK_THR, but still saw a lot of wrong merge. (BTW, why we take a long
>> >> > distence far away request as close. Taking them close doesn't improve any thoughtput
>> >> > to me. Maybe we should always use CIC_SEEK_THR as close criteria).
>> >> Yes, when deciding if two queues are going to be merged, we should use
>> >> the constant CIC_SEEK_THR.
>> >
>> > seek_mean could be very big sometimes, using it as close criteria is meanless
>> > as this doen't improve any performance. So if it's big, let's fallback to
>> > default value.
>>
>> meanless -> meaningless (also in the comment within code)
> oops
>
>> > Signed-off-by: Shaohua Li<shaohua.li@intel.com>
>> >
>> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> > index e2f8046..8025605 100644
>> > --- a/block/cfq-iosched.c
>> > +++ b/block/cfq-iosched.c
>> > @@ -1682,6 +1682,10 @@ static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>> >        if (!sample_valid(cfqq->seek_samples))
>> >                sdist = CFQQ_SEEK_THR;
>> >
>> > +       /* if seek_mean is big, using it as close criteria is meanless */
>> > +       if (sdist > CFQQ_SEEK_THR)
>> > +               sdist = CFQQ_SEEK_THR;
>> > +
>> >        return cfq_dist_from_last(cfqd, rq) <= sdist;
>> >  }
>> >
>> >
>> This changes also the cfq_should_preempt behaviour, where a large
>> seek_mean could be meaningful, so I think it is better to add a
>> boolean parameter to cfq_rq_close, to distinguish whether we are
>> preempting or looking for queue merges, and make the new code
>> conditional on merging.
> can you explain why it's meaningful for cfq_should_preempt()? Unless sdist is
> very big, for example > 10*seek_mean, the preempt seems not meaningless.

Disk access time is a complex function, but for rotational disks it is
'sort of' increasing with the amplitude of the seek. So, if you have a
new request that is within the mean seek distance (even if it is
larger than our constant), it is good to chose this request instead of
waiting for an other one from the active queue (this behaviour is the
same exhibited by AS, so we need a good reason to change).

This is reasonable for chosing the next request, but not to determine
if two queues have to be merged (since they can depart soon), so my
suggestion is to differentiate using a parameter.

>
> Thanks,
> Shaohua
>

Thanks
Corrado
