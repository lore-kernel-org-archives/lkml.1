Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbYKMSmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbYKMSmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 13:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYKMSmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 13:42:05 -0500
Received: from smtp-out.google.com ([216.239.45.13]:30451 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYKMSmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 13:42:03 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=dOXO1lY9OUvkuKOX9exue1qTAxbRS6rgX3DJkeN71NUd0O+3XLnOnXhD0Fn1JvqZD
	aMRfih/cJThFJ+yqQM6zw==
MIME-Version: 1.0
In-Reply-To: <20081113155834.GE7542@redhat.com>
References: <20081106153022.215696930@redhat.com>
	 <20081113.180558.519459540419535699.ryov@valinux.co.jp>
	 <20081113155834.GE7542@redhat.com>
Date: Thu, 13 Nov 2008 10:41:57 -0800
Message-ID: <af41c7c40811131041t1b8491b6la5574ebe75f89000@mail.gmail.com>
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
From: Divyesh Shah <dpshah@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       taka@valinux.co.jp, righi.andrea@gmail.com, s-uchida@ap.jp.nec.com,
       fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com,
       akpm@linux-foundation.org, menage@google.com, ngupta@google.com,
       riel@redhat.com, jmoyer@redhat.com, peterz@infradead.org,
       Fabio Checconi <fchecconi@gmail.com>, paolo.valente@unimore.it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 7:58 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Nov 13, 2008 at 06:05:58PM +0900, Ryo Tsuruta wrote:
> > Hi,
> >
> > From: vgoyal@redhat.com
> > Subject: [patch 0/4] [RFC] Another proportional weight IO controller
> > Date: Thu, 06 Nov 2008 10:30:22 -0500
> >
> > > Hi,
> > >
> > > If you are not already tired of so many io controller implementations, here
> > > is another one.
> > >
> > > This is a very eary very crude implementation to get early feedback to see
> > > if this approach makes any sense or not.
> > >
> > > This controller is a proportional weight IO controller primarily
> > > based on/inspired by dm-ioband. One of the things I personally found little
> > > odd about dm-ioband was need of a dm-ioband device for every device we want
> > > to control.  I thought that probably we can make this control per request
> > > queue and get rid of device mapper driver. This should make configuration
> > > aspect easy.
> > >
> > > I have picked up quite some amount of code from dm-ioband especially for
> > > biocgroup implementation.
> > >
> > > I have done very basic testing and that is running 2-3 dd commands in different
> > > cgroups on x86_64. Wanted to throw out the code early to get some feedback.
> > >
> > > More details about the design and how to are in documentation patch.
> > >
> > > Your comments are welcome.
> >
> > Do you have any benchmark results?
> > I'm especially interested in the followings:
> > - Comparison of disk performance with and without the I/O controller patch.
>
> If I dynamically disable the bio control, then I did not observe any
> impact on performance. Because in that case practically it boils down
> to just an additional variable check in __make_request().
>
> > - Put uneven I/O loads. Processes, which belong to a cgroup which is
> >   given a smaller weight than another cgroup, put heavier I/O load
> >   like the following.
> >
> >      echo 1024 > /cgroup/bio/test1/bio.shares
> >      echo 8192 > /cgroup/bio/test2/bio.shares
> >
> >      echo $$ > /cgroup/bio/test1/tasks
> >      dd if=/somefile1-1 of=/dev/null &
> >      dd if=/somefile1-2 of=/dev/null &
> >      ...
> >      dd if=/somefile1-100 of=/dev/null
> >      echo $$ > /cgroup/bio/test2/tasks
> >      dd if=/somefile2-1 of=/dev/null &
> >      dd if=/somefile2-2 of=/dev/null &
> >      ...
> >      dd if=/somefile2-10 of=/dev/null &
>
> I have not tried this case.
>
> Ryo, do you still want to stick to two level scheduling? Given the problem
> of it breaking down underlying scheduler's assumptions, probably it makes
> more sense to the IO control at each individual IO scheduler.

Vivek,
     I agree with you that 2 layer scheduler *might* invalidate some
IO scheduler assumptions (though some testing might help here to
confirm that). However, one big concern I have with proportional
division at the IO scheduler level is that there is no means of doing
admission control at the request queue for the device. What we need is
request queue partitioning per cgroup.
    Consider that I want to divide my disk's bandwidth among 3
cgroups(A, B and C) equally. But say some tasks in the cgroup A flood
the disk with IO requests and completely use up all of the requests in
the rq resulting in the following IOs to be blocked on a slot getting
empty in the rq thus affecting their overall latency. One might argue
that over the long term though we'll get equal bandwidth division
between these cgroups. But now consider that cgroup A has tasks that
always storm the disk with large number of IOs which can be a problem
for other cgroups.
    This actually becomes an even larger problem when we want to
support high priority requests as they may get blocked behind other
lower priority requests which have used up all the available requests
in the rq. With request queue division we can achieve this easily by
having tasks requiring high priority IO belong to a different cgroup.
dm-ioband and any other 2-level scheduler can do this easily.

-Divyesh

>
> I have had a very brief look at BFQ's hierarchical proportional
> weight/priority IO control and it looks good. May be we can adopt it for
> other IO schedulers also.
>
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
