Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbZG0IAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbZG0IAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 04:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZG0IAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 04:00:48 -0400
Received: from leia.mcbone.net ([194.97.104.42]:51248 "EHLO leia.mcbone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbZG0IAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 04:00:47 -0400
Subject: futexes: Still infinite loop in get_futex_key() in 2.6.31-rc4
From: Jens Rosenboom <jens@mcbone.net>
To: Sonny Rao <sonnyrao@us.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 10:00:37 +0200
Message-Id: <1248681637.7279.12.camel@fnki-nb00130>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a problem with infinitely running processes on kernels at least
since 2.6.29.4. It happens on a loaded machine after running for a
couple of days, that a "ps ax" seems to get stuck in get_futex_key while
exiting. Sadly your patch does not fix it as I hoped from the
description, maybe the following tracebacks taken a couple of minutes
apart from the same process can help in identifying some further bug
here:

ps            R running      0 12886  12884 0x00000000
 c9189cc4 c136ea4b 03d5e000 00000058 c9189c68 c1053959 00000000 c40d6e00
 0000061e c9189cb4 c104b558 fffff000 00000007 c1b18000 80000000 c9189d18
 00000000 c9189c9c c1020e3f 00000163 80000000 b7f1c000 c9189cc0 c1020135
Call Trace:
 [<c136ea4b>] ? schedule+0x28b/0x970
 [<c1057bce>] ? trace_hardirqs_on_caller+0x5e/0x180
 [<c1020e3f>] ? kmap_atomic+0x1f/0x30
 [<c1020135>] ? gup_pte_range+0x115/0x190
 [<c1020252>] ? gup_pud_range+0xa2/0x120
 [<c1020405>] ? get_user_pages_fast+0x135/0x170
 [<c1057cfb>] ? trace_hardirqs_on+0xb/0x10
 [<c1020405>] ? get_user_pages_fast+0x135/0x170
 [<c105bed5>] ? get_futex_key+0x95/0x1c0
 [<c105c60c>] ? futex_wake+0x4c/0x110
 [<c105de0d>] ? do_futex+0x21d/0xd00
 [<c101bd86>] ? no_context+0x26/0x1a0
 [<c102a013>] ? finish_task_switch+0x33/0xf0
 [<c101bfbb>] ? __bad_area_nosemaphore+0xbb/0x180
 [<c1058d8d>] ? __lock_acquire+0x39d/0x18e0
 [<c1058d8d>] ? __lock_acquire+0x39d/0x18e0
 [<c101c0c9>] ? __bad_area+0x29/0x50
 [<c101c0da>] ? __bad_area+0x3a/0x50
 [<c101c122>] ? bad_area_access_error+0x12/0x20
 [<c1002e1c>] ? restore_all_notrace+0x0/0x18
 [<c101c210>] ? do_page_fault+0x0/0x280
 [<c1057c9c>] ? trace_hardirqs_on_caller+0x12c/0x180
 [<c105e992>] ? sys_futex+0xa2/0x130
 [<c101c210>] ? do_page_fault+0x0/0x280
 [<c102fa68>] ? mm_release+0xa8/0xc0
 [<c1033668>] ? exit_mm+0x18/0x110
 [<c1065121>] ? acct_collect+0x131/0x180
 [<c10353cb>] ? do_exit+0x60b/0x680
 [<c101c35d>] ? do_page_fault+0x14d/0x280
 [<c104b8f6>] ? up_read+0x16/0x30
 [<c103547c>] ? do_group_exit+0x3c/0xa0
 [<c10354f3>] ? sys_exit_group+0x13/0x20
 [<c1002d68>] ? sysenter_do_call+0x12/0x36

ps            R running      0 12886  12884 0x00000000
 c9189ca4 00200046 c1036db8 c9189c6c c1036f02 00200046 c1067e57 00000001
 c15239dc c15239dc c15239dc 00000001 f6bfee60 00051f77 00000000 00000001
 c1590000 c1592424 c15955c0 f6bfee64 f6bfecc0 c9189c80 c103716c f6bfecc0
Call Trace:
 [<c1036db8>] ? _local_bh_enable+0x48/0xb0
 [<c1036f02>] ? __do_softirq+0xe2/0x130
 [<c1067e57>] ? handle_fasteoi_irq+0x87/0xc0
 [<c103716c>] ? irq_exit+0x3c/0x80
 [<c136f25c>] ? preempt_schedule_irq+0x2c/0x60
 [<c1057c9c>] ? trace_hardirqs_on_caller+0x12c/0x180
 [<c136f262>] preempt_schedule_irq+0x32/0x60
 [<c1002cf2>] need_resched+0x1f/0x21
 [<c102040a>] ? get_user_pages_fast+0x13a/0x170
 [<c105beef>] ? get_futex_key+0xaf/0x1c0
 [<c105c60c>] ? futex_wake+0x4c/0x110
 [<c105de0d>] ? do_futex+0x21d/0xd00
 [<c101bd86>] ? no_context+0x26/0x1a0
 [<c102a013>] ? finish_task_switch+0x33/0xf0
 [<c101bfbb>] ? __bad_area_nosemaphore+0xbb/0x180
 [<c1058d8d>] ? __lock_acquire+0x39d/0x18e0
 [<c1058d8d>] ? __lock_acquire+0x39d/0x18e0
 [<c101c0c9>] ? __bad_area+0x29/0x50
 [<c101c0da>] ? __bad_area+0x3a/0x50
 [<c101c122>] ? bad_area_access_error+0x12/0x20
 [<c1002e1c>] ? restore_all_notrace+0x0/0x18
 [<c101c210>] ? do_page_fault+0x0/0x280
 [<c1057c9c>] ? trace_hardirqs_on_caller+0x12c/0x180
 [<c105e992>] ? sys_futex+0xa2/0x130
 [<c101c210>] ? do_page_fault+0x0/0x280
 [<c102fa68>] ? mm_release+0xa8/0xc0
 [<c1033668>] ? exit_mm+0x18/0x110
 [<c1065121>] ? acct_collect+0x131/0x180
 [<c10353cb>] ? do_exit+0x60b/0x680
 [<c101c35d>] ? do_page_fault+0x14d/0x280
 [<c104b8f6>] ? up_read+0x16/0x30
 [<c103547c>] ? do_group_exit+0x3c/0xa0
 [<c10354f3>] ? sys_exit_group+0x13/0x20
 [<c1002d68>] ? sysenter_do_call+0x12/0x36


