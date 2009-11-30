Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbZK3PgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbZK3PgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZK3PgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:36:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbZK3PgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:36:05 -0500
Date: Mon, 30 Nov 2009 10:36:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: Make use of service count to estimate the rb_key
	offset
Message-ID: <20091130153604.GB11670@redhat.com>
References: <4B0E1E2F.9080604@cn.fujitsu.com> <4e5e476b0911260108s2fe4cd86lcb32c7be76b4f75c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911260108s2fe4cd86lcb32c7be76b4f75c@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 10:08:36AM +0100, Corrado Zoccolo wrote:
> Hi Gui, Jens
> On Thu, Nov 26, 2009 at 7:20 AM, Gui Jianfeng
> <guijianfeng@cn.fujitsu.com> wrote:
> > Hi Jens, Czoccolo
> >
> > For the moment, different workload cfq queues are put into different
> > service trees. But CFQ still uses "busy_queues" to estimate rb_key
> > offset when inserting a cfq queue into a service tree. I think this
> > isn't appropriate, and it should make use of service tree count to do
> > this estimation. This patch is for for-2.6.33 branch.
> 
> In cfq_choose_wl, we rely on consistency of rb_keys across service
> trees to compute the next workload to be serviced.
>         for (i = 0; i < 3; ++i) {
>                 /* otherwise, select the one with lowest rb_key */
>                 queue = cfq_rb_first(service_tree_for(prio, i, cfqd));
>                 if (queue &&
>                     (!key_valid || time_before(queue->rb_key, lowest_key))) {
>                         lowest_key = queue->rb_key;
> 			cur_best = i;
> 			key_valid = true;
> 		}
>         }
> 
> If you change how the rb_key is computed (so it is no longer
> consistent across service trees) without changing how it is used can
> introduce problems.
> 

Hi Corrado,

currently rb_key seems to be combination of two things. busy_queues and
jiffies. 

In new scheme, where we decide the share of a workload and then switch to
new workload, dependence on busy_queues does not seem to make much sense.

Assume, a bunch of sequential readers get backlogged and then few random
readers gets backlogged. Now random reader will get higher rb_key because
there are 8 sequential reders on sync-idle tree.

IIUC, with above logic, even if we expire the sync-idle workload duration
once, we might not switch to sync-noidle workload and start running the
sync-idle workload again. (Because minimum slice length restrictions or
if low_latency is not set).

So instead of relying on rb_keys to switch the workload type, why not do
it in round robin manner across the workload types? So rb_key will be
significant only with-in service tree and not across service tree? 

Thanks
Vivek

> Thanks,
> Corrado
> 
> >
> > Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> > ---
> >  block/cfq-iosched.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index 1bcbd8c..467981e 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -600,11 +600,15 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >  static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
> >                                      struct cfq_queue *cfqq)
> >  {
> > +       struct cfq_rb_root *service_tree;
> > +
> > +       service_tree = service_tree_for(cfqq_prio(cfqq), cfqq_type(cfqq), cfqd);
> > +
> >        /*
> >         * just an approximation, should be ok.
> >         */
> > -       return (cfqd->busy_queues - 1) * (cfq_prio_slice(cfqd, 1, 0) -
> > -                      cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
> > +       return  service_tree->count * (cfq_prio_slice(cfqd, 1, 0) -
> > +                  cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
> >  }
> >
> >  /*
> > --
> > 1.5.4.rc3
> >
> > --
> > Regards
> > Gui Jianfeng
> >
> >
> 
> 
> 
> -- 
> __________________________________________________________________________
> 
> dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
> PhD - Department of Computer Science - University of Pisa, Italy
> --------------------------------------------------------------------------
> The self-confidence of a warrior is not the self-confidence of the average
> man. The average man seeks certainty in the eyes of the onlooker and calls
> that self-confidence. The warrior seeks impeccability in his own eyes and
> calls that humbleness.
>                                Tales of Power - C. Castaneda
