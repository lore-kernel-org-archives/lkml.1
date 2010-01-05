Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379Ab0AEPOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0AEPOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450Ab0AEPOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:14:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab0AEPOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:14:00 -0500
Date: Tue, 5 Jan 2010 10:13:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue
	merging
Message-ID: <20100105151353.GA4631@redhat.com>
References: <20091230213439.GQ4489@kernel.dk> <1262211768-10858-1-git-send-email-czoccolo@gmail.com> <20100104144711.GA7968@redhat.com> <4e5e476b1001040836p2c8d7486x807a1a89b61c2458@mail.gmail.com> <x49wrzxak5n.fsf@segfault.boston.devel.redhat.com> <4e5e476b1001041037x6aa63be6ncfa523a7df78bb0d@mail.gmail.com> <20100104185100.GF7968@redhat.com> <x49fx6ladzk.fsf@segfault.boston.devel.redhat.com> <4e5e476b1001041237v71952c8ewaaef3778353f7521@mail.gmail.com> <x49zl4s8uoj.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <x49zl4s8uoj.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 09:58:52AM -0500, Jeff Moyer wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
> 
> > On Mon, Jan 4, 2010 at 8:04 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> >> Vivek Goyal <vgoyal@redhat.com> writes:
> >>>> >>> Hi Corrado,
> >>>> >>>
> >>>> >>> What's the reason that reads don't benefit from merging queues and hence
> >>>> >>> merging requests and only writes do on SSD?
> >>>> >>
> >>>> >> On SSDs, reads are just limited by the maximum transfer rate, and
> >>>> >> larger (i.e. merged) reads will just take proportionally longer.
> >>>> >
> >>>> > This is simply not true.  You can get more bandwidth from an SSD (I just
> >>>> > checked numbers for 2 vendors' devices) by issuing larger read requests,
> >>>> > no matter whether the access pattern is sequential or random.
> >>>> I know, but the performance increase given the size is sublinear, and
> >>>> the situation here is slightly different.
> >>>> In order for the requests to be merged, they have to be submitted concurrently.
> >>>> So you have to compare 2 concurrent requests of size x with one
> >>>> request of size 2*x (with some CPU overhead).
> >>>> Moreover, you always pay the CPU overhead, even if you can't do the
> >>>> merging, and you must be very lucky to keep merging, because it means
> >>>> the two processes are working in lockstep; it is not sufficient that
> >>>> the requests are just nearby, as for rotational disks.
> >>>>
> >>>
> >>> For jeff, at least "dump" utility threads were kind of working in lockstep
> >>> for writes and he gained significantly by merging these queues together.
> >>
> >> Actually, it was for reads.
> >>
> >>> So the argument is that CPU overhead saving in this case is more substantial
> >>> as compared to gains made by lockstep read threads. I think we shall have to
> >>> have some numbers to justify that.
> >>
> >> Agreed.  Corrado, I know you don't have the hardware, so I'll give this
> >> a run through the read-test2 program and see if it regresses at all.
> > Great.
> 
> I ran the test program 50 times, and here are the results:
> 
> ==> vanilla <==
> Mean: 163.22728
> Population Std. Dev.: 0.55401
> 
> ==> patched <==
> Mean: 162.91558
> Population Std. Dev.: 1.08612
> 
> This looks acceptable to me.

Thanks Jeff, one thing comes to mind. Now with recent changes, we drive deeper
depths on SSD with NCQ and there are not many pending cfqq on service tree
until and unless number of parallel threads exceed NCQ depth (32). If
that's the case, then I think we might not be seeing lot of queue merging
happening in this test case until and unless dump utility is creating more
than 32 threads.

If time permits, it might also be interesting to run the same test with queue
depth 1 and see if SSDs without NCQ will suffer or not.

Thanks
Vivek
