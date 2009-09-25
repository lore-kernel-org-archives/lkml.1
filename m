Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbZIYU12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbZIYU12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 16:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZIYU11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 16:27:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbZIYU11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 16:27:27 -0400
Date: Fri, 25 Sep 2009 16:26:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com,
       jens.axboe@oracle.com
Subject: Re: IO scheduler based IO controller V10
Message-ID: <20090925202636.GC15007@redhat.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com> <4ABC28DE.7050809@datenparkplatz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABC28DE.7050809@datenparkplatz.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 04:20:14AM +0200, Ulrich Lukas wrote:
> Vivek Goyal wrote:
> > Notes:
> > - With vanilla CFQ, random writers can overwhelm a random reader.
> >   Bring down its throughput and bump up latencies significantly.
> 
> 
> IIRC, with vanilla CFQ, sequential writing can overwhelm random readers,
> too.
> 
> I'm basing this assumption on the observations I made on both OpenSuse
> 11.1 and Ubuntu 9.10 alpha6 which I described in my posting on LKML
> titled: "Poor desktop responsiveness with background I/O-operations" of
> 2009-09-20.
> (Message ID: 4AB59CBB.8090907@datenparkplatz.de)
> 
> 
> Thus, I'm posting this to show that your work is greatly appreciated,
> given the rather disappointig status quo of Linux's fairness when it
> comes to disk IO time.
> 
> I hope that your efforts lead to a change in performance of current
> userland applications, the sooner, the better.
> 
[Please don't remove people from original CC list. I am putting them back.]

Hi Ulrich,

I quicky went through that mail thread and I tried following on my
desktop.

##########################################
dd if=/home/vgoyal/4G-file of=/dev/null &
sleep 5
time firefox
# close firefox once gui pops up.
##########################################

It was taking close to 1 minute 30 seconds to launch firefox and dd got 
following.

4294967296 bytes (4.3 GB) copied, 100.602 s, 42.7 MB/s

(Results do vary across runs, especially if system is booted fresh. Don't
 know why...).


Then I tried putting both the applications in separate groups and assign
them weights 200 each.

##########################################
dd if=/home/vgoyal/4G-file of=/dev/null &
echo $! > /cgroup/io/test1/tasks
sleep 5
echo $$ > /cgroup/io/test2/tasks
time firefox
# close firefox once gui pops up.
##########################################

Now I firefox pops up in 27 seconds. So it cut down the time by 2/3.

4294967296 bytes (4.3 GB) copied, 84.6138 s, 50.8 MB/s

Notice that throughput of dd also improved.

I ran the block trace and noticed in many a cases firefox threads
immediately preempted the "dd". Probably because it was a file system
request. So in this case latency will arise from seek time.

In some other cases, threads had to wait for up to 100ms because dd was
not preempted. In this case latency will arise both from waiting on queue
as well as seek time.

With cgroup thing, We will run 100ms slice for the group in which firefox
is being launched and then give 100ms uninterrupted time slice to dd. So
it should cut down on number of seeks happening and that's why we probably
see this improvement.

So grouping can help in such cases. May be you can move your X session in
one group and launch the big IO in other group. Most likely you should
have better desktop experience without compromising on dd thread output.

Thanks
Vivek
