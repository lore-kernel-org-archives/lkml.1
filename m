Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbYHZGh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbYHZGh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 02:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYHZGhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 02:37:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbYHZGhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 02:37:50 -0400
Date: Mon, 25 Aug 2008 23:37:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ryan Hope" <rmh3093@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>
Subject: Re: [-mmotm] BUG: scheduling while atomic: swapper
Message-Id: <20080825233729.816cf182.akpm@linux-foundation.org>
In-Reply-To: <48f7fe350808251909g26207e7agdda6408c0b46a1ed@mail.gmail.com>
References: <48f7fe350808251909g26207e7agdda6408c0b46a1ed@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2008 22:09:25 -0400 "Ryan Hope" <rmh3093@gmail.com> wrote:

> BUG: scheduling while atomic: swapper/1/0x00000002
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc4-zenmmotm1 #4
>  [<c057a0c7>] schedule+0x287/0x6d0
>  [<c03672e6>] vsnprintf+0x3a6/0x6c0
>  [<c057a92d>] schedule_timeout+0x7d/0xb0
>  [<c021e0c8>] __wake_up+0x38/0x50
>  [<c057a74a>] wait_for_common+0x8a/0x130
>  [<c0220ab0>] default_wake_function+0x0/0x10
>  [<c0237743>] call_usermodehelper_exec+0xc3/0xf0
>  [<c0362ede>] kobject_uevent_env+0x37e/0x3a0
>  [<c03d5921>] device_add+0x551/0x630
>  [<c03d5ac3>] device_create_vargs+0xb3/0xd0
>  [<c06ccc47>] microcode_intel_module_init+0x0/0x39
>  [<c03d5b0b>] device_create+0x2b/0x30
>  [<c0385f2e>] misc_register+0xbe/0x170
>  [<c02137d1>] microcode_init+0x21/0xf0
>  [<c0201336>] do_one_initcall+0x26/0x170
>  [<c021e0c8>] __wake_up+0x38/0x50
>  [<c0237c98>] insert_work+0x48/0x50
>  [<c02380a5>] __queue_work+0x25/0x40
>  [<c023812a>] queue_work_on+0x3a/0x50
>  [<c06c29bf>] kernel_init+0x170/0x251
>  [<c06c284f>] kernel_init+0x0/0x251
>  [<c0204157>] kernel_thread_helper+0x7/0x10
>  =======================

As a mad guess, I'd guess that someone changed get_online_cpus() so
that disables preemption (with a suitable config combination, perhaps).
Which would cause microcode_init()'s sysdev_driver_register() to run
in atomic context.

But that's just a guess - I can't immediately see any change in there
which does this.  Ingo, any theories?

