Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbXA1SxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbXA1SxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 13:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbXA1SxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 13:53:01 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:39169 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbXA1SxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 13:53:00 -0500
Date: Sun, 28 Jan 2007 19:52:58 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: stgt-devel@lists.berlios.de, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       David Miller <davem@davemloft.net>
Subject: ibmvstgt/aio broken with 2.6.20-rc6 powerpc
Message-ID: <20070128185258.GA18860@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	stgt-devel@lists.berlios.de, linux-aio@kvack.org,
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
	Linus Torvalds <torvalds@osdl.org>,
	David Miller <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks

I'm not really sure if this is a ibmvstgt or a generic aio problem.

I tried ibmvstgt on my openpower and the kernel shows the following
warning several times:
| Jan 28 15:11:15 waldi kernel: Badness at arch/powerpc/mm/slb.c:95
| Jan 28 15:11:15 waldi kernel: Call Trace:
| Jan 28 15:11:15 waldi kernel: [C00000000282B750] [C00000000000EC94] .show_stack+0x68/0x1b0 (unreliable)
| Jan 28 15:11:15 waldi kernel: [C00000000282B7F0] [C00000000015ED64] .report_bug+0x94/0xe8
| Jan 28 15:11:15 waldi kernel: [C00000000282B880] [C0000000000228DC] .program_check_exception+0x140/0x54c
| Jan 28 15:11:15 waldi kernel: [C00000000282B920] [C000000000004774] program_check_common+0xf4/0x100
| Jan 28 15:11:15 waldi kernel: --- Exception: 700 at .slb_flush_and_rebolt+0xc/0xe0
| Jan 28 15:11:15 waldi kernel:     LR = .switch_slb+0xac/0x1a0
| Jan 28 15:11:15 waldi kernel: [C00000000282BC10] [FFFFFFFFFFFFFFFF] 0xffffffffffffffff (unreliable)
| Jan 28 15:11:15 waldi kernel: [C00000000282BCB0] [C0000000000E1750] .aio_kick_handler+0x128/0x278
| Jan 28 15:11:15 waldi kernel: [C00000000282BD60] [C000000000066380] .run_workqueue+0xec/0x1d4
| Jan 28 15:11:15 waldi kernel: [C00000000282BE00] [C000000000066F2C] .worker_thread+0x164/0x1bc
| Jan 28 15:11:15 waldi kernel: [C00000000282BEE0] [C00000000006B6E8] .kthread+0x120/0x170
| Jan 28 15:11:15 waldi kernel: [C00000000282BF90] [C000000000024204] .kernel_thread+0x4c/0x68

One possibility:
aio_kick_handler calls use_mm. use_mm calls switch_mm. It seems that
90aef12e6dd609e1ad7fb70044eedc78ca55ee5e changed that from activate_mm.

activate_mm on powerpc disables interupts and calls swtich_mm. So
switch_mm is now called with interrupts enabled and runs into the
WARN_ON.

Bastian

-- 
She won' go Warp 7, Cap'n!  The batteries are dead!
