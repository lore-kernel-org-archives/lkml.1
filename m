Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZG0L2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZG0L2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 07:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZG0L2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 07:28:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZG0L2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 07:28:51 -0400
Subject: Re: futexes: Still infinite loop in get_futex_key() in 2.6.31-rc4
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Rosenboom <jens@mcbone.net>
Cc: Sonny Rao <sonnyrao@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1248681637.7279.12.camel@fnki-nb00130>
References: <1248681637.7279.12.camel@fnki-nb00130>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Jul 2009 13:31:06 +0200
Message-Id: <1248694266.6987.1594.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 10:00 +0200, Jens Rosenboom wrote:
> We have a problem with infinitely running processes on kernels at least
> since 2.6.29.4. It happens on a loaded machine after running for a
> couple of days,

What kinds of machine, i386? Could you please enable
CONFIG_FRAME_POINTER, these backtraces are quite mangled.

>  that a "ps ax" seems to get stuck in get_futex_key while
> exiting. Sadly your patch 

Who's patch, and which patch? 7c8fa4f04ab956076605422d5ed37410893a8a73?
That was only regarding huge pages.

The only loop in get_futex_key() appears to be the one around
get_user_pages_fast(), and I'm not quite sure how that could get stuck
like this.

Could it be glibc loops on futex_wake() returning -EFAULT?

> does not fix it as I hoped from the
> description, maybe the following tracebacks taken a couple of minutes
> apart from the same process can help in identifying some further bug
> here:
> 
> ps            R running      0 12886  12884 0x00000000
>  c9189cc4 c136ea4b 03d5e000 00000058 c9189c68 c1053959 00000000 c40d6e00
>  0000061e c9189cb4 c104b558 fffff000 00000007 c1b18000 80000000 c9189d18
>  00000000 c9189c9c c1020e3f 00000163 80000000 b7f1c000 c9189cc0 c1020135
> Call Trace:
>  [<c136ea4b>] ? schedule+0x28b/0x970
>  [<c1057bce>] ? trace_hardirqs_on_caller+0x5e/0x180
>  [<c1020e3f>] ? kmap_atomic+0x1f/0x30
>  [<c1020135>] ? gup_pte_range+0x115/0x190
>  [<c1020252>] ? gup_pud_range+0xa2/0x120
>  [<c1020405>] ? get_user_pages_fast+0x135/0x170
>  [<c1057cfb>] ? trace_hardirqs_on+0xb/0x10
>  [<c1020405>] ? get_user_pages_fast+0x135/0x170
>  [<c105bed5>] ? get_futex_key+0x95/0x1c0
>  [<c105c60c>] ? futex_wake+0x4c/0x110
>  [<c105de0d>] ? do_futex+0x21d/0xd00
>  [<c101bd86>] ? no_context+0x26/0x1a0
>  [<c102a013>] ? finish_task_switch+0x33/0xf0
>  [<c101bfbb>] ? __bad_area_nosemaphore+0xbb/0x180
>  [<c1058d8d>] ? __lock_acquire+0x39d/0x18e0
>  [<c1058d8d>] ? __lock_acquire+0x39d/0x18e0
>  [<c101c0c9>] ? __bad_area+0x29/0x50
>  [<c101c0da>] ? __bad_area+0x3a/0x50
>  [<c101c122>] ? bad_area_access_error+0x12/0x20
>  [<c1002e1c>] ? restore_all_notrace+0x0/0x18
>  [<c101c210>] ? do_page_fault+0x0/0x280
>  [<c1057c9c>] ? trace_hardirqs_on_caller+0x12c/0x180
>  [<c105e992>] ? sys_futex+0xa2/0x130
>  [<c101c210>] ? do_page_fault+0x0/0x280
>  [<c102fa68>] ? mm_release+0xa8/0xc0
>  [<c1033668>] ? exit_mm+0x18/0x110
>  [<c1065121>] ? acct_collect+0x131/0x180
>  [<c10353cb>] ? do_exit+0x60b/0x680
>  [<c101c35d>] ? do_page_fault+0x14d/0x280
>  [<c104b8f6>] ? up_read+0x16/0x30
>  [<c103547c>] ? do_group_exit+0x3c/0xa0
>  [<c10354f3>] ? sys_exit_group+0x13/0x20
>  [<c1002d68>] ? sysenter_do_call+0x12/0x36


