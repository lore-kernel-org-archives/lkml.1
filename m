Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbXBEPGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbXBEPGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 10:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932617AbXBEPGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 10:06:00 -0500
Received: from mkedef1.rockwellautomation.com ([208.22.104.18]:13098 "EHLO
	ramilwsmtp01.ra.rockwell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932600AbXBEPF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 10:05:59 -0500
To: linux-kernel@vger.kernel.org
Subject: Re: v2.6.20-rt1, yum/rpm
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.5  CCH1 March 07, 2006
Message-ID: <OF7AB1DD4E.7E28CFD4-ONC1257279.0052B9E9-C1257279.0052EFF1@ra.rockwell.com>
From: Milan Svoboda <msvoboda@ra.rockwell.com>
Date: Mon, 5 Feb 2007 16:06:46 +0100
X-MIMETrack: Serialize by Router on RAMilwSMTP01/Milwaukee/RA/Rockwell(Release 6.5.4FP1|June
 19, 2005) at 02/05/2007 09:06:59 AM,
	Serialize complete at 02/05/2007 09:06:59 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 5, 7:50 am, Ingo Molnar <m...@elte.hu> wrote:
> i have released the v2.6.20-rt1 kernel, which can be downloaded from the
> usual place:
> 

Clean boot for me on ARM ixp4xx (gcc-4.1.1, glibc-2.5, big endian, 
softfloat).
High-res timers looks good.

However, I'm trying to use PI mutexes in userspace 
(pthread_mutexattr_setprotocol =>
PTHREAD_PRIO_INHERIT) and found strange behaviour. It seems to me that 
mutex
is not really locked, ie. first thread locks mutex then second thread also 
locks the
same mutex! Then the second mutex unlock it and when the first thread 
unlocks the
mutex error EPERM is returned.

What do you think, is it kernel or glibc problem? (Priority ceiling works 
as expected.)
Is PTHREAD_PRIO_INHERIT supposed to work on my platform?

If there is anything else what would you like to see from my system, let 
me know.

See logs from pi_tests-1.15 => classic_pi.c (I added code that test return 
value from
pthread_mutex_lock/pthread_mutex_unlock):

# /mnt/clfs/opt/classic_pi --verbose
main: Priority Inheritance turned on
set_cpu_affinity: using processr 0
main: creating low priority thread
main: creating medium priority thread
main: creating high priority thread
main: releasing all threads
high_priority: running as FIFO thread at priority 97
high_priority: entering ready state
med_priority: running as FIFO thread at priority 96
med_priority: entering ready state
low_priority: running as FIFO thread at priority 95
low_priority: entering ready state
main: all threads initialized, waiting for mutex to be claimed
main: waiting for threads to finish
high_priority: starting inversion loop (1)
high_priority: entering start state (1)
med_priority: starting inversion loop (1)
med_priority: entering start state (1)
low_priority: starting inversion loop (1)
low_priority: entering start wait (1)
high_priority: entering running state
med_priority: entering elevate state
low_priority: claiming mutex
low_priority: mutex locked
low_priority: entering locked wait
high_priority: locking mutex
high_priority: got mutex
high_priority: unlocking mutex
high_priority: entering finish state
low_priority: entering elevated wait
med_priority: entering finish state
low_priority: unlocking mutex
low_priority: mutex unlock failed: 1
low_priority: entering finish wait
high_priority: entering exit state
med_priority: entering exit state
low_priority: entering exit state
main: all threads terminated!
main: test passed

And this is log from kernel (I added prink to sys_futex and do_futex):
sys_futex: op == 0
do_futex: op == 0
sys_futex: op == 0
do_futex: op == 0
sys_futex: op == 0
do_futex: op == 0
sys_futex: op == 1
do_futex: op == 1
sys_futex: op == 0
do_futex: op == 0
sys_futex: op == 0
do_futex: op == 0
sys_futex: op == 0
do_futex: op == 0
sys_futex: op == 1
do_futex: op == 1
sys_futex: op == 0
do_futex: op == 0
sys_futex: op == 0
do_futex: op == 0
sys_futex: op == 1
do_futex: op == 1
sys_futex: op == 6
do_futex: op == 6
FUTEX_LOCK_PI
sys_futex: op == 7
do_futex: op == 7
FUTEX_UNLOCK_PI
sys_futex: op == 0
do_futex: op == 0
sys_futex: op == 1
do_futex: op == 1
sys_futex: op == 0
do_futex: op == 0
sys_futex: op == 1
do_futex: op == 1
sys_futex: op == 0
do_futex: op == 0
sys_futex: op == 0
do_futex: op == 0
sys_futex: op == 1
do_futex: op == 1
sys_futex: op == 1
do_futex: op == 1
