Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbXLSSqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbXLSSqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXLSSpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:45:53 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:43754 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbXLSSpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:45:52 -0500
Subject: Re: 2.6.24-rc5-mm1 -- inconsistent {in-hardirq-W} ->
	{hardirq-on-W} usage -- pm-hibernate/9940 [HC0[0]:SC0[0]:HE1:SE1]
From: Daniel Walker <dwalker@mvista.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <47693385.1010901@gmail.com>
References: <a44ae5cd0712190517t7c80e15bv759fa5486dfca234@mail.gmail.com>
	 <47693385.1010901@gmail.com>
Content-Type: text/plain
Date: Wed, 19 Dec 2007 10:42:09 -0800
Message-Id: <1198089729.2716.45.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-19 at 10:06 -0500, Miles Lane wrote:
> [   11.827653] PM: Creating hibernation image:
> [   11.827658] WARNING: at arch/x86/kernel/smp_32.c:561 
> native_smp_call_function_mask()
> [   11.827661] Pid: 9940, comm: pm-hibernate Not tainted
> 2.6.24-rc5-mm1 #8
> [   11.827665]  [<c0107d55>] show_trace_log_lvl+0x12/0x25
> [   11.827673]  [<c010848a>] show_trace+0xd/0x10
> [   11.827677]  [<c0108763>] dump_stack+0x57/0x5f
> [   11.827681]  [<c0117db4>] native_smp_call_function_mask+0x41/0x126
> [   11.827686]  [<c01192d9>] smp_call_function+0x18/0x1f
> [   11.827690]  [<c012c624>] on_each_cpu+0x12/0x40
> [   11.827695]  [<c0166ece>] drain_all_pages+0x13/0x16
> [   11.827700]  [<c014f7b3>] swsusp_save+0x18/0x46b
> [   11.827705]  [<c03103fa>] swsusp_arch_suspend+0x2a/0x2c
> [   11.827710]  [<c014e7d8>] hibernate+0xba/0x16e
> [   11.827714]  [<c014d56b>] state_store+0x45/0xac
> [   11.827717]  [<c01ffe95>] kobj_attr_store+0x1a/0x22
> [   11.827722]  [<c01b92c7>] sysfs_write_file+0xb8/0xe3
> [   11.827726]  [<c01837eb>] vfs_write+0xa4/0x120
> [   11.827731]  [<c0183d5e>] sys_write+0x3b/0x60
> [   11.827734]  [<c0106bae>] sysenter_past_esp+0x6b/0xc1
> [   11.827738]  =======================
...
> [   15.624993] =================================
> [   15.624995] [ INFO: inconsistent lock state ]
> [   15.624998] 2.6.24-rc5-mm1 #8
> [   15.624999] ---------------------------------
> [   15.625001] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.

It looks like the swsusp_save() calls drain_all_pages() , which calls
on_each_cpu() .. On return on_each_cpu() unconditionally enables
interrupts so the rest of the resume process has interrupt enable
(which , it looks like, shouldn't happen) and then you get the lockdep()
warning due to the above..

Not sure if this has been found already, or not?

Should drain_all_pages() really be drain_local_pages() ?

Daniel

