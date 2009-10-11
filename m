Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZJKMej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZJKMej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 08:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZJKMeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 08:34:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbZJKMeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 08:34:36 -0400
Date: Sun, 11 Oct 2009 08:32:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       m-ikeda@ds.jp.nec.com, agk@redhat.com, peterz@infradead.org,
       jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       riel@redhat.com
Subject: Re: Performance numbers with IO throttling patches (Was: Re: IO
	scheduler based IO controller V10)
Message-ID: <20091011123219.GA3832@redhat.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com> <20090924143315.781cd0ac.akpm@linux-foundation.org> <20091010195316.GB16510@redhat.com> <20091010222728.GA30943@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091010222728.GA30943@linux>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 12:27:30AM +0200, Andrea Righi wrote:

[..]
> > 
> > - Andrea, can you please also run similar tests to see if you see same
> >   results or not. This is to rule out any testing methodology errors or
> >   scripting bugs. :-). I also have collected the snapshot of some cgroup
> >   files like bandwidth-max, throttlecnt, and stats. Let me know if you want
> >   those to see what is happenig here. 
> 
> Sure, I'll do some tests ASAP. Another interesting test would be to set
> a blockio.iops-max limit also for the sequential readers' cgroup, to be
> sure we're not touching some iops physical disk limit.
> 
> Could you post all the options you used with fio, so I can repeat some
> tests as similar as possible to yours?
> 

I will respond to rest of the points later after some testing with iops-max
rules. In the mean time here are my fio options so that you can try to
replicate the tests.

I am simply copying pasting from my script. I have written my own program
"semwait" so that two different instances of fio can synchronize on an
external semaphore. Generally all the jobs go in single fio files but here
we need to put two fio instances in two different cgroups. It is important
that two fio jobs are synchronized and start at the same time after laying
out files. (Becomes primarilly useful in write testing. Reads are fine 
generally onces the files have been laid out).

Sequential readers
------------------
fio_args="--rw=read --bs=4K --size=2G --runtime=30 --numjobs=$nr_jobs --direct=1"
fio $fio_args --name=$jobname --directory=/mnt/$blockdev/fio --exec_prerun="'/usr/local/bin/semwait fiocgroup'" >> $outputdir/$outputfile &

Random Reader
-------------
fio_args="--rw=randread --bs=4K --size=1G --runtime=30 --direct=1 --numjobs=$nr_jobs"
fio $fio_args --name=$jobname --directory=/mnt/$blockdev/fio --exec_prerun="'/usr/local/bin/semwait fiocgroup'" >> $outputdir/$outputfile &

Random Writer
-------------
fio_args="--rw=randwrite --bs=64K --size=2G --runtime=30 --numjobs=$nr_jobs1 --ioengine=libaio --iodepth=4 --direct=1"

fio $fio_args --name=$jobname --directory=/mnt/$blockdev/fio --exec_prerun="'/usr/local/bin/semwait fiocgroup'" >> $outputdir/$outputfile &

Thanks
Vivek
