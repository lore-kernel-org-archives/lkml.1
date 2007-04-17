Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbXDQLMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbXDQLMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 07:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXDQLMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 07:12:49 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:31602 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbXDQLMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 07:12:48 -0400
Date: Tue, 17 Apr 2007 15:20:48 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Roland McGrath <roland@redhat.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: utrace, RCU and ia64
Message-ID: <20070417112048.GA10908@localhost.sw.ru>
References: <20070329170731.GA6808@localhost.sw.ru> <20070329203025.540841801C4@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070329203025.540841801C4@magilla.sf.frob.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[double freeing of struct utrace leading to oops in
 __rcu_process_callbacks]

Hi, Roland,

utrace debugging you've put into 2.6.21-rc6-mm1 helped. Two double-frees
reproduced:
1) BUG at kernel/utrace.c:176
	rcu_utrace_free
	utrace_reap
	utrace_release_task
	release_task
	flush_old_exec
	load_elf_binary
	search_binary_handler
	do_execve

2)	rcu_utrace_free
	check_dead_utrace
	remove_detached
	finish_report_death
	utrace_report_death
	do_exit
	debug_mutex_init
	get_signal_to_deliver
	do_notify_resume
	ptregscall_common
	sysret_signal
----------------
I've sprinkled more atomic_set's over utrace code to determine who is at
fault of first freeing. It seems to be

	rcu_utrace_free
	check_dead_utrace
	wake_quiscent
	utrace_detach

It was atomic_set(&utrace->debug, 42) right before wake_quiscent() call
and printk() in rcu_utrace_free() call. So it was 42 or garbage.

How I understand all this is that check_dead_utrace() can free struct
utrace, and don't clear ->utrace pointer.

