Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYIRPJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYIRPJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbYIRPJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:09:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbYIRPJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:09:21 -0400
Date: Thu, 18 Sep 2008 11:06:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, xemul@openvz.org, agk@sourceware.org,
       jens.axboe@oracle.com
Subject: Re: dm-ioband + bio-cgroup benchmarks
Message-ID: <20080918150634.GH20640@redhat.com>
References: <20080918.210418.226794540.ryov@valinux.co.jp> <20080918131554.GB20640@redhat.com> <48D267B5.20402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D267B5.20402@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 04:37:41PM +0200, Andrea Righi wrote:
> Vivek Goyal wrote:
> > On Thu, Sep 18, 2008 at 09:04:18PM +0900, Ryo Tsuruta wrote:
> >> Hi All,
> >>
> >> I have got excellent results of dm-ioband, that controls the disk I/O
> >> bandwidth even when it accepts delayed write requests.
> >>
> >> In this time, I ran some benchmarks with a high-end storage. The
> >> reason was to avoid a performance bottleneck due to mechanical factors
> >> such as seek time.
> >>
> >> You can see the details of the benchmarks at:
> >> http://people.valinux.co.jp/~ryov/dm-ioband/hps/
> >>
> > 
> > Hi Ryo,
> > 
> > I had a query about dm-ioband patches. IIUC, dm-ioband patches will break
> > the notion of process priority in CFQ because now dm-ioband device will
> > hold the bio and issue these to lower layers later based on which bio's
> > become ready. Hence actual bio submitting context might be different and
> > because cfq derives the io_context from current task, it will be broken.
> > 
> > To mitigate that problem, we probably need to implement Fernando's
> > suggestion of putting io_context pointer in bio. 
> > 
> > Have you already done something to solve this issue?
> > 
> > Secondly, why do we have to create an additional dm-ioband device for 
> > every device we want to control using rules. This looks little odd
> > atleast to me. Can't we keep it in line with rest of the controllers
> > where task grouping takes place using cgroup and rules are specified in
> > cgroup itself (The way Andrea Righi does for io-throttling patches)?
> > 
> > To avoid creation of stacking another device (dm-ioband) on top of every
> > device we want to subject to rules, I was thinking of maintaining an
> > rb-tree per request queue. Requests will first go into this rb-tree upon
> > __make_request() and then will filter down to elevator associated with the
> > queue (if there is one). This will provide us the control of releasing
> > bio's to elevaor based on policies (proportional weight, max bandwidth
> > etc) and no need of stacking additional block device.
> > 
> > I am working on some experimental proof of concept patches. It will take
> > some time though.
> > 
> > I was thinking of following.
> > 
> > - Adopt the Andrea Righi's style of specifying rules for devices and
> >   group the tasks using cgroups.
> > 
> > - To begin with, adopt dm-ioband's approach of proportional bandwidth
> >   controller. It makes sense to me limit the bandwidth usage only in
> >   case of contention. If there is really a need to limit max bandwidth,
> >   then probably we can do something to implement additional rules or
> >   implement some policy switcher where user can decide what kind of
> >   policies need to be implemented.
> > 
> > - Get rid of dm-ioband and instead buffer requests on an rb-tree on every
> >   request queue which is controlled by some kind of cgroup rules.
> > 
> > It would be good to discuss above approach now whether it makes sense or 
> > not. I think it is kind of fusion of io-throttling and dm-ioband patches
> > with additional idea of doing io-control just above elevator on the request
> > queue using an rb-tree.
> 
> Thanks Vivek. All sounds reasonable to me and I think this is be the right way
> to proceed.
> 
> I'll try to design and implement your rb-tree per request-queue idea into my
> io-throttle controller, maybe we can reuse it also for a more generic solution.
> Feel free to send me your experimental proof of concept if you want, even if
> it's not yet complete, I can review it, test and contribute.

Currently I have taken code from bio-cgroup to implement cgroups and to
provide functionality to associate a bio to a cgroup. I need this to be
able to queue the bio's at right node in the rb-tree and then also to be
able to take a decision when is the right time to release few requests.

Right now in crude implementation, I am working on making system boot.
Once patches are at least in little bit working shape, I will send it to you
to have a look.

Thanks
Vivek
