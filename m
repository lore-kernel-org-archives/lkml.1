Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYBILes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYBILes (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 06:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYBILej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 06:34:39 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:3992 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYBILei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 06:34:38 -0500
Date: Sat, 9 Feb 2008 12:34:35 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: preempt rcu bug on s390
Message-ID: <20080209113435.GA6915@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using CONFIG_PREEMPT_RCU and CONFIG_NO_IDLE_HZ on s390 my system always
gets stuck when running with more than one cpu.
When booting with four cpus I get all four cpus caught withing cpu_idle
and not advancing anymore. However there is the init process which is
waitung for synchronize_rcu() to complete (lcrash output):

STACK TRACE FOR TASK: 0xf84d968 (swapper)

 STACK:
 0 schedule+842 [0x36c956]
 1 schedule_timeout+172 [0x36d0e4]
 2 wait_for_common+204 [0x36c398]
 3 synchronize_rcu+76 [0x567bc]
 4 netlink_change_ngroups+150 [0x2b4302]
 5 genl_register_mc_group+256 [0x2b6174]
 6 genl_init+188 [0x534e44]
 7 kernel_init+444 [0x518334]
 8 kernel_thread_starter+6 [0x192a6]

If I change the code so that timer ticks won't be disabled everything
runs fine. So my guess is that rcu_needs_cpu() doesn't do the right
thing for the rcu preemptible case.

Kernel version is git head of today.

Any ideas?
