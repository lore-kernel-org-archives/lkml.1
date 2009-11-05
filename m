Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbZKEOkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbZKEOkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbZKEOkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:40:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055AbZKEOkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:40:09 -0500
Date: Thu, 5 Nov 2009 09:39:14 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Divyesh Shah <dpshah@google.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, nauman@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time
	stamps
Message-ID: <20091105143914.GC4001@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-3-git-send-email-vgoyal@redhat.com> <x49d43yuzud.fsf@segfault.boston.devel.redhat.com> <20091104163752.GB2870@redhat.com> <af41c7c40911041844v2905a9c6vb9d0649faf060726@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af41c7c40911041844v2905a9c6vb9d0649faf060726@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 06:44:28PM -0800, Divyesh Shah wrote:
> On Wed, Nov 4, 2009 at 8:37 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Nov 04, 2009 at 09:30:34AM -0500, Jeff Moyer wrote:
> >> Vivek Goyal <vgoyal@redhat.com> writes:
> >>
> >
> > Thanks for the review Jeff.
> >
> >> > o Currently CFQ provides priority scaled time slices to processes. If a process
> >> >   does not use the time slice, either because process did not have sufficient
> >> >   IO to do or because think time of process is large and CFQ decided to disable
> >> >   idling, then processes looses it time slice share.
> >>                            ^^^^^^
> >> loses
> >>
> >
> > Will fix it.
> >
> >> > o One possible way to handle this is implement CFS like time stamping of the
> >> >   cfq queues and keep track of vtime. Next queue for execution will be selected
> >> >   based on the one who got lowest vtime. This patch implemented time stamping
> >> >   mechanism of cfq queues based on disk time used.
> >> >
> >> > o min_vdisktime represents the minimum vdisktime of the queue, either being
> >>                                                           ^^^^^
> >> >   serviced or leftmost element on the serviec tree.
> >>
> >> queue or service tree?  The latter seems to make more sense to me.
> >
> > Yes, it should be service tree. Will fix it.
> >
> >>
> >> > +static inline u64
> >> > +cfq_delta_fair(unsigned long delta, struct cfq_queue *cfqq)
> >> > +{
> >> > +   const int base_slice = cfqq->cfqd->cfq_slice[cfq_cfqq_sync(cfqq)];
> >> > +
> >> > +   return delta + (base_slice/CFQ_SLICE_SCALE * (cfqq->ioprio - 4));
> >> > +}
> >>
> >> cfq_scale_delta might be a better name.
> >>
> >
> > cfq_scale_delta sounds good. Will use it in next version.
> >
> >>
> >> > +static inline u64 max_vdisktime(u64 min_vdisktime, u64 vdisktime)
> >> > +{
> >> > +   s64 delta = (s64)(vdisktime - min_vdisktime);
> >> > +   if (delta > 0)
> >> > +           min_vdisktime = vdisktime;
> >> > +
> >> > +   return min_vdisktime;
> >> > +}
> >> > +
> >> > +static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
> >> > +{
> >> > +   s64 delta = (s64)(vdisktime - min_vdisktime);
> >> > +   if (delta < 0)
> >> > +           min_vdisktime = vdisktime;
> >> > +
> >> > +   return min_vdisktime;
> >> > +}
> >>
> >> Is there a reason you've reimplemented min and max?
> >
> > I think you are referring to min_t and max_t. Will these macros take care
> > of wrapping too?
> >
> > For example, if I used min_t(u64, A, B), then unsigned comparision will
> > not work right wrapping has just taken place for any of the A or B. So if
> > A=-1 and B=2, then min_t() would return B as minimum. This is not right
> > in our case.
> >
> > If we do signed comparison (min_t(s64, A, B)), that also seems to be
> > broken in another case where a value of variable moves from 63bits to 64bits,
> > (A=0x7fffffffffffffff, B=0x8000000000000000). Above will return B as minimum but
> > in our scanario, vdisktime will progress from 0x7fffffffffffffff to
> > 0x8000000000000000 and A should be returned as minimum (unsigned
> > comparison).
> 
> Can you define and use u64 versions of time_before() and time_after()
> (from include/linux/jiffies.h) for your comparisons? These take care
> of wrapping as well. Maybe call them timestamp_before()/after().
> 
> >
> > Hence I took these difnitions from CFS.
> 
> Also if these are exactly the same and you decide to continue using
> these, can we move them to a common header file (time.h or maybe add a
> vtime.h) and reuse?
> 

Ok. I will look into it. Sharing the function between CFS scheduler and
CFQ scheduler.

Thanks
Vivek
