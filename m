Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbZA3H6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbZA3H6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 02:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZA3H54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 02:57:56 -0500
Received: from mail.gmx.net ([213.165.64.20]:59375 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752056AbZA3H5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 02:57:55 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/glgAT37bgAqMoErF0QSKOmlDeKTDq/CdnsPz1WD
	ioLYyncqQkGxCy
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
	synchronizing threads on different cores
From: Mike Galbraith <efault@gmx.de>
To: Thomas Pilarski <thomas.pi@arcor.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1233237934.11129.183.camel@bugs-laptop>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
	 <1233181507.6988.14.camel@bugs-laptop>  <1233220048.7835.19.camel@twins>
	 <1233223979.5294.41.camel@bugs-laptop>
	 <1233224644.5294.52.camel@bugs-laptop>  <1233229028.4495.34.camel@laptop>
	 <1233237934.11129.183.camel@bugs-laptop>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 08:57:50 +0100
Message-Id: <1233302270.6061.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 15:05 +0100, Thomas Pilarski wrote:
> > In short this program is carefully crafted to defeat all our affinity
> > tests - and I'm not sure what to do.
> 
> I am sorry, although it is not carefully crafted. The function random()
> is causing my problem. I currently have no real data, so I tried to make
> some random utilization and data.

Yeah, rather big difference, mega-contention vs zero-contention.

2.6.28.2, profile of ThreadSchedulingIssue 4 524288 8 200

vma              samples  %        app name                 symbol name
ffffffff80251efa 2574819  31.6774  vmlinux                  futex_wake
ffffffff80251a39 1367613  16.8255  vmlinux                  futex_wait
0000000000411790 815426   10.0320  ThreadSchedulingIssue    random
ffffffff8022b3b5 343692    4.2284  vmlinux                  task_rq_lock
0000000000404e30 299316    3.6824  ThreadSchedulingIssue    __lll_lock_wait_private
ffffffff8030d430 262906    3.2345  vmlinux                  copy_user_generic_string
ffffffff80462af2 235176    2.8933  vmlinux                  schedule
0000000000411b90 210984    2.5957  ThreadSchedulingIssue    random_r
ffffffff80251730 129376    1.5917  vmlinux                  hash_futex
ffffffff8020be10 123548    1.5200  vmlinux                  system_call
ffffffff8020a679 119398    1.4689  vmlinux                  __switch_to
ffffffff8022f49b 110068    1.3541  vmlinux                  try_to_wake_up
ffffffff8024c4d1 106352    1.3084  vmlinux                  sched_clock_cpu
ffffffff8020be20 102709    1.2636  vmlinux                  system_call_after_swapgs
ffffffff80229a2d 100614    1.2378  vmlinux                  update_curr
ffffffff80248309 86475     1.0639  vmlinux                  add_wait_queue
ffffffff80253149 85969     1.0577  vmlinux                  do_futex

Versus using myrand() free sample cruft generator from rand(3) manpage.  Poof.

vma      samples  %        app name                 symbol name
004002f4 979506   90.7113  ThreadSchedulingIssue    myrand
00400b00 53348     4.9405  ThreadSchedulingIssue    thread_consumer
00400c25 42710     3.9553  ThreadSchedulingIssue    thread_producer

One of those "don't _ever_ do that" things?

	-Mike


