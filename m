Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbXJVKWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbXJVKWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXJVKWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 06:22:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43201 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbXJVKWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 06:22:15 -0400
Subject: Re: 100% iowait on one of cpus in current -git
From: Peter Zijlstra <peterz@infradead.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200710221159.19364.maximlevitsky@gmail.com>
References: <200710220822.52370.maximlevitsky@gmail.com>
	 <1193046118.27435.166.camel@twins>
	 <200710221159.19364.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 12:22:10 +0200
Message-Id: <1193048530.27435.169.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-22 at 11:59 +0200, Maxim Levitsky wrote:
> On Monday 22 October 2007 11:41:57 Peter Zijlstra wrote:
> > On Mon, 2007-10-22 at 08:22 +0200, Maxim Levitsky wrote:
> > > Hi,
> > > 
> > > I found a bug in current -git:
> > > 
> > > On my system on of cpus stays 100% in iowait mode (I have core 2 duo)
> > > Otherwise the system works OK, no disk activity and/or slowdown.
> > > Suspecting that this is a swap-related problem I tried to turn swap of, but it doesn't affect anything.
> > > It is probably some accounting bug.
> > > 
> > > If I start with init=/bin/bash, then this disappears.
> > > I tried then to start usual /etc/init.d scripts then, and first one to show this bug was gpm.
> > > but then I rebooted the system to X without gpm, and I still see 100% iowait.
> > > 
> > > No additional messages in dmesg.
> > 
> > does sysrq-t show any D state tasks?
> > 
> > 
> This one:
> Probably per-block device dirty writeback?
> I am compiling now revision 1f7d6668c29b1dfa307a44844f9bb38356fc989b
> Thanks for the pointer.
> 
> 
> 
> [  673.365631] pdflush       D c21bdecc     0   221      2
> [  673.365635]        c21bdee0 00000046 00000002 c21bdecc c21bdec4 00000000 c21b3000 00000002
> [  673.365643]        c0134892 c21b3164 c1e00200 00000001 c7109280 c21bdec0 c03ff849 c21bdef0
> [  673.365650]        00052974 00000000 000000ff 00000000 00000000 00000000 c21bdef0 000529dc
> [  673.365657] Call Trace:
> [  673.365659]  [<c03fd728>] schedule_timeout+0x48/0xc0
> [  673.365663]  [<c03fd50e>] io_schedule_timeout+0x5e/0xb0
> [  673.365667]  [<c0170d11>] congestion_wait+0x71/0x90
> [  673.365671]  [<c016b92e>] wb_kupdate+0x9e/0xf0
> [  673.365675]  [<c016beb2>] pdflush+0x102/0x1d0
> [  673.365679]  [<c013fa82>] kthread+0x42/0x70
> [  673.365683]  [<c01050df>] kernel_thread_helper+0x7/0x18
> 

That looks more like the inode writeback patches from Wu than the per
bdi dirty stuff. The later typically hangs in balance_dirty_pages().


