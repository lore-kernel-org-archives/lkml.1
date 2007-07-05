Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbXGEQa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbXGEQa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbXGEQaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:30:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56014 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757612AbXGEQaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:30:10 -0400
Date: Thu, 5 Jul 2007 09:28:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, marcel@holtmann.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [1/2] 2.6.22-rc7: known regressions
In-Reply-To: <1183599771.2740.19.camel@shinybook.infradead.org>
Message-ID: <alpine.LFD.0.98.0707050921000.9434@woody.linux-foundation.org>
References: <468A7D14.1050505@googlemail.com>
 <1183599771.2740.19.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Jul 2007, David Woodhouse wrote:
> 
> Oh, and here's another one for you. My Bluetooth mouse just stopped
> working and hidd is deadlocked...

Looks like it is stuck on hidp_session_sem.

Nothing after 2.6.21 seems to have even touched that semaphore usage, and 
in fact there's not a whole lot of changes to the hidp code at all (and 
none of them look even remotely interesting). 

So I suspect it's something lower down in the bluetooth stack, or it's a 
long-standing problem that you are somehow able to trigger more easily 
now. Is it consistent?

Can you showo the traces for the _other_ processes that are in bluetooth 
functions? Because there should be other processes there, holding that 
hidp_session_sem rwsem.

[ Alternatively, there is some process that doesn't release it in an error 
  case, but that is definitely not a regression if so: the changes to 
  net/bluetooth/hidp/core.c since 2.6.21 really are trivial. ]

IOW, more info needed, I think.

			Linus

---
> hidd          D 1FE27798  5940  1695      1 (NOTLB)
> Call Trace:
> [ef3ddb70] [00000004] 0x4 (unreliable)
> [ef3ddc30] [c0008e7c] __switch_to+0x50/0x68
> [ef3ddc50] [c02d5998] schedule+0x3cc/0x480
> [ef3ddc80] [c0137a20] rwsem_down_failed_common+0x1c4/0x1f4
> [ef3ddcb0] [c02d7454] rwsem_down_write_failed+0x28/0x40
> [ef3ddce0] [c004ff60] down_write+0x50/0x64
> [ef3ddd00] [f27f2068] hidp_add_connection+0x168/0x75c [hidp]
> [ef3ddd40] [f27f2e44] hidp_sock_ioctl+0x140/0x414 [hidp]
> [ef3ddeb0] [c024da6c] sock_ioctl+0x248/0x284
> [ef3dded0] [c00ab02c] do_ioctl+0x38/0x84
> [ef3ddee0] [c00ab448] vfs_ioctl+0x3d0/0x404
> [ef3ddf10] [c00ab4e4] sys_ioctl+0x68/0x98
> 
> -- 
> dwmw2
> 
