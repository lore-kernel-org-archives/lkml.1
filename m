Return-Path: <linux-kernel-owner+w=401wt.eu-S1761401AbYEGDnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761401AbYEGDnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 23:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbYEGDnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:43:08 -0400
Received: from mga07.intel.com ([143.182.124.22]:18886 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753069AbYEGDnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:43:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,446,1204531200"; 
   d="scan'208";a="243075457"
Subject: Re: AIM7 40% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1210126286.3453.37.camel@ymzhang>
References: <1210052904.3453.30.camel@ymzhang>
	 <20080506114449.GC32591@elte.hu>  <1210126286.3453.37.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 May 2008 11:41:52 +0800
Message-Id: <1210131712.3453.43.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 10:11 +0800, Zhang, Yanmin wrote:
> On Tue, 2008-05-06 at 13:44 +0200, Ingo Molnar wrote:
> > * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> > 
> > > Comparing with kernel 2.6.25, ﻿AIM7 (use tmpfs) has ﻿more than 40% with 
> > > 2.6.26-rc1 on my 8-core stoakley, 16-core tigerton, and Itanium 
> > > Montecito. Bisect located below patch.
> > > 
> > > 64ac24e738823161693bf791f87adc802cf529ff is first bad commit
> > > commit 64ac24e738823161693bf791f87adc802cf529ff
> > > Author: Matthew Wilcox <matthew@wil.cx>
> > > Date:   Fri Mar 7 21:55:58 2008 -0500
> > > 
> > >     Generic semaphore implementation
> > > 
> > > After I manually reverted the patch against 2.6.26-rc1 while fixing 
> > > lots of conflictions/errors, aim7 regression became less than 2%.
> > 
> > hm, which exact semaphore would that be due to?
> > 
> > My first blind guess would be the BKL - there's not much other semaphore 
> > use left in the core kernel otherwise that would affect AIM7 normally. 
> > The VFS still makes frequent use of the BKL and AIM7 is very VFS 
> > intense. Getting rid of that BKL use from the VFS might be useful to 
> > performance anyway.
> > 
> > Could you try to check that it's indeed the BKL?
> > 
> > Easiest way to check it would be to run AIM7 it on 
> > sched-devel.git/latest and do scheduler tracing via:
> > 
> >    http://people.redhat.com/mingo/sched-devel.git/readme-tracer.txt
> One clear weird behavior of aim7 is cpu idle is 0% with 2.6.25, but is more than 50% with
> 2.6.26-rc1. I have a patch to collect schedule info.
With my patch+gprof, I collected some data. Below was outputed by gprof.

index % time    self  children    called     name
                0.00    0.00       2/223305376     __down_write_nested [22749]
                0.00    0.00       3/223305376     journal_commit_transaction [10526]
                0.00    0.00       6/223305376     __down_read [22745]
                0.00    0.00       8/223305376     start_this_handle [19167]
                0.00    0.00      15/223305376     sys_pause [19808]
                0.00    0.00      17/223305376     log_wait_commit [11047]
                0.00    0.00      20/223305376     futex_wait [8122]
                0.00    0.00      64/223305376     pdflush [14335]
                0.00    0.00      71/223305376     do_get_write_access [5367]
                0.00    0.00      84/223305376     pipe_wait [14460]
                0.00    0.00     111/223305376     kjournald [10726]
                0.00    0.00     116/223305376     int_careful [9634]
                0.00    0.00     224/223305376     do_nanosleep [5418]
                0.00    0.00    1152/223305376     watchdog [22065]
                0.00    0.00    4087/223305376     worker_thread [22076]
                0.00    0.00    5003/223305376     __mutex_lock_killable_slowpath [23305]
                0.00    0.00    7810/223305376     ksoftirqd [10831]
                0.00    0.00    9389/223305376     __mutex_lock_slowpath [23306]
                0.00    0.00   10642/223305376     io_schedule [9813]
                0.00    0.00   23544/223305376     migration_thread [11495]
                0.00    0.00   35319/223305376     __cond_resched [22673]
                0.00    0.00   49065/223305376     retint_careful [16146]
                0.00    0.00  119757/223305376     sysret_careful [20074]
                0.00    0.00  151717/223305376     do_wait [5545]
                0.00    0.00  250221/223305376     do_exit [5356]
                0.00    0.00  303836/223305376     cpu_idle [4350]
                0.00    0.00 222333093/223305376     schedule_timeout [2]
[1]      0.0    0.00    0.00 223305376         schedule [1]
-----------------------------------------------
                0.00    0.00       2/222333093     io_schedule_timeout [9814]
                0.00    0.00       4/222333093     journal_stop [10588]
                0.00    0.00       8/222333093     cifs_oplock_thread [3760]
                0.00    0.00      14/222333093     do_sys_poll [5513]
                0.00    0.00      20/222333093     cifs_dnotify_thread [3733]
                0.00    0.00      32/222333093     read_chan [15648]
                0.00    0.00      47/222333093     wait_for_common [22017]
                0.00    0.00     658/222333093     do_select [5479]
                0.00    0.00    2000/222333093     inet_stream_connect [9324]
                0.00    0.00 222330308/222333093     __down [22577]
[2]      0.0    0.00    0.00 222333093         schedule_timeout [2]
                0.00    0.00 222333093/223305376     schedule [1]
-----------------------------------------------
                0.00    0.00       1/165565      flock_lock_file_wait [7735]
                0.00    0.00       7/165565      __posix_lock_file [23371]
                0.00    0.00     203/165565      de_put [4665]
                0.00    0.00     243/165565      opost [13633]
                0.00    0.00     333/165565      proc_root_readdir [14982]
                0.00    0.00     358/165565      write_chan [22090]
                0.00    0.00    6222/165565      proc_lookup_de [14908]
                0.00    0.00   32081/165565      sys_fcntl [19687]
                0.00    0.00   36045/165565      vfs_ioctl [21822]
                0.00    0.00   42025/165565      tty_release [20818]
                0.00    0.00   48047/165565      chrdev_open [3702]
[3]      0.0    0.00    0.00  165565         lock_kernel [3]
                0.00    0.00  152987/153190      down [4]
-----------------------------------------------
                0.00    0.00     203/153190      __reacquire_kernel_lock [23420]
                0.00    0.00  152987/153190      lock_kernel [3]
[4]      0.0    0.00    0.00  153190         down [4]
                0.00    0.00  153190/153190      __down [22577]
-----------------------------------------------
                0.00    0.00  153190/153190      down [4]
[22577   0.0    0.00    0.00  153190         __down [22577]
                0.00    0.00 222330308/222333093     schedule_timeout [2]


As system idle is more than 50%, so the schedule/schedule_timeout caller is important
information.
1) lock_kernel causes most schedule/schedule_timeout;
2) When lock_kernel calls down, then __down, __down calls ﻿schedule_timeout for
lots of times in a loop;
3) Caller of lcok_kernel are sys_fcntl/vfs_ioctl/tty_release/chrdev_open.

-yanmin


