Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbZCLPk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbZCLPk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZCLPkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:40:49 -0400
Received: from ms01.sssup.it ([193.205.80.99]:34893 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754494AbZCLPks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:40:48 -0400
X-Greylist: delayed 3598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 11:40:47 EDT
Date: Thu, 12 Mar 2009 15:48:42 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp,
       fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, arozansk@redhat.com, jmoyer@redhat.com,
       oz-kernel@redhat.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com, peterz@infradead.org
Subject: Re: [PATCH 01/10] Documentation
Message-ID: <20090312144842.GS12361@gandalf.sssup.it>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <1236823015-4183-2-git-send-email-vgoyal@redhat.com> <20090312100054.GA8024@linux.vnet.ibm.com> <20090312140450.GE10919@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312140450.GE10919@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Vivek Goyal <vgoyal@redhat.com>
> Date: Thu, Mar 12, 2009 10:04:50AM -0400
>
> On Thu, Mar 12, 2009 at 03:30:54PM +0530, Dhaval Giani wrote:
...
> > > +Some Test Results
> > > +=================
> > > +- Two dd in two cgroups with prio 0 and 4. Ran two "dd" in those cgroups.
> > > +
> > > +234179072 bytes (234 MB) copied, 10.1811 s, 23.0 MB/s
> > > +234179072 bytes (234 MB) copied, 12.6187 s, 18.6 MB/s
> > > +
> > > +- Three dd in three cgroups with prio 0, 4, 4.
> > > +
> > > +234179072 bytes (234 MB) copied, 13.7654 s, 17.0 MB/s
> > > +234179072 bytes (234 MB) copied, 19.476 s, 12.0 MB/s
> > > +234179072 bytes (234 MB) copied, 20.1858 s, 11.6 MB/s
> > 
> > Hi Vivek,
> > 
> > I would be interested in knowing if these are the results expected?
> > 
> 
> Hi Dhaval, 
> 
> Good question. Keeping current expectation in mind, yes these are expected
> results. To begin with, current expectations are that try to emulate
> cfq behavior and the kind of service differentiation we get between
> threads of different priority, same kind of service differentiation we
> should get from different cgroups.
>  
> Having said that, in theory a more accurate estimate should be amount 
> of actual disk time a queue/cgroup got. I have put a tracing message
> to keep track of total service received by a queue. If you run "blktrace"
> then you can see that. Ideally, total service received by two threads
> over a period of time should be in same proportion as their cgroup
> weights.
> 
> It will not be easy to achive it given the constraints we have got in
> terms of how to accurately we can account for disk time actually used by a
> queue in certain situations. So to begin with I am targetting that
> try to meet same kind of service differentation between cgroups as
> cfq provides between threads and then slowly refine it to see how
> close one can come to get accurate numbers in terms of "total_serivce"
> received by each queue.
> 

There is also another issue to consider; to achieve a proper weighted
distribution of ``service time'' (assuming that service time can be
attributed accurately) over any time window, we need also that the tasks
actually compete for disk service during this window.

For example, in the case above with three tasks, the highest weight task
terminates earlier than the other ones, so we have two time frames:
during the first one disk time is divided among all the three tasks
according to their weights, then the highest weight one terminates,
and disk time is divided (equally) among the remaining ones.
