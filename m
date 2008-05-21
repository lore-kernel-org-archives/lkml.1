Return-Path: <linux-kernel-owner+w=401wt.eu-S1762722AbYEUVdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762722AbYEUVdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYEUVdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:33:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59897 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYEUVc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:32:59 -0400
Date: Wed, 21 May 2008 14:32:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: mark <markkicks@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fork: Resource temporarily unavailable / cant start new threads
Message-Id: <20080521143248.baee1391.randy.dunlap@oracle.com>
In-Reply-To: <82fa9e310805211408o65b49923jd9bf4a6c89b97c30@mail.gmail.com>
References: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>
	<20080521132845.72db5748.randy.dunlap@oracle.com>
	<82fa9e310805211339o3090e0d0le8503051d3e0aa38@mail.gmail.com>
	<48348AFA.1070900@oracle.com>
	<82fa9e310805211408o65b49923jd9bf4a6c89b97c30@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 14:08:53 -0700 mark wrote:

> On Wed, May 21, 2008 at 1:50 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > mark wrote:
> >>
> >> On Wed, May 21, 2008 at 1:28 PM, Randy Dunlap <randy.dunlap@oracle.com>
> >> wrote:
> >>>
> >>> On Tue, 20 May 2008 11:26:47 -0700 mark wrote:
> >>>>
> >>>> I upgraded to 2.6.25.3-18.fc9.x86_64 fedora core 9, now I get this
> >>>> error when I try to login to the box, kill a pr start a python app, or
> >>>> do anything on a regular basis.
> >>>>
> >>>> fork: Resource temporarily unavailable
> >>>>
> >>>> I have over 10GB RAM free, and zero swap spaced used. The box is a
> >>>> dual quad core Intel Xeon 5405 with 16GB RAM.
> >>>>
> >>>> There is no error message in /var/log/messages or dmesg ...
> >>>> how do I identify the problem?
> >>>> thanks!
> >>>>
> >>>> uname -a
> >>>> Linux XXX 2.6.25.3-18.fc9.x86_64 #1 SMP Tue May 13 04:54:47 EDT 2008
> >>>> x86_64 x86_64 x86_64 GNU/Linux
> >>>>
> >>>>
> >>>> free -m
> >>>>            total       used       free     shared    buffers     cached
> >>>> Mem:         16086       3189      12896          0         42
> >>>>  666
> >>>> -/+ buffers/cache:       2481      13605
> >>>> Swap:         1983          0       1983
> >>>>
> >>>>
> >>>> have only 505 processes running
> >>>> ps aux | wc -l
> >>>> 505
> >>>>
> >>>>
> >>>> uptime
> >>>>  11:24:15 up 39 min,  1 user,  load average: 3.54, 3.47, 2.87
> >>>>
> >>>> ulimit -a
> >>>> core file size          (blocks, -c) 0
> >>>> data seg size           (kbytes, -d) unlimited
> >>>> scheduling priority             (-e) 0
> >>>> file size               (blocks, -f) unlimited
> >>>> pending signals                 (-i) 137216
> >>>> max locked memory       (kbytes, -l) 32
> >>>> max memory size         (kbytes, -m) unlimited
> >>>> open files                      (-n) 32768
> >>>> pipe size            (512 bytes, -p) 8
> >>>> POSIX message queues     (bytes, -q) 819200
> >>>> real-time priority              (-r) 0
> >>>> stack size              (kbytes, -s) 10240
> >>>> cpu time               (seconds, -t) unlimited
> >>>> max user processes              (-u) 1024
> >>>> virtual memory          (kbytes, -v) unlimited
> >>>> file locks                      (-x) unlimited
> >>>
> >>> The only place that fork() returns EAGAIN is for number of
> >>> processes being >= its limit.  Does this user already have >= 1024
> >>> processes?
> >>
> >> No, it is around 400
> >
> > Well, my comment was wrong anyway.  There are several other tests just
> > below number of user processes that also return EAGAIN, like:
> >
> > - total number of threads being too large

Total number of threads currently running is in /proc/loadavg:

> cat /proc/loadavg
1.56 0.58 0.27 2/203 28500

It's the number following the '/', e.g., 203 on my desktop system.

max_threads allowed is a sysctl, so you can tune it if needed.
It's in /proc/sys/kernel/threads-max:

> cat /proc/sys/kernel/threads-max
32624

I sort of doubt that one is the problem, but you can tell us.

> > - error on grabbing a module reference count (?)
> > - error on grabbing a binfmt module reference
> 
> as a user how do i identify what is wrong, and fix this? for total
> number of threads -> is there anyway i can find out if this is causing
> the problem? my system is running around 80 multi-threaded python web
> apps.

I can send you some debug patches that will print out the specific
problem area.  Do you want to do that?  Can you rebuild and install
a new kernel?


> >> my webserver is now throwing this error:
> >>
> >> setuid(500) failed (11: Resource temporarily unavailable)
> >
> > That's all of the useful information??
> 
> Yes. i get this error  when i restart the web server. if i kill all
> other apps, and then start it again it starts fine.
> 
> this is the complete error message,
> 2008/05/21 08:02:19 [emerg] 30558#0: setuid(500) failed (11: Resource
> temporarily unavailable)
> 2008/05/21 08:02:19 [alert] 30557#0: worker process 30558 exited with
> fatal code 2 and can not be respawn


---
~Randy
