Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276Ab0AFBTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0AFBTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 20:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021Ab0AFBTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 20:19:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:31365 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab0AFBTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 20:19:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,225,1262592000"; 
   d="scan'208";a="584628608"
From: "Li, Shaohua" <shaohua.li@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
CC: Corrado Zoccolo <czoccolo@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Date: Wed, 6 Jan 2010 09:19:26 +0800
Subject: RE: [PATCH]cfq-iosched: don't take requests with long distence as
 close
Thread-Topic: [PATCH]cfq-iosched: don't take requests with long distence as
 close
Thread-Index: AcqOTFF1rgzOp7AGT0malMzhwo5QAAAIMSRg
Message-ID: <C8EDE645B81E5141A8C6B2F73FD92651138B596F12@shzsmsx501.ccr.corp.intel.com>
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
	<4e5e476b0912250216n2b4aceacyf22a0e73425efd3a@mail.gmail.com>
	<20091228020348.GB28115@sli10-desk.sh.intel.com>
	<4e5e476b0912280036r6e55587dj66952fcd6ff4d08b@mail.gmail.com>
	<20091228084659.GA31389@sli10-desk.sh.intel.com>
	<4e5e476b0912280111s6a977251m3416341b4bd2c272@mail.gmail.com>
	<20091228092844.GA9710@sli10-desk.sh.intel.com>
 <x493a2k8d7x.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x493a2k8d7x.fsf@segfault.boston.devel.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o061KQ16012287



>-----Original Message-----
>From: Jeff Moyer [mailto:jmoyer@redhat.com]
>Sent: Wednesday, January 06, 2010 5:16 AM
>To: Li, Shaohua
>Cc: Corrado Zoccolo; linux-kernel@vger.kernel.org; jens.axboe@oracle.com;
>Zhang, Yanmin
>Subject: Re: [PATCH]cfq-iosched: don't take requests with long distence as
>close
>
>Shaohua Li <shaohua.li@intel.com> writes:
>
>> On Mon, Dec 28, 2009 at 05:11:25PM +0800, Corrado Zoccolo wrote:
>>> Hi Shaohua,
>>> On Mon, Dec 28, 2009 at 9:46 AM, Shaohua Li <shaohua.li@intel.com>
>wrote:
>>> > On Mon, Dec 28, 2009 at 04:36:39PM +0800, Corrado Zoccolo wrote:
>>> >> Hi Shaohua,
>>> >> On Mon, Dec 28, 2009 at 3:03 AM, Shaohua Li <shaohua.li@intel.com>
>wrote:
>>> >> > On Fri, Dec 25, 2009 at 06:16:27PM +0800, Corrado Zoccolo wrote:
>>> >> >> Hi Shaohua,
>>> >> >> On Thu, Dec 24, 2009 at 1:55 AM, Shaohua Li <shaohua.li@intel.com>
>wrote:
>>> >> >> > df5fe3e8e13883f58dc97489076bbcc150789a21
>>> >> >> > b3b6d0408c953524f979468562e7e210d8634150
>>> >> >> > The coop merge is too aggressive. For example, if two tasks are
>reading two
>>> >> >> > files where the two files have some adjecent blocks, cfq will
>immediately
>>> >> >> > merge them. cfq_rq_close() also has trouble, sometimes the
>seek_mean is very
>>> >> >> > big. I did a test to make cfq_rq_close() always checks the
>distence according
>>> >> >> > to CIC_SEEK_THR, but still saw a lot of wrong merge. (BTW, why
>we take a long
>>> >> >> > distence far away request as close. Taking them close doesn't
>improve any thoughtput
>>> >> >> > to me. Maybe we should always use CIC_SEEK_THR as close
>criteria).
>>> >> >> Yes, when deciding if two queues are going to be merged, we
>should use
>>> >> >> the constant CIC_SEEK_THR.
>>> >> >
>>> >> > seek_mean could be very big sometimes, using it as close criteria
>is meanless
>>> >> > as this doen't improve any performance. So if it's big, let's
>fallback to
>>> >> > default value.
>>> >>
>>> >> meanless -> meaningless (also in the comment within code)
>>> > oops
>>> >
>>> >> > Signed-off-by: Shaohua Li<shaohua.li@intel.com>
>>> >> >
>>> >> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>>> >> > index e2f8046..8025605 100644
>>> >> > --- a/block/cfq-iosched.c
>>> >> > +++ b/block/cfq-iosched.c
>>> >> > @@ -1682,6 +1682,10 @@ static inline int cfq_rq_close(struct
>cfq_data *cfqd, struct cfq_queue *cfqq,
>>> >> > Â  Â  Â  Â if (!sample_valid(cfqq->seek_samples))
>>> >> > Â  Â  Â  Â  Â  Â  Â  Â sdist = CFQQ_SEEK_THR;
>>> >> >
>>> >> > + Â  Â  Â  /* if seek_mean is big, using it as close criteria is
>meanless */
>>> >> > + Â  Â  Â  if (sdist > CFQQ_SEEK_THR)
>>> >> > + Â  Â  Â  Â  Â  Â  Â  sdist = CFQQ_SEEK_THR;
>>> >> > +
>>> >> > Â  Â  Â  Â return cfq_dist_from_last(cfqd, rq) <= sdist;
>>> >> > Â }
>>> >> >
>>> >> >
>>> >> This changes also the cfq_should_preempt behaviour, where a large
>>> >> seek_mean could be meaningful, so I think it is better to add a
>>> >> boolean parameter to cfq_rq_close, to distinguish whether we are
>>> >> preempting or looking for queue merges, and make the new code
>>> >> conditional on merging.
>>> > can you explain why it's meaningful for cfq_should_preempt()? Unless
>sdist is
>>> > very big, for example > 10*seek_mean, the preempt seems not
>meaningless.
>>>
>>> Disk access time is a complex function, but for rotational disks it is
>>> 'sort of' increasing with the amplitude of the seek. So, if you have a
>>> new request that is within the mean seek distance (even if it is
>>> larger than our constant), it is good to chose this request instead of
>>> waiting for an other one from the active queue (this behaviour is the
>>> same exhibited by AS, so we need a good reason to change).
>> I have no good reason, but just thought it's a little strange.
>> If other ioscheds take the same way, let's stick.
>>
>>
>> seek_mean could be very big sometimes, using it as close criteria is
>meaningless
>> as this doen't improve any performance. So if it's big, let's fallback
>to
>> default value.
>
>Sorry, I don't follow how you came to these conclusions.
>
>cfq_close_cooperator checks whether cur_cfqq is seeky:
>
>        if (CFQQ_SEEKY(cur_cfqq))
>                return NULL;
>
>So, by the time we get to the call to cfqq_close, we know that the
>passed-in cfqq has a seek_mean within the CFQQ_SEEK_THR.
>
>cfqq_close then calls cfq_rq_close with the non-seeky cfqq and the next
>request of the queue it is checking:
>
>        if (cfq_rq_close(cfqd, cur_cfqq, __cfqq->next_rq))
>
>So, it seems to me that the checks you added are superfluous.  How did
>you test this to ensure that your patch improved performance?  Your
>statement about testing above seems to indicate that you did not see any
>performance improvement.
>
>For now, I'm leaning towards asking Jens to revert this.  It may still
>be worth making sure that we don't merge a seeky queue with a non-seeky
>queue.  I have a patch for that if folks are interested.
Ha, yes, you are right. I did see some improvement on tiobench test,
but maybe it's from another patch (the split patch) or I checked an old
code. So please revert the patch.

Thanks,
Shaohua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
