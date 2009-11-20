Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbZKTSol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbZKTSol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbZKTSok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:44:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZKTSok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:44:40 -0500
Date: Fri, 20 Nov 2009 13:42:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091120184257.GG5872@redhat.com>
References: <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail> <20091118153227.GA5796@redhat.com> <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com> <20091118225626.GA2974@redhat.com> <4e5e476b0911181535y4d73d381s14b54c6d787d2b46@mail.gmail.com> <20091120141840.GA5872@redhat.com> <4e5e476b0911200628g42a0ab6ftd65b68bff5d1aea3@mail.gmail.com> <20091120150421.GC5872@redhat.com> <4e5e476b0911201032j5319b012v5fd0a64ebfe11089@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0911201032j5319b012v5fd0a64ebfe11089@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 07:32:28PM +0100, Corrado Zoccolo wrote:
> On Fri, Nov 20, 2009 at 4:04 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Nov 20, 2009 at 03:28:27PM +0100, Corrado Zoccolo wrote:
> >> Hi Vivek,
> >> On Fri, Nov 20, 2009 at 3:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > Hi Corrado,
> >> >
> >> > I liked the idea of putting all the sync-noidle queues together in root
> >> > group to achieve better throughput and implemeted a small patch.
> >> >
> >> > It works fine for random readers. But when I do multiple direct random writers
> >> > in one group vs a random reader in other group, I am getting strange
> >> > behavior. Random reader moves to root group as sync-noidle workload. But
> >> > random writers are largely sync queues in remain in other group. But many
> >> > a times also jump into root group and preempt random reader.
> >>
> >> can you try the attached patches?
> >> They fix the problems you identified about no-idle preemption, and
> >> deep seeky queues.
> >> With those, you should not see this jumping any more.
> >> I'll send them to Jens as soon has he comes back from vacation.
> >>
> >> Corrado
> >>
> >> > Anyway, with 4 random writers and 1 random reader running for 30 seconds
> >> > in root group I get following.
> >> >
> >> > rw: 59,963KB/s
> >> > rr: 66KB/s
> >> >
> >> > But if these are put in seprate groups test1 and test2 then
> >> >
> >> > rw: 30,587KB/s
> >> > rr: 23KB/s
> >> >
> >
> > I quickly tried your new patches to try to keep idling enabled on deep
> > seeky sync queues so that it does not jump around too much and consume
> > share both in sync workload and sync-noidle workload.
> >
> > Here are new results.
> >
> > Without cgroup.
> >
> > rw: 58,571KB/s
> > rr: 83KB/s
> >
> > With cgroup:
> >
> > rw: 32,525KB/s
> > rr: 25KB/s
> >
> > So without cgroup it looks like that random reader gained a bit and that's
> > a good thing.
> 
> Great.

Should we also take into account the "cfqq->dispatched" request in
determining whether we should enable idling on deep queue random seeky
readers?

Adding that helps me a bit in cgroup setup but I still see sync seeky random
writers switching between sync and sync-noidle so frequently. 

In fact I think that's part of the reason why it is slow. Out of 4, 1 
random seeky reader will switch group so often and then will not drive
the enough queue depth. Rest of them seem to be running in other group.

In fact sometimes this same writer will jump to second group, get the time
slice and then jump back to root group and then again get the time slice
in sync-noidle category. This will preempt the reader in root group at the
same time will not drive higher queue depths as rest of the writers are
in other groups.

So frequent switching of type of random seeky reqder queue from
sync --> sync-noidle--->sync seems to be one of the hurting factors.

But when I started taking cfqq->dispatched also in account, share of
random writers increased when running without cgroups. So it is kind of
puzzling.

But in general, we need to stablize the type of a queue and it should
not vary so fast, given the fact nature of the workload/queue has not
changed.

> > With cgroup, problem still persists. I am wondering why both are loosing.
> > Looks like I am idling somewhere otherwise at least one person should have
> > gained.
> With just 2 groups (one is the root), you can't be idling 50% of the
> time. How is the disk utilization during the test?
> 

How do I measure the utilization of the array?

> Note that you can lose even if you're not idling enough.
> How does this workload fare with noop or deadline.
> Thanks
> Corrado
> 
> >
> > Thanks
> > Vivek
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
