Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYIEQ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYIEQ7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYIEQ6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:58:55 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38773 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYIEQ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:58:54 -0400
Message-ID: <48761.166.70.238.43.1220632184.squirrel@webmail.wolfmountaingroup.com>
Date: Fri, 5 Sep 2008 10:29:44 -0600 (MDT)
Subject: 2.6.27-rc5-git7 iwl3945: driver still has receiver lockups and is 
     worse than before
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Same problems as previously reported, except now it's gotten worse.  Where
before the adapter would lockup only when setting encryption keys, now it
locks up intermittently even without using encryption using the native
linux iwl3945 driver

This same kernel now causes ndis drivers to crash under ndiswrapper (which
wrked before) with bugs being reported in the "workqueue" functions.  The
specific area where I tracked down some serious bugginess and sickness was
here (I LOVE MY SHINY NEW LINUX KERNEL DEBUGGER).


		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
					"%s/0x%08x/%d\n",
					current->comm, preempt_count(),
				       	task_pid_nr(current));
			printk(KERN_ERR "    last function: ");
			print_symbol("%s\n", (unsigned long)f);
			debug_show_held_locks(current);
			dump_stack();
		}


These iwl3945 problems seem related to the copy of Novell's work-to-do
subsystem called "workqueues" in linux when preemption is active, at least
in the ndiswrapper case.

Jeff

