Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbZKDRIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbZKDRIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757179AbZKDRIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:08:09 -0500
Received: from smtp-out.google.com ([216.239.33.17]:38853 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbZKDRII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:08:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=TFW72a6hrYWLNvnt6lNTisVdeYPIkuDYp4pBnU0enZZTaxjg8m2H4iDKKOSLGDVao
	8V/2EITMctfXHp8lgKong==
MIME-Version: 1.0
In-Reply-To: <20091104154135.GA2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> 
	<1257291837-6246-4-git-send-email-vgoyal@redhat.com> <x498wemuy6v.fsf@segfault.boston.devel.redhat.com> 
	<20091104154135.GA2870@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Wed, 4 Nov 2009 09:07:41 -0800
Message-ID: <af41c7c40911040907y11103944ief0654f84ffdf5ed@mail.gmail.com>
Subject: Re: [PATCH 03/20] blkio: Introduce the notion of weights
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, nauman@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 7:41 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Nov 04, 2009 at 10:06:16AM -0500, Jeff Moyer wrote:
> > Vivek Goyal <vgoyal@redhat.com> writes:
> >
> > > o Introduce the notion of weights. Priorities are mapped to weights internally.
> > >   These weights will be useful once IO groups are introduced and group's share
> > >   will be decided by the group weight.
> >
> > I'm sorry, but I need more background to review this patch.  Where do
> > the min and max come from?  Why do you scale 7-0 from 200-900?  How does
> > this map to what was there before (exactly, approximately)?
> >
>
> Well, So far we only have the notion of iopriority for the process and
> based on that we determine time slice length.
>
> Soon we will throw cfq groups also in the mix. Because cpu IO controller
> is weight driven, people have shown preference that group's share should
> be decided based on its weight and not introduce the notion of ioprio for
> groups.
>
> So now core scheduling algorithm only recognizes weights for entities (be it
> cfq queues or cfq groups), and it is required that we convert the ioprio
> of cfqq into weight.
>
> Now it is a matter of coming up with what weight range do we support and
> how ioprio should be mapped onto these weights. We can always change the
> mappings but to being with, I have followed following.
>
> Allow a weight range from 100 to 1000. Allowing too small a weights like
> "1", can lead to very interesting corner cases and I wanted to avoid that
> in first implementation. For example, if some group with weight "1" gets
> a time slice of 100ms, its vtime will be really high and after that it
> will not get scheduled in for a very long time.
>
> Seconly allowing too small a weights can make vtime of the tree move very
> fast with faster wrap around of min_vdistime. (especially on SSD where idling
> might not be enabled, and for every queue expiry we will attribute minimum of
> 1ms of slice. If weight of the group is "1" it will higher vtime and
> min_vdisktime will move very fast). We don't want too fast a wrap around
> of min_vdisktime (especially in case of idle tree. That infrastructure is
> not part of current patches).
>
> Hence, to begin with I wanted to limit the range of weights allowed because
> wider range opens up lot of interesting corner cases. That's why limited
> minimum weight to 100. So at max user can expect the 1000/100=10 times service
> differentiation between highest and lower weight groups. If folks need more
> than that, we can look into it once things stablize.

We definitely need the 1:100 differentiation. I'm ok with adding that
later after the core set of patches stabilize but just letting you
know that it is important to us. Also curious why you chose a higher
range 100-1000 instead of 10-100? For smaller vtime leaps?

>
> Priority and weights follow reverse order. Higher priority means low
> weight and vice-versa.
>
> Currently we support 8 priority levels and prio "4" is the middle point.
> Anything higher than prio 4 gets 20% less slice as compared to prio 4 and
> priorities lower than 4, get 20% higher slice of prio 4 (20% higher/lower
> for each priority level).
>
> For weight range 100 - 1000, 500 can be considered as mid point. Now this
> is how priority mapping looks like.
>
>        100 200 300 400 500 600 700 800 900 1000  (Weights)
>             7   6   5   4   3   2  1   0         (io prio).
>
> Once priorities are converted to weights, we are able to retain the notion
> of 20% difference between prio levels by choosing 500 as the mid point and
> mapping prio 0-7 to weights 900-200, hence this mapping.
>
> I am all ears if you have any suggestions on how this ca be handled
> better.
>
> Thanks
> Vivek
