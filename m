Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZKWPVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZKWPVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZKWPVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:21:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbZKWPVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:21:32 -0500
Date: Mon, 23 Nov 2009 10:19:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091123151946.GA3112@redhat.com>
References: <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com> <20091118225626.GA2974@redhat.com> <4e5e476b0911181535y4d73d381s14b54c6d787d2b46@mail.gmail.com> <20091120141840.GA5872@redhat.com> <4e5e476b0911200628g42a0ab6ftd65b68bff5d1aea3@mail.gmail.com> <20091120150421.GC5872@redhat.com> <4e5e476b0911201032j5319b012v5fd0a64ebfe11089@mail.gmail.com> <20091120184257.GG5872@redhat.com> <4e5e476b0911201150p7cbdfc20k4b8d02f07e16abc8@mail.gmail.com> <4e5e476b0911210957g5b099329u33fa6ec4d740f7d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0911210957g5b099329u33fa6ec4d740f7d1@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 06:57:47PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Fri, Nov 20, 2009 at 8:50 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> > On Fri, Nov 20, 2009 at 7:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >>
> >> Should we also take into account the "cfqq->dispatched" request in
> >> determining whether we should enable idling on deep queue random seeky
> >> readers?
> >
> > Probably, but I think the most important thing is to do some averaging
> > or hysteresis, so the completion of a single request doesn't cause the
> > switch of a workload.
> 
> can you test the new version of the idling patch?
> I register the fact that the queue had a large depth in a flag, that
> is reset only when the idle times out (so at the end of the burst).
> Idling is enabled if that flag is set (and think time is acceptable).
> This should fix the switching behaviour you observed.
> 
> I decided to not count cfqq->dispatched to determine the depth.
> In this way, when all queues in the system are random the idling is
> enabled only if the requests queue builds up faster than it can be
> consumed.

Hi Corrado,

This patch seems to be working much better in marking the random writer
queue as sync and not interefere with sync-noidle workload.

So frequent migration of random writer queue across group has stopped.

But there seems to be a different issue now after sometime, random writer
queue stops generating enough traffic and gets deleted after one request
and root group now runs random reader for sometime. So it basically
changes the ratio in which random writers and random readers get disk 
share.

I guess part of the dependency comes from kjournald which is in root
group. But there is something else too because I don't see this happening
when there are no cgroups. I will do more debugging on this.

Thanks
Vivek
