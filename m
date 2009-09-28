Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbZI1O7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbZI1O7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 10:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbZI1O7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:59:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZI1O7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:59:16 -0400
Date: Mon, 28 Sep 2009 10:56:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com,
       jens.axboe@oracle.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20090928145655.GB8192@redhat.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com> <4ABC28DE.7050809@datenparkplatz.de> <20090925202636.GC15007@redhat.com> <4e5e476b0909271000u69d79346s27cccad219e49902@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0909271000u69d79346s27cccad219e49902@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 07:00:08PM +0200, Corrado Zoccolo wrote:
> Hi Vivek,
> On Fri, Sep 25, 2009 at 10:26 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Sep 25, 2009 at 04:20:14AM +0200, Ulrich Lukas wrote:
> >> Vivek Goyal wrote:
> >> > Notes:
> >> > - With vanilla CFQ, random writers can overwhelm a random reader.
> >> >   Bring down its throughput and bump up latencies significantly.
> >>
> >>
> >> IIRC, with vanilla CFQ, sequential writing can overwhelm random readers,
> >> too.
> >>
> >> I'm basing this assumption on the observations I made on both OpenSuse
> >> 11.1 and Ubuntu 9.10 alpha6 which I described in my posting on LKML
> >> titled: "Poor desktop responsiveness with background I/O-operations" of
> >> 2009-09-20.
> >> (Message ID: 4AB59CBB.8090907@datenparkplatz.de)
> >>
> >>
> >> Thus, I'm posting this to show that your work is greatly appreciated,
> >> given the rather disappointig status quo of Linux's fairness when it
> >> comes to disk IO time.
> >>
> >> I hope that your efforts lead to a change in performance of current
> >> userland applications, the sooner, the better.
> >>
> > [Please don't remove people from original CC list. I am putting them back.]
> >
> > Hi Ulrich,
> >
> > I quicky went through that mail thread and I tried following on my
> > desktop.
> >
> > ##########################################
> > dd if=/home/vgoyal/4G-file of=/dev/null &
> > sleep 5
> > time firefox
> > # close firefox once gui pops up.
> > ##########################################
> >
> > It was taking close to 1 minute 30 seconds to launch firefox and dd got
> > following.
> >
> > 4294967296 bytes (4.3 GB) copied, 100.602 s, 42.7 MB/s
> >
> > (Results do vary across runs, especially if system is booted fresh. Don't
> >  know why...).
> >
> >
> > Then I tried putting both the applications in separate groups and assign
> > them weights 200 each.
> >
> > ##########################################
> > dd if=/home/vgoyal/4G-file of=/dev/null &
> > echo $! > /cgroup/io/test1/tasks
> > sleep 5
> > echo $$ > /cgroup/io/test2/tasks
> > time firefox
> > # close firefox once gui pops up.
> > ##########################################
> >
> > Now I firefox pops up in 27 seconds. So it cut down the time by 2/3.
> >
> > 4294967296 bytes (4.3 GB) copied, 84.6138 s, 50.8 MB/s
> >
> > Notice that throughput of dd also improved.
> >
> > I ran the block trace and noticed in many a cases firefox threads
> > immediately preempted the "dd". Probably because it was a file system
> > request. So in this case latency will arise from seek time.
> >
> > In some other cases, threads had to wait for up to 100ms because dd was
> > not preempted. In this case latency will arise both from waiting on queue
> > as well as seek time.
> 
> I think cfq should already be doing something similar, i.e. giving
> 100ms slices to firefox, that alternate with dd, unless:
> * firefox is too seeky (in this case, the idle window will be too small)
> * firefox has too much think time.
> 

Hi Corrado,

"firefox" is the shell script to setup the environment and launch the
broser. It seems to be a group of threads. Some of them run in parallel
and some of these seems to be running one after the other (once previous
process or threads finished).


> To rule out the first case, what happens if you run the test with your
> "fairness for seeky processes" patch?

I applied that patch and it helps a lot.

http://lwn.net/Articles/341032/

With above patchset applied, and fairness=1, firefox pops up in 27-28
seconds.

So it looks like if we don't disable idle window for seeky processes on 
hardware supporting command queuing, it helps in this particular case.

Thanks
Vivek


 
> To rule out the second case, what happens if you increase the slice_idle?
> 
> Thanks,
> Corrado
> 
> >
> > With cgroup thing, We will run 100ms slice for the group in which firefox
> > is being launched and then give 100ms uninterrupted time slice to dd. So
> > it should cut down on number of seeks happening and that's why we probably
> > see this improvement.
> >
> > So grouping can help in such cases. May be you can move your X session in
> > one group and launch the big IO in other group. Most likely you should
> > have better desktop experience without compromising on dd thread output.
> 
> > Thanks
> > Vivek
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
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
