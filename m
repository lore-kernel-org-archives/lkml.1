Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbZKDSyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbZKDSyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZKDSyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:54:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZKDSys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:54:48 -0500
Date: Wed, 4 Nov 2009 13:54:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time
	stamps
Message-ID: <20091104185402.GF2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-3-git-send-email-vgoyal@redhat.com> <x49d43yuzud.fsf@segfault.boston.devel.redhat.com> <20091104163752.GB2870@redhat.com> <4e5e476b0911040959t122df6aaqee1039f265cbd18a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911040959t122df6aaqee1039f265cbd18a@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 06:59:45PM +0100, Corrado Zoccolo wrote:
> On Wed, Nov 4, 2009 at 5:37 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
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
> should be 'process loses'
> 

Will fix it.

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
> >
> > Hence I took these difnitions from CFS.
> If those are times (measured in jiffies), why are you using u64? You
> could use unsigned long and time_before/time_after, that perform the
> proper wrap checking.
> 

This is virtual time and not exactly the jiffies. This can run faster than
real time. In current patchset there are two reasons for that.

- We assign minimum time slice used by queue as 1ms and queue if we expire
  the queue immediately after dispatching a request. So if we have really
  fast hardware and we decide not to idle, we will be doing queue switch
  very fast assigning each queue 1ms as slice used and vtime will be
  progressing much faster than real time.

- We shift real time by CFQ_SERVICE_SHIFT so that theoritically one can
  see service difference between weights x and x+1 for all values in the
  weight range of 1 to 1000. and not loose small difference in the division
  part.

  vtime calculation is as follows.

  vtime = (slice_used << CFQ_SERVICE_SHIFT )* DEFAUTL_WEIGHT/cfqe->weight

  minimum value of slice_used is 1 jiffy. DEFAULT WEIGHT is 500. So if one
  wants to get different vtime values for queue weights of 998 and 999, we
  need to shift slice used by atleast 12 bits. 

We are giving 12 bits shift to the real time, we are left with 20 bits on 32
bit hardware. So even if vtime does not run faster, in 1M jiffies (~ 1000
seconds) we will wrap around. I did some 4K sized direct IO on one of the
SSD and it achieve 7K io per second. In the worst case if these IO were
coming from two queues and we were interleaving the requests between these
then we will do 7 queue switch in 1ms. That means vtime travelling 7 times
faster and wrap around will take place in 1000/7 ~= 130 seconds. 

I thought that on 32bit hardware we are really close to pushing the
limits, hence I thought of continuing to use 64bit vdisktime/key instead
of a unsigned long one.

Thanks
Vivek
