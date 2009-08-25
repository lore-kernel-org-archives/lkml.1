Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbZHYVVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbZHYVVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbZHYVVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:21:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbZHYVVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:21:03 -0400
Subject: Re: BUG: scheduling while atomic in acpi_ps_complete_op
From: Eric Paris <eparis@redhat.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, len.brown@intel.com
In-Reply-To: <19f34abd0908240750q454a684fy9aaf4a1cb596c4ce@mail.gmail.com>
References: <1250873707.2168.38.camel@dhcp231-106.rdu.redhat.com>
	 <4A8EFFB2.4040100@suse.de>
	 <1250886352.2168.83.camel@dhcp231-106.rdu.redhat.com>
	 <4A8F1081.3020803@suse.de>
	 <1251124609.2359.25.camel@dhcp231-106.rdu.redhat.com>
	 <19f34abd0908240750q454a684fy9aaf4a1cb596c4ce@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 17:20:52 -0400
Message-Id: <1251235252.2270.16.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 16:50 +0200, Vegard Nossum wrote:

> I'm more confused about the change you had to with
> irqs_disabled()/in_atomic_preempt_off().

kmemcheck is irrelevant to that particular problem.  If I boot a
linux-next kernel I get (this is from Aug 25, 2009 linux-next kernel)

If I change it from irqs_disabled() to in_atomic_preempt_off() it does
not BUG().  I'm not sure if that is a reasonable and legitimate check,
but it makes the BUG messages go away.

-Eric

[    0.480087] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.481163] no locks held by swapper/0.
[    0.482153] Modules linked in:
[    0.483382] Pid: 0, comm: swapper Not tainted 2.6.31-rc7-next-20090825 #50
[    0.484010] Call Trace:
[    0.485024]  [<ffffffff81058ba5>] __schedule_bug+0xa5/0xb0
[    0.486014]  [<ffffffff81528dd5>] thread_return+0x794/0x93f
[    0.487014]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.488014]  [<ffffffff812d184a>] ? acpi_os_release_object+0x1c/0x34
[    0.489022]  [<ffffffff810624d6>] __cond_resched+0x26/0x50
[    0.490014]  [<ffffffff8152911a>] _cond_resched+0x4a/0x60
[    0.491014]  [<ffffffff812f5541>] acpi_ps_complete_op+0x239/0x25b
[    0.492015]  [<ffffffff812f5c36>] acpi_ps_parse_loop+0x6d3/0x89d
[    0.493022]  [<ffffffff812fdac5>] ? acpi_ut_create_generic_state+0x5d/0x7f
[    0.494014]  [<ffffffff812f4dab>] acpi_ps_parse_aml+0xab/0x32d
[    0.495013]  [<ffffffff812e2dca>] ? acpi_ds_init_aml_walk+0x10f/0x12e
[    0.496014]  [<ffffffff812f39f9>] acpi_ns_one_complete_parse+0xf9/0x128
[    0.497022]  [<ffffffff817fa140>] ? early_idt_handler+0x0/0x71
[    0.498014]  [<ffffffff812f3a6b>] acpi_ns_parse_table+0x43/0x60
[    0.499028]  [<ffffffff812f03a9>] acpi_ns_load_table+0x59/0xb8
[    0.500014]  [<ffffffff812f867d>] acpi_load_tables+0x80/0x161
[    0.501021]  [<ffffffff81836eb0>] acpi_early_init+0x71/0x11d
[    0.502013]  [<ffffffff817faf6a>] start_kernel+0x39a/0x4a0
[    0.503014]  [<ffffffff817fa2e1>] x86_64_start_reservations+0xc1/0x100
[    0.504014]  [<ffffffff817fa428>] x86_64_start_kernel+0x108/0x150

